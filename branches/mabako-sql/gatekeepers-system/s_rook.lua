rook = createPed (21, 1976.51, -1155.109, 20.9)
exports.pool:allocateElement(rook)

setPedRotation(rook, 180)
setPedFrozen(rook, true)
setElementData (rook, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
setElementData(rook, "name", "Rook")
setElementData(rook, "talk", true)
setElementData(rook, "rotation", getPedRotation(rook), false)

function rookIntro () -- When player enters the colSphere create GUI with intro output to all local players as local chat.	
	-- Give the player the "Find Hunter" achievement.
	if(getElementData( rook, "activeConvo" )==1)then
		outputChatBox("Rook doesn't want to talk to you.", source, 255, 0, 0)
	else
		local theTeam = getPlayerTeam(source)
		local factionType = getElementData(theTeam, "type")
		
		if not(factionType==0) then
			local pedX, pedY, pedZ = getElementPosition( rook )
			local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
			exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
			local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
			for i, player in ipairs( targetPlayers ) do
				outputChatBox("Rook says: Keep on walkin'. Grown men tryin' to talk around here.", player, 255, 255, 255)
			end
			destroyElement(chatSphere)	
		else
			local query = mysql_query(handler, "SELECT rook FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .."'")
			local rooksFriend = tonumber(mysql_result(query, 1, 1))
			mysql_free_result(query)
			if(rooksFriend==1)then -- If they are already a friend.
				local pedX, pedY, pedZ = getElementPosition( rook )
				local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
				exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
				local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
				for i, player in ipairs( targetPlayers ) do
					outputChatBox("Rook says: Whats good, my nigga?  You gettin' that paper now, right?", player, 255, 255, 255)
				end
				destroyElement(chatSphere)			
			else -- If they are not a frient.		
				triggerClientEvent( source, "rookIntroEvent", getRootElement()) -- Trigger Client side function to create GUI.
				local pedX, pedY, pedZ = getElementPosition( rook )
				local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
				exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
				local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
				for i, player in ipairs( targetPlayers ) do
					outputChatBox("Rook says: What up, Homie? You lookin' to make some real green?", player, 255, 255, 255)
				end
				destroyElement(chatSphere)
				setElementData (rook, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
				talkingToRook = source
				addEventHandler("onPlayerQuit", talkingToRook, resetRookConvoStateDelayed)
				addEventHandler("onPlayerWasted", talkingToRook, resetRookConvoStateDelayed)
			end
		end
	end
end
addEvent( "startRookConvo", true )
addEventHandler( "startRookConvo", getRootElement(), rookIntro )

-- Statement 2
function rookStatement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Hell yeah, I'm always lookin' for that paper.", player, 255, 255, 255)
		outputChatBox("Rook whispers: Economies all fucked up, right?  There's only one market that isn't goin' down like a high school cheerleader.", player, 255, 255, 255)
		outputChatBox("Rook whispers: I'm talkin' about that dope money.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "rookStatement2ServerEvent", true )
addEventHandler( "rookStatement2ServerEvent", getRootElement(), rookStatement2_S )

-- Statement 3
function rookStatement3_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	for i, player in ipairs( targetPlayers ) do
		outputChatBox("Rook says: Whatever, homie. I was just tryin' to help a brother out.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	resetRookConvoStateDelayed()
end
addEvent( "rookStatement3ServerEvent", true )
addEventHandler( "rookStatement3ServerEvent", getRootElement(), rookStatement3_S )

-- Statement 4
function rookStatement4_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " whispers: What do you know about it?", player, 255, 255, 255)
		outputChatBox("Rook whispers: I know a guy that's looking to reach out. He got connects but no soldiers to push his product.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "rookStatement4ServerEvent", true )
addEventHandler( "rookStatement4ServerEvent", getRootElement(), rookStatement4_S )

-- Statement 5
function rookStatement5_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " whispers: Where's he at?", player, 255, 255, 255)
		outputChatBox("Rook whispers: His names Tyrese and lives over in Kennedy Apartments on Panoptican Avenue, apartment 3. Tell him Rook sent you.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "rookStatement5ServerEvent", true )
addEventHandler( "rookStatement5ServerEvent", getRootElement(), rookStatement5_S )

-- Statement 6
function rookStatement6_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " whispers: And you're just telling me this because you're feelin' charitable.", player, 255, 255, 255)
		outputChatBox("Rook whispers: If a brother doesn't look out for his own who will? The white man?", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "rookStatement6ServerEvent", true )
addEventHandler( "rookStatement6ServerEvent", getRootElement(), rookStatement6_S )

-- Statement 7
function rookStatement7_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 5 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " whispers: I hear that.", player, 255, 255, 255)
		outputChatBox("Rook whispers: Peace, homie.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	local query = mysql_query(handler, "UPDATE characters SET rook='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
	mysql_free_result(query)
	resetRookConvoStateDelayed()
end
addEvent( "rookStatement7ServerEvent", true )
addEventHandler( "rookStatement7ServerEvent", getRootElement(), rookStatement7_S )

function resetRookConvoState()
	setElementData(rook,"activeConvo", 0)
end

function resetRookConvoStateDelayed()
	if talkingToRook then
		removeEventHandler("onPlayerQuit", talkingToRook, resetTyConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToRook, resetTyConvoStateDelayed)
		talkingToRook = nil
	end
	setTimer(resetRookConvoState, 120000, 1)
end
