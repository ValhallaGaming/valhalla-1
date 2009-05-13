function stopNameChange(oldNick, newNick)
	if (source==getLocalPlayer()) then
		local legitNameChange = getElementData(getLocalPlayer(), "legitnamechange")

		if (oldNick~=newNick) and (legitNameChange==0) then
			triggerServerEvent("resetName", getLocalPlayer(), oldNick, newNick) 
			outputChatBox("Click 'Change Character' if you wish to change your roleplay identity.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientPlayerChangeNick", getRootElement(), stopNameChange)

function onPlayerSpawn()
	if (source==getLocalPlayer()) then
		showCursor(false)
		
		local interior = getElementInterior(source)
		setCameraInterior(interior)
	end
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), onPlayerSpawn)

function clearChatBox()
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
end

function hideInterfaceComponents()
	showPlayerHudComponent("weapon", false)
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("vehicle_name", false)
	showPlayerHudComponent("money", false)
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("area_name", false)
	showPlayerHudComponent("radar", false)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), hideInterfaceComponents)

--========================= TUTORIAL SCRIPT ==============================================

-- Concrete Gaming Roleplay Server - Tutorial and Quiz script for un-registerd players - written by Peter Gibbons (aka Jason Moore)

local tutorialStage = {}
	tutorialStage[1] = {2040.7735595703, 1533.9848632813, 23.378678321838, 2004.0617675781, 1545.6661376953, 13.5859375} -- idlewood gas station
	tutorialStage[2] = {2311.42578125, 2447.7314453125, 23.8203125, 2339.0307617188, 2456.6774902344, 14.96875} --LSPD
	tutorialStage[3] = {2323.5373535156, 1283.30078125, 97.444427490234, 2300.5373535156, 1283.30078125, 97.444427490234} -- 10 green bottles
	tutorialStage[4] = {2427.2941894531, 1106.0552978516, 10.671875, 2414.3232421875, 1123.9416503906, 14.878396987915} -- Unity Station
	tutorialStage[5] = {2557.0424804688, 2035.7072753906, 10.679664611816, 2571.6921386719, 2041.4582519531, 11.101631164551} -- Santa Maria Beach
	tutorialStage[6] = {2528.1484375, 2281.8376464844, 28.3515625, 2537.8205566406, 2322.0336914063, 28.3515625} -- Pier
	tutorialStage[7] = {2594.97265625, 2275.2221679688, 31.8203125, 2616.0190429688, 2246.7856445313, 31.0625} -- Vinewood sign
	tutorialStage[8] = {2311.42578125, 2447.7314453125, 23.8203125, 2339.0307617188, 2456.6774902344, 14.96875} -- Glen Park
	tutorialStage[9] = {2427.2941894531, 1106.0552978516, 10.671875, 2414.3232421875, 1123.9416503906, 14.878396987915} -- Docks
	tutorialStage[10] = {2040.7735595703, 1533.9848632813, 23.378678321838, 2004.0617675781, 1545.6661376953, 13.5859375} -- Pig Pen
	tutorialStage[11] = {2557.0424804688, 2035.7072753906, 10.679664611816, 2571.6921386719, 2041.4582519531, 11.101631164551} -- East Beach
	
local stageTime = 15000
local fadeTime = 2000
local fadeDelay = 300

local tutorialTitles = {}
	tutorialTitles[1] = "WELCOME"
	tutorialTitles[2] = "YOUR NAME"
	tutorialTitles[3] = "ROLEPLAYING"
	tutorialTitles[4] = "IC AND OOC"
	tutorialTitles[5] = "ROLEPLAY RULES"
	tutorialTitles[6] = "EXPLOITING"
	tutorialTitles[7] = "LANGUAGE"
	tutorialTitles[8] = "SERVER RULES"
	tutorialTitles[9] = "STARTING OUT"
	tutorialTitles[10] = "ADMINS"
	tutorialTitles[11] = "MORE INFORMATION"
	

local tutorialText = {}
		tutorialText[1] = {"Hello and welcome to Valhalla Gaming: MTA Roleplay Server.",
					"I see you're new here, so please give us 2 minutes to introduce you the server.",
					"Currently we are the only fully roleplay structured server on MTA, with a constantly",
					"updating script. You can visit the website at http://valhallagaming.net for more info."}
	
	tutorialText[2] = 		{"Roleplay (RP) is a game genre where the players assume the role of a fictional",
					"character. In our server, your name is your identity, and must be in the format ",
					"Firstname_Lastname. It can be anything you want, as long as it's realistic and",
					"not a celebrity name. An example of a valid name is: 'Niko_Harrison'. "}
	
	tutorialText[3] = 		{"You're expected to roleplay at all times. That means acting as you would in",
					"real life. Just because it's possible in GTA, doesn't mean it's ok to do it here.",
					"Even though we have server factions, you can roleplay anything you want,",
					"providing that it follows the server rules."}
	
	tutorialText[4] = 		{"In Character (IC) and Out of Character (OOC) is fundamental to good roleplaying",
					"OOC refers to you, the player, talking about non relevant, off topic things.",
					"To talk OOC to each other, use /o, /b and /pm. IC refers your characters words",
					"being spoken to other characters - try not to confuse the two."}
	
	tutorialText[5] = 		{"There are a number of roleplay terms that you will need to understand, like 'Metagaming' (using",
					"OOC information in a IC situation), or 'Powergaming' (forcing your roleplay on other people.)",
					"For more information about these terms, press F1 in game and all the information you need",
					"to know will be there. We don't like people metagaming or powergaming, so please don't do it!"}
	
	tutorialText[6] = 		{"Gaining an unfair advantage over other players, by using cheats or abusing",
					"bugs won't be tolerated in any way, and will result in a instant ban, so watch",
					"out! ;)  If you see any exploits in the script, please report it to the admins ",
					"straight away or externally onto our forums." }
				      
	tutorialText[7] = 		{"We encourage people from all over the world to play here, but ask that",
					"you all stick to one language - English - so everyone knows whats going on,",
					"even in OOC. If you want to talk in your native language to someone, please",
					"do it over private messages. (/pm)"}
	
	tutorialText[8] = 		{"Our set of server rules are probably very different compared to other MTA servers.",
					"There is a full list available on the website, but some of the most common are:",
					"No deathmatching, advertising other servers and cheating or hacking (obviously...)",
					"No spamming the chat or commands please, and don't use full capitals, thanks!"}

	tutorialText[9] =		 {"So you've just arrived in Las Venturas, what do you do? There are plenty",
					"of factions for you to become members of - just roleplay with other players",
					"and you'll soon find yourself rising up the faction ranks. Some factions, like ",
					"the LVMPD require you to fill out applications on the forums before you can join."}
	
	tutorialText[10] = 	{"Our admins are here to help you should you need it. If you need help, have a quick question",
					"or wish to report someone for breaking the rules, don't be afraid to use /report  and someone ",
					"will come and help as soon as they can. For larger questions, and account issues, it might be",
					"easier to ask on our forums at http://www.valhallagaming.net/forums/"}
				   
	tutorialText[11] = 	{"For more information on the server, as already mentioned, press F1 during gameplay.",
					"A list of player commands can be found by doing /helpcmds, so please read through and",
					"familarise yourself with them. Alternatively ask one of the admins or players in game.",
					"This marks the end of the tutorial. Thank you for playing. "}
					
					

-- function starts the tutorial
function showTutorial()

	local thePlayer = getLocalPlayer()

	-- set the player to not logged in so they don't see any other random chat
	setElementData(thePlayer, "loggedin", 0)
		
	-- if the player hasn't got an element data, set it to 1
	if not (getElementData(thePlayer, "tutorialStage")) then
		setElementData(thePlayer, "tutorialStage", 0)
	end
	
	-- ionc
	setElementData(thePlayer, "tutorialStage", getElementData(thePlayer, "tutorialStage")+1)

	
	-- stop the player from using any controls to move around or chat
	toggleAllControls (  false )
	-- fade the camera to black so they don't see the teleporting renders
	fadeCamera ( false, fadeTime/1000 ,0,0,0)
	
	-- timer to move the camera to the first location as soon as the screen has gone black.
	setTimer(function()
		
		-- timer to set camera position and fade in after the camera has faded out to black
		setTimer(function()
				
			local stage = getElementData(thePlayer, "tutorialStage")
			
			local camX = tutorialStage[stage][1]
			local camY = tutorialStage[stage][2]
			local camZ = tutorialStage[stage][3]
			local lookX = tutorialStage[stage][4]
			local lookY = tutorialStage[stage][5]
			local lookZ = tutorialStage[stage][6]
			
			setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
			
			-- set the element to outside and dimension 0 so they see th eother players
			setElementInterior(thePlayer, 0)
			setElementDimension(thePlayer, 0)
			
			-- fade the camera in
			fadeCamera( true, fadeTime/1000)
			
			-- call function to output the text
			outputTutorialText(stage)
			
			-- function to fade out after message has been displayed a read
			setTimer(function()
								
				local lastStage = getLastStage()
				
				-- if the player is on the last stage of the tutorial, fade their camera out and...
				if(stage == lastStage) then
					fadeCamera( false, fadeTime/1000, 0,0,0)
						
					setTimer(function()

						-- show the quiz after a certain time
						endTutorial()
						
						setElementData ( thePlayer, "tutorialStage", 0 )
						
					end, fadeTime+fadeDelay,1 )
				else -- else more stages to go, show the next stage
					showTutorial(thePlayer)
				end
			end, stageTime, 1)
		end, 150, 1)
	end, fadeTime+fadeDelay , 1)
end
addEvent("onShowTutorial", true)
addEventHandler("onShowTutorial", getLocalPlayer(), showTutorial)



-- function returns the number of stages
function getLastStage()

	local lastStage = 0
	
	if(tutorialStage) then
		for i, j in pairs(tutorialStage) do
			lastStage = lastStage + 1
		end
	end
	
	return lastStage
end


-- function outputs the text during the tutorial
function outputTutorialText( stage)
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(tutorialTitles[stage],  255, 0,0, true)
	outputChatBox(" ")
	
	if(tutorialText[stage]) then
		for i, j in pairs(tutorialText[stage]) do
				outputChatBox(j)
		end
	end

end

-- function fade in the camera and sets the player to the quiz room so they can do the quiz
function endTutorial()

	local thePlayer = getLocalPlayer()
	
	-- set the player to not logged in so they don't see the chat
	setElementData(thePlayer, "loggedin", 0)
	toggleAllControls(false)
			
	
	setTimer(function()
		setCameraMatrix(2638.5322265625, 2298.2038574219, 17.671875, 2638.2592773438, 2326.6357421875, 17.8203125)
		
		-- fade the players camera in
		fadeCamera(true, 2)
		
		-- trigger the client to start showing the quiz
		setTimer(function()
			triggerEvent("onClientStartQuiz", thePlayer)
			
		end, 2000, 1)
		
		
	end, 100, 1)

end




   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS, AKA JASON MOORE --------------
   
   
   
   questions = { }
questions[1] = {"What does the term RP stand for?", "Real Playing", "Role Playing", "Record Playing", "Route Playing", 2}
questions[2] = {"When are you allowed to advertise other servers?", "Using /ad", "In out of character chat", "Via PM's (/w)", "Never", 4}
questions[3] = {"What should you do if you see someone hacking?", "Tell an admin using /report", "Ignore it", "/w the hacker and tell them to stop", "Report the hacker in OOC", 1}
questions[4] = {"What is the address of the website and forums?", "www.valhalla.com", "www.valhallagaming.co.uk", "www.valhallagaming.net", "www.vg.com", 3} 
questions[5] = {"I want to get to the other side of Las Venturas, how should I do it?", "Ask an admin to teleport you.", "Find a roleplay way to get there, like a taxi.", "Start bunnyhopping to get there faster", "Jump in a random players car and demand them to take you.", 2}
questions[6] = {"What is the correct format for your in game name?", "Firstname", "firstname_lastname", "Firstname_Lastname", "There is no format", 3}
questions[7] = {"Which one of the following names would be acceptable", "David_Beckham", "Niko_Harrison", "Roleplayer_150", "They are all acceptable", 2}
questions[8] = {"When must you roleplay in this server?", "At all times", "Never", "When you feel like it", "Only when other people are", 1}
questions[9] = {"What should you do if you accidently drive your car off a cliff?", "Carry on driving because the car didn't blow up", "Ask an admin to move you to the top of the cliff", "Say it was an OOC accident", "Stop and roleplay a car accident", 4}
questions[10] = {"I want to join a particular gang or mafia, how should I do it?", "Ask an admin to move you into the faction", "Ask in OOC to join the faction", "Roleplay with the gang/mafia until they invite you.", "nil", 3}
questions[11] = {"What does OOC stand for?", "Out of Control", "Out of Character", "Out of Chance", "Out of Coffee", 2}
questions[12] = {"What does IC stand for?", "In Character", "In Chaos", "In Car", "nil", 1}
questions[13] = {"What is Metagaming?", "Killing someone for no reason", "Doing something that is unrealistic in real life", "Forcing your roleplay on other players", "Using Out of Character knowledge in In Character situations", 4}
questions[14] = {"What language should you use in this server?", "French", "English", "Hewbrew", "Anything", 2}
questions[15] = {"When can you talk to another player in your native language?", "In Character chat", "In any Out of Character chat", "Through private messages only.", "Never", 3}
questions[16] = {"Which ones of these is a server rule?", "No Roleplaying", "No Deathmatching", "No Driving", "No Shooting", 2}
questions[17] = {"What would you do if you wanted to contact an admin?", "Use the admin /report system", "Ask in global OOC for an admin", "Private message the admin", "Ask In Character for an admin.", 1}

-- variable for the max number of possible questions
local NoQuestions = 17
local NoQuestionToAnswer = 10
local correctAnswers = 0
local passPercent = 90
		
selection = {}


-- functon makes the intro window for the quiz
function createQuizIntroWindow()

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Roleplay Quiz" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, "	You will now proceed with a short roleplay quiz. This quiz isn't\
										 hard and is only to check that you've followed the tutorial. All \
										of the answers are hidden in the tutorial, and you don't need to \
										get every question correct.\
										\
										Good luck!", true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center")
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Quiz" , true ,guiIntroWindow)
	
	guiSetVisible(guiIntroWindow, true)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startQuiz()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)

end


-- function create the question window
function createQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.1, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.3, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	if not(selection[number][5] == "nil") then
		guiQuestionAnswer4Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][5], true,guiQuestionWindow)
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
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createQuestionWindow(number+1)
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
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createFinishQuizWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createFinishQuizWindow()

	local score = (correctAnswers/NoQuestionToAnswer)*100

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of Quiz", false )
	
	if(score >= passPercent) then
	
		local xmlRoot = xmlCreateFile("vgrptut.xml", "passedtutorial")
		xmlSaveFile(xmlRoot)
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed!", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!\
											Please remember to register at the forums (www.valhallagaming.net)\
											if you have not done so.\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center")
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				toggleAllControls ( true )
				
				createMainUI(getThisResource())
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%.\
											You can retake the quiz as many times as you like, so have another shot!\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center")
		
		guiFinalRetakeButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Take Quiz Again" , true ,guiFinishWindow)
		guiFinalTutorialButton = guiCreateButton ( 0.55 , 0.8 , 0.25, 0.1 , "Show Tutorial" , true ,guiFinishWindow)
		
		-- if player click the retake button
		addEventHandler ( "onClientGUIClick", guiFinalRetakeButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				startShowQuizIntro()
			end
		end, false)
		
		-- if player click the show tutorial
		addEventHandler ( "onClientGUIClick", guiFinalTutorialButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers and hide the window
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				guiSetInputEnabled(false)
				
				-- trigger server event to show the tutorial
				showTutorial()
			end
		end, false)
	
	
	
	end

end


-- function is triggerd by the server when it is time for the player to take the quiz
function startShowQuizIntro()
	
	clearChatBox()
	-- reset the players correct answers to 0
	correctAnswers = 0
	-- create the intro window
	createQuizIntroWindow()
	-- Set input enabled
	guiSetInputEnabled(true)

end
 addEvent("onClientStartQuiz", true)
 addEventHandler( "onClientStartQuiz", getLocalPlayer() ,  startShowQuizIntro)
 
 
 -- function starts the quiz
 function startQuiz()
 
	-- choose a random set of questions
	chooseQuizQuestions()
	-- create the question window with question number 1
	createQuestionWindow(1)
 
 end
 
 
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseQuizQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(questionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (questionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function questionAlreadyUsed(number)
 
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
 










---------------------- [ ACCOUNT SCRIPT ] ----------------------
lLostSecurityKey, tLostSecurityKey, bForgot, chkRemember, chkAutoLogin, bLogin, lLogUsername, lLogUsernameNote, tLogUsername, tLogPassword, lLogPassword, tabPanelMain, tabLogin, tabRegister, tabForgot, lRegUsername, tRegUsername, lRegUsernameNote, lRegPassword, tRegPassword, lRegPassword2, tRegPassword2, bRegister = nil
-- increasing this will reshow the tos as updated
tosversion = 100

toswindow, tos, bAccept, bDecline = nil
function checkTOS()
	local xmlRoot = xmlLoadFile("vgrptos.xml")
	
	if (xmlRoot) then
		local tosNode = xmlFindChild(xmlRoot, "tosversion", 0)
		
		if (tosNode) then
			local tversion = xmlNodeGetValue(tosNode)
			if (tversion) and (tversion~="") then				
				if (tonumber(tversion)~=tosversion) then
					xmlRoot = nil
				end
			else
				xmlRoot = nil
			end
		else
			xmlRoot = nil
		end
	end
	
	if not (xmlRoot) then -- User hasn't accepted terms of service or is out of date
		local width, height = 700, 300
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		toswindow = guiCreateWindow(x, y, width, height, "Terms of Service", false)
		guiWindowSetMovable(toswindow, false)
		
		tos = guiCreateMemo(0.025, 0.1, 0.95, 0.7, "", true, toswindow)
		guiSetText(tos, "By connecting, playing, registering and logging into this server you agree to the following terms and conditions (Last revised 17/October/2008). \n\n- You will not use any external software to 'hack' or cheat in the game.\n- You will not exploit any bugs within the script to gain an advantage over other players.\n- Your account and character are property of Valhalla Gaming.\n- Your account may be removed after 30 days of inactivity (character inactivity does not count).\n\n Visit www.valhallagaming.net if you require any assistance with these terms.")
		guiEditSetReadOnly(tos, true)
		
		bAccept = guiCreateButton(0.1, 0.8, 0.4, 0.15, "Accept", true, toswindow)
		bDecline = guiCreateButton(0.51, 0.8, 0.4, 0.15, "Decline", true, toswindow)
		addEventHandler("onClientGUIClick", bAccept, acceptTOS, false)
		addEventHandler("onClientGUIClick", bDecline, declineTOS, false)
	end
end

function acceptTOS(button, state)
	local theFile = xmlCreateFile("vgrptos.xml", "tosversion")
	if (theFile) then
		local node = xmlCreateChild(theFile, "tosversion")
		xmlNodeSetValue(node, tostring(tosversion))
		xmlSaveFile(theFile)
	end
	destroyElement(toswindow)
	toswindow = nil
end

function declineTOS(button, state)
	triggerServerEvent("declineTOS", getLocalPlayer())
end


function renderWelcomeMessage()
	local screenWidth, screenHeight = guiGetScreenSize()
	dxDrawText("Welcome to Valhalla Gaming", 36, screenHeight-61, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
    dxDrawText("Welcome to Valhalla Gaming", 34, screenHeight-63, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	local version = exports.global:cgetScriptVersion()
	
	dxDrawText("Version " .. version, screenWidth-170, screenHeight-61, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
    dxDrawText("Version " .. version, screenWidth-168, screenHeight-63, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	dxDrawLine(0, screenHeight-30, screenWidth, screenHeight-30, tocolor(255, 255, 255, 150), 2)
end

function cleanupScenarioOne()
	if (scen1Timer) then
		killTimer(scen1Timer)
		scen1Timer = nil
	end
	
	if (scen1Timer2) then
		killTimer(scen1Timer2)
		scen1Timer2 = nil
	end

	if (scen1Car1) then
		destroyElement(scen1Car1)
		scen1Car1 = nil
	end
	
	if (scen1Car2) then
		destroyElement(scen1Car2)
		scen1Car2 = nil
	end
	
	if (scen1Car3) then
		destroyElement(scen1Car3)
		scen1Car3 = nil
	end
	
	if (scen1Car4) then
		destroyElement(scen1Car4)
		scen1Car4 = nil
	end
	
	if (scen1Car5) then
		destroyElement(scen1Car5)
		scen1Car5 = nil
	end
	
	if (scen1Car6) then
		destroyElement(scen1Car6)
		scen1Car6 = nil
	end
	
	if (scen1Officer) then
		destroyElement(scen1Officer)
		scen1Officer = nil
	end
end

scenario = -1
scen1Car1, scen1Car2, scen1Car3, scen1Car4, scen1Car5, scen1Car6, scen1Officer, scen1Timer, scen1Timer2 = nil
function loadScenarioOne()
	scenario = 1
	local id = getElementData(getLocalPlayer(), "playerid")
	
	if not (id) then
		id = 0
	end
	
	setElementDimension(getLocalPlayer(), 65400+id)
	setElementAlpha(getLocalPlayer(), 255)
	setElementPosition(getLocalPlayer(), 1944.0075683594, -1750.8298339844, 14.382812)
	setElementInterior(getLocalPlayer(), 0)
	setCameraInterior(0)

	-- Car
	scen1Car1 = createVehicle(542, 2074.8247070313, 1012.0288085938, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car1, 65400+id)
	setVehicleEngineState(scen1Car1, true)
	setVehicleOverrideLights(scen1Car1, 2)
	
	-- Car 2
	scen1Car2 = createVehicle(598, 2074.8215332031, 1005.6492919922, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car2, 65400+id)
	setVehicleEngineState(scen1Car2, true)
	setVehicleSirensOn(scen1Car2, true)
	setVehicleOverrideLights(scen1Car2, 2)
	
	-- Car 3
	scen1Car3 = createVehicle(598, 2074.8215332031, 1018.6492919922, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car3, 65400+id)
	setVehicleEngineState(scen1Car3, true)
	setVehicleSirensOn(scen1Car3, true)
	setVehicleOverrideLights(scen1Car3, 2)
	
	-- CHASE
	-- Car
	scen1Car4 = createVehicle(542, 2066.4184570313, 883.01971435547, 7.1771411895752, 0, 0, 360)
	setElementDimension(scen1Car4, 65400+id)
	setVehicleEngineState(scen1Car4, true)
	setVehicleOverrideLights(scen1Car4, 2)
	
	-- Car
	scen1Car5 = createVehicle(598, 2069.53515625, 868.87261962891, 6.8626842498779, 0, 0, 360)
	setElementDimension(scen1Car5, 65400+id)
	setVehicleEngineState(scen1Car5, true)
	setVehicleOverrideLights(scen1Car5, 2)
	setVehicleSirensOn(scen1Car5, true)
	
	-- Car
	scen1Car6 = createVehicle(598, 2063.2297363281, 866.16375732422, 6.8054342269897, 0, 0, 360)
	setElementDimension(scen1Car6, 65400+id)
	setVehicleEngineState(scen1Car6, true)
	setVehicleOverrideLights(scen1Car6, 2)
	setVehicleSirensOn(scen1Car6, true)
	
	scen1Timer = setTimer(updateScenario1, 50, 300)
	scen1Timer2 = setTimer(resetScenario1, 16000, 1)
	
	-- OFFICER
	scen1Officer1 = createPed(282, 2072.5834960938, 1011.3972167969, 10.67187)
	setPedRotation(scen1Officer1, 274.4475)
	setElementDimension(scen1Officer1, 65400+id)

	-- CAMERA
	setCameraMatrix(2064.0795898438, 987.72485351563, 19.671875, 2064.5834960938, 1010.3972167969, 10.67187)
end

function updateScenario1()
	local x1, y1, z1 = getElementPosition(scen1Car4)
	setElementPosition(scen1Car4, x1, y1+2.5, z1)
	
	local x2, y2, z2 = getElementPosition(scen1Car5)
	setElementPosition(scen1Car5, x2, y2+2.5, z2)
	
	local x3, y3, z3 = getElementPosition(scen1Car6)
	setElementPosition(scen1Car6, x3, y3+2.5, z3)
end

function resetScenario1()
	killTimer(scen1Timer)
	killTimer(scen1Timer2)
	
	local id = getElementData(getLocalPlayer(), "playerid")
	
	if not (id) then
		id = 0
	end
	
	destroyElement(scen1Car4)
	scen1Car4 = nil
	
	destroyElement(scen1Car5)
	scen1Car5 = nil
	
	destroyElement(scen1Car6)
	scen1Car6 = nil

	-- CHASE
	-- Car
	scen1Car4 = createVehicle(542, 2066.4184570313, 883.01971435547, 7.1771411895752, 0, 0, 360)
	setElementDimension(scen1Car4, 65400+id)
	setVehicleEngineState(scen1Car4, true)
	setVehicleOverrideLights(scen1Car4, 2)
	
	-- Car
	scen1Car5 = createVehicle(598, 2069.53515625, 868.87261962891, 6.8626842498779, 0, 0, 360)
	setElementDimension(scen1Car5, 65400+id)
	setVehicleEngineState(scen1Car5, true)
	setVehicleOverrideLights(scen1Car5, 2)
	setVehicleSirensOn(scen1Car5, true)
	
	-- Car
	scen1Car6 = createVehicle(598, 2063.2297363281, 866.16375732422, 6.8054342269897, 0, 0, 360)
	setElementDimension(scen1Car6, 65400+id)
	setVehicleEngineState(scen1Car6, true)
	setVehicleOverrideLights(scen1Car6, 2)
	setVehicleSirensOn(scen1Car6, true)
	
	scen1Timer = setTimer(updateScenario1, 50, 300)
	scen1Timer2 = setTimer(resetScenario1, 15000, 1)
end

triggerServerEvent("getSalt", getLocalPlayer())

function storeSalt(theSalt, version)
	sversion = version
	salt = theSalt
	
	createMainUI(getThisResource())
end
addEvent("sendSalt", true)
addEventHandler("sendSalt", getRootElement(), storeSalt)

function createMainUI(res, isChangeAccount)
	if (res==getThisResource()) then
		local tutFile = xmlLoadFile("vgrptut.xml")
		
		if (tutFile) then
			-- Set the camera to a nice view
			local cameraRand = math.random(1, 1)
			
			
			if (cameraRand==1) then
				loadScenarioOne()
				addEventHandler("onClientRender", getRootElement(), renderWelcomeMessage)
			end
			fadeCamera(true)
			
			if (bChangeChar) then
				destroyElement(bChangeAccount)
				bChangeAccount = nil
			end
			
			checkTOS() -- Terms of Service
			
			local width, height = 400, 200
			
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)

			if (scrWidth<1024) and (scrHeight<768) then
				outputChatBox("WARNING: You are running on a low resolution. We recommend atleast 1024x768.", 255, 0, 0)
			end
			
			local version = tonumber(string.sub(getVersion().type, 10, string.len(getVersion().type)))
			if (getVersion().type~="Custom" and getVersion().type~="Release") and sversion then
				
				if (version<sversion) then
					clearChatBox()
					showChat(true)
					outputChatBox("You are using an older nightly. You require r" .. sversion .. ".")
					outputChatBox("You can obtain this at http://nightly.mtasa.com")
					return
				end
			end
				
			tabPanelMain = guiCreateTabPanel(x, y, width, height, false)
			local regFile = xmlLoadFile("vgrpreg.xml")
			
			if (regFile) then -- User has already registered on this PC before.
				tabLogin = guiCreateTab("Login to Account", tabPanelMain)
				tabRegister = guiCreateTab("Register Account", tabPanelMain)
				tabForgot = guiCreateTab("Forgot Details", tabPanelMain)
			else
				tabRegister = guiCreateTab("Register Account", tabPanelMain)
				tabLogin = guiCreateTab("Login to Account", tabPanelMain)
				tabForgot = guiCreateTab("Forgot Details", tabPanelMain)
			end
			
			guiSetAlpha(tabPanelMain, 0)
			
			lRegUsername = guiCreateLabel(0.2, 0.15, 0.3, 0.1, "Account Name:", true, tabRegister)
			lRegUsernameNote = guiCreateLabel(0.225, 0.25, 0.8, 0.2, "NOTE: This is NOT your character's name.", true, tabRegister)
			guiSetFont(lRegUsernameNote, "default-bold-small")
			
			tRegUsername = guiCreateEdit(0.425, 0.15, 0.3, 0.1, "Memorable Name", true, tabRegister)
			guiEditSetMaxLength(tRegUsername, 16)
			
			lRegPassword = guiCreateLabel(0.15, 0.45, 0.3, 0.1, "Account Password:", true, tabRegister)
			tRegPassword = guiCreateEdit(0.425, 0.45, 0.3, 0.1, "password", true, tabRegister)
			guiEditSetMasked(tRegPassword, true)
			guiEditSetMaxLength(tRegPassword, 29)
			
			lRegPassword2 = guiCreateLabel(0.165, 0.575, 0.3, 0.1, "Confirm Password:", true, tabRegister)
			tRegPassword2 = guiCreateEdit(0.425, 0.575, 0.3, 0.1, "password", true, tabRegister)
			guiEditSetMasked(tRegPassword2, true)
			guiEditSetMaxLength(tRegPassword2, 29)
			
			bRegister = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Register", true, tabRegister)
			addEventHandler("onClientGUIClick", bRegister, validateDetails, false)
			
			-- LOGIN
			lLogUsername = guiCreateLabel(0.2, 0.2, 0.3, 0.1, "Account Name:", true, tabLogin)
			lLogUsernameNote = guiCreateLabel(0.225, 0.3, 0.8, 0.2, "NOTE: This is NOT your character's name.", true, tabLogin)
			guiSetFont(lLogUsernameNote, "default-bold-small")
			
			
			tLogUsername = guiCreateEdit(0.425, 0.2, 0.3, 0.1, "", true, tabLogin)
			guiEditSetMaxLength(tLogUsername, 16)
			
			lLogPassword = guiCreateLabel(0.15, 0.45, 0.3, 0.1, "Account Password:", true, tabLogin)
			tLogPassword = guiCreateEdit(0.425, 0.45, 0.3, 0.1, "", true, tabLogin)
			guiEditSetMasked(tLogPassword, true)
			guiEditSetMaxLength(tLogPassword, 32)
			
			chkRemember = guiCreateCheckBox(0.35, 0.52, 0.5, 0.15, "Remember my Details", false, true, tabLogin)
			chkAutoLogin = guiCreateCheckBox(0.35, 0.62, 0.5, 0.15, "Automatic Login", false, true, tabLogin)
			
			addEventHandler("onClientGUIClick", chkRemember, updateLoginState)
			
			bLogin = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Login", true, tabLogin)
			addEventHandler("onClientGUIClick", bLogin, validateDetails, false)
			
			-- FORGOTTEN DETAILS
			lLostSecurityKey = guiCreateLabel(0.15, 0.4, 0.3, 0.1, "Security Key:", true, tabForgot)
			tLostSecurityKey = guiCreateEdit(0.425, 0.4, 0.3, 0.1, "", true, tabForgot)
			guiEditSetMaxLength(tLostSecurityKey, 12)
			
			bForgot = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Retrieve Details", true, tabForgot)
			addEventHandler("onClientGUIClick", bForgot, retrieveDetails, false)
			
			-- LOAD SAVED USER INFO
			local xmlRoot = xmlLoadFile("vgrplogin.xml")
			if (xmlRoot) then
				local usernameNode = xmlFindChild(xmlRoot, "username", 0)
				local passwordNode = xmlFindChild(xmlRoot, "password", 0)
				local autologinNode = xmlFindChild(xmlRoot, "autologin", 0)
				
				if (usernameNode) then
					local uname = xmlNodeGetValue(usernameNode)
					if (uname) and (uname~="") then
						guiSetText(tLogUsername, tostring(uname))
						guiCheckBoxSetSelected(chkRemember, true)
					end
				end
				
				if (passwordNode) then
					local pword = xmlNodeGetValue(passwordNode)
					if (pword) and (pword~="") then
						guiSetText(tLogPassword, tostring(pword))
						guiCheckBoxSetSelected(chkRemember, true)
					else
						guiSetEnabled(chkAutoLogin, false)
					end
				end
				
				if (autologinNode) then
					local autolog = xmlNodeGetValue(autologinNode)
					if (autolog) and (autolog=="1") then
						
						if(guiGetEnabled(chkAutoLogin)) then
							guiCheckBoxSetSelected(chkAutoLogin, true)
							if not (isChangeAccount) then
								local vinfo = getVersion()
								local operatingsystem = vinfo.os
								triggerServerEvent("attemptLogin", getLocalPlayer(), guiGetText(tLogUsername), guiGetText(tLogPassword), operatingsystem) 
							end
						end
					end
				else
					guiCheckBoxSetSelected(chkAutoLogin, false)
				end
			end
			
			if (toswindow) then
				guiBringToFront(toswindow)
			end
			setTimer(fadeWindow, 50, 20)
		else
			showChat(true)
			showTutorial()
		end
	end
end
--addEventHandler("onClientResourceStart", getRootElement(), createMainUI)

function retrieveDetails()
	if (source==bForgot) then
		local securityKey = guiGetText(tLostSecurityKey)
		
		clearChatBox()
		if (string.len(securityKey)<12) then
			outputChatBox("Your security key must be 12 characters long.", 255, 0, 0)
		elseif (string.find(securityKey, ";", 0)) or (string.find(securityKey, "'", 0)) or (string.find(securityKey, "@", 0))  then
			outputChatBox("Your security key cannot contain ;,@'", 255, 0, 0)
		else
			guiSetText(tLostSecurityKey, "")
			showChat(true)
			triggerServerEvent("retrieveDetails", getLocalPlayer(), securityKey)
		end
	end
end

function updateLoginState()
	if (guiCheckBoxGetSelected(chkRemember)) then
		guiSetEnabled(chkAutoLogin, true)
	else
		guiSetEnabled(chkAutoLogin, false)
		guiCheckBoxSetSelected(chkAutoLogin, false)
	end
end

function validateDetails()
	if (source==bRegister) then
		local username = guiGetText(tRegUsername)
		local password1 = guiGetText(tRegPassword)
		local password2 = guiGetText(tRegPassword2)
		
		local password = password1 .. password2
		
		clearChatBox()
		if (string.len(username)<3) then
			outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
		elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
			outputChatBox("Your name cannot contain ;,@'.", 255, 0, 0)
		elseif (string.len(password1)<6) then
			outputChatBox("Your password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.len(password1)>=30) then
			outputChatBox("Your password is too long. You must enter less than 30 characters.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("Your password cannot contain ;,@'.", 255, 0, 0)
		elseif (password1~=password2) then
			outputChatBox("The passwords you entered do not match.", 255, 0, 0)
		else
			showChat(true)
			triggerServerEvent("attemptRegister", getLocalPlayer(), username, password1) 
		end
	elseif (source==bLogin) then
		local username = guiGetText(tLogUsername)
		local password = guiGetText(tLogPassword)
		
		clearChatBox()
		if (string.len(username)<3) then
			outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
		elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
			outputChatBox("Your name cannot contain ;,@.'", 255, 0, 0)
		elseif (string.len(password)<6) then
			outputChatBox("Your password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("Your password cannot contain ;,@'.", 255, 0, 0)
		else
			if (string.len(password)~=32) then
				password = md5(salt .. password)
			end
			
			local vinfo = getVersion()
			local operatingsystem = vinfo.os
			triggerServerEvent("attemptLogin", getLocalPlayer(), username, password, operatingsystem) 
			
			local saveInfo = guiCheckBoxGetSelected(chkRemember)
			local autoLogin = guiCheckBoxGetSelected(chkAutoLogin)
			
			local theFile = xmlCreateFile("vgrplogin.xml", "login")
			if (theFile) then
				if (saveInfo) then
					local node = xmlCreateChild(theFile, "username")
					xmlNodeSetValue(node, tostring(username))
					
					local node = xmlCreateChild(theFile, "password")
					xmlNodeSetValue(node, tostring(password))
					
					local node = xmlCreateChild(theFile, "autologin")
					if (autoLogin) then
						xmlNodeSetValue(node, tostring(1))
					else
						xmlNodeSetValue(node, tostring(0))
					end
				else
					local node = xmlCreateChild(theFile, "username")
					xmlNodeSetValue(node, "")
					
					local node = xmlCreateChild(theFile, "password")
					xmlNodeSetValue(node, "")
					
					local node = xmlCreateChild(theFile, "autologin")
					xmlNodeSetValue(node, tostring(0))
				end
				xmlSaveFile(theFile)
			end
		end
	end
end

function fadeWindow()
	if (tabPanelMain) then
		local alpha = guiGetAlpha(tabPanelMain)
		local newalpha = alpha + 0.05
		guiSetAlpha(tabPanelMain, newalpha)
		
		if(newalpha>=0.7) then
			guiSetAlpha(tabPanelMain, 0.75)
			showCursor(true)
			guiSetInputEnabled(true)
		end
	end
end

function hideUI(regged)
	local xmlRoot = xmlCreateFile("vgrpreg.xml", "registered")
	if (xmlRoot) then
		xmlSaveFile(xmlRoot)
	end

	showCursor(false)
	guiSetInputEnabled(false)
	
	cleanupScenarioOne()
	
	if (tabPanelMain) then
		destroyElement(tabPanelMain)
		tabPanelMain = nil
	end
	
	if (tabPanelCharacter) then
		destroyElement(tabPanelCharacter)
		tabPanelCharacter = nil
	end
	
	removeEventHandler("onClientRender", getRootElement(), renderWelcomeMessage)
	
	if (regged) then
		createMainUI(getThisResource())
	end
	
	if (bChangeAccount) then
		destroyElement(bChangeAccount)
		bChangeAccount = nil
	end
end
addEvent("hideUI", true)
addEventHandler("hideUI", getRootElement(), hideUI)

tabPanelCharacter, tabCharacter, tabAccount, tabAchievements, tabStatistics, tableAccounts, lCharacters, paneCharacters, lCreateFakepane, lCreateBG, lCreateName, lCreateImage = nil
paneChars = { }
tableAchievements, tableStatistics, iAchievementCount, iAchievementPointsCount = nil
bDeleteChar = nil
bChangeAccount = nil

function showCharacterUI(accounts, achievementCount, achievementPointsCount, achievements, firstTime)
	if (bChangeChar) then
		destroyElement(bChangeChar)
		bChangeChar = nil
	end
	
	if not (firstTime) then
		showChat(false)
	end
	setElementAlpha(getLocalPlayer(), 255)
	
	setCameraInterior(14)
	setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
	fadeCamera(true)
	
	tableAccounts = accounts
	iAchievementCount = achievementCount
	iAchievementPointsCount = achievementPointsCount
	tableAchievements = achievements
	
	toggleAllControls(false, true, false)

	local width, height = 420, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCharacter = guiCreateTabPanel(5, y, width, height, false)
	tabCharacter = guiCreateTab("Character Selection", tabPanelCharacter)
	tabAccount = guiCreateTab("Account Management", tabPanelCharacter)
	tabAchievements = guiCreateTab("Achievements", tabPanelCharacter)
	
	displayAccountManagement()
	displayAchievements()

	-- Character Info
	local charsDead, charsAlive = 0, 0
	
	for key, value in pairs(accounts) do
		if (tonumber(accounts[key][3])==1) then
			charsDead = charsDead + 1
		else
			charsAlive = charsAlive + 1
		end
	end
	
	lCharacters = guiCreateLabel(0.05, 0.025, 0.9, 0.15, "Characters: " .. #accounts .. " (" .. charsAlive .. " Alive, " .. charsDead .. " Dead).", true, tabCharacter)
	guiSetFont(lCharacters, "default-bold-small")
	
	paneCharacters = guiCreateScrollPane(0.05, 0.075, 0.9, 0.85, true, tabCharacter)
	
	paneChars = { }
	local y = 0.0
	local height = 0.2
	
	for key, value in pairs(accounts) do
		local charname = string.gsub(tostring(accounts[key][2]), "_", " ")
		local cked = tonumber(accounts[key][3])
		local area = accounts[key][4]
		local age = accounts[key][5]
		local gender = tonumber(accounts[key][6])
		local factionName = accounts[key][7]
		local factionRank = accounts[key][8]
		local skinID = tostring(accounts[key][9])
		local charyearday = tonumber(accounts[key][10])
		local charyear = tonumber(accounts[key][11])
		local login = ""
		
		-- Compare the TIME
		local time = getRealTime()
		local year = 1900+time.year
		local yearday = time.yearday
		
		if (charyearday==999) then
			login = "Never"
		elseif (year>charyear) then
			login = "last year"
		else
			local difference = yearday - charyearday
			
			if (difference==0) then
				login = "Today"
			elseif (difference==1) then
				login = tostring(difference) .. " day ago"
			else
				login = tostring(difference) .. " days ago"
			end
		end
		
		--Fix skin ID
		if (string.len(skinID)==2) then
			skinID = "0" .. skinID
		elseif (string.len(skinID)==1) then
			skinID = "00" .. skinID
		end
		
		-- Gender
		if (gender==0) then
			gender = "Male"
		else
			gender = "Female"
		end
		
		paneChars[key] = {}
		paneChars[key][7] = guiCreateScrollPane(0.0, y, 1.0, 0.35, true, paneCharacters)
		paneChars[key][1] = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, "img/charbg0.png", true, paneChars[key][7])
		
		if (cked==0) then
			paneChars[key][2] = guiCreateLabel(0.3, 0.1, 0.5, 0.2, tostring(charname), true, paneChars[key][7])
		else
			paneChars[key][2] = guiCreateLabel(0.3, 0.1, 0.5, 0.2, tostring(charname) .. " (Deceased)", true, paneChars[key][7])
		end
		
		paneChars[key][3] = guiCreateStaticImage(0.05, 0.1, 0.2, 0.5, "img/" .. skinID .. ".png", true, paneChars[key][7])
		paneChars[key][4] = guiCreateLabel(0.3, 0.25, 0.7, 0.2, age .. " year old " .. gender .. ".", true, paneChars[key][7])
		
		if (factionRank=="Nullement") then
			paneChars[key][5] = guiCreateLabel(0.3, 0.35, 0.7, 0.2, "Not in a faction.", true, paneChars[key][7])
		else
			paneChars[key][5] = guiCreateLabel(0.3, 0.35, 0.7, 0.2, tostring(factionRank) .. " of '" .. tostring(factionName) .. "'.", true, paneChars[key][7])
		end
		
		if (login~="Never") then
			paneChars[key][6] = guiCreateLabel(0.3, 0.45, 0.7, 0.2, "Last seen: " .. login .. " at " .. area .. ".", true, paneChars[key][7])
		else
			paneChars[key][6] = guiCreateLabel(0.3, 0.45, 0.7, 0.2, "Last seen: Never", true, paneChars[key][7])
		end
		
		addEventHandler("onClientGUIClick", paneChars[key][1], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][2], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][3], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][4], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][5], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][6], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][7], selectedCharacter)
		
		addEventHandler("onClientGUIDoubleClick", paneChars[key][1], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][2], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][3], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][4], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][5], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][6], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][7], dcselectedCharacter)
		
		-- Set the fonts
		guiSetFont(paneChars[key][2], "default-bold-small")
		guiSetFont(paneChars[key][4], "default-small")
		guiSetFont(paneChars[key][5], "default-small")
		guiSetFont(paneChars[key][6], "default-small")
		
		y = y + 0.205
	end
	
	-- For character creation
	lCreateFakepane = guiCreateScrollPane(0.0, y-0.015, 1.0, 0.35, true, paneCharacters)
	lCreateBG = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, "img/charbg0.png", true, lCreateFakepane)
	lCreateName = guiCreateLabel(0.3, 0.1, 0.5, 0.2, "Create a character", true, lCreateFakepane)
	lCreateImage = guiCreateStaticImage(0.05, 0.07, 0.2, 0.53, "img/newchar.png", true, lCreateFakepane)

	guiSetFont(lCreateName, "default-bold-small")
	
	addEventHandler("onClientGUIClick", lCreateFakepane, selectedCharacter)
	addEventHandler("onClientGUIClick", lCreateBG, selectedCharacter)
	addEventHandler("onClientGUIClick", lCreateName, selectedCharacter)
	addEventHandler("onClientGUIClick", lCreateImage, selectedCharacter)
	
	addEventHandler("onClientGUIDoubleClick", lCreateFakepane, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateBG, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateName, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateImage, dcselectedCharacter)
	
	-- Delete char button
	bDeleteChar = guiCreateButton(0.05, 0.925, 0.9, 0.05, "Delete Character", true, tabCharacter)
	
	addEventHandler("onClientGUIClick", bDeleteChar, deleteSelectedCharacter, false)
	
	guiSetAlpha(tabPanelCharacter, 0.75)
	showCursor(true)
	setElementAlpha(getLocalPlayer(), 0)
	fadeCamera(true, 2)
	
	-- Change Account button
	bChangeAccount = guiCreateButton(0.835, 0.925, 0.15, 0.05, "Change Account", true)
	guiSetAlpha(bChangeAccount, 0.75)
	addEventHandler("onClientGUIClick", bChangeAccount, changeAccount)
	
	guiSetInputEnabled(true)
end
addEvent("showCharacterSelection", true)
addEventHandler("showCharacterSelection", getRootElement(), showCharacterUI)

function changeAccount(button, state)
	if (source==bChangeAccount) and (button=="left") then
		local id = getElementData(getLocalPlayer(), "gameaccountid")
		showCursor(false)
		cancelCreation()
		hideUI()
		
		createMainUI(getThisResource(), true)
		--destroyElement(bChangeAccount)
		--bChangeAccount = nil
		setElementData(getLocalPlayer(), "gameaccountloggedin", 0, true)
	end
end

fading = false
tmrHideMouse = nil

function fadePlayerIn(newChar)
	local alpha = getElementAlpha(getLocalPlayer())
	setElementAlpha(getLocalPlayer(), alpha+25)
	if ((alpha+25)>=250) then
		setElementAlpha(getLocalPlayer(), 255)
		showCursor(true)
		fading = false
	end
end

triggering = false
spawned = false

function deleteSelectedCharacter(button, state)
	if (button=="left") and (state=="up") and (source==bDeleteChar) then
		if (selectedChar) then
			local charname = tostring(guiGetText(paneChars[selectedChar][2]))
			hideUI()
			triggerServerEvent("deleteCharacter", getLocalPlayer(), charname)
		end
	end
end
			
addEvent("onClientChooseCharacter", false)
function dcselectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then
			if not (triggering) then
				triggering = true
			
				-- Find the key that was hit
				local foundkey = nil
				for key, value in pairs(paneChars) do
					for i, j in pairs(paneChars[key]) do
						if (j==source) then
							foundkey = key
						end
					end
				end
				
				local charname = tostring(guiGetText(paneChars[foundkey][2]))
				local cked = string.find(charname, "(Deceased)")

				if (cked==nil) then
					fadeCamera(false, 1)
					setCameraInterior(0)
					spawned = true
					destroyElement(tabPanelCharacter)
					playSoundFrontEnd(32)
					triggerServerEvent("spawnCharacter", getLocalPlayer(), charname)
					setTimer(resetTriggers, 100, 1)
					setTimer(showCursor, 50, 30, false)
					
					toggleAllControls(true, true, true)
					guiSetInputEnabled(false)
					showCursor(false)
					showChat(true)
					showLogoutPanel()
					
					showPlayerHudComponent("weapon", true)
					showPlayerHudComponent("ammo", true)
					showPlayerHudComponent("vehicle_name", false)
					showPlayerHudComponent("money", true)
					showPlayerHudComponent("clock", true)
					showPlayerHudComponent("health", true)
					showPlayerHudComponent("armour", true)
					showPlayerHudComponent("breath", true)
					showPlayerHudComponent("radar", true)
					showPlayerHudComponent("area_name", true)
				else
					triggering = false
					setTimer(playSoundFrontEnd, 500, 3, 20)
				end
			end
		else
			if (creation==false) then
				creation = true
				guiSetVisible(tabPanelCharacter, false)
				characterCreation()
				playSoundFrontEnd(32)
			end
		end
	end
end



bChangeChar = nil
selectedChar = nil
function showLogoutPanel()
	bChangeChar = guiCreateButton(0.835, 0.925, 0.15, 0.05, "Change Character", true)
	guiSetAlpha(bChangeChar, 0.75)
	addEventHandler("onClientGUIClick", bChangeChar, changeCharacter)
end

addEvent("onClientChangeChar", false)
function changeCharacter(button, state)
	if (source==bChangeChar) and (button=="left") then
		local id = getElementData(getLocalPlayer(), "gameaccountid")
		destroyElement(bChangeChar)
		bChangeChar = nil
		showCursor(false)
		triggerEvent("onClientChangeChar", getLocalPlayer())
		triggerServerEvent("sendAccounts", getLocalPlayer(), getLocalPlayer(), id, true)
		setElementData(getLocalPlayer(), "loggedin", 0, true)
	end
end

function resetTriggers()
	triggering = false
end

function unhideCursor()
	if not (spawned) then
		showCursor(true)
	else
		showCursor(false)
	end
end

function selectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		playSoundFrontEnd(32)
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then
			local found = false
			local key = 0
			for i, j in pairs(paneChars) do
				local isthis = false
				for k, v in pairs(paneChars[i]) do
			        if (v==source) then
						isthis = true
						found = true
						key = i
					end
				end
				
				guiBringToFront(paneChars[i][2])
				guiBringToFront(paneChars[i][3])
				guiBringToFront(paneChars[i][4])
				guiBringToFront(paneChars[i][5])
				guiBringToFront(paneChars[i][6])
				guiBringToFront(paneChars[i][7])
				
				guiBringToFront(lCreateBG)
				guiBringToFront(lCreateFakepane)
				guiBringToFront(lCreateName)
				guiBringToFront(lCreateImage)
				if not (isthis) then
					guiStaticImageLoadImage(paneChars[i][1], "img/charbg0.png")
				end
			end

			if (found) then
				guiStaticImageLoadImage(paneChars[key][1], "img/charbg1.png")
				
				selectedChar = key
				guiStaticImageLoadImage(lCreateBG, "img/charbg0.png")
				
				if not (fading) then
					
					local skinID = tonumber(tableAccounts[key][9])
					local cked = tonumber(tableAccounts[key][3])
					setElementModel(getLocalPlayer(), skinID)
					setPedAnimation(getLocalPlayer(), "ON_LOOKERS", "wave_loop", -1, true, false, false)
					setElementAlpha(getLocalPlayer(), 0)
					
					if (cked==0) then
						if (skinID==0) then -- Load CJ's clothes etc.
							local charname = tableAccounts[key][2]
							triggerServerEvent("spawnClothes", getLocalPlayer(), charname)
						end
						fading = true
						
						tmrHideMouse = setTimer(unhideCursor, 200, 1)
						tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
					else
						local x, y, z = getElementPosition(getLocalPlayer())
						setElementAlpha(getLocalPlayer(), 0)
						tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
						setPedAnimation(getLocalPlayer(), "WUZI", "CS_Dead_Guy", -1, false, false, false)
					end
				end
			end
		else
			for key, value in ipairs(paneChars) do
				guiStaticImageLoadImage(paneChars[key][1], "img/charbg0.png")
			end
			selectedChar = nil
			
			guiBringToFront(lCreateBG)
			guiBringToFront(lCreateFakepane)
			guiBringToFront(lCreateName)
			guiBringToFront(lCreateImage)
			guiStaticImageLoadImage(lCreateBG, "img/charbg1.png")
			
			-- Player effect
			if not (fading) then
				setElementModel(getLocalPlayer(), 0)
				
				triggerServerEvent("stripPlayer", getLocalPlayer())
				setElementAlpha(getLocalPlayer(), 0)
				
				
				fading = true
				
				tmrHideMouse = setTimer(unhideCursor, 200, 1)
				tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
			end
		end
	end
end

-- /////////////////////////////// CHARACTER CREATION ////////////////////////////////////
tabPanelCreation, bCancel, bNext, lType, rNormal, rCJ = nil

-- Step 1
fatness = 0
muscles = 0
name = ""

tabCreationOne, lName, tName, lRestrictions, bRotate = nil

creation = false

function characterCreation()
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationOne = guiCreateTab("Character Creation: Step 1", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	rot = 120.0
	addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
	
	lType = guiCreateLabel(0.1, 0.45, 0.25, 0.1, "Character Type:", true, tabCreationOne)
	guiSetFont(lType, "default-bold-small")
	
	rCJ = guiCreateRadioButton(0.15, 0.5, 0.6, 0.05, "CJ - Ultimate customization", true, tabCreationOne)
	rNormal = guiCreateRadioButton(0.15, 0.65, 0.6, 0.05, "Normal - Pedestrian skin", true, tabCreationOne)
	
	
	guiRadioButtonSetSelected(rCJ, true)
	addEventHandler("onClientGUIClick", rNormal, spawnNormal, false)
	addEventHandler("onClientGUIClick", rCJ, spawnCJ, false)
	
	
	guiSetFont(rNormal, "default-bold-small")
	guiSetFont(rCJ, "default-bold-small")
	
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationOne)
	addEventHandler("onClientGUIClick", bNext, loadNextPage, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationOne)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	
	-- Step 1 tab contents
	lName = guiCreateLabel(0.1, 0.05, 0.25, 0.1, "Character Name:", true, tabCreationOne) 
	tName = guiCreateEdit(0.35, 0.05, 0.4, 0.05, "Joe Bloggs", true, tabCreationOne)
	
	addEventHandler("onClientGUIChanged", tName, checkName) 
	guiSetFont(lName, "default-bold-small")
	
	lRestrictions = guiCreateLabel(0.0, 0.105, 1.0, 0.3, "Restrictions: \n\n - Must NOT contain underscores, use spaces. \n - Must be a realistic, roleplay name \n - Must be less than 30 characters long \n - Must be two words, Firstname Lastname \n - Cannot contain numbers \n - Cannot contain special characters such as $@';", true, tabCreationOne)
	guiLabelSetColor(lRestrictions, 0, 255, 0)
	guiLabelSetHorizontalAlign(lRestrictions, "center")
	guiSetFont(lRestrictions,"default-bold-small")
	
	bRotate = guiCreateButton(0.835, 0.855, 0.15, 0.05, "Pause Camera", true)
	guiSetAlpha(bRotate, 0.75)
	addEventHandler("onClientGUIClick", bRotate, pauseCameraMovement, false)
	
	showCursor(true)
	guiSetInputEnabled(true)
end

function pauseCameraMovement()
	if not (removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)) then
		addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		guiSetText(bRotate, "Pause Camera")
	else
		guiSetText(bRotate, "Un-Pause Camera")
	end
end

function spawnCJ(button, state)
	if (button=="left") and (state=="up") then
		setElementModel(getLocalPlayer(), 0) 
		for i = 0, 17 do
			removePlayerClothes(getLocalPlayer(), i)
		end
	end
end

function spawnNormal(button, state)
	if (button=="left") and (state=="up") then
		skinint = math.random(1, #blackMales)
		skin = blackMales[skinint]
		setElementModel(getLocalPlayer(), skin)
		curskin = skinint
	end
end

function checkName()
	if (source==tName) then
		local theText = guiGetText(source)
		
		local foundSpace = string.find(theText, "%s", 2)
		
		local length = string.len(theText)
		local foundNumber = false
		for i = 0, 9 do
			if (string.find(theText, tostring(i))) then
				foundNumber = true
			end
		end
		
		local noSpecialChars = false
		if (string.find(theText, ";", 0)) or (string.find(theText, "'", 0)) or (string.find(theText, "_", 0)) or (string.find(theText, "@", 0)) or (string.find(theText, ",", 0)) then
			noSpecialChars = false
		else
			noSpecialChars = true
		end
		
		if (foundSpace) and (length<30) and not (foundNumber) and (noSpecialChars) then
			guiLabelSetColor(lRestrictions, 0, 255, 0)
		else
			guiLabelSetColor(lRestrictions, 255, 0, 0)
		end
	end
end

function cancelCreation(button, state)
			triggerServerEvent("stripPlayer", getLocalPlayer())
			removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			
			destroyElement(bRotate)
			bRotate = nil
			local playerid = getElementData(getLocalPlayer(), "playerid")
			setElementInterior(getLocalPlayer(), 14)
			setElementDimension(getLocalPlayer(), 65000+playerid)
			setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375)
			setPedRotation(getLocalPlayer(), 268.19247436523)
			
			creation = false
			destroyElement(tabPanelCreation)
			tabPanelCreation = nil
			
			
			setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
			setCameraInterior(14)
			fadeCamera(true)
			
			--addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			guiSetVisible(tabPanelCharacter, true)
end

rot = 120.0
function moveCameraToCreation()
	local pX, pY, pZ = getElementPosition(getLocalPlayer())
	local x = pX + math.cos(math.deg(rot))*2
	local y = pY + math.sin(math.deg(rot))*2
		
	local sight, eX, eY, eZ = processLineOfSight(pX, pY, pZ, x, y, pZ+1, true, true, false)
			
	if (sight) then
		setCameraMatrix(eX, eY, eZ, pX, pY, pZ+0.2)
	else
		setCameraMatrix(x, y, pZ+1, pX, pY, pZ+0.2)
	end
	rot = rot + 0.0001
end

function loadNextPage(button, state)
	if (button=="left") and (state=="up") then
		triggerServerEvent("doesCharacterExist", getLocalPlayer(), guiGetText(tName))
	end
end

function nextPage(exists)
	if (exists) then
		guiSetText(tName, "Already Taken")
		guiLabelSetColor(lRestrictions, 255, 0, 0)
	elseif not (exists) then
		local CJ = guiRadioButtonGetSelected(rCJ)
			
		name = guiGetText(tName)
		destroyElement(tabCreationOne)
		tabCreationOne = nil
			
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		if (CJ) then
			characterCreationStep2CJ()
		else
			characterCreationStep2Normal()
		end
	end
end
addEvent("characterNextStep", true )
addEventHandler("characterNextStep", getRootElement(), nextPage)

tabCreationTwo, fatInc, fatDec, lFat, lFatDesc, muscleInc, muscleDec, lMuscle, lMuscleDesc = nil
lDescriptionNormal, lGender, rMale, rFemale, lSkinColour, rBlack, rWhite, rAsian, tempPane, lChangeSkin, nextSkin, prevSkin = nil
gender = 0
skincolour = 0
curskin = 0

blackMales = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function characterCreationStep2Normal()
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationTwo = guiCreateTab("Character Creation: Step 2", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	lDescriptionNormal = guiCreateLabel(0.1, 0.025, 0.9, 0.15, "Design your character", true, tabCreationTwo) 
	guiSetFont(lDescriptionNormal, "sa-header")
	
	--/////////////
	-- GENDER
	--/////////////
	lGender = guiCreateLabel(0.1, 0.225, 0.25, 0.15, "Gender:", true, tabCreationTwo)
	guiSetFont(lGender, "default-bold-small")

	rMale =  guiCreateRadioButton(0.4, 0.225, 0.15, 0.05, "Male", true, tabCreationTwo)
	rFemale =  guiCreateRadioButton(0.65, 0.225, 0.15, 0.05, "Female", true, tabCreationTwo)
	guiRadioButtonSetSelected(rMale, true)
	addEventHandler("onClientGUIClick", rMale, normalSetMale, false)
	addEventHandler("onClientGUIClick", rFemale, normalSetFemale, false)
	
	--/////////////
	-- SKIN COLOUR
	--/////////////
	tempPane = guiCreateScrollPane(0.05, 0.35, 0.9, 0.4, true, tabCreationTwo)
	lSkinColour = guiCreateLabel(0.1, 0.375, 0.25, 0.15, "Skin Colour:", true, tempPane)
	guiSetFont(lSkinColour, "default-bold-small")

	rBlack =  guiCreateRadioButton(0.4, 0.385, 0.15, 0.15, "Black", true, tempPane)
	rWhite =  guiCreateRadioButton(0.6, 0.385, 0.15, 0.15, "White", true, tempPane)
	rAsian =  guiCreateRadioButton(0.8, 0.385, 0.15, 0.15, "Asian", true, tempPane)
	guiRadioButtonSetSelected(rBlack, true)
	addEventHandler("onClientGUIClick", rBlack, normalSetBlack, true, false, false)
	addEventHandler("onClientGUIClick", rWhite, normalSetWhite, false, true, false)
	addEventHandler("onClientGUIClick", rAsian, normalSetAsian, false, false, true)
	
	--/////////////
	-- SKIN
	--/////////////
	lChangeSkin = guiCreateLabel(0.1, 0.535, 0.25, 0.2, "Skin:", true, tempPane) 
	guiSetFont(lChangeSkin, "default-bold-small")
	
	prevSkin =  guiCreateButton(0.3, 0.525, 0.2, 0.15, "<-", true, tempPane)
	addEventHandler("onClientGUIClick", prevSkin, adjustNormalSkin, false)
	
	nextSkin =  guiCreateButton(0.6, 0.525, 0.2, 0.15, "->", true, tempPane)
	addEventHandler("onClientGUIClick", nextSkin, adjustNormalSkin, false)
	
	-- NEXT/BACK
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bNext, characterCreationStep5, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustNormalSkin(button, state)
	if (button=="left") and (state=="up") then
		if (source==nextSkin) then
			local array = nil
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales
				end
			end
			
			-- Get the next skin
			if (curskin==#array) then
				curskin = 1
				skin = array[1]
				setElementModel(getLocalPlayer(), tonumber(skin))
			else
				curskin = curskin + 1
				skin = array[curskin]
				setElementModel(getLocalPlayer(), tonumber(skin))
			end
		elseif (source==prevSkin) then
			local array = nil
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales
				end
			end
			
			-- Get the next skin
			if (curskin==1) then
				curskin = #array
				skin = array[1]
				setElementModel(getLocalPlayer(), tonumber(skin))
			else
				curskin = curskin - 1
				skin = array[curskin]
				setElementModel(getLocalPlayer(), tonumber(skin))
			end
		end
	end
end

function normalSetMale(button, state)
	if (source==rMale) and (button=="left") and (state=="up") then
		gender = 0
		generateSkin()
	end
end

function normalSetFemale(button, state)
	if (source==rFemale) and (button=="left") and (state=="up") then
		gender = 1
		generateSkin()
	end
end

function normalSetBlack(button, state)
	if (source==rBlack) and (button=="left") and (state=="up") then
		skincolour = 0
		generateSkin()
	end
end

function normalSetWhite(button, state)
	if (source==rWhite) and (button=="left") and (state=="up") then
		skincolour = 1
		generateSkin()
	end
end

function normalSetAsian(button, state)
	if (source==rAsian) and (button=="left") and (state=="up") then
		skincolour = 2
		generateSkin()
	end
end

function generateSkin()
	local skinint = 0
	if (gender==0) then -- MALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackMales)
			skin = blackMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteMales)
			skin = whiteMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianMales)
			skin = asianMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		end
	elseif (gender==1) then -- FEMALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackFemales)
			skin = blackFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteFemales)
			skin = whiteFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianFemales)
			skin = asianFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		end
	end
	curskin = skinint
end
	

function characterCreationStep2CJ()
	fatness = 0
	muscles = 0
	gender = 0
	skincolour = 0
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationTwo = guiCreateTab("Character Creation: Step 2", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	--/////////////
	-- FAT
	--/////////////
	lFat = guiCreateLabel(0.1, 0.025, 0.25, 0.15, "Fat", true, tabCreationTwo) 
	guiSetFont(lFat, "sa-header")
	
	lFatDesc = guiCreateLabel(0.1, 0.15, 0.9, 0.1, "Be able to climb a wall: Will he or won't he?", true, tabCreationTwo)
	guiSetFont(lFatDesc, "default-bold-small")
	
	fatDec =  guiCreateButton(0.15, 0.225, 0.2, 0.1, "-", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", fatDec, adjustFatness, false)
	
	fatInc =  guiCreateButton(0.45, 0.225, 0.2, 0.1, "+", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", fatInc, adjustFatness, false)
	
	--/////////////
	-- MUSCLES
	--/////////////
	lMuscle = guiCreateLabel(0.1, 0.375, 0.4, 0.15, "Muscles", true, tabCreationTwo)
	guiSetFont(lMuscle, "sa-header")
	
	lMuscleDesc = guiCreateLabel(0.1, 0.5, 0.9, 0.1, "Rocky Balboa or Minnie Mouse?", true, tabCreationTwo)
	guiSetFont(lMuscleDesc, "default-bold-small")
	
	muscleDec =  guiCreateButton(0.15, 0.575, 0.2, 0.1, "-", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", muscleDec, adjustMuscles, false)
	
	muscleInc =  guiCreateButton(0.45, 0.575, 0.2, 0.1, "+", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", muscleInc, adjustMuscles, false)
	
	-- NEXT/BACK
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bNext, characterCreationStep3CJ, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustFatness(button, state)
	if (button=="left") and (state=="up") then
		if (source==fatDec) then
			if (fatness>=99) then
				fatness = fatness - 99
				triggerServerEvent("adjustFatness", getLocalPlayer(), fatness)
			end
		elseif (source==fatInc) then
			if (fatness<=900) then
				fatness = fatness + 99
				triggerServerEvent("adjustFatness", getLocalPlayer(), fatness)
			end
		end
	end
end

function adjustMuscles(button, state)
	if (button=="left") and (state=="up") then
		if (source==muscleDec) then
			if (muscles>=99) then
				muscles = muscles - 99
				triggerServerEvent("adjustMuscles", getLocalPlayer(), muscles)
			end
		elseif (source==muscleInc) then
			if (muscles<=900) then
				muscles = muscles + 99
				triggerServerEvent("adjustMuscles", getLocalPlayer(), muscles)
			end
		end
	end
end

leftUpperArmTattoos = { {"NONE", "NONE"}, {"4WEED", "4weed"}, {"4RIP", "4rip"}, {"4SPIDER", "4spider"} }
leftLowerArmTattoos = { {"NONE", "NONE"}, {"5GUN", "5gun"}, {"5CROSS", "5cross"}, {"5CROSS2", "5cross2"}, {"5CROSS3", "5cross3"}  }
rightUpperArmTattoos = { {"NONE", "NONE"}, {"6AZTEC", "6aztec"}, {"6CROWN", "6crown"}, {"6CLOWN", "6clown"}, {"6AFRICA", "6africa"} }
rightLowerArmTattoos = { {"NONE", "NONE"}, {"7CROSS", "7cross"}, {"7CROSS2", "7cross2"}, {"7MARY", "7mary"} }
backTattoos = { {"NONE", "NONE"}, {"8SA", "8sa"}, {"8SA2", "8sa2"}, {"8SA3", "8sa3"}, {"8WESTSD", "8westside"}, {"8SANTOS", "8santos"}, {"8POKER", "8poker"}, {"8GUN", "8gun"} }
leftChestTattoos = { {"NONE", "NONE"}, {"9CROWN", "9crown"}, {"9GUN", "9GUN"}, {"9GUN2", "9gun2"}, {"9HOMBY", "9homeboy"}, {"9BULLT", "9bullet"}, {"9RASTA", "9rasta"} }
rightChestTattoos = { {"NONE", "NONE"}, {"10LS", "10ls"}, {"10LS2", "10ls2"}, {"10LS3", "10ls3"}, {"10LS4", "10ls4"}, {"10ls5", "10ls5"}, {"10OG", "10og"}, {"10WEED", "10weed"} }
stomachTattoos = { {"NONE", "NONE"}, {"11GROVE", "11grove"}, {"11GROV2", "11grove2"}, {"11GROV3", "11grove3"}, {"11DICE", "11dice"}, {"11DICE2", "11dice2"}, {"11JAIL", "11jail"}, {"11GGIFT", "11godsgift"} }
lowerBackTattoos = { {"NONE", "NONE"}, {"12ANGEL", "12angels"}, {"12MAYBR", "12mayabird"}, {"12DAGER", "12dagger"}, {"12BNDIT", "12bandit"}, {"12CROSS", "12cross7"}, {"12MYFAC", "12mayafce"} }

lTattoos, lLeftUpperArm, bLeftUpperPrev, bLeftUpperNext, lLeftLowerArm, bLeftLowerPrev, bLeftLowNext, lRightUpperArm, bRightUpperPrev, bRightUpperNext, lRightLowerArm, bRightLowerPrev, bRightLowNext, lBackTattoo, bBackTattooPrev, bBackTattooNext, lLeftChest, bLeftChestPrev, bLeftChestNext = nil
lRightChest, bRightChestPrev, bRightChestNext, lStomach, bStomachPrev, bStomachNext, lLowBack, bLowBackPrev, bLowBackNext = nil
lLeftUpperArmInfo, lLeftLowerArmInfo, lRightUpperArmInfo, lRightLowerArmInfo, lBackTattooInfo, lLeftChestInfo, lRightChestInfo, lStomachInfo, lLowerBackInfo = nil
luTattoo = 1
llTattoo = 1
ruTattoo = 1
rlTattoo = 1
bTattoo = 1
lcTattoo = 1
rcTattoo = 1
sTattoo = 1
lbTattoo = 1

function characterCreationStep3CJ()
		gender = 0
		skincolour = 0
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		destroyElement(tabCreationTwo)
		tabCreationTwo = nil
		
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationThree = guiCreateTab("Character Creation: Step 3", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lTattoos = guiCreateLabel(0.1, 0.025, 0.25, 0.15, "Tattoos", true, tabCreationThree) 
		guiSetFont(lTattoos, "sa-header")
		
		--/////////////
		-- LEFT UPPER ARM
		--/////////////
		lLeftUpperArmInfo = guiCreateLabel(0.87, 0.125, 0.13, 0.15, "1/" .. #leftUpperArmTattoos, true, tabCreationThree)
		guiSetFont(lLeftUpperArmInfo, "default-bold-small")
		
		lLeftUpperArm = guiCreateLabel(0.1, 0.125, 0.25, 0.15, "Left Upper Arm:", true, tabCreationThree)
		guiSetFont(lLeftUpperArm, "default-bold-small")
		
		bLeftUpperPrev =  guiCreateButton(0.4, 0.125, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftUpperPrev, adjustTattoos, false)
		
		bLeftUpperNext =  guiCreateButton(0.65, 0.125, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftUpperNext, adjustTattoos, false)
		
		--/////////////
		-- LEFT LOWER ARM
		--/////////////
		lLeftLowerArmInfo = guiCreateLabel(0.87, 0.18, 0.13, 0.15, "1/" .. #leftLowerArmTattoos, true, tabCreationThree)
		guiSetFont(lLeftLowerArmInfo, "default-bold-small")
		
		lLeftLowerArm = guiCreateLabel(0.1, 0.18, 0.25, 0.15, "Left Lower Arm:", true, tabCreationThree)
		guiSetFont(lLeftLowerArm, "default-bold-small")
		
		bLeftLowerPrev =  guiCreateButton(0.4, 0.18, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftLowerPrev, adjustTattoos, false)
		
		bLeftLowerNext =  guiCreateButton(0.65, 0.18, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftLowerNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT UPPER ARM
		--/////////////
		lRightUpperArmInfo = guiCreateLabel(0.87, 0.235, 0.13, 0.15, "1/" .. #rightUpperArmTattoos, true, tabCreationThree)
		guiSetFont(lRightUpperArmInfo, "default-bold-small")
		
		lRightUpperArm = guiCreateLabel(0.1, 0.235, 0.25, 0.15, "Right Upper Arm:", true, tabCreationThree)
		guiSetFont(lRightUpperArm, "default-bold-small")
		
		bRightUpperPrev =  guiCreateButton(0.4, 0.235, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightUpperPrev, adjustTattoos, false)
		
		bRightUpperNext =  guiCreateButton(0.65, 0.235, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightUpperNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT LOWER ARM
		--/////////////
		lRightLowerArmInfo = guiCreateLabel(0.87, 0.29, 0.13, 0.15, "1/" .. #rightLowerArmTattoos, true, tabCreationThree)
		guiSetFont(lRightLowerArmInfo, "default-bold-small")
		
		lRightLowerArm = guiCreateLabel(0.1, 0.29, 0.25, 0.15, "Right Lower Arm:", true, tabCreationThree)
		guiSetFont(lRightLowerArm, "default-bold-small")
		
		bRightLowerPrev =  guiCreateButton(0.4, 0.29, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightLowerPrev, adjustTattoos, false)
		
		bRightLowerNext =  guiCreateButton(0.65, 0.29, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightLowerNext, adjustTattoos, false)
		
		--/////////////
		-- BACK
		--/////////////
		lBackTattooInfo = guiCreateLabel(0.87, 0.345, 0.13, 0.15, "1/" .. #backTattoos, true, tabCreationThree)
		guiSetFont(lBackTattooInfo, "default-bold-small")
		
		lBackTattoo = guiCreateLabel(0.1, 0.345, 0.25, 0.15, "Back:", true, tabCreationThree)
		guiSetFont(lBackTattoo, "default-bold-small")
		
		bBackTattooPrev =  guiCreateButton(0.4, 0.345, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bBackTattooPrev, adjustTattoos, false)
		
		bBackTattooNext =  guiCreateButton(0.65, 0.345, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bBackTattooNext, adjustTattoos, false)
		
		--/////////////
		-- LEFT CHEST
		--/////////////
		lLeftChestInfo = guiCreateLabel(0.87, 0.4, 0.13, 0.15, "1/" .. #leftChestTattoos, true, tabCreationThree)
		guiSetFont(lLeftChestInfo, "default-bold-small")
		
		lLeftChest = guiCreateLabel(0.1, 0.4, 0.25, 0.15, "Left Chest:", true, tabCreationThree)
		guiSetFont(lLeftChest, "default-bold-small")
		
		bLeftChestPrev =  guiCreateButton(0.4, 0.4, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftChestPrev, adjustTattoos, false)
		
		bLeftChestNext =  guiCreateButton(0.65, 0.4, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftChestNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT CHEST
		--/////////////
		lRightChestInfo = guiCreateLabel(0.87, 0.455, 0.13, 0.15, "1/" .. #rightChestTattoos, true, tabCreationThree)
		guiSetFont(lRightChestInfo, "default-bold-small")
		
		lRightChest = guiCreateLabel(0.1, 0.455, 0.25, 0.15, "Right Chest:", true, tabCreationThree)
		guiSetFont(lRightChest, "default-bold-small")
		
		bRightChestPrev =  guiCreateButton(0.4, 0.455, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightChestPrev, adjustTattoos, false)
		
		bRightChestNext =  guiCreateButton(0.65, 0.455, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightChestNext, adjustTattoos, false)
		
		--/////////////
		-- STOMACH
		--/////////////
		lStomachInfo = guiCreateLabel(0.87, 0.51, 0.13, 0.15, "1/" .. #stomachTattoos, true, tabCreationThree)
		guiSetFont(lStomachInfo, "default-bold-small")
		
		lStomach = guiCreateLabel(0.1, 0.51, 0.25, 0.15, "Stomach:", true, tabCreationThree)
		guiSetFont(lStomach, "default-bold-small")
		
		bStomachPrev =  guiCreateButton(0.4, 0.51, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bStomachPrev, adjustTattoos, false)
		
		bStomachNext =  guiCreateButton(0.65, 0.51, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bStomachNext, adjustTattoos, false)
		
		--/////////////
		-- LOW BACK
		--/////////////
		lLowerBackInfo = guiCreateLabel(0.87, 0.565, 0.13, 0.15, "1/" .. #lowerBackTattoos, true, tabCreationThree)
		guiSetFont(lLowerBackInfo, "default-bold-small")
		
		lLowBack = guiCreateLabel(0.1, 0.565, 0.25, 0.15, "Lower Back:", true, tabCreationThree)
		guiSetFont(lLowBack, "default-bold-small")
		
		bLowBackPrev =  guiCreateButton(0.4, 0.565, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLowBackPrev, adjustTattoos, false)
		
		bLowBackNext =  guiCreateButton(0.65, 0.565, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLowBackNext, adjustTattoos, false)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep4CJ, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustTattoos(button, state)
	if (button=="left") and (state=="up") then
	
		-- //////////////////////////////////////////////
		-- LEFT UPPER ARM
		-- //////////////////////////////////////////////
		if (source==bLeftUpperNext) then
			if (luTattoo==#leftUpperArmTattoos) then
				luTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			else
				luTattoo = luTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			end
		end
		
		if (source==bLeftUpperPrev) then
			if (luTattoo<=1) then
				luTattoo = #leftUpperArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			else
				luTattoo = luTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LEFT LOWER ARM
		-- //////////////////////////////////////////////
		if (source==bLeftLowerNext) then
			if (llTattoo==#leftLowerArmTattoos) then
				llTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			else
				llTattoo = llTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			end
		end
		
		if (source==bLeftLowerPrev) then
			if (llTattoo<=1) then
				llTattoo = #leftLowerArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			else
				llTattoo = llTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT UPPER ARM
		-- //////////////////////////////////////////////
		if (source==bRightUpperNext) then
			if (ruTattoo==#rightUpperArmTattoos) then
				ruTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			else
				ruTattoo = ruTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			end
		end
		
		if (source==bRightUpperPrev) then
			if (ruTattoo<=1) then
				ruTattoo = #rightUpperArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			else
				ruTattoo = ruTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT LOWER ARM
		-- //////////////////////////////////////////////
		if (source==bRightLowerNext) then
			if (rlTattoo==#rightLowerArmTattoos) then
				rlTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			else
				rlTattoo = rlTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			end
		end
		
		if (source==bRightLowerPrev) then
			if (rlTattoo<=1) then
				rlTattoo = #rightLowerArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			else
				rlTattoo = rlTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			end
		end
		
		-- //////////////////////////////////////////////
		-- BACK
		-- //////////////////////////////////////////////
		if (source==bBackTattooNext) then
			if (bTattoo==#backTattoos) then
				bTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1], backTattoos[bTattoo][2], 8)
			else
				bTattoo = bTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			end
		end
		
		if (source==bBackTattooPrev) then
			if (bTattoo<=1) then
				bTattoo = #backTattoos
				triggerServerEvent("addClothes", getLocalPlayer(),backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			else
				bTattoo = bTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LEFT CHEST
		-- //////////////////////////////////////////////
		if (source==bLeftChestNext) then
			if (lcTattoo==#leftChestTattoos) then
				lcTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			else
				lcTattoo = lcTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			end
		end
		
		if (source==bLeftChestPrev) then
			if (lcTattoo<=1) then
				lcTattoo = #leftChestTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			else
				lcTattoo = lcTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT CHEST
		-- //////////////////////////////////////////////
		if (source==bRightChestNext) then
			if (rcTattoo==#rightChestTattoos) then
				rcTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			else
				rcTattoo = rcTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			end
		end
		
		if (source==bRightChestPrev) then
			if (rcTattoo<=1) then
				rcTattoo = #rightChestTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			else
				rcTattoo = rcTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			end
		end
		
		-- //////////////////////////////////////////////
		-- STOMACH
		-- //////////////////////////////////////////////
		if (source==bStomachNext) then
			if (sTattoo==#stomachTattoos) then
				sTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1], stomachTattoos[sTattoo][2], 11)
			else
				sTattoo = sTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			end
		end
		
		if (source==bStomachPrev) then
			if (sTattoo<=1) then
				sTattoo = #stomachTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			else
				sTattoo = sTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LOWER BACK
		-- //////////////////////////////////////////////
		if (source==bLowBackNext) then
			if (lbTattoo==#lowerBackTattoos) then
				lbTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			else
				lbTattoo = lbTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			end
		end
		
		if (source==bLowBackPrev) then
			if (lbTattoo<=1) then
				lbTattoo = #lowerBackTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			else
				lbTattoo = lbTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			end
		end
		
		guiSetText(lLeftUpperArmInfo, luTattoo .. "/" .. #leftUpperArmTattoos)
		guiSetText(lLeftLowerArmInfo, llTattoo .. "/" .. #leftLowerArmTattoos)
		guiSetText(lRightUpperArmInfo, ruTattoo .. "/" .. #rightUpperArmTattoos)
		guiSetText(lRightLowerArmInfo, rlTattoo .. "/" .. #rightLowerArmTattoos)
		guiSetText(lBackTattooInfo, bTattoo .. "/" .. #backTattoos)
		guiSetText(lLeftChestInfo, lcTattoo .. "/" .. #leftChestTattoos)
		guiSetText(lRightChestInfo, rcTattoo .. "/" .. #rightChestTattoos)
		guiSetText(lStomachInfo, sTattoo .. "/" .. #stomachTattoos)
		guiSetText(lLowerBackInfo, lbTattoo .. "/" .. #lowerBackTattoos)
	end
end

-- /////////////////////////
-- CJ STEP 4
-- /////////////////////////
hair = { {"player_face", "head"}, {"hairblond", "head"}, {"hairred", "head"}, {"hairblue", "head"}, {"hairgreen", "head"}, {"hairpink", "head"}, {"bald", "head"}, {"baldbeard", "head"}, {"baldtash", "head"}, {"baldgoatee", "head"}, {"highfade", "head"}, {"highafro", "highafro"}, {"wedge", "wedge"}, {"slope", "slope"}, {"jhericurl", "jheri"}, {"cornrows", "cornrows"}, {"cornrowsb", "cornrows"}, {"tramline", "tramline"}, {"groovecut", "groovecut"}, {"mohawk", "mohawk"}, {"mohawkblond", "mohawk"}, {"mohawkpink", "mohawk"}, {"mohawkbeard", "mohawk"}, {"afro", "afro"}, {"afrotash", "afro"}, {"afrobeard", "afro"}, {"afroblond", "afro"}, {"flattop", "flattop"}, {"elvishair", "elvishair"}, {"beard", "head"}, {"tash", "head"}, {"goatee", "head"}, {"afrogoatee", "afro"} }
hats = { {"NONE", "NONE"}, {"bandred", "bandana"}, {"bandblue", "bandana"}, {"bandgang", "bandana"}, {"bandblack", "bandana"}, {"bandred2", "bandknots"}, {"bandblue2", "bandknots"}, {"bandblack2", "bandknots"}, {"bandgang2", "bandknots"}, {"capknitgrn", "capknit"}, {"captruck", "captruck"}, {"cowboy", "cowboy"}, {"hattiger", "cowboy"}, {"helmet", "helmet"}, {"moto", "moto"}, {"boxingcap", "boxingcap"}, {"hockey", "hockeymask"}, {"capgang", "cap"}, {"capgangback", "capblack"}, {"capgangside", "capside"}, {"capgangover", "capovereye"}, {"capgangup", "caprimup"}, {"bikerhelmet", "bikerhelmet"}, {"capred", "cap"}, {"capredback", "capback"}, {"capredside", "capside"}, {"capredover", "capovereye"}, {"capredup", "caprimup"}, {"capblue", "cap"}, {"capblueback", "capback"}, {"capblueside", "capside"}, {"capblueover", "capovereye"}, {"capblueup", "caprimup"}, {"skullyblk", "scullycap"}, {"skullygrn", "skullycap"}, {"hatmancblk", "hatmanc"}, {"hatmancplaid", "hatmanc"}, {"capzip", "cap"}, {"capzipback", "capback"}, {"capzipside", "capside"}, {"capzipover", "capovereye"}, {"capzipup", "caprimup"}, {"beretred", "beret"}, {"beretblk", "beret"}, {"capblk", "cap"}, {"capblkback", "capback"}, {"capblkside", "capside"}, {"capblkeover", "capovereye"}, {"capblkup", "caprimup"}, {"trilbydrk", "trilby"}, {"trilbylght", "trilby"}, {"bowler", "bowler"}, {"bolwerred", "bowlerred"}, {"bowlerblue", "bowler"}, {"bowleryellow", "bowler"}, {"boater", "boater"}, {"bowlergang", "bowler"}, {"boaterblk", "boater"} }
necks = { {"NONE", "NONE"}, {"dogtag", "neck"}, {"neckafrica", "neck"}, {"stopwatch", "neck"}, {"necksaints", "neck"}, {"neckhash", "neck"}, {"necksilver", "neck2"}, {"neckgold", "neck2"}, {"neckropes", "neck2"}, {"neckropg", "neck2"}, {"neckls", "neck2"}, {"neckdollar", "neck2"}, {"neckcross", "neck2"} }
faces = { {"NONE", "NONE"}, {"groucho", "grouchos"}, {"zorro", "zorromask"}, {"eyepatch", "glasses01"}, {"glasses04", "glasses04"}, {"bandred3", "bandmask"}, {"bandblue3", "bandmask"}, {"bandgang3", "bandmask"}, {"bandblack3", "bandmask"}, {"glasses01dark", "glasses01"}, {"glasses04dark", "glasses04"}, {"glasses03", "glasses03"}, {"glasses03red", "glasses03"}, {"glasses03blue", "glasses03"}, {"glasses03dark", "glasses03"}, {"glasses05dark", "glasses03"}, {"glasses05", "glasses03"} }
upperbody = { {"torso", "player_torso"}, {"vestblack", "vest"}, {"vest", "vest"}, {"tshirt2horiz", "tshirt2"}, {"tshirtwhite", "tshirt"}, {"tshirtlovels", "tshirt"}, {"tshirtblunts", "tshirt"}, {"shirtbplaid", "shirtb"}, {"shirtbcheck", "shirtb"}, {"field", "field"}, {"tshirterisyell", "tshirt"}, {"tshirterisorn", "tshirt"}, {"trackytop2eris", "trackytop2"}, {"bbjackrim", "bbjack"}, {"bbjackrstar", "bbjack"}, {"baskballdrib", "basjball"}, {"sixtyniners", "tshirt"}, {"bandits", "baseball"}, {"tshirtprored", "tshirt"}, {"tshirtproblk", "tshirt"}, {"trackytop1pro", "trackytop1"}, {"hockeytop", "sweat"}, {"bbjersey", "sleevt"}, {"shellsuit", "trackytop1"}, {"tshirtheatwht", "tshirt"}, {"tshirtbobomonk", "tshirt"}, {"tshirtbobored", "tshirt"}, {"tshirtbase5", "tshirt"}, {"tshirtsuburb", "tshirt"}, {"hoodyamerc", "hoodya"}, {"hoodyabase5", "hoodya"}, {"hoodayarockstar", "hoodya"}, {"wcoatblue", "wcoat"}, {"coach", "coach"}, {"coachsemi", "coach"}, {"sweatrstar", "sweat"}, {"hoodyAblue", "hoodyA"}, {"hoodyAblack", "hoodyA"}, {"hoodyAgreen", "hoodyA"}, {"sleevtbrown", "sleevt"}, {"shirtablue", "shirta"}, {"shirtayellow", "shirta"}, {"shirtagrey", "shirta"}, {"shirtbgang", "shirtb"}, {"tshirtzipcrm", "tshirt"}, {"tshirtzipgry", "tshirt"}, {"denimfade", "denim"}, {"bowling", "hawaii"}, {"hoodjackbeige", "hoodjack"}, {"baskballoc", "baskball"}, {"tshirtlocgrey", "tshirt"}, {"tshirtmaddgrey", "tshirt"}, {"tshirtmaddgrn", "tshirt"}, {"suit1grey", "suit1"}, {"suit1blk", "suit1"}, {"leather", "leather"}, {"painter", "painter"}, {"hawaiiwht", "hawaii"}, {"hawaiired", "hawaii"}, {"sportjack", "trackytop1"}, {"suit1red", "suit1"}, {"suit1blue", "suit1"}, {"suit1yellow", "suit1"}, {"suit2grn", "suit2"}, {"tuxedo", "suit2"}, {"suit1gang", "suit1"}, {"letter", "sleevt"} }
wrists = { {"NONE", "NONE"}, {"watchpink", "watch"}, {"watchyellow", "watch"}, {"watchpro", "watch"}, {"watchpro2", "watch"}, {"watchsub1", "watch"}, {"watchsub2", "watch"}, {"watchzip1", "watch"}, {"watchzip2", "watch"}, {"watchgno", "watch"}, {"watchgno2", "watch"}, {"watchcro", "watch"}, {"watchcro2", "watch"} }
lowerbody = { {"player_legs", "legs"}, {"worktrcamogrn", "worktr"}, {"worktrcamogry", "worktr"}, {"worktrgrey", "worktr"}, {"worktrhaki", "worktr"}, {"tracktr", "tracktr"}, {"trackteris", "tracktr"}, {"jeansdenim", "jeans"}, {"legsblack", "legs"}, {"legsheart", "legs"}, {"beiegetr", "chinosb"}, {"trackpro", "tracktr"}, {"tracktrwhstr", "tracktr"}, {"tracktrblue", "tracktr"}, {"tracktrgang", "tracktr"}, {"bbshortwht", "boxingshort"}, {"bbshortred", "boxingshort"}, {"shellsuittr", "tracktr"}, {"shortsgrey", "shorts"}, {"shortskhaki", "shorts"}, {"chongergrey", "chonger"}, {"chongergang", "chonger"}, {"chongerred", "chonger"}, {"chongerblue", "chonger"}, {"shortsgang", "shorts"}, {"denimsgang", "jeans"}, {"denimsred", "jeans"}, {"chinosbiege", "chinosb"}, {"chinoskhaki", "chinosb"}, {"cutoffchinos", "shorts"}, {"cutoffchinesblue", "shorts"}, {"chinosblack", "chinosb"}, {"chinosblue", "chinosb"}, {"leathertr", "leathertr"}, {"leathertrchaps", "leathertr"}, {"suit1trgrey", "suit1tr"}, {"suit1trblk", "suit1tr"}, {"cutoffdenims", "shorts"}, {"suit1trred", "suit1tr"}, {"suit1trblue", "suit1tr"}, {"suit1tryellow", "suit1tr"}, {"suit1trgreen", "suit1tr"}, {"suit1trblk2", "suit1tr"}, {"suit1trgang", "suit1tr"} }
feet = { {"foot", "feet"}, {"cowboyboot2", "biker"}, {"bask2semi", "bask1"}, {"bask1eris", "bask1"}, {"sneakerbincgang", "sneaker"}, {"sneakerbincblue", "sneakers"}, {"sneakerbincblk", "sneaker"}, {"sandal", "flipflop"}, {"sandalsock", "flipflop"}, {"flipflop", "flipflop"}, {"hitop", "bask1"}, {"convproblk", "conv"}, {"convproblu", "conv"}, {"convprogrn", "conv"}, {"sneakerprored", "sneaker"}, {"sneakerproblu", "sneakers"}, {"sneakerprowht", "sneaker"}, {"bask1prowht", "bask1"}, {"bask1problk", "bask1"}, {"boxingshoe", "biker"}, {"convheatblk", "conv"}, {"convheatred", "conv"}, {"convheatorn", "conv"}, {"sneakerheatwht", "sneaker"}, {"sneakerheatgry", "sneaker"}, {"sneakerheatblk", "sneaker"}, {"bask2heatwht", "bask1"}, {"bask2headband", "bask1"}, {"timbergrey", "back1t"}, {"timberred", "bask1"}, {"timberfawn", "bask1"}, {"timberhike", "bask1"}, {"cowboyboot", "biker"}, {"biker", "biker"}, {"snakeskin", "biker"}, {"shoedressblk", "shoe"}, {"shoedressbrn", "shoe"}, {"shoespatz", "shoe"} } 
costumes = { {"NONE", "NONE"}, {"valet", "valet"}, {"countrytr", "countrytr"}, {"croupier", "valet"}, {"pimptr", "pimptr"} }

lAppearance, lHair, lHairInfo, bHairPrev, bHairNext, lHat, lHatInfo, bHatPrev, bHatNext, lNeck, lNeckInfo, bNeckPrev, bNeckNext, lFace, lFaceInfo, bFacePrev, bFaceNext, lUpperBody, lUpperBodyInfo, bUpperBodyPrev, bUpperBodyNext, lWrists, lWristsInfo, bWristsPrev, bWristsNext, lLowerBody, lLowerBodyInfo, bLowerBodyPrev, bLowerBodyNext, lFeet, lFeetInfo, bFeetPrev, bFeetNext, lCostumes, lCostumesInfo, bCostumesPrev, bCostumesNext = nil

curhair = 1
curhat = 1
curneck = 1
curface = 1
curupper = 1
curwrist = 1
curlower = 1
curfeet = 1
curcostume = 1

function characterCreationStep4CJ(button, state)
	if (source==bNext) and (button=="left") and (state=="up") then
		-- Cleanup
		destroyElement(tabCreationThree)
		tabCreationThree = nil
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		curhair = 1
		curhat = 1
		curneck = 1
		curface = 1
		curupper = 1
		curwrist = 1
		curlower = 1
		curfeet = 1
		curcostume = 1
		
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationFour = guiCreateTab("Character Creation: Step 4", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lAppearance = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Appearance", true, tabCreationFour) 
		guiSetFont(lAppearance, "sa-header")
		
		--/////////////
		-- HAIR
		--/////////////
		lHairInfo = guiCreateLabel(0.87, 0.125, 0.13, 0.15, "1/" .. #hair, true, tabCreationFour)
		guiSetFont(lHairInfo, "default-bold-small")
		
		lHair = guiCreateLabel(0.1, 0.125, 0.25, 0.15, "Hair:", true, tabCreationFour)
		guiSetFont(lHair, "default-bold-small")
		
		bHairPrev =  guiCreateButton(0.4, 0.125, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHairPrev, adjustClothes, false)
		
		bHairNext =  guiCreateButton(0.65, 0.125, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHairNext, adjustClothes, false)
		
		--/////////////
		-- HATS
		--/////////////
		lHatInfo = guiCreateLabel(0.87, 0.18, 0.13, 0.15, "1/" .. #hats, true, tabCreationFour)
		guiSetFont(lHatInfo, "default-bold-small")
		
		lHat = guiCreateLabel(0.1, 0.18, 0.25, 0.15, "Hat:", true, tabCreationFour)
		guiSetFont(lHat, "default-bold-small")
		
		bHatPrev =  guiCreateButton(0.4, 0.18, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHatPrev, adjustClothes, false)
		
		bHatNext =  guiCreateButton(0.65, 0.18, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHatNext, adjustClothes, false)
		
		--/////////////
		-- NECK
		--/////////////
		lNeckInfo = guiCreateLabel(0.87, 0.235, 0.13, 0.15, "1/" .. #necks, true, tabCreationFour)
		guiSetFont(lNeckInfo, "default-bold-small")
		
		lNeck = guiCreateLabel(0.1, 0.235, 0.25, 0.15, "Neck:", true, tabCreationFour)
		guiSetFont(lNeck, "default-bold-small")
		
		bNeckPrev =  guiCreateButton(0.4, 0.235, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNeckPrev, adjustClothes)
		
		bNeckNext =  guiCreateButton(0.65, 0.235, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNeckNext, adjustClothes)
		
		--/////////////
		-- FACE
		--/////////////
		lFaceInfo = guiCreateLabel(0.87, 0.29, 0.13, 0.15, "1/" .. #faces, true, tabCreationFour)
		guiSetFont(lFaceInfo, "default-bold-small")
		
		lFace = guiCreateLabel(0.1, 0.29, 0.25, 0.15, "Face:", true, tabCreationFour)
		guiSetFont(lFace, "default-bold-small")
		
		bFacePrev =  guiCreateButton(0.4, 0.29, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFacePrev, adjustClothes, false)
		
		bFaceNext =  guiCreateButton(0.65, 0.29, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFaceNext, adjustClothes, false)
		
		--/////////////
		-- UPPER BODY
		--/////////////
		lUpperBodyInfo = guiCreateLabel(0.87, 0.345, 0.13, 0.15, "1/" .. #upperbody, true, tabCreationFour)
		guiSetFont(lUpperBodyInfo, "default-bold-small")
		
		lUpperBody = guiCreateLabel(0.1, 0.345, 0.25, 0.15, "Upper Body:", true, tabCreationFour)
		guiSetFont(lUpperBody, "default-bold-small")
		
		bUpperBodyPrev =  guiCreateButton(0.4, 0.345, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bUpperBodyPrev, adjustClothes)
		
		bUpperBodyNext =  guiCreateButton(0.65, 0.345, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bUpperBodyNext, adjustClothes)
		
		--/////////////
		-- WRISTS
		--/////////////
		lWristsInfo = guiCreateLabel(0.87, 0.4, 0.13, 0.15, "1/" .. #wrists, true, tabCreationFour)
		guiSetFont(lWristsInfo, "default-bold-small")
		
		lWrists = guiCreateLabel(0.1, 0.4, 0.25, 0.15, "Wrists:", true, tabCreationFour)
		guiSetFont(lWrists, "default-bold-small")
		
		bWristsPrev =  guiCreateButton(0.4, 0.4, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bWristsPrev, adjustClothes, false)
		
		bWristsNext =  guiCreateButton(0.65, 0.4, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bWristsNext, adjustClothes, false)
		
		--/////////////
		-- LOWER BODY
		--/////////////
		lLowerBodyInfo = guiCreateLabel(0.87, 0.455, 0.13, 0.15, "1/" .. #lowerbody, true, tabCreationFour)
		guiSetFont(lLowerBodyInfo, "default-bold-small")
		
		lLowerBody = guiCreateLabel(0.1, 0.455, 0.25, 0.15, "Lower Body:", true, tabCreationFour)
		guiSetFont(lLowerBody, "default-bold-small")
		
		bLowerBodyPrev =  guiCreateButton(0.4, 0.455, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bLowerBodyPrev, adjustClothes, false)
		
		bLowerBodyNext =  guiCreateButton(0.65, 0.455, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bLowerBodyNext, adjustClothes, false)
		
		--/////////////
		-- FEET
		--/////////////
		lFeetInfo = guiCreateLabel(0.87, 0.51, 0.13, 0.15, "1/" .. #feet, true, tabCreationFour)
		guiSetFont(lFeetInfo, "default-bold-small")
		
		lFeet = guiCreateLabel(0.1, 0.51, 0.25, 0.15, "Feet:", true, tabCreationFour)
		guiSetFont(lFeet, "default-bold-small")
		
		bFeetPrev =  guiCreateButton(0.4, 0.51, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFeetPrev, adjustClothes, false)
		
		bFeetNext =  guiCreateButton(0.65, 0.51, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFeetNext, adjustClothes, false)
		
		--/////////////
		-- COSTUMES
		--/////////////
		lCostumesInfo = guiCreateLabel(0.87, 0.565, 0.13, 0.15, "1/" .. #costumes, true, tabCreationFour)
		guiSetFont(lCostumesInfo, "default-bold-small")
		
		lCostumes = guiCreateLabel(0.1, 0.565, 0.25, 0.15, "Costumes:", true, tabCreationFour)
		guiSetFont(lCostumes, "default-bold-small")
		
		bCostumesPrev =  guiCreateButton(0.4, 0.565, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCostumesPrev, adjustClothes, false)
		
		bCostumesNext =  guiCreateButton(0.65, 0.565, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCostumesNext, adjustClothes, false)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep5, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	end
end

function adjustClothes(button, state)
	if (button=="left") and (state=="up") then
	
		-- //////////////////////////////////////////////
		-- HAIR
		-- //////////////////////////////////////////////
		if (source==bHairNext) then
			if (curhair==#hair) then
				curhair = 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			else
				curhair = curhair + 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			end
		end
		
		if (source==bHairPrev) then
			if (curhair<=1) then
				curhair = #hair
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			else
				curhair = curhair - 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			end
		end
		
		-- //////////////////////////////////////////////
		-- HATS
		-- //////////////////////////////////////////////
		if (source==bHatNext) then
			if (curhat==#hats) then
				curhat = 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			else
				curhat = curhat + 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			end
		end
		
		if (source==bHatPrev) then
			if (curhat<=1) then
				curhat = #hats
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			else
				curhat = curhat - 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			end
		end
		
		-- //////////////////////////////////////////////
		-- NECK
		-- //////////////////////////////////////////////
		if (source==bNeckNext) then
			if (curneck==#necks) then
				curneck = 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			else
				curneck = curneck + 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			end
		end
		
		if (source==bNeckPrev) then
			if (curneck<=1) then
				curneck = #necks
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			else
				curneck = curneck - 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			end
		end
		
		-- //////////////////////////////////////////////
		-- FACE
		-- //////////////////////////////////////////////
		if (source==bFaceNext) then
			if (curface==#faces) then
				curface = 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			else
				curface = curface + 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			end
		end
		
		if (source==bFacePrev) then
			if (curface<=1) then
				curface = #faces
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			else
				curface = curface - 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			end
		end
		
		-- //////////////////////////////////////////////
		-- UPPER
		-- //////////////////////////////////////////////
		if (source==bUpperBodyNext) then
			if (curupper==#upperbody) then
				curupper = 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			else
				curupper = curupper + 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			end
		end
		
		if (source==bUpperBodyPrev) then
			if (curupper<=1) then
				curupper = #upperbody
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			else
				curupper = curupper - 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			end
		end
		
		-- //////////////////////////////////////////////
		-- WRISTS
		-- //////////////////////////////////////////////
		if (source==bWristsNext) then
			if (curwrist==#wrists) then
				curwrist = 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			else
				curwrist = curwrist + 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			end
		end
		
		if (source==bWristsPrev) then
			if (curwrist<=1) then
				curwrist = #wrists
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			else
				curwrist = curwrist - 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LOWER
		-- //////////////////////////////////////////////
		if (source==bLowerBodyNext) then
			if (curlower==#lowerbody) then
				curlower = 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			else
				curlower = curlower + 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			end
		end
		
		if (source==bLowerBodyPrev) then
			if (curlower<=1) then
				curlower = #lowerbody
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			else
				curlower = curlower - 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			end
		end
		
		-- //////////////////////////////////////////////
		-- FEET
		-- //////////////////////////////////////////////
		if (source==bFeetNext) then
			if (curfeet==#feet) then
				curfeet = 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			else
				curfeet = curfeet + 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			end
		end
		
		if (source==bFeetPrev) then
			if (curfeet<=1) then
				curfeet = #feet
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			else
				curfeet = curfeet - 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			end
		end
		
		-- //////////////////////////////////////////////
		-- COSTUME
		-- //////////////////////////////////////////////
		if (source==bCostumesNext) then
			if (curcostume==#costumes) then
				curcostume = 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			else
				curcostume = curcostume + 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			end
		end
		
		if (source==bCostumesPrev) then
			if (curcostume<=1) then
				curcostume = #costumes
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			else
				curcostume = curcostume - 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			end
		end
		
		guiSetText(lHairInfo, curhair .. "/" .. #hair)
		guiSetText(lHatInfo, curhat .. "/" .. #hats)
		guiSetText(lNeckInfo, curneck .. "/" .. #necks)
		guiSetText(lFaceInfo, curface .. "/" .. #faces)
		guiSetText(lUpperBodyInfo, curupper .. "/" .. #upperbody)
		guiSetText(lWristsInfo, curwrist .. "/" .. #wrists)
		guiSetText(lLowerBodyInfo, curlower .. "/" .. #lowerbody)
		guiSetText(lFeetInfo, curfeet .. "/" .. #feet)
		guiSetText(lCostumesInfo, curcostume .. "/" .. #costumes)
	end
end

-- ///////////////////////
-- CJ STEP 5
-- ///////////////////////
lInformation, lHeight, tHeight, lWeight, tWeight, lCharDesc, tCharDesc, lAge, tAge = nil
weight, height, description = "", "", ""
age = 24

function characterCreationStep5(button, state)
	if (button=="left") and (state=="up") and (source==bNext) then
		-- Cleanup
		if (tabCreationFour) then
			destroyElement(tabCreationFour)
			tabCreationFour = nil
		elseif (tabCreationTwo) then
			destroyElement(tabCreationTwo)
			tabCreationTwo = nil
		end
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationFive = guiCreateTab("Character Creation: Almost Done!", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Information", true, tabCreationFive) 
		guiSetFont(lInformation, "sa-header")
		
		--/////////////
		-- HEIGHT
		--/////////////
		lHeight = guiCreateLabel(0.1, 0.145, 0.5, 0.15, "Height (cm)(between 100 and 200):", true, tabCreationFive)
		guiSetFont(lHeight, "default-bold-small")
		guiLabelSetColor(lHeight, 0, 255, 0)
		
		tHeight = guiCreateEdit(0.635, 0.143, 0.15, 0.05, "140", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tHeight, checkInput)
		
		--/////////////
		-- WEIGHT
		--/////////////
		lWeight = guiCreateLabel(0.1, 0.215, 0.5, 0.15, "Weight (kg)(between 40 and 200):", true, tabCreationFive)
		guiSetFont(lWeight, "default-bold-small")
		guiLabelSetColor(lWeight, 0, 255, 0)
		
		tWeight = guiCreateEdit(0.635, 0.213, 0.15, 0.05, "140", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tWeight, checkInput)
		
		--/////////////
		-- AGE
		--/////////////
		lAge = guiCreateLabel(0.1, 0.285, 0.5, 0.15, "Age (between 18 and 80):", true, tabCreationFive)
		guiSetFont(lAge, "default-bold-small")
		guiLabelSetColor(lAge, 0, 255, 0)
		
		tAge = guiCreateEdit(0.635, 0.283, 0.15, 0.05, "24", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tAge, checkInput)
		
		--/////////////
		-- DESCRIPTION
		--/////////////
		lCharDesc = guiCreateLabel(0.1, 0.385, 0.8, 0.15, "Description(between 30 and 100 characters):", true, tabCreationFive)
		guiSetFont(lCharDesc, "default-bold-small")
		guiLabelSetColor(lCharDesc, 0, 255, 0)
		
		tCharDesc = guiCreateMemo(0.1, 0.455, 0.8, 0.25, "A description of your character and his/her visual appearance. Other players can see this.", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tCharDesc, checkInput)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep6, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	end
end

heightvalid = true 
weightvalid = true
descvalid = true
agevalid = true
function checkInput()
	if (source==tHeight) then
		if not (tostring(type(tonumber(guiGetText(tHeight)))) == "number") then
			guiLabelSetColor(lHeight, 255, 0, 0)
			heightvalid = false
		elseif (tonumber(guiGetText(tHeight))<100) or (tonumber(guiGetText(tHeight))>200) then
			guiLabelSetColor(lHeight, 255, 0, 0)
			heightvalid = false
		else
			guiLabelSetColor(lHeight, 0, 255, 0)
			heightvalid = true
		end
	elseif (source==tWeight) then
		if not (tostring(type(tonumber(guiGetText(tWeight)))) == "number") then
			guiLabelSetColor(lWeight, 255, 0, 0)
			weightvalid = false
		elseif (tonumber(guiGetText(tWeight))<40) or (tonumber(guiGetText(tWeight))>200) then
			guiLabelSetColor(lWeight, 255, 0, 0)
			weightvalid = false
		else
			guiLabelSetColor(lWeight, 0, 255, 0)
			weightvalid = true
		end
	elseif (source==tAge) then
		if not (tostring(type(tonumber(guiGetText(tAge)))) == "number") then
			guiLabelSetColor(lAge, 255, 0, 0)
			agevalid = false
		elseif (tonumber(guiGetText(tAge))<18) or (tonumber(guiGetText(tAge))>80) then
			guiLabelSetColor(lAge, 255, 0, 0)
			agevalid = false
		else
			guiLabelSetColor(lAge, 0, 255, 0)
			agevalid = true
		end
	elseif (source==tCharDesc) then
		if (string.len(guiGetText(tCharDesc))<30) or (string.len(guiGetText(tCharDesc))>100) then
			guiLabelSetColor(lCharDesc, 255, 0, 0)
			descvalid = false
		else
			guiLabelSetColor(lCharDesc, 0, 255, 0)
			descvalid = true
		end
	end
end

tabCreationFive, lTransport, rTrain, rBus, rAeroplane, rBoat, transObject, transVehicle, lastSelected, anim = nil
function characterCreationStep6(button, state)
	if (button=="left") and (state=="up") and (source==bNext) then
		if (heightvalid) and (weightvalid) and (descvalid) and (agevalid) then
			height = guiGetText(tHeight)
			weight = guiGetText(tWeight)
			age = guiGetText(tAge)
			description = guiGetText(tCharDesc)
		
			-- Cleanup
			destroyElement(tabCreationFive)
			tabCreationFive = nil
			destroyElement(tabPanelCreation)
			tabPanelCreation = nil
			
			local width, height = 400, 400
			
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)

			tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
			tabCreationSix = guiCreateTab("Character Creation: Last Page!", tabPanelCreation)
			guiSetAlpha(tabPanelCreation, 0.75)
			
			lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Just a little more...", true, tabCreationSix) 
			guiSetFont(lInformation, "sa-header")
			
			--/////////////
			-- TRANSPORT
			--/////////////
			lTransport = guiCreateLabel(0.1, 0.145, 0.8, 0.15, "Transport - How did you arrive in Las Venturas?", true, tabCreationSix)
			guiSetFont(lTransport, "default-bold-small")
			
			rAeroplane = guiCreateRadioButton(0.15, 0.2, 0.6, 0.05, "Aeroplane", true, tabCreationSix)
			rBus = guiCreateRadioButton(0.15, 0.25, 0.6, 0.05, "Bus", true, tabCreationSix)
			
			addEventHandler("onClientGUIClick", rBus, busEffect, false)
			addEventHandler("onClientGUIClick", rAeroplane, aeroplaneEffect, false)
			
			--/////////////
			-- NEXT/BACK
			--/////////////
			bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "That's it, Were Done!", true, tabCreationSix)
			addEventHandler("onClientGUIClick", bNext, characterCreationFinal, false)
			
			bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationSix)
			addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
		end
	end
end

--/////////////////////
-- BUS EFFECT
--/////////////////////
function busEffect(button, state)
	if (source==rBus) and (button=="left") and (state=="up") and not (lastSelected==rBus) and not (anim) then
		lastSelected = source -- Avoid duplicates
		fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0)
		
		setElementInterior(getLocalPlayer(), 0)
		setCameraInterior(0)
		setElementPosition(getLocalPlayer(), 2079.3344726563, 2030.2542724609, 10.8203125)
		setPedRotation(getLocalPlayer(), 182.91093444824)
		setElementAlpha(getLocalPlayer(), 255)

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		setCameraMatrix(2070.3344726563, 2030.2542724609, 10.8203125, 2079.3344726563, 2030.2542724609, 10.8203125)
		
		fadeCamera(true)
	end
end

--/////////////////////
-- AEROPLANE EFFECT
--/////////////////////
function aeroplaneEffect(button, state)
	if (source==rAeroplane) and (button=="left") and (state=="up") and not (lastSelected==rAeroplane) and not (anim) then
		lastSelected = source -- Avoid duplicates
		fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0)
		
		setElementInterior(getLocalPlayer(), 0)
		setElementPosition(getLocalPlayer(), 1704.1889648438, 1411.068359375, 10.640625)
		setPedRotation(getLocalPlayer(), 306.16784667969)
		setElementAlpha(getLocalPlayer(), 255)

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		setCameraMatrix(1718.6136474609, 1423.9624023438, 15.64062, 1704.1889648438, 1411.068359375, 10.640625)
		fadeCamera(true, 1)
	end
end

-- ////////////////
-- FINAL
--/////////////////
function characterCreationFinal(button, state)
	if (source==bNext) and (button=="left") and (state=="up") and not (anim) then
		local train = guiRadioButtonGetSelected(rTrain)
		local bus = guiRadioButtonGetSelected(rBus)
		local aeroplane = guiRadioButtonGetSelected(rAeroplane)
		
		if (train or bus or aeroplane) then
			local transport
			if (train) then
				transport = 0
			elseif (bus) then
				transport = 1
			elseif (aeroplane) then
				transport = 2
			end
			local skin = getElementModel(getLocalPlayer())
			creation = false
			destroyElement(tabPanelCreation)
			
			-- cleanup
			removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			
			destroyElement(bRotate)
			bRotate = nil
			
			local playerid = getElementData(getLocalPlayer(), "playerid")
			setElementInterior(getLocalPlayer(), 14)
			setElementDimension(getLocalPlayer(), 65000+playerid)
			setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375)
			setPedRotation(getLocalPlayer(), 268.19247436523)
			
			creation = false
			destroyElement(tabPanelCreation)
			tabPanelCreation = nil
			
			
			setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
			setCameraInterior(14)
			fadeCamera(true)
			-- end cleanup

			
			if (skin==0) then -- CJ
				local clothes = { curhair, curhat, curneck, curface, curupper, curwrist, curlower, curfeet, curcostume, luTattoo, llTattoo, ruTattoo, rlTattoo, bTattoo, lcTattoo, rcTattoo, sTattoo, lbTattoo }
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, clothes)
			else
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin)
			end
		end
	end
end

--/////////////////////////////////////////////////////////////////
--DISPLAY STATISTICS
--/////////////////////////////////////////////////////////////////
lStatistics, lPoints, paneStatistics = nil
tabPanel, tabMystats, tabAllstats = nil

--/////////////////////////////////////////////////////////////////
--DISPLAY ACHIEVEMENTS
--/////////////////////////////////////////////////////////////////
lAchievements, lPoints, paneAchievements, pane = nil
tableAchievements, iAchievementCount, iAchievementPointsCount = nil
function displayAchievements()
	local numAchievements = 0
	local currpoints = 0
	for key, value in pairs(tableAchievements) do
		numAchievements = numAchievements + 1
		currpoints = currpoints + tonumber(tableAchievements[key][3])
	end

	lAchievements = guiCreateLabel(0.05, 0.025, 0.9, 0.15, numAchievements .. " Achievements of a possible " .. iAchievementCount .. " (" .. tostring(math.ceil((numAchievements/iAchievementCount)*100)) .. "%).", true, tabAchievements)
	guiSetFont(lAchievements, "default-bold-small")
	
	lPoints = guiCreateLabel(0.05, 0.07, 0.9, 0.15, currpoints .. " Achievement Points of a possible " .. iAchievementPointsCount .. " (" .. tostring(math.ceil((currpoints/iAchievementPointsCount)*100)) .. "%).", true, tabAchievements)
	guiSetFont(lPoints, "default-bold-small")
	
	paneAchievements = guiCreateScrollPane(0.05, 0.125, 0.9, 0.85, true, tabAchievements)
	
	pane = { }
	local y = 0.0
	local height = 0.2
	local resource = getResourceFromName("achievement-system")
	
	for key, value in pairs(tableAchievements) do
		local name = tableAchievements[key][1]
		local desc = tableAchievements[key][2]
		local points = tableAchievements[key][3]
		local date = tableAchievements[key][4]
		
		pane[key] = {}
		pane[key][7] = guiCreateScrollPane(0.0, y, 1.0, 0.35, true, paneAchievements)
		pane[key][6] = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, "bg.png", true, pane[key][7], resource)
		
		pane[key][1] = guiCreateLabel(0.225, 0.1, 0.7, 0.2, tostring(name) .. " (" .. date .. ").", true, pane[key][7])
		guiSetFont(pane[key][1], "default-bold-small")
		guiLabelSetHorizontalAlign(pane[key][1], "center")
		
		pane[key][3] = guiCreateStaticImage(0.05, 0.1, 0.2, 0.5, "achievement.png", true, pane[key][7], resource)
		pane[key][4] = guiCreateLabel(0.05, 0.45, 0.2, 0.2, tostring(points) .. " Pts", true, pane[key][7])
		guiLabelSetHorizontalAlign(pane[key][4], "center")
		guiSetFont(pane[key][4], "default-bold-small")
		
		pane[key][5] = guiCreateLabel(0.225, 0.25, 0.7, 0.6, tostring(desc), true, pane[key][7])
		guiLabelSetHorizontalAlign(pane[key][5], "center")
		guiSetFont(pane[key][5], "default-small")
		
		y = y + 0.205
	end
end

--/////////////////////////////////////////////////////////////////
--DISPLAY ACCOUNT MANAGEMENT
--////////////////////////////////////////////////////////////////
lDonator, lAdmin, lMuted, chkBlur, lChangePassword, lCurrPassword, tCurrPassword, lNewPassword1, NewPassword1, lNewPassword2, tNewPassword2, bSavePass = nil
function displayAccountManagement()
	-- DONATOR
	local donator = tonumber(getElementData(getLocalPlayer(), "donatorlevel"))
	lDonator = guiCreateLabel(0.2, 0.05, 0.5, 0.05, "Donator: ", true, tabAccount)
	guiSetFont(lDonator, "default-bold-small")
	if (donator==0) then
		guiSetText(lDonator, "Donator: No")
	elseif (donator==1) then
		guiSetText(lDonator, "Donator: Bronze")
	elseif (donator==2) then
		guiSetText(lDonator, "Donator: Silver")
	elseif (donator==3) then
		guiSetText(lDonator, "Donator: Gold")
	end
	
	-- ADMIN
	local admin = getElementData(getLocalPlayer(), "adminlevel")
	lAdmin = guiCreateLabel(0.2, 0.1, 0.5, 0.05, "Admin: ", true, tabAccount)
	guiSetFont(lAdmin, "default-bold-small")
	if (admin==0) then
		guiSetText(lAdmin, "Admin: No")
	else
		guiSetText(lAdmin, "Admin: Yes (" .. tostring(admin) .. ")")
	end
	
	-- MUTED
	local muted = getElementData(getLocalPlayer(), "muted")
	lMuted = guiCreateLabel(0.2, 0.15, 0.5, 0.05, "Muted: ", true, tabAccount)
	guiSetFont(lMuted, "default-bold-small")
	if (muted==0) then
		guiSetText(lMuted, "Muted: No")
	else
		guiSetText(lMuted, "Muted: Yes")
	end
	
	-- MTA USERNAME
	--local mtausername = getPlayerUserName(getLocalPlayer())
	--lMTAusername = guiCreateLabel(0.2, 0.2, 0.5, 0.05, "MTA Username: " .. mtausername, true, tabAccount)
	--guiSetFont(lMTAusername, "default-bold-small")
	
	-- MTA SERIAL
	--local mtaserial = getElementData(getLocalPlayer(), "serial")
	--mtaserial = string.sub(mtaserial, 1,4) .. "-" ..  string.sub(mtaserial, 5,8) .. "-" ..   string.sub(mtaserial, 9,12) .. "-" ..  string.sub(mtaserial, 13,16)  .. "-" .. string.sub(mtaserial, 17,20)  .. "-" .. string.sub(mtaserial, 21,24) .. "-" .. string.sub(mtaserial, 25,28) .. "-" .. string.sub(mtaserial, 29,32)
	--lMTAserial = guiCreateLabel(0.2, 0.25, 0.8, 0.05, "MTA Serial: " .. mtaserial, true, tabAccount)
	--guiSetFont(lMTAserial, "default-bold-small")
	
	-- BLUR
	local blur = getElementData(getLocalPlayer(), "blur")
	chkBlur = guiCreateCheckBox(0.2, 0.2, 0.5, 0.1, "Vehicle Blur", false, true, tabAccount)
	guiSetFont(chkBlur, "default-bold-small")
	if (blur==0) then
		guiCheckBoxSetSelected(chkBlur, false)
	else
		guiCheckBoxSetSelected(chkBlur, true)
	end
	addEventHandler("onClientGUIClick", chkBlur, clientToggleBlur, false)
	
	-- CHANGE PASSWORD
	lChangePassword = guiCreateLabel(0.375, 0.35, 0.5, 0.05, "Change Password", true, tabAccount)
	guiSetFont(lChangePassword, "default-bold-small")
	
	lCurrPassword = guiCreateLabel(0.1, 0.405, 0.5, 0.05, "Current Password: ", true, tabAccount)
	guiSetFont(lCurrPassword, "default-bold-small")
	tCurrPassword = guiCreateEdit(0.4, 0.4, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tCurrPassword, true)
	
	lNewPassword1 = guiCreateLabel(0.1, 0.505, 0.5, 0.05, "New Password: ", true, tabAccount)
	guiSetFont(lNewPassword1, "default-bold-small")
	tNewPassword1 = guiCreateEdit(0.4, 0.5, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tNewPassword1, true)
	
	lNewPassword2 = guiCreateLabel(0.1, 0.56, 0.5, 0.05, "New Password: ", true, tabAccount)
	guiSetFont(lNewPassword2, "default-bold-small")
	tNewPassword2 = guiCreateEdit(0.4, 0.555, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tNewPassword2, true)
	
	bSavePass = guiCreateButton(0.25, 0.65, 0.5, 0.1, "Save Password", true, tabAccount)
	addEventHandler("onClientGUIClick", bSavePass, savePassword, false)
end

function clientToggleBlur()
	local blur = guiCheckBoxGetSelected(chkBlur)
	
	if (blur) then
		triggerServerEvent("updateBlurLevel", getLocalPlayer(), true)
	else
		triggerServerEvent("updateBlurLevel", getLocalPlayer(), false)
	end
end

function savePassword(button, state)
	if (source==bSavePass) and (button=="left") and (state=="up") then
		showChat(true)
		local password = guiGetText(tCurrPassword)
		local password1 = guiGetText(tNewPassword1)
		local password2 = guiGetText(tNewPassword2)
		
		
		if (string.len(password1)<6) or (string.len(password2)<6) then
			outputChatBox("Your new password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.len(password)<6)  then
			outputChatBox("Your current password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("Your current password cannot contain ;,@'.", 255, 0, 0)
		elseif (string.find(password1, ";", 0)) or (string.find(password1, "'", 0)) or (string.find(password1, "@", 0)) or (string.find(password1, ",", 0)) then
			outputChatBox("Your new password cannot contain ;,@'.", 255, 0, 0)
		elseif (password1~=password2) then
			outputChatBox("The new passwords you entered do not match.", 255, 0, 0)
		else
			triggerServerEvent("cguiSavePassword", getLocalPlayer(), password, password1)
		end
	end
end

