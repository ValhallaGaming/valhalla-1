-- Since GUIs are only client side the only way I could think to do this was by each statement having
-- a client side function (the GUI) which triggers a server side function to ouput chat messages.
-- It's probably more complicated and less efficient than it could be. There are also a lot of holes
-- that need filling.

----------------------
-- Creating the Ped --
----------------------

-- Server Side
function createStevie () -- Create SteviePed at 19:00 every day.
	
	local theTime = -- get the server's time.
	
	if ( ) -- At 1900 server time create Stevie in the steakhouse.
		local stevie = createPed (258, 675.89807128906, -455.46102905273, -26.4140625)
		setElementRotation (stevie, 187.01502990723)
		setElementInterior (stevie, 1)
		setElementDimension (stevie, 515)
		setPedAnimation ( stevie, "FOOD", "FF_Sit_Loop", -1, true, false, false) -- Set the Peds Animation.
		
		setElementData (stevie, "activeConvo", 0) -- Set the convo state to 0 so people can start talking to him.
		
		local pedX, pedY, pedZ = getElementPosition( stevie ) -- Create colSphere to detect trigger.
		local triggerSphere = createColSphere( pedX, pedY, pedZ, 2 )
		
		setTimer ( destroyStevie, 10800000, 1  ) -- Put Stevie on a 3 hour timer to delete him.
	else
		
	end
end
-- add event handler

-- Destroy Stevie at 22:00 every day.
function destroyStevie ()
	destroyElement ( stevie )
	destroyElement ( triggerSphere )
end

-----------
-- Intro --
-----------
-- Client side 
wStevie, optionOne, optionTwo, buttonClose, stevieText = nil

function createStevieGUI( thePlayer, matchingDimension) 
	
			-- Window variables
			local Width = 400
			local Height = 400
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2

			-- Create the window
			wStevie = guiCreateWindow( x, y, Width, Height, "Conversation with a stranger.", true )
	
			-- Create Stevies text box
			stevieText guiCreateMemo ( 0.1, 0.1, 0.8, 0.5, "Do you want something, pal?", true )
			guiMemoSetReadOnly ( stevieText, true )
	
			-- Create close, previous and Next Button
			optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "Can I take a seat?", true )
			addEventHandler( "onClientGUIClick", optionOne, statement2, false )

			optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "No. Sorry to bother you.", true )
			addEventHandler( "onClientGUIClick", optionTwo, quickClose, false ) -- Trigger Server side event
		
		end
	end
end
addEvent( "introEvent", true )
addEventHandler( "introEvent", getRootElement(), createStevieGUI )

-- Server side
function stevieIntro ( thePlayer, matchingDimension ) -- When player enters the colSphere create GUI with intro output to all local players as local chat.
	if getElementType ( thePlayer ) == "player" then --if the element that entered was player
		if (getElementData(stevie, "activeConvo") == 1) then -- If stevie is already talking to someone...
			-- do nothing
		else
			
			-- Give the player the "Find Stevie" achievement.
			
			setElementData (stevie, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
	
			local chatSphere = createColSphere( pedX, pedY, pedZ, 10 ) -- Create the colSphere for chat output to local players
			local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
			for index, targetPlayers in ipairs( targetPlayers ) do
			outputChatBox("Stevie says: Do you want something, pal?", targetPlayers, 255, 255, 255) -- Stevies next question
						
			triggerClientEvent ( thePlayer, "introEvent", getRootElement() ) -- Trigger Client side function to create GUI.
		end
	end
end
addEventHandler ( "onColShapeHit", triggerSphere, stevieIntro ) -- when player enters the colSphere start the conversation / open the GUI.

---------------------------------------------
---------------- Statement 2 ----------------
---------------------------------------------
-- Server Side
function statement2_S ()
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Can I take a seat?", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Sure, sit down. Have you tried the food here? It’s f****** unbelievable.", targetPlayers, 255, 255, 255) -- Stevies next question
	end
	destroyElement (chatSphere)
end
addEvent( "statement2ServerEvent", true )
addEventHandler( "statement2ServerEvent", getRootElement(), statement2_S )

-- Client Side
function statement2 ()
	
	triggerServerEvent( "statement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Set players position and anim so they are sitting opposite Stevie. Freeze them so they can't move until they end the conversation
	setElementPosition (thePlayer, 675.81127929688, -457.45016479492, -24.406700134277)
	setElementRotation (thePlayer, 11.667144775391)
	setPedAnimation ( thePlayer, "INT_OFFICE", "OFF_Sit_Watch", -1, true, false, false)
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil
	
	-- Create new Stevies text box
	guiSetText ( StevieText, "Sure, sit down. Have you tried the food here? It's f****** unbelievable" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "Yeah I heard it’s good. I was just about to order something.", true )
	addEventHandler( "onClientGUIClick", optionOne, statement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "I’m a vegetarian. The thought of those poor animals suffering for you to stuff your face makes me sick.", true )
	addEventHandler( "onClientGUIClick", optionTwo, statement3, false )

	buttonClose = guiCreateButton( 0.1, 0.8, 0.8, 0.1, "Is that the time? I have to go.", true )
	addEventHandler( "onClientGUIClick", buttonClose, CloseButtonClick, false )
	
end

------------------------------------------
---------------- Statement 3 ----------------
------------------------------------------
-- Server Side
function statement3_S ()
	setPedAnimation ( thePlayer ) --Unfreeze the player.
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I’m a vegetarian. The thought of those poor animals suffering for you to stuff your face makes me sick.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: Hey f*** you, pal. You don’t like it, you can go save a whale or some shit ‘cause I don’t wanna hear it.", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "statement3Event", getRootElement() -- Trigger client side "statement3"
end	
addEvent( "statement3ServerEvent", true )
addEventHandler( "statement3ServerEvent", getRootElement(), statement3_S )

-- Client Side
function statement3
	
	triggerServerEvent( "statement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil
	
end


------------------------------------------
---------------- Statement 4 ----------------
------------------------------------------

-- Server Side
function statement4_S ()
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Yeah I heard it’s good. I was just about to order something.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: Get the Angus ribeye. You won’t regret it. Where’s my manners...", targetPlayers, 255, 255, 255)
		exports.global:sendLocalMeAction( "Stevie wipes his hands on a napkin and offers "..name.." a hand shake.")
		outputChatBox("Stevie says: The name’s Stevie.", targetPlayers, 255, 194, 14)
	end
	destroyElement (chatSphere)
	
end
addEvent( "statement4ServerEvent", true )
addEventHandler( "statement4ServerEvent", getRootElement(), statement4_S )

-- Client Side
function statement4 ()
	
	triggerServerEvent( "statement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil

	-- Create Stevies text box
	guiSetText (StevieText, "Get the Angus ribeye. You won’t regret it. Where’s my manners... The name’s Stevie." )
	guiMemoSetReadOnly ( stevieText, true )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "Shake Stevie’s hand.", true )
	addEventHandler( "onClientGUIClick", optionOne, statement6, false )

	optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "Refuse to shake Stevie’s hand.", true )
	addEventHandler( "onClientGUIClick", optionTwo, statement5, false )
	
end
------------------------------------------
---------------- Statement 5 ----------------
------------------------------------------
-- Client Side
function statement5
	
	triggerServerEvent( "statement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( buttonClose )
	destroyElement ( stevieText )
	destroyElement ( wStevie )
	destroyElement ( chatSphere )
	optionOne = nil
	optionTwo = nil
	buttonClose = nil
	stevieText = nil
	wStevie = nil
	
end

-- Server Side
function statement5_S ()
	
	setPedAnimation ( thePlayer ) --Unfreeze the player.
		
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox("Stevie says: I was just being polite but if you want to be an ass about it how about you leave me to eat my steak in peace.", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "statement5Event", getRootElement()  -- Trigger client side "statement5"
end	
addEvent( "statement5ServerEvent", true )
addEventHandler( "statement5ServerEvent", getRootElement(), statement5_S )

------------------------------------------
---------------- Statement 6 ----------------
------------------------------------------
-- Client Side
function statement6
	
	triggerServerEvent( "statement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil

	-- Create Stevies text box
	guiSetText (StevieText, "Stevie says: Me and the boys from the freight depot come down here all the time. Football and steaks make a damn good combo don’t ya think?" )
	guiMemoSetReadOnly ( stevieText, true )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "I never really liked football.", true )
	addEventHandler( "onClientGUIClick", optionOne, statement8, false )

	optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "Are you kidding me? I’ve been a Beavers fan my whole life!", true )
	addEventHandler( "onClientGUIClick", optionTwo, statement7, false )
end


-- Server Side
function statement6_S ()
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		exports.global:sendLocalMeAction( name.." shakes Stevie's hand.")
		outputChatBox("Stevie says: Me and the boys from the freight depo come down here every week. Football and steaks make a damn good combination don’t you think?", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "statement6Event", getRootElement()  -- Trigger client side "statement6"
end
addEvent( "statement6ServerEvent", true )
addEventHandler( "statement6ServerEvent", getRootElement(), statement6_S )

------------------------------------------
---------------- Statement 7 ----------------
------------------------------------------
-- Client Side
function statement7

	triggerServerEvent( "statement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( buttonClose )
	destroyElement ( stevieText )
	destroyElement ( wStevie )
	destroyElement ( chatSphere )
	optionOne = nil
	optionTwo = nil
	buttonClose = nil
	stevieText = nil
	wStevie = nil
end

-- Server Side
function statement7_S ()
	
	setPedAnimation ( thePlayer ) --Unfreeze the player.
		
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name.." says: Are you kidding me? I’ve been a Beavers fan my whole life!", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: What?! The Beavers? You’re lucky I don’t punch your lights out right here and now you piece-a beaver scum. Look... now you made me lose my appetite.", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "statement7Event", getRootElement() -- Trigger client side "statement7"
end
addEvent( "statement7ServerEvent", true )
addEventHandler( "statement7ServerEvent", getRootElement(), statement7_S )

------------------------------------------
---------------- Statement 8 ----------------
------------------------------------------
-- Client Side
function statement8
	
	triggerServerEvent( "statement8ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil

	-- Create Stevies text box
	guiSetText ( StevieText, "Stevie says: Yeah, maybe it isn’t to everyone’s taste. So what do you do?" )
	guiMemoSetReadOnly ( stevieText, true )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "I’d rather not get into that if you don’t mind.", true )
	addEventHandler( "onClientGUIClick", optionOne, statement5, false )

	optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "Over worked and underappreciated. You know how it is.", true )
	addEventHandler( "onClientGUIClick", optionTwo, statement9, false )
end

-- Server Side
function statement8_S ()
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox( name.." says: I never really liked football.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: Yeah, maybe it isn’t to everyone’s taste. So what do you do?", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "statement8", getRootElement()  -- Trigger client side "statment8"
end
addEvent( "statement8ServerEvent", true )
addEventHandler( "statement8ServerEvent", getRootElement(), statement8_S )

------------------------------------------
---------------- Statement 9 ----------------
------------------------------------------
-- Client Side
function statement9
	
	triggerServerEvent( "statement9ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	optionOne = nil
	optionTwo = nil
	stevieText = nil

	-- Create Stevies text box
	guiSetText ( StevieText, "Stevie says: Tell me about it! They got me bustin’ my ass at the freight yard for change. See it’s people like you and me that need to help each other out. Tell you what, here’s my card. You ever need anything I can help you out with, just give me a call." )
	guiMemoSetReadOnly ( stevieText, true )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "Take Stevie’s card", true )
	addEventHandler( "onClientGUIClick", optionOne, stevieSuccess, false )

	optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "Leave without taking the card", true )
	addEventHandler( "onClientGUIClick", optionTwo, CloseButtonClick, false )
end

-- Server Side
function statement9_S ()
	
	setPedAnimation ( thePlayer ) --Unfreeze the player.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox( name.." says: Over worked and underappreciated. You know how it is.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: Tell me about it! They got me bustin’ my ass at the freight yard for change.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: See it’s people like you and me that need to help each other out.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: Tell you what, here’s my card. You ever need anything I can help you out with, just give me a call.", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	-- Give the player the "A friend of Stevie" achievement.
end
addEvent( "statement9ServerEvent", true )
addEventHandler( "statement9ServerEvent", getRootElement(), statement9_S )
------------------------------------------
---------------- Success with Stevie ----------------
------------------------------------------
-- Client Side
function stevieSuccess
	
	triggerServerEvent( "stevieSuccessServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( buttonClose )
	destroyElement ( stevieText )
	destroyElement ( wStevie )
	optionOne = nil
	optionTwo = nil
	buttonClose = nil
	stevieText = nil
	wStevie = nil
	
	-- Unfreeze the player
end

-- Server Side
function stevieSuccess_S ()
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Add Stevie's business card to players inventory.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	exports.global:sendLocalMeAction( name.." takes Stevie's card.")
	-- Give the player an item. Name = "Business card"  Description = "Steven Pullman, L.V. Freight Depot, Tel: 081016"  !NEEDS NEW ITEM!
	end
	destroyElement (chatSphere)
	
end
addEvent( "stevieSuccessServerEvent", true )
addEventHandler( "stevieSuccessServerEvent", getRootElement(), stevieSuccess_S )

----------------------------------------------
---------------- Close Button ----------------
----------------------------------------------
-- Client Side
function CloseButtonClick
	
	triggerServerEvent( "CloseButtonClickServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( buttonClose )
	destroyElement ( stevieText )
	destroyElement ( wStevie )
	destroyElement ( chatSphere )
	optionOne = nil
	optionTwo = nil
	buttonClose = nil
	stevieText = nil
	wStevie = nil
	
end

-- Server Side
function CloseButtonClick_S
	
	setPedAnimation ( thePlayer ) --Unfreeze the player.
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Is that the time? I have to go.", targetPlayers, 255, 255, 255)
		outputChatBox("Stevie says: You take it easy. Maybe I'll run into you again some time.", targetPlayers, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	triggerClientEvent ( thePlayer, "CloseEvent", getRootElement() -- Trigger client side event ( CloseButtonClick ) to output chat
end
addEvent( "CloseButtonClickServerEvent", true )
addEventHandler( "CloseButtonClickServerEvent", getRootElement(), CloseButtonClick_S )

----------------------------------------------
---------------- Simple Close Button ----------------
----------------------------------------------
-- Client Side
function quickClose ()
	
	triggerServerEvent( "quickCloseServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( stevieText )
	destroyElement ( wStevie )
	destroyElement ( chatSphere )
	optionOne = nil
	optionTwo = nil
	stevieText = nil
	wStevie = nil
	
end

-- Server Side
function quickClose_S ()
	setPedAnimation ( thePlayer ) --Unfreeze the player.
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
end
addEvent( "quickCloseServerEvent", true )
addEventHandler( "quickCloseServerEvent", getRootElement(), quickClose_S )

---------------------------------
------ Phone Conversation -------
---------------------------------
function steviePhonegui( thePlayer, commandName, SteviesNumber )
	
	if not(exports.global:doesPlayerHaveItem(thePlayer, 2) -- Check the player has a cellphone.
		outputChatBox("You need a cellphone to make a call.", targetPlayers, 255, 194, 14)
	else
		setPedAnimation(thePlayer, "ped", "phone_in", 100, false, true, false)
		setTimer(setPedAnimation, 2000, 1, thePlayer, "ped", "phone_talk", 100, false, true, false)
		setElementData(thePlayer, "phonestate", 1) -- The player cannot be called.
		
		local serverTime = -- get the server's time.
	
		if not ( serverTime<1900 ) and ( serverTime>2200 ) then -- Make sure the time not between 7pm and 10pm when Stevie is at the steak house.
			outputChatBox("The phone you are trying to call is switched off.", targetPlayers, 255, 194, 14)
			setPedAnimation ( thePlayer )
		else
			if not (getElementData (stevie, "phoneCconvoState") == 0 ) then -- is someone already talking to Stevie?
				outputChatBox("The phone you are trying to call is engaged.", targetPlayers, 255, 194, 14)
				setPedAnimation ( thePlayer )
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
		
				if (factionType==2) then -- is the player a cop?
					outputChatBox("((Steven Pullman)) #081016 [Cellphone]: I think you got the wrong number, pal.", thePlayer )
					outputChatBox("They hung up.", thePlayer)
					setPedAnimation(thePlayer, "ped", "phone_out", 1300, false, true, false)
					setTimer(setPedAnimation, 1305, 1, thePlayer)
				else -- If they aren't a cop.
					setElementData (stevie, "phoneConvoState", 1) -- convoState set to active so no one else can call.
					-- Create the GUI
					local Width = 400
					local Height = 400
					local X = (screenwidth - Width)/2
					local Y = (screenheight - Height)/2

					wStevie = guiCreateWindow( x, y, Width, Height, "Phone Conversation with a stranger", true ) -- Create the window
		
					stevieText guiCreateMemo ( 0.1, 0.1, 0.8, 0.5, "I've got a couple crates that I could put aside if you're interested. Shall we say $3,000?", true ) -- Create Stevies text box
					guiMemoSetReadOnly ( stevieText, true )
	
					optionOne = guiCreateButton( 0.1, 0.6, 0.8, 0.1, "Agree to the deal.", true ) -- Create option buttons
					addEventHandler( "onClientGUIClick", optionOne, triggerServerEvent ( "agreeSteviePhoneDeal", getLocalPlayer()), false )

					optionTwo = guiCreateButton( 0.1, 0.7, 0.8, 0.1, "Decline the deal.", true )
					addEventHandler( "onClientGUIClick", optionTwo, triggerServerEvent ( "declineSteviePhoneDeal", getLocalPlayer()), false )
				end
			end
		end		
	end
end
addCommandHandler ( "call 081016", steviePhonegui )

---------------------------
-- Closing the phone GUI -- for both accept and declining the deal.
---------------------------

-- Client Side
function CloseSteviePhoneGUI
	-- Destroy elements
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement( stevieText )
	destroyElement ( wStevie )
	optionOne = nil
	optionTwo = nil
	stevieText = nil
	wStevie = nil
end
addEvent( "phoneCloseWindowEvent", true )
addEventHandler( "phoneCloseWindowEvent", getRootElement(), CloseSteviePhoneGUI )

--------------------------------------------------
---------------- Agree Phone Deal ----------------
--------------------------------------------------
-- Server Side
function agreeDeal_S ()

		setPedAnimation(thePlayer, "ped", "phone_out", 1300, false, true, false) -- Reset the players animation
		setTimer(setPedAnimation, 1305, 1, thePlayer)
		setElementData(thePlayer, "phonestate", 0) -- The player can be called again.
		setElementData(stevie,"phoneConvoState", 0) -- reset the convo state so other players can call Stevie.
		
		local playerMoney = getElementData ( thePlayer, "cashInHand" ) -- Check the player has $3000
		if not (playerMoney >= 3000) then
			outputChatBox("Stevie says: Call me when you've got the money.", thePlayer, 255, 194, 14) -- Tell the player they don't have enough money
			setPedAnimation ( thePlayer ) -- End the call			
		else
			
			local chatSphere = createColSphere( pedX, pedY, pedZ, 10 ) -- Output the text from the last option to all player in radius
			local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
			local name = string.gsub(getPlayerName(thePlayer), "_", " ")
			for index, targetPlayers in ipairs( targetPlayers ) do
				outputChatBox(name.. " says: You got a deal.", targetPlayers, 255, 194, 14)
			end
			
			destroyElement (chatSphere)
			outputChatBox("Stevie says: The crates will be in a truck at the freight depot. Take it easy.", thePlayer, 255, 194, 14)
		
			-- Take the money from the thePlayer
	
			-- Spawn the truck with a random selection of items inside at one of several locations around the freight yard
			
			if (fType == "gang") then
				-- A random selection of: Pistol, shotguns, tec-9, micro SMG, rifle, marijuana
			elseif (fType == "mafia") then
				-- A random selection of: Pistol, SD Pistol, Sawnoff, Combat Shotgun, SMG, AK, M4, Sniper Rifle, Satchel and detonator, cocaine
			else
				-- A random selection of: Pistol, SD Pistols, Shotgun, Rifle, Tec 9
			end
			
			-- Create a marker on the player's radar showing the trucks spawn location.
		
		else
	end
	
	triggerClientEvent ( thePlayer, "phoneCloseWindowEvent", getRootElement() -- Trigger client side "CloseWindow" to remove the GUI
end
addEvent( "agreeSteviePhoneDeal", true )
addEventHandler( "agreeSteviePhoneDeal", getRootElement(), agreeDeal_S )
--------------------------------------------------
---------------- Decline Phone Deal ----------------
-------------------------------------------------
-- Server Side
function declineDeal_S ()
	
	setPedAnimation(thePlayer, "ped", "phone_out", 1300, false, true, false) -- Reset the players animation
	setTimer(setPedAnimation, 1305, 1, thePlayer)
	setElementData(thePlayer, "phonestate", 0) -- The player can be called again.
	setElementData(stevie, "phoneConvoState", 0) -- reset the convo state so other players can call Stevie.
			
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 ) -- Output the text from the last option to all player in radius
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(thePlayer), "_", " ")
	for index, targetPlayers in ipairs( targetPlayers ) do
		outputChatBox(name.. " says: Maybe another time.", targetPlayers, 255, 194, 14)
	end			
	destroyElement (chatSphere)
	outputChatBox("Stevie says: Okay. Give me a call if you change your mind.", thePlayer, 255, 194, 14)
	setPedAnimation ( thePlayer ) -- Reset the players animation
	
	triggerClientEvent ( thePlayer, "phoneCloseWindowEvent", getRootElement() -- Trigger client side "CloseWindow" to remove the GUI
	
end
addEvent( "declineSteviePhoneDeal", true )
addEventHandler( "declineSteviePhoneDeal", getRootElement(), declineDeal_S )