local tyColSphere = createColSphere( 2242.52, -1170.7, 1029.79, 1)
exports.pool:allocateElement(tyColSphere)
tyColDim = 1160
setElementDimension( tyColSphere, tyColDim )

tyrese = createPed (28, 2264.65234375, -1134.3662109375, 1050.6328125)
exports.pool:allocateElement(tyrese)

setPedRotation(tyrese, 120)
setPedFrozen(tyrese, true)
setElementInterior( tyrese, 10 )
setElementDimension( tyrese, 1165 )
setElementData (tyrese, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
setElementData(tyrese, "name", "Ty")
setElementData(tyrese, "talk", true)
setElementData(tyrese, "rotation", getPedRotation(tyrese), false)

function startTy(thePlayer, matchingDimension )
	if matchingDimension then
		local logged = getElementData(thePlayer, "loggedin")
		
		if (logged==1) then
			if (isElementWithinColShape(thePlayer, tyColSphere)) then
				triggerClientEvent( thePlayer, "startTy_c", getRootElement())
			end
		end
	end
end
addEventHandler("onColShapeHit", tyColSphere, startTy )

function tyIntro () -- When player enters the colSphere create GUI with intro output to all local players as local chat.	
	-- Give the player the "Find Ty" achievement.
	exports.global:sendLocalMeAction(source,"knocks on the door")
	
	if(getElementData( tyrese, "activeConvo" )==1)then
		
		local pedX, pedY, pedZ = getElementPosition( source )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("Ty shouts: Yo', I'm busy!", player, 255, 255, 255)
		end
		destroyElement(chatSphere)
		
		triggerClientEvent(source, "closeTyWindow", getRootElement())
	
	else
		-- Friend of Ty's?
		local query = mysql_query(handler, "SELECT tyrese FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .."'")
		local tysFriend = tonumber(mysql_result(query, 1, 1))
		mysql_free_result(query)
		
		-- Friend of Rook's?
		local query = mysql_query(handler, "SELECT rook FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .."'")
		local rooksFriend = tonumber(mysql_result(query, 1, 1))
		mysql_free_result(query)
		
		-- Output chat.
		local pedX, pedY, pedZ = getElementPosition( source )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("Ty shouts: Yo', who is it?!", player, 255, 255, 255)
		end
		
		destroyElement(chatSphere)
		
		setElementData (tyrese, "activeConvo",  1)
		talkingToTy = source
		addEventHandler("onPlayerQuit", talkingToTy, resetTyConvoStateDelayed)
		addEventHandler("onPlayerWasted", talkingToTy, resetTyConvoStateDelayed)
		
		triggerClientEvent( source, "callback", getRootElement(), rooksFriend, tysFriend)
	end
end
addEvent( "startTyConvo", true )
addEventHandler( "startTyConvo", getRootElement(), tyIntro )

---------------------------- Non-Friends ------------------------------------

-- Statement 4
function tyStatement4_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " shouts: Yo', c'mon open the fuckin' door, homie.", player, 255, 255, 255)
		outputChatBox("Ty shouts: I don't know you. Get the fuck up outta here!", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	setElementData (tyrese, "activeConvo",  0)
	
end
addEvent( "tyStatement4ServerEvent", true )
addEventHandler( "tyStatement4ServerEvent", getRootElement(), tyStatement4_S )

-- Statement 5
function tyStatement5_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " shouts: Rook sent me. He said you needed some help with some business.", player, 255, 255, 255)
		outputChatBox("Ty shouts: A'ight, hold up!", player, 255, 255, 255)
		outputChatBox("* The door unlocks", player, 255, 51, 102)
		outputChatBox("Ty says: Only you. Anyone else is gonna have to wait outside.", player, 255, 255, 255)
	end
	
	destroyElement (chatSphere)
	
	setElementPosition(source, 2260, -1136, 1049.6)
	setElementDimension(source, 1165)
	setElementInterior(source, 10)
	
	-- Output the text from the last option to all player in radius
	outputChatBox( "Ty says: So you talked to Rook, right? What did he tell you?.", source, 255, 255, 255)
end
addEvent( "tyStatement5ServerEvent", true )
addEventHandler( "tyStatement5ServerEvent", getRootElement(), tyStatement5_S )

-- Statement 6
function tyStatement6_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( tyrese )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: He said you had connects but needed someone to put it all to use.", player, 255, 255, 255)
		outputChatBox("Ty says: Yeah that's right. So you down? Here's how it'll work.", player, 255, 255, 255)
		outputChatBox("Ty says: I got some people's I can call up on when I need that produce.", player, 255, 255, 255)
		outputChatBox("Ty says: I'll act as middle man and sell to you at wholesale. You then can do whatever you want with it.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "tyStatement6ServerEvent", true )
addEventHandler( "tyStatement6ServerEvent", getRootElement(), tyStatement6_S )

-- Statement 7
function tyStatement7_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: He said you had connects but didn't know what to do with them.", player, 255, 255, 255)
		outputChatBox("Ty says: Fuck you! I ain't no amateur. Get the fuck up out of here. ", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	setElementPosition(source, 2242.52, -1170.7, 1028.79)
	setElementDimension(source, 1160)
	setElementInterior(source, 15)
	
	resetTyConvoStateDelayed()
	
end
addEvent( "tyStatement7ServerEvent", true )
addEventHandler( "tyStatement7ServerEvent", getRootElement(), tyStatement7_S )

-- Statement 8
function tyStatement8_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Sounds a'ight.", player, 255, 255, 255)
		outputChatBox("Ty says: You ever need the shit just come by.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	setElementPosition(source, 2242.52, -1170.7, 1028.79)
	setElementDimension(source, 1160)
	setElementInterior(source, 15)
	
	resetTyConvoStateDelayed()
	
	local query = mysql_query(handler, "UPDATE characters SET tyrese='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
	mysql_free_result(query)
end
addEvent( "tyStatement8ServerEvent", true )
addEventHandler( "tyStatement8ServerEvent", getRootElement(), tyStatement8_S )

-- Statement 9
function tyStatement9_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Wholesale? I thought we were partners.", player, 255, 255, 255)
		outputChatBox("Ty says: If you ain't down I can find some other niggas.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
end
addEvent( "tyStatement9ServerEvent", true )
addEventHandler( "tyStatement9ServerEvent", getRootElement(), tyStatement9_S )

-- Statement 10
function tyStatement10_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Na, it's cool. We got a deal.", player, 255, 255, 255)
		outputChatBox("Ty says: You ever need me to hook you up, just stop by.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	setElementPosition(source, 2242.52, -1170.7, 1028.79)
	setElementDimension(source, 1160)
	setElementInterior(source, 15)
	
	resetTyConvoStateDelayed()
	
	local query = mysql_query(handler, "UPDATE characters SET tyrese='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
	mysql_free_result(query)
end
addEvent( "tyStatement10ServerEvent", true )
addEventHandler( "tyStatement10ServerEvent", getRootElement(), tyStatement10_S )

-- Statement 11
function tyStatement11_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Yeah you do that.", player, 255, 255, 255)
		outputChatBox("Ty says: Then we're done here.  Get the steppin'.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	setElementPosition(source, 2242.52, -1170.7, 1028.79)
	setElementDimension(source, 1160)
	setElementInterior(source, 15)
	
	resetTyConvoStateDelayed()
	
end
addEvent( "tyStatement11ServerEvent", true )
addEventHandler( "tyStatement11ServerEvent", getRootElement(), tyStatement11_S )

---------------- friends----------------------
function tyFriendStatement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " shouts: Yo it's me. Open the door.", player, 255, 255, 255)
		outputChatBox("Ty shouts: A'ight hold up..", player, 255, 255, 255)
		outputChatBox("* The door unlocks", player, 255, 51, 102)
	end
	destroyElement (chatSphere)
	
	setElementPosition(source, 2260, -1136, 1049.6)
	setElementDimension(source, 1165)
	setElementInterior(source, 10)
	
	outputChatBox("Ty says: So what you looking for this time?", source, 255, 255, 255)
		
end
addEvent( "tyFriendStatement2ServerEvent", true )
addEventHandler( "tyFriendStatement2ServerEvent", getRootElement(), tyFriendStatement2_S )

function giveTyItems( itemNumber )

	if(itemNumber == 1)then
		itemID = 30
		cost = 10
	elseif (itemNumber == 2)then
		itemID = 32
		cost = 20
	elseif (itemNumber == 3)then
		itemID = 33
		cost = 20
	--elseif (itemNumber == 4)then
	--	itemID = 31
	--	cost = 25
	end
		
	-- does the player have enough money?
	if not exports.global:takeMoney(source, cost) then
		
		local pedX, pedY, pedZ = getElementPosition( tyrese )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		local name = string.gsub(getPlayerName(source), "_", " ")
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("Ty says: I ain't givin' this shit away. Come back when you got the money.", player, 255, 255, 255)
		end
		
		destroyElement (chatSphere)
		
		setElementPosition(source, 2242.52, -1170.7, 1028.79)
		setElementDimension(source, 1160)
		setElementInterior(source, 15)
		
		triggerClientEvent(source, "closeTyWindow", getRootElement())
		
		resetTyConvoStateDelayed()
	
	else
		exports.global:giveItem(source, itemID, 1)
		outputChatBox("You have bought a drug item from Ty for $"..cost..".", source)
	end
end
addEvent("tyGiveItem", true)
addEventHandler("tyGiveItem", getRootElement(), giveTyItems)


function tyClose_S()

	local pedX, pedY, pedZ = getElementPosition( tyrese )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I'm set.", player, 255, 255, 255)
		outputChatBox("Ty says: Peace, homie.", player, 255, 255, 255)
	end
	
	setElementPosition(source, 2242.52, -1170.7, 1028.79)
	setElementDimension(source, 1160)
	setElementInterior(source, 15)
	
	resetTyConvoStateDelayed()
end
addEvent("tyFriendClose", true)
addEventHandler("tyFriendClose", getRootElement(), tyClose_S)

------------------------ Reset -----------------------------
function resetTyConvoState()
	setElementData(tyrese,"activeConvo", 0)
end

function resetTyConvoStateDelayed()
	if talkingToTy then
		removeEventHandler("onPlayerQuit", talkingToTy, resetTyConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToTy, resetTyConvoStateDelayed)
		triggerClientEvent(talkingToTy, "closeTyWinodw", getRootElement())
		talkingToTy = nil
	end
	setTimer(resetTyConvoState, 120000, 1)
end
