-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler~=nil) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)

-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

local huntersCar = createVehicle ( 541, 618.575193, -74.190429, 997.992.1875, 0, 0, 110, D34M0N)
setElementDimension(huntersCar, 1000)
setElementInteiror(huntersCar, 2)

local hunter = createPed (258, 616.162109, -75.3720, 997.992)
exports.pool:allocateElement(hunter)
setPedRotation (hunter, 300.6221)
setElementInterior (hunter, 2)
setElementDimension (hunter, 1000)
setPedAnimation(hunter, "CAR_CHAT", "car_talkm_loop", -1, true, false, true) -- Set the Peds Animation.
setElementData (hunter, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
local triggerSphere = createColSphere( 677, -456, -25, 1 )
exports.pool:allocateElement(triggerSphere)

function hunterIntro (thePlayer, matchingDimension) -- When player enters the colSphere create GUI with intro output to all local players as local chat.
	
	local convoState = getElementData(hunter, "activeConvo")
	if (convoState == 0) then -- If hunter is not already talking to someone...
		
		-- Give the player the "Find Hunter" achievement.
			
		setElementData (hunter, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
		
		local pedX, pedY, pedZ = getElementPosition( hunter )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, key in ipairs( targetPlayers ) do
			outputChatBox("* A muscular man works under the car’s hood.", targetPlayers, 255, 51, 102)
		end
		destroyElement(chatSphere)
		triggerClientEvent ( thePlayer, "introEvent", getRootElement() ) -- Trigger Client side function to create GUI.
	end	
end
addEventHandler ( "onColShapeHit", triggerSphere, hunterIntro ) -- when player enters the colSphere start the conversation / open the GUI.

-- Statement 2
function statement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Hey. I’m logging for a mechanic to change a spark plug.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: I’m busy. There’s a place on ... that can do it.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 3
function statement3_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Nice ride. Is it yours?", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: It sure is.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 4
function statement4_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Whatcha running under there?", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Sport air intake, NOS, fogger system and a T4 turbo. But you wouldn’t know much about that, would you?", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 5
function statement5_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I like the paint job.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: It’s not about how it looks, man. This car will rip your insides out and throw ‘em at you, rookie.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 6
function statement6_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Looks like all show and no go to me.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Just goes to show you aren’t a real gear head. Come back when you have a clue.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 7
function statement7_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Is that an AIC controller? ...And direct port nitrous injection?", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: You almost sound like you know what you’re talking about.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 8
function statement8_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: There’s nothing better than living a quarter mile at a time.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Oh, you’re a racer? They call me Hunter. I got a real name but unless you’re the government you don’t need to know it.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 9
function statement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: You work here alone?", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Yeah so I got work to do. Nice talkin’ to ya.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 10
function statement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: My mother taught me never to trust a man that won’t even tell you his name.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Well here’s the thing. One of my usual guys got busted a couple days ago. If you’re looking to make some money I could use a new go to guy.", targetPlayers, 255, 255, 255) -- Hunter's next question
		outputChatBox("Hunter says: See running a car like this isn’t cheap so we ...borrow from other cars if you know what I’m saying.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 11
function statement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Sounds like easy money. Give me a call on ".. phoneNumber ..".", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: You can expect my call. I might see you on the circuit some time too.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
	mysql_query(handler, "UPDATE characters SET hunter='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1") -- NOT WORKING

end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 12
function statement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: . I’d rather not get involved in all that.", targetPlayers, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Whatever. I got work to do.", targetPlayers, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )