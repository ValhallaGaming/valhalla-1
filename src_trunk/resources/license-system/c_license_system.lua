wLicense, licenseList, bAcceptLicense, bCancel = nil
local ped = createPed(71, 356.29598999023, 161.48677062988, 1008.3762207031)
setPedRotation(ped, 271.4609375)
setElementDimension(ped, 125)
setElementInterior(ped, 3)

function showLicenseWindow()
	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wLicense= guiCreateWindow(x, y, width, height, "Las Venturas Licensing Department", false)
	
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
				local money = getElementData(getLocalPlayer(), "money")
				outputDebugString(tostring(licensecost))
				if (money<licensecost) then
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
testRoute[1] = { 2514.2597, 1191.9062, 10.477 }		-- 1
testRoute[2] = { 2530.0156, 1284.8164, 10.4880 }	-- 2
testRoute[3] = { 2712.6298,	1310.6669, 13.6419 }	-- 3
testRoute[4] = { 2829.1064, 1436.44, 10.5162 }		-- 4
testRoute[5] = { 2782.4716, 1525.5292, 9.7729 }		-- 5
testRoute[6] = { 2729.1005, 1812.75, 6.5581 }		-- 6
testRoute[7] = { 2773.9082, 2046.6904, 9.1560 }		-- 7
testRoute[8] = { 2719.7871, 2115.8505, 13.7437 }	-- 8
testRoute[9] = { 2509.4902, 2148.9462, 10.4880 }	-- 9
testRoute[10] = { 2400.9990, 2149.6630, 10.5272 }	-- 10
testRoute[11] = { 2196.4970, 2150.0312, 10.4746 }	-- 11
testRoute[12] = { 2149.6796, 2213.7060, 10.49095 }	-- 12
testRoute[13] = { 2229.5185, 2426.5937, 10.4748 }	-- 13
testRoute[14] = { 2117.9375, 2455.0009, 10.5272 }	-- 14
testRoute[15] = { 2037.2714, 2342.9609, 10.4735 }	-- 15
testRoute[16] = { 2045.8105, 1623.1123, 10.5269 }	-- 16
testRoute[17] = { 2055.3525, 1371.8535, 10.4815 }	-- 17
testRoute[18] = { 2242.7185, 1371.2167, 10.4796 }	-- 18
testRoute[19] = { 2310.5205, 1463.1201, 10.6294 }	-- 19 -- Parking exercise
testRoute[20] = { 2301.7207, 1451.6406, 10.6252 }	-- 20 -- Parking exercise
testRoute[21] = { 2310.9482, 1438.4736, 10.6266 }	-- 21 -- Parking exercise
testRoute[22] = { 2381.1210, 1370.7363, 10.5272 }	-- 22
testRoute[23] = { 2425.0205, 1220.6035, 10.4880 }	-- 23

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

function startDrivingTest()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	local id = getElementModel(vehicle)
	if not (testVehicle[id]) then
		outputChatBox("#FF9933You must be in a DMV test car when passing through the check points.", 255, 0, 0, true ) -- Wrong car type.
	else
		destroyElement(blip)
		destroyElement(marker)
		
		outputChatBox("You have paid the $100 fee to take the driving practical test.", source, 255, 194, 14)
		triggerServerEvent("payFee", getLocalPlayer(), 100)
		
		local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
		setElementData(getLocalPlayer(), "drivingTest.marker", "1")

		local x1,y1,z1 = nil -- Setup the first checkpoint
		x1 = testRoute[2][1]
		y1 = testRoute[2][2]
		z1 = testRoute[2][3]
		setElementData(getLocalPlayer(), "drivingTest.checkmarkers", 23)

		blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
		marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
			
		addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)	
			
		outputChatBox("#FF9933You will need to complete the route without damaging the test car. Good luck and drive safe.", 255, 194, 14, true)
	end
end

function UpdateCheckpoints()
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
			setElementData(getLocalPlayer(), "drivingTest.marker", newnumber)
				
			local x2, y2, z2 = nil
			x2 = testRoute[newnumber][1]
			y2 = testRoute[newnumber][2]
			z2 = testRoute[newnumber][3]
			
			marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
			blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
			
			
			addEventHandler("onClientMarkerHit", marker, EndTest)
		
		else
		
			local newnumber = m_number+1
			setElementData(getLocalPlayer(), "drivingTest.marker", newnumber)
					
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

function EndTest()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	local id = getElementModel(vehicle)
	if not (testVehicle[id]) then
		outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0)
	else
		local vehicleHealth = getElementHealth ( vehicle )
		if (vehicleHealth >= 800) then
			local playerMoney = getElementData(getLocalPlayer(), "money")
			if (playerMoney < 250 ) then
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
 