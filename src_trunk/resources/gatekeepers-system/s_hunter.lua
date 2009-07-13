local huntersCar = createVehicle ( 506, 618.575193, -74.190429, 997.9921875, 0, 0, 110, "D34M0N")
setVehicleLocked(huntersCar, true)
setElementDimension(huntersCar, 1000)
setElementInterior(huntersCar, 2)

local hunter = createPed (250, 616.162109, -75.3720, 997.99)
exports.pool:allocateElement(hunter)
setPedRotation (hunter, 300.6221)
setElementInterior (hunter, 2)
setElementDimension (hunter, 1000)
setPedAnimation(hunter, "CAR_CHAT", "car_talkm_loop", -1, true, false, true) -- Set the Peds Animation.
setElementData (hunter, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
setElementData(hunter, "name", "Hunter")
setElementData(hunter, "talk", true)
setPedAnimation(hunter, "CAR_CHAT", "car_talkm_loop", -1, true, false, true)

function hunterIntro () -- When player enters the colSphere create GUI with intro output to all local players as local chat.	
	-- Give the player the "Find Hunter" achievement.
	local thePlayer = source
	local state = getElementData( thePlayer, "hunterCoolDown")
	
	if(getElementData( thePlayer, "hunterCoolDown"))then
		outputChatBox("Hunter doesn't want to talk to you.", thePlayer, 255, 0, 0)
	else
		local pedX, pedY, pedZ = getElementPosition( hunter )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("* A muscular man works under the car’s hood.", player, 255, 51, 102)
		end
		destroyElement(chatSphere)
		setElementData (hunter, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
	end
end
addEvent( "startHunterConvo", true )
addEventHandler( "startHunterConvo", getRootElement(), hunterIntro )

-- Statement 2
function statement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Hey. I’m looking for a mechanic to change a spark plug.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: I’m busy. There’s a place on ... that can do it.", player, 255, 255, 255) -- Hunter's next question
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
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Nice ride. Is it yours?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: It sure is.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement3ServerEvent", true )
addEventHandler( "hunterStatement3ServerEvent", getRootElement(), statement3_S )

-- Statement 4
function statement4_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Whatcha running under there?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Sport air intake, NOS, fogger system and a T4 turbo. But you wouldn’t know much about that, would you?", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement4ServerEvent", true )
addEventHandler( "hunterStatement4ServerEvent", getRootElement(), statement4_S )

-- Statement 5
function statement5_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I like the paint job.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: It’s not about how it looks, man. This car will rip your insides out and throw ‘em at you, rookie.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement5ServerEvent", true )
addEventHandler( "hunterStatement5ServerEvent", getRootElement(), statement5_S )

-- Statement 6
function statement6_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Looks like all show and no go to me.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Just goes to show you aren’t a real gear head. Come back when you have a clue.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement6ServerEvent", true )
addEventHandler( "hunterStatement6ServerEvent", getRootElement(), statement6_S )

-- Statement 7
function statement7_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Is that an AIC controller? ...And direct port nitrous injection?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: You almost sound like you know what you’re talking about.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement7ServerEvent", true )
addEventHandler( "hunterStatement7ServerEvent", getRootElement(), statement7_S )

-- Statement 8
function statement8_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: There’s nothing better than living a quarter mile at a time.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Oh, you’re a racer? They call me Hunter. I got a real name but unless you’re the government you don’t need to know it.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement8ServerEvent", true )
addEventHandler( "hunterStatement8ServerEvent", getRootElement(), statement8_S )

-- Statement 9
function statement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: You work here alone?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Yeah so I got work to do. Nice talkin’ to ya.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement9ServerEvent", true )
addEventHandler( "hunterStatement9ServerEvent", getRootElement(), statement9_S )

-- Statement 10
function statement10_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: My mother taught me never to trust a man that won’t even tell you his name.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Well here’s the thing. One of my usual guys got busted a couple days ago.", player, 255, 255, 255) -- Hunter's next question
		outputChatBox("If you’re looking to make some money I could use a new go to guy.", player, 255, 255, 255)
		outputChatBox("Hunter says: See running a car like this isn’t cheap so we ...borrow from other cars if you know what I’m saying.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
end
addEvent( "hunterStatement10ServerEvent", true )
addEventHandler( "hunterStatement10ServerEvent", getRootElement(), statement10_S )

-- Statement 11
function statement11_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Sounds like easy money. Give me a call.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: You can expect my call. I might see you on the circuit some time too.", player, 255, 255, 255) -- Hunter's next question
		exports.global:sendLocalMeAction( source,"jots down their number on a scrap of paper and hands it to Hunter.")
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
	mysql_query(handler, "UPDATE characters SET hunter='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1") -- NOT WORKING

end
addEvent( "hunterStatement11ServerEvent", true )
addEventHandler( "hunterStatement11ServerEvent", getRootElement(), statement11_S )

-- Statement 12
function statement12_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: . I’d rather not get involved in all that.", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Hunter says: Whatever. I got work to do.", player, 255, 255, 255) -- Hunter's next question
	end
	destroyElement (chatSphere)
	setElementData (hunter, "activeConvo", 0)
end
addEvent( "hunterStatement12ServerEvent", true )
addEventHandler( "hunterStatement12ServerEvent", getRootElement(), statement12_S )