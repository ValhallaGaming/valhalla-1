wLicense, licenseList, bAcceptLicense, bCancel = nil
local ped = createPed(71, 356.29598999023, 161.48677062988, 1008.3762207031)
setPedRotation(ped, 271.4609375)
setElementDimension(ped, 125)
setElementInterior(ped, 3)

local localPlayer = getLocalPlayer()

function showLicenseWindow()
	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wLicense= guiCreateWindow(x, y, width, height, "Los Santos Licensing Department", false)
	
	licenseList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wLicense)
    local column = guiGridListAddColumn(licenseList, "License", 0.7)
	local column2 = guiGridListAddColumn(licenseList, "Cost", 0.2)

	local vehiclelicense = getElementData(getLocalPlayer(), "license.car")
	
	if (vehiclelicense~=1) then
		local row = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row, column, "Car License", false, false)
		guiGridListSetItemText(licenseList, row, column2, "450", true, false)
	end
	
	local weaponlicense = getElementData(getLocalPlayer(), "license.gun")
	
	if (weaponlicense==0) then
		local row2 = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row2, column, "Weapon License", false, false)
		guiGridListSetItemText(licenseList, row2, column2, "4000", true, false)
	end
	
	bAcceptLicense = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Buy License", true, wLicense)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, wLicense)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptLicense, acceptLicense)
	addEventHandler("onClientGUIClick", bCancel, cancelLicense)
end
addEvent("onLicense", true)
addEventHandler("onLicense", getRootElement(), showLicenseWindow)

function acceptLicense(button, state)
	if (source==bAcceptLicense) and (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Please select a license first!", 255, 0, 0)
		else
			local license = 0
			local licensetext = guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 1)
			local licensecost = tonumber(guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 2))
			
			if (licensetext=="Car License") then
				license = 1
			elseif (licensetext=="Weapon License") then
				license = 2
			end
			
			if (license>0) then
				if not exports.global:hasMoney( getLocalPlayer(), licensecost ) then
					outputChatBox("You cannot afford this license.", 255, 0, 0)
				else
					if (license == 1) then
						if (getElementData(getLocalPlayer(),"license.car")==0) then
							triggerServerEvent("payFee", getLocalPlayer(), 100)
							createlicenseTestIntroWindow() -- take the drivers theory test.
							destroyElement(licenseList)
							destroyElement(bAcceptLicense)
							destroyElement(bCancel)
							destroyElement(wLicense)
							wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
							showCursor(false)
						elseif(getElementData(getLocalPlayer(),"license.car")==3) then
							initiateDrivingTest()
						end
					else
						triggerServerEvent("acceptLicense", getLocalPlayer(), license, licensecost) -- give them the weapons license.
						destroyElement(licenseList)
						destroyElement(bAcceptLicense)
						destroyElement(bCancel)
						destroyElement(wLicense)
						wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
						showCursor(false)
					end
				end
			end
		end
	end
end

function cancelLicense(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(licenseList)
		destroyElement(bAcceptLicense)
		destroyElement(bCancel)
		destroyElement(wLicense)
		wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end

   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS (AKA JASON MOORE), ADAPTED BY CHAMBERLAIN --------------
   
questions = { }
questions[1] = {"Which side of the street should you drive on?", "Left", "Right", "Either", 2}
questions[2] = {"At an intersection with a four-way stop, which driver can go first?", "The driver to the left of you.", "The driver to the right of you.", "Who ever reached the intersection first.", 1}
questions[3] = {"What would be a reason for approaching a sharp curve slowly?", "To save wear and tear on your tires.", "To be able to take in the scenery.", "To be able to stop if someone is in the roadway.", 3}
questions[4] = {"When a traffic light is red you should...", "Bring the vehicle to a complete stop.", "Continue.", "Continue if nothing is coming.", 1} 
questions[5] = {"Drivers must yield to pedestrians:", "At all times.", "On private property.", "Only in a crosswalk. ", 1}
questions[6] = {"The blind spots where trucks will not be able to see you are:", "Directly behind the body.", "The immediate left of the cab.", "All of the above." , 3}
questions[7] = {"There is an emergency vehicle coming from behind you with emergency lights on and flashing. You should:", "Slow down and keep moving.", "Pull over to the right and stop.", "Maintain your speed. ", 2}
questions[8] = {"On a road with two or more lanes traveling in the same direction, the driver should:", " Drive in any lane.", "Drive in the left lane.", "Drive in the right lane except to pass.", 3}
questions[9] = {"In bad weather, you should make your car easier for others to see by:", " Turning on your headlights.", "Turning on your emergency flashers.", "Flash your high beams.", 1}
questions[10] = {"You may not park within how many feet of a fire hydrant?", "10 feet", "15 feet", "20 feet", 1}

guiIntroLabel1 = nil
guiIntroProceedButton = nil
guiIntroWindow = nil
guiQuestionLabel = nil
guiQuestionAnswer1Radio = nil
guiQuestionAnswer2Radio = nil
guiQuestionAnswer3Radio = nil
guiQuestionWindow = nil
guiFinalPassTextLabel = nil
guiFinalFailTextLabel = nil
guiFinalRegisterButton = nil
guiFinalCloseButton = nil
guiFinishWindow = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseTestIntroWindow()
	
	showCursor(true)
	
	outputChatBox("You have paid the $100 fee to take the driving theory test.", source, 255, 194, 14)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Driving Theory Test" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, "	You will now proceed with the driving theory test. You will\
										be given seven questions based on basic driving theory. You must score\
										a minimum of 80 percent to pass.\
										\
										Good luck.", true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center", true )
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Test" , true ,guiIntroWindow)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceTest()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)
	
end


-- function create the question window
function createLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabel, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Next Question" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Submit Answers" , true ,guiQuestionWindow)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createTestFinishWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of test.", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed this section of the test.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				triggerServerEvent("theoryComplete", getLocalPlayer())

				initiateDrivingTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				
				--cleanup
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalPassTextLabel)
				destroyElement(guiFinalRegisterButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalPassTextLabel = nil
				guiFinalRegisterButton = nil
				guiFinishWindow = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		
		guiFinalCloseButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Close" , true ,guiFinishWindow)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButton,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalFailTextLabel)
				destroyElement(guiFinalCloseButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalFailTextLabel = nil
				guiFinalCloseButton = nil
				guiFinishWindow = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
	
end
 
 -- function starts the quiz
 function startLicenceTest()
 
	-- choose a random set of questions
	chooseTestQuestions()
	-- create the question window with question number 1
	createLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
 end

---------------------------------------
------ Practical Driving Test ---------
---------------------------------------
 
testRoute = {}
testRoute[1] = { 1265.54296875, -1797.587890625, 12.982382774353 }		-- 1
testRoute[2] = { 1445.2490234375, -1875.130859375, 12.954732894897 }	-- 2
testRoute[3] = { 1572.060546875, -1791.5078125, 12.948467254639 }	-- 3
testRoute[4] = { 1531.8037109375, -1693.458984375, 12.93030834198 }		-- 4
testRoute[5] = { 1478.5146484375, -1589.458984375, 12.949851036072 }		-- 5
testRoute[6] = { 1452.9833984375, -1486.0546875, 12.926139831543 }		-- 6
testRoute[7] = { 1457.20703125, -1249.77734375, 12.955498695374 }		-- 7
testRoute[8] = { 1524.654296875, -1163.6259765625, 23.471897125244 }	-- 8
testRoute[9] = { 1738.9228515625, -1164.3310546875, 23.19779586792 }	-- 9
testRoute[10] = { 1845.9169921875, -1222.90234375, 17.727577209473 }	-- 10
testRoute[11] = { 1907.3046875, -1263.4931640625, 13.0679063797 }	-- 11
testRoute[12] = { 1924.8388671875, -1133.375, 24.50156211853 }	-- 12
testRoute[13] = { 1864.9404296875, -1169.1796875, 23.223041534424 }	-- 13
testRoute[14] = { 1669.3642578125, -1158.5263671875, 23.225805282593 }	-- 14
testRoute[15] = { 1639.76171875, -1147.5517578125, 23.477903366089 }	-- 15
testRoute[16] = { 1632.076171875, -1089.611328125, 23.477054595947 }	-- 16 -- Parking exercise
testRoute[17] = { 1608.7919921875, -1009.9169921875, 23.467891693115 }	-- 17 -- Parking exercise
testRoute[18] = { 1678.71484375, -1012.7236328125, 23.462585449219 }	-- 18 -- Parking exercise
testRoute[19] = { 1444.3115234375, -1157.7900390625, 23.223503112793 }	-- 19
testRoute[20] = { 1339.3525390625, -1258.958984375, 12.9471616745 }	-- 20
testRoute[21] = { 1294.44921875, -1690.6328125, 12.948437690735 }	-- 21
testRoute[22] = { 1271.0126953125, -1843.71875, 12.96185874939 }	-- 22
testRoute[23] = { 1267.125, -1810.93359375, 13.395156860352 }	-- 23

testVehicle = { [436]=true } -- Previons need to be spawned at the start point.

local blip = nil
local marker = nil

function initiateDrivingTest()

	local x, y, z = testRoute[1][1], testRoute[1][2], testRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startDrivingTest)
	
	outputChatBox("#FF9933You are now ready to take your practical driving examination. Collect a DMV test car and begin the route.", 255, 194, 14, true)
	outputChatBox("#FF9933((The #00FF00start point #FF9933has been added to your radar.))", 255, 194, 14, true)
end

function startDrivingTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#FF9933You must be in a DMV test car when passing through the check points.", 255, 0, 0, true ) -- Wrong car type.
		elseif not exports.global:hasMoney( getLocalPlayer(), 100 ) then
			outputChatBox("You can't pay the processing fee.", 255, 0, 0 )
		else
			destroyElement(blip)
			destroyElement(marker)
			
			outputChatBox("You have paid the $100 fee to take the driving practical test.", source, 255, 194, 14)
			triggerServerEvent("payFee", getLocalPlayer(), 100)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", "1", false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testRoute[2][1]
			y1 = testRoute[2][2]
			z1 = testRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", 23, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)	
				
			outputChatBox("#FF9933You will need to complete the route without damaging the test car. Good luck and drive safe.", 255, 194, 14, true)
		end
	end
end

function UpdateCheckpoints(element)
    if (element == localPlayer) then
    	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
    	local id = getElementModel(vehicle)
    	if not (testVehicle[id]) then
    		outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0) -- Wrong car type.
    	else
    		destroyElement(blip)
    		destroyElement(marker)
    		blip = nil
    		marker = nil
    			
    		local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
    		local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
    		
    		if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
    			
    			outputChatBox("#FF9933Pull over at the #FF66CCside of the road #FF9933ahead to complete the test.", 255, 194, 14, true)
    			
    			local newnumber = m_number+1
    			setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
    				
    			local x2, y2, z2 = nil
    			x2 = testRoute[newnumber][1]
    			y2 = testRoute[newnumber][2]
    			z2 = testRoute[newnumber][3]
    			
    			marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
    			blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
    			
    			
    			addEventHandler("onClientMarkerHit", marker, EndTest)
    		
    		else
    		
    			local newnumber = m_number+1
    			setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
    					
    			local x2, y2, z2 = nil
    			x2 = testRoute[newnumber][1]
    			y2 = testRoute[newnumber][2]
    			z2 = testRoute[newnumber][3]
    					
    			marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
    			blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
    			
    			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
    		
    		end
    	end
    end
end

function EndTest(element)
    if (element == localPlayer) then
    	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
    	local id = getElementModel(vehicle)
    	if not (testVehicle[id]) then
    		outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0)
    	else
    		local vehicleHealth = getElementHealth ( vehicle )
    		if (vehicleHealth >= 800) then
    			if not exports.global:hasMoney( getLocalPlayer(), 250 ) then
    				outputChatBox("You can't afford the $250 processing fee.", 255, 0, 0)
    			else
    				----------
    				-- PASS --
    				----------
    				outputChatBox("After inspecting the vehicle we can see no damage.", 255, 194, 14)
    				triggerServerEvent("acceptLicense", getLocalPlayer(), 1, 250)
    			end
    		else
    			----------
    			-- Fail --
    			----------
    			outputChatBox("After inspecting the vehicle we can see that it's damage.", 255, 194, 14)
    			outputChatBox("You have failed the practical driving test.", 255, 0, 0)

    		end
    		
    		destroyElement(blip)
    		destroyElement(marker)
    		blip = nil
    		marker = nil
    				
    		removeElementData(thePlayer, "drivingTest.vehicle")
    		
    		removeElementData(thePlayer, "drivingTest.vehicle")	-- cleanup data
    		removeElementData ( thePlayer, "drivingTest.marker" )
    		removeElementData ( thePlayer, "drivingTest.checkmarkers" )
    	end
    end
end
 