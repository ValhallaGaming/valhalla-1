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
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

-- EVENTS
addEvent("onPlayerJoinFaction", false)

function loadAllFactions(res)
	-- work out how many minutes it is until the next hour
	local mins = getRealTime().minute
	local minutes = 60 - mins
	setTimer(payAllWages, 60000*minutes, 1)
	
	local result = mysql_query(handler, "SELECT id, name, bankbalance, type FROM factions")
	local counter = 0
	
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
			local name = row[2]
			local money = tonumber(row[3])
			local factionType = tonumber(row[4])
			
			local theTeam = createTeam(tostring(name))
			exports.pool:allocateElement(theTeam)
			setElementData(theTeam, "type", factionType)
			setElementData(theTeam, "money", money)
			setElementData(theTeam, "id", id, false)
			counter = counter + 1
		end
		mysql_free_result(result)
		
		local citteam = createTeam("Citizen", 255, 255, 255)
		exports.pool:allocateElement(citteam)
		
		-- set all players into their appropriate faction
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local username = getPlayerName(thePlayer)
			local safeusername = mysql_escape_string(handler, username)
			
			local result = mysql_query(handler, "SELECT faction_id FROM characters WHERE charactername='" .. safeusername .. "' LIMIT 1")
			if (result) then
				local factionID = tonumber(mysql_result(result, 1, 1))

				setElementData(thePlayer, "factionMenu", 0)
				setElementData(thePlayer, "faction", factionID, false)
				
				mysql_free_result(result)
				if (factionID) then
					if (factionID~=-1) then
						result = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. factionID .. "' LIMIT 1")

						if (result) then
							local factionName = tostring(mysql_result(result, 1, 1))
							local theTeam = getTeamFromName(factionName)
							setPlayerTeam(thePlayer, theTeam)
							mysql_free_result(result)
						end
					else
						local theTeam = getTeamFromName("Citizen")
						setPlayerTeam(thePlayer, theTeam)
					end
				end
			end
		end
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " factions.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllFactions)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F3", "down", showFactionMenu)) then
			bindKey(arrayPlayer, "F3", "down", showFactionMenu)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F3", "down", showFactionMenu)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showFactionMenu(source)
	local logged = getElementData(source, "loggedin")
	
	if (logged==1) then
		local menuVisible = getElementData(source, "factionMenu")
		
		if (menuVisible==0) then
			local factionID = getElementData(source, "faction")
			
			if (factionID~=-1) then
				local query = mysql_query(handler, "SELECT charactername, faction_rank, faction_leader, DATEDIFF(NOW(), lastlogin) FROM characters WHERE faction_ID='" .. factionID .. "'")
				local query2 = mysql_query(handler, "SELECT rank_1, rank_2, rank_3, rank_4, rank_5, rank_6, rank_7, rank_8, rank_9, rank_10, rank_11, rank_12, rank_13, rank_14, rank_15 FROM factions WHERE id='" .. factionID .. "' LIMIT 1")
				local query3 = mysql_query(handler, "SELECT wage_1, wage_2, wage_3, wage_4, wage_5, wage_6, wage_7, wage_8, wage_9, wage_10, wage_11, wage_12, wage_13, wage_14, wage_15, motd FROM factions WHERE id='" .. factionID .. "' LIMIT 1")
				
				if (query) and (query2) and (query3) then
					local rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10, rank11, rank12, rank13, rank14, rank15 = mysql_result(query2, 1, 1), mysql_result(query2, 1, 2), mysql_result(query2, 1, 3), mysql_result(query2, 1, 4), mysql_result(query2, 1, 5), mysql_result(query2, 1, 6), mysql_result(query2, 1, 7), mysql_result(query2, 1, 8), mysql_result(query2, 1, 9), mysql_result(query2, 1, 10), mysql_result(query2, 1, 11), mysql_result(query2, 1, 12), mysql_result(query2, 1, 13), mysql_result(query2, 1, 14), mysql_result(query2, 1, 15)
					local wage1, wage2, wage3, wage4, wage5, wage6, wage7, wage8, wage9, wage10, wage11, wage12, wage13, wage14, wage15 = mysql_result(query3, 1, 1), mysql_result(query3, 1, 2), mysql_result(query3, 1, 3), mysql_result(query3, 1, 4), mysql_result(query3, 1, 5), mysql_result(query3, 1, 6), mysql_result(query3, 1, 7), mysql_result(query3, 1, 8), mysql_result(query3, 1, 9), mysql_result(query3, 1, 10), mysql_result(query3, 1, 11), mysql_result(query3, 1, 12), mysql_result(query3, 1, 13), mysql_result(query3, 1, 14), mysql_result(query3, 1, 15)
					local motd = mysql_result(query3, 1, 16)
					
					local memberUsernames = {}
					local memberRanks = {}
					local memberLeaders = {}
					local memberOnline = {}
					local memberLastLogin = {}
					local memberLocation = {}
					local factionRanks = {rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10, rank11, rank12, rank13, rank14, rank15 }
					local factionWages = {wage1, wage2, wage3, wage4, wage5, wage6, wage7, wage8, wage9, wage10, wage11, wage12, wage13, wage14, wage15 }
					
					if (motd == "") then motd = nil end
					
					local i = 1
					for result, row in mysql_rows(query) do
						local playerName = row[1]
						memberUsernames[i] = playerName
						memberRanks[i] = row[2]
						
						if (tonumber(row[3])==1) then
							memberLeaders[i] = true
						else
							memberLeaders[i] = false
						end
						
						--local charyearday = tonumber(row[4])
						--local charyear = tonumber(row[5])
						local login = ""
						
						-- Compare the TIME
						--local time = getRealTime()
						--local year = 1900+time.year
						--local yearday = time.yearday
						memberLastLogin[i] = tonumber(row[4])
						
						
						local targetPlayer = getPlayerFromName(tostring(playerName))
						if (targetPlayer) then
							memberOnline[i] = true
							local zone, city = exports.global:getElementZoneName(targetPlayer)
							
							if(zone~=city) and (city~=nil) then
								memberLocation[i] = zone .. ", " .. city
							else
								memberLocation[i] = zone
							end
						else
							memberOnline[i] = false
							memberLocation[i] = "Not Available"
						end
						i = i + 1
					end
					setElementData(source, "factionMenu", 1)
					
					mysql_free_result(query)
					mysql_free_result(query2)
					mysql_free_result(query3)
					
					local theTeam = getPlayerTeam(source)
					triggerClientEvent(source, "showFactionMenu", getRootElement(), motd, memberUsernames, memberRanks, memberLeaders, memberOnline, memberLastLogin, memberLocation, factionRanks, factionWages, theTeam)
				end
			else
				outputChatBox("You are not in a faction.", source)
			end
		elseif (menuVisible==1) then
			triggerClientEvent(source, "hideFactionMenu", getRootElement())
		end
	end
end

-- // CALL BACKS FROM CLIENT GUI
function callbackUpdateRanks(ranks, wages)
	local theTeam = getPlayerTeam(source)
	local factionID = getElementData(theTeam, "id")
	
	for key, value in ipairs(ranks) do
		ranks[key] = mysql_escape_string(handler, ranks[key])
	end
	
	if (wages) then
		for key, value in ipairs(wages) do
			wages[key] = tonumber(wages[key]) or 0
		end
		
		local update = mysql_query(handler, "UPDATE factions SET wage_1='" .. wages[1] .. "', wage_2='" .. wages[2] .. "', wage_3='" .. wages[3] .. "', wage_4='" .. wages[4] .. "', wage_5='" .. wages[5] .. "', wage_6='" .. wages[6] .. "', wage_7='" .. wages[7] .. "', wage_8='" .. wages[8] .. "', wage_9='" .. wages[9] .. "', wage_10='" .. wages[10] .. "', wage_11='" .. wages[11] .. "', wage_12='" .. wages[12] .. "', wage_13='" .. wages[13] .. "', wage_14='" .. wages[14] .. "', wage_15='" .. wages[15] .. "' WHERE id='" .. factionID .. "'")
		mysql_free_result(update)
	end
	
	local query = mysql_query(handler, "UPDATE factions SET rank_1='" .. ranks[1] .. "', rank_2='" .. ranks[2] .. "', rank_3='" .. ranks[3] .. "', rank_4='" .. ranks[4] .. "', rank_5='" .. ranks[5] .. "', rank_6='" .. ranks[6] .. "', rank_7='" .. ranks[7] .. "', rank_8='" .. ranks[8] .. "', rank_9='" .. ranks[9] .. "', rank_10='" .. ranks[10] .. "', rank_11='" .. ranks[11] .. "', rank_12='" .. ranks[12] .. "', rank_13='" .. ranks[13] .. "', rank_14='" .. ranks[14] .. "', rank_15='" .. ranks[15] .. "' WHERE id='" .. factionID .. "'")
	mysql_free_result(query)
	
	outputChatBox("Faction information updated successfully.", source, 0, 255, 0)
	showFactionMenu(source)
end
addEvent("cguiUpdateRanks", true )
addEventHandler("cguiUpdateRanks", getRootElement(), callbackUpdateRanks)


function callbackRespawnVehicles()
	local theTeam = getPlayerTeam(source)
	
	local factionCooldown = getElementData(theTeam, "cooldown")
	
	if not (factionCooldown) then
		local factionID = getElementData(theTeam, "id")
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			local faction = getElementData(value, "faction")
			if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
				respawnVehicle(value)
			end
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		local username = getPlayerName(source)
		for k, v in ipairs(teamPlayers) do
			outputChatBox(username .. " respawned all unoccupied faction vehicles.", v)
		end
		
		outputChatBox("Unoccupied faction vehicles respawned successfully.", source, 0, 255, 0)
		setTimer(resetFactionCooldown, 900000, 1, theTeam)
		setElementData(theTeam, "cooldown", true, false)
	else
		outputChatBox("You currently cannot respawn your factions vehicles, Please wait a while.", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnVehicles", true )
addEventHandler("cguiRespawnVehicles", getRootElement(), callbackRespawnVehicles)

function resetFactionCooldown(theTeam)
	removeElementData(theTeam, "cooldown")
end

function callbackUpdateMOTD(motd)
	local faction = tonumber(getElementData(source, "faction"))
	
	if (faction~=-1) then
		local safemotd = mysql_escape_string(handler, motd)
		local query = mysql_query(handler, "UPDATE factions SET motd='" .. tostring(safemotd) .. "' WHERE id='" .. faction .. "'")

		if (query) then
			mysql_free_result(query)
			outputChatBox("You changed your faction's MOTD to '" .. motd .. "'", source, 0, 255, 0)
		else
			outputChatBox("Error 300000 - Ensure your MOTD does not include characters such as '@!,.", source, 255, 0, 0)
		end
	end
end
addEvent("cguiUpdateMOTD", true )
addEventHandler("cguiUpdateMOTD", getRootElement(), callbackUpdateMOTD)

function callbackRemovePlayer(removedPlayerName)
	local safename = mysql_escape_string(handler, removedPlayerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_id='-1', faction_leader='0', faction_rank='1' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local theTeam = getPlayerTeam(source)
		local theTeamName = "None"
		if (theTeam) then
			theTeamName = getTeamName(theTeam)
		end
		
		local username = getPlayerName(source)
		
		exports.irc:sendMessage("[SCRIPT] " .. username .. " removed " .. removedPlayerName .. " from faction '" .. tostring(theTeamName) .. "'.")
		
		local removedPlayer = getPlayerFromName(removedPlayerName)
		if (removedPlayer) then -- Player is online
			if (getElementData(source, "factionMenu")==1) then
				triggerClientEvent(removedPlayer, "hideFactionMenu", getRootElement())
			end
			outputChatBox(username .. " removed you from the faction '" .. tostring(theTeamName) .. "'", removedPlayer)
			setPlayerTeam(removedPlayer, nil)
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		for k, v in ipairs(teamPlayers) do
			if (v~=removedPlayer) then
				outputChatBox(username .. " kicked " .. removedPlayerName .. " from faction '" .. tostring(theTeamName) .. "'.", v)
			end
		end
	else
		outputChatBox("Failed to remove " .. removedPlayerName .. " from the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiKickPlayer", true )
addEventHandler("cguiKickPlayer", getRootElement(), callbackRemovePlayer)

function callbackToggleLeader(playerName, isLeader)
	
	if (isLeader) then -- Make player a leader
		local username = getPlayerName(source)
		local safename = mysql_escape_string(handler, playerName)
		
		local query = mysql_query(handler, "UPDATE characters SET faction_leader='1' WHERE charactername='" .. safename .. "'")
		
		if (query) then
			mysql_free_result(query)
			exports.irc:sendMessage("[SCRIPT] " .. username .. " promoted " .. tostring(playerName) .. " to leader.")
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				outputChatBox(username .. " promoted you to a leader of your faction.", thePlayer)
			end
			
			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(source)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=source) then
					outputChatBox(username .. " promoted " .. playerName .. " to leader.", v)
				end
			end
		else
			outputChatBox("Failed to promote " .. removedPlayerName .. " to faction leader, Contact an admin.", source, 255, 0, 0)
		end
	else
		local username = getPlayerName(source)
		local safename = mysql_escape_string(handler, playerName)
		
		local query = mysql_query(handler, "UPDATE characters SET faction_leader='0' WHERE charactername='" .. safename .. "'")
		
		if (query) then
			mysql_free_result(query)
			exports.irc:sendMessage("[SCRIPT] " .. username .. " demoted " .. tostring(playerName) .. " to member.")
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				if (getElementData(source, "factionMenu")==1) then
					triggerClientEvent(thePlayer, "hideFactionMenu", getRootElement())
				end
				outputChatBox(username .. " demoted you to a member of your faction.", thePlayer)
			end
			
			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(source)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=thePlayer) then
					outputChatBox(username .. " demoted " .. playerName .. " to member.", v)
				end
			end
		else
			outputChatBox("Failed to demote " .. removedPlayerName .. " from faction leader, Contact an admin.", source, 255, 0, 0)
		end
	end
end
addEvent("cguiToggleLeader", true )
addEventHandler("cguiToggleLeader", getRootElement(), callbackToggleLeader)

function callbackPromotePlayer(playerName, rankNum, oldRank, newRank)
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, playerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, tell them
			setElementData(thePlayer, "factionrank", rankNum)
			outputChatBox(username .. " promoted you from '" .. oldRank .. "' to '" .. newRank .. "'.", thePlayer)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(source)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=thePlayer) then
					outputChatBox(username .. " promoted " .. playerName .. " from '" .. oldRank .. "' to '" .. newRank .. "'.", v)
				end
			end
		end
	else
		outputChatBox("Failed to promote " .. removedPlayerName .. " in the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiPromotePlayer", true )
addEventHandler("cguiPromotePlayer", getRootElement(), callbackPromotePlayer)

function callbackDemotePlayer(playerName, rankNum, oldRank, newRank)
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, playerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, tell them
			setElementData(thePlayer, "factionrank", rankNum)
			outputChatBox(username .. " demoted you from '" .. oldRank .. "' to '" .. newRank .. "'.", thePlayer)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(source)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=thePlayer) then
					outputChatBox(username .. " demoted " .. playerName .. " from '" .. oldRank .. "' to '" .. newRank .. "'.", v)
				end
			end
		end
	else
		outputChatBox("Failed to demote " .. removedPlayerName .. " in the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiDemotePlayer", true )
addEventHandler("cguiDemotePlayer", getRootElement(), callbackDemotePlayer)

function callbackQuitFaction()
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, username)
	local theTeam = getPlayerTeam(source)
	local theTeamName = getTeamName(theTeam)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_id='-1', faction_leader='0' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		outputChatBox("You quit the faction '" .. theTeamName .. "'.", source)
		
		local newTeam = getTeamFromName("Citizen")
		setPlayerTeam(source, newTeam)
		setElementData(source, "faction", -1, false)

		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		for k, v in ipairs(teamPlayers) do
			if (v~=thePlayer) then
				outputChatBox(username .. " has quit the faction '" .. theTeamName .. "'.", v)
			end
		end
	else
		outputChatBox("Failed to quit the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiQuitFaction", true )
addEventHandler("cguiQuitFaction", getRootElement(), callbackQuitFaction)

function callbackInvitePlayer(invitedPlayer)
	local faction = tonumber(getElementData(source, "faction"))

	local invitedPlayerNick = getPlayerName(invitedPlayer)
	local safename = mysql_escape_string(handler, invitedPlayerNick)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_leader='0', faction_id='" .. faction .. "', faction_rank='1' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local theTeam = getPlayerTeam(source)
		local theTeamName = getTeamName(theTeam)
		
		local targetTeam = getPlayerTeam(invitedPlayer)
		if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
			outputChatBox("Player is already in a faction.", source, 255, 0, 0)
		else
			setPlayerTeam(invitedPlayer, theTeam)
			setElementData(invitedPlayer, "faction", faction)
			outputChatBox("Player " .. invitedPlayerNick .. " is now a member of faction '" .. tostring(theTeamName) .. "'.", source, 0, 255, 0)
							
			if	(invitedPlayer) then
				triggerEvent("onPlayerJoinFaction", invitedPlayer, theTeam)
				setElementData(invitedPlayer, "factionrank", 1)
				setElementData(invitedPlayer, "dutyskin", -1, false)
				outputChatBox("You were set to Faction '" .. tostring(theTeamName) .. ".", invitedPlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("Player is already in a faction.", source, 255, 0, 0)
	end
end
addEvent("cguiInvitePlayer", true )
addEventHandler("cguiInvitePlayer", getRootElement(), callbackInvitePlayer)

-- // ADMIN COMMANDS
function createFaction(thePlayer, commandName, factionType, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction Type 0=GANG, 1=MAFIA, 2=LAW, 3=GOV, 4=MED, 5=OTHER, 6=NEWS][Faction Name]", thePlayer, 255, 194, 14)
		else
			factionName = table.concat({...}, " ")
			factionType = tonumber(factionType)
			
			local theTeam = createTeam(tostring(factionName))
			exports.pool:allocateElement(theTeam)
			if	(theTeam) then
				local query = mysql_query(handler, "INSERT INTO factions SET name='" .. mysql_escape_string(handler, factionName) .. "', bankbalance='0', type='" .. mysql_escape_string(handler, factionType) .. "'")
				
				if (query) then
					local id = mysql_insert_id(handler)
					mysql_free_result(query)
					
					query = mysql_query(handler, "UPDATE factions SET rank_1='Dynamic Rank #1', rank_2='Dynamic Rank #2', rank_3='Dynamic Rank #3', rank_4='Dynamic Rank #4', rank_5='Dynamic Rank #5', rank_6='Dynamic Rank #6', rank_7='Dynamic Rank #7', rank_8='Dynamic Rank #8', rank_9='Dynamic Rank #9', rank_10='Dynamic Rank #10', rank_11='Dynamic Rank #11', rank_12='Dynamic Rank #12', rank_13='Dynamic Rank #13', rank_14='Dynamic Rank #14', rank_15='Dynamic Rank #15', motd='Welcome to the faction.' WHERE id='" .. id .. "'")
					mysql_free_result(query)
					outputChatBox("Faction " .. factionName .. " created with ID #" .. id .. ".", thePlayer, 0, 255, 0)
					setElementData(theTeam, "type", tonumber(factionType))
					setElementData(theTeam, "id", tonumber(id), false)
					setElementData(theTeam, "money", 0)
				else
					outputChatBox("Error creating faction.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Faction '" .. tostring(factionName) .. "' already exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makefaction", createFaction, false, false)

function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID) or not (...)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Faction Name]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID then
				theTeam = nil
				for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
					local id = getElementData(value, "id")
					
					if id== tonumber(factionID) then
						theTeam = value
					end
				end
				
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					local updated = mysql_query(handler, "UPDATE factions SET name='" .. mysql_escape_string(handler, factionName) .. "' WHERE id='" .. factionID .. "'")
					
					setTeamName(theTeam, factionName)
					
					mysql_free_result(updated)
					outputChatBox("Faction #" .. factionID .. " was renamed to " .. factionName .. ".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (partialNick) or not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(partialNick)
			
			if not (targetPlayer) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local targetPlayerNick = getPlayerName(targetPlayer)
				local query = mysql_query(handler, "UPDATE characters SET faction_leader='0', faction_id='" .. factionID .. "', faction_rank='1' WHERE charactername='" .. mysql_escape_string(handler, targetPlayerNick) .. "'")
				
				factionID = tonumber(factionID)
				if (query) then
					mysql_free_result(query)
				end
				if (query) and (factionID>0) then
					
					local safeid = mysql_escape_string(handler, factionID)
					
					query = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. tonumber(safeid) .. "' LIMIT 1")
					
					if (query) then
						local factionName = mysql_result(query, 1, 1)
						mysql_free_result(query)
						local theTeam = getTeamFromName(tostring(factionName))
						setPlayerTeam(targetPlayer, theTeam)
						setElementData(targetPlayer, "faction", tonumber(factionID), false)
						setElementData(targetPlayer, "factionrank", 1)
						setElementData(targetPlayer, "dutyskin", -1, false)
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a member of faction '" .. tostring(factionName) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						if	(targetPlayer) then
							triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
							outputChatBox("You were set to Faction '" .. tostring(factionName) .. ".", targetPlayer, 255, 194, 14)
						end
					else
						outputChatBox("Invalid Faction ID, Ensure you entered a number!", thePlayer, 255, 0, 0)
					end
				elseif (query) and (factionID==-1) then
					local theTeam = getTeamFromName("Citizen")
					setPlayerTeam(targetPlayer, theTeam)
					setElementData(targetPlayer, "faction", -1, false)
					
					outputChatBox("Player " .. targetPlayerNick .. " was set to no faction.", thePlayer, 0, 255, 0)
					outputChatBox("You were removed from your faction.", targetPlayer, 255, 0, 0)
				else
					outputChatBox("Invalid Faction ID, Ensure you entered a number!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (partialNick) or not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(partialNick)
			
			if not (targetPlayer) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local targetPlayerNick = getPlayerName(targetPlayer)
				local query = mysql_query(handler, "UPDATE characters SET faction_leader='1', faction_id='" .. tonumber(factionID) .. "', faction_rank='1' WHERE charactername='" .. mysql_escape_string(handler, targetPlayerNick) .. "'")
				
				if (query) then
					mysql_free_result(query)
					query = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. tonumber(factionID) .. "' LIMIT 1")
					
					if (query) then
						local factionName = mysql_result(query, 1, 1)
						mysql_free_result(query)
						local theTeam = getTeamFromName(tostring(factionName))
						setPlayerTeam(targetPlayer, theTeam)
						setElementData(targetPlayer, "faction", tonumber(factionID), false)
						setElementData(targetPlayer, "dutyskin", -1, false)
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a leader of faction '" .. tostring(factionName) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						if	(targetPlayer) then
							triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
							setElementData(targetPlayer, "factionrank", 1)
							outputChatBox("You were set to the leader of Faction '" .. tostring(factionName) .. ".", targetPlayer, 255, 194, 14)
						end
					else
						outputChatBox("Invalid Faction ID, Ensure you entered a number!", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID then
				theTeam = nil
				for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
					local id = getElementData(value, "id")
					
					if id == factionID then
						theTeam = value
					end
				end
				
				if (theTeam) then
					local deleted = mysql_query(handler, "DELETE FROM factions WHERE id='" .. factionID .. "'")
					
					mysql_free_result(deleted)
					outputChatBox("Faction #" .. factionID .. " was deleted.", thePlayer, 0, 255, 0)
					
					local civTeam = getTeamFromName("Citizen")
					for key, value in pairs( getPlayersInTeam( theTeam ) ) do
						setPlayerTeam( value, civTeam )
						setElementData( value, "faction", -1 )
					end
					destroyElement( theTeam )
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local result = mysql_query(handler, "SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) FROM factions f")
		
		
		
		if (result) then
			local factions = { }
			local key = 1
			
			for result, row in mysql_rows(result) do
				factions[key] = { }
				factions[key][1] = row[1]
				factions[key][2] = row[2]
				factions[key][3] = row[3]
				
				local team = getTeamFromName(row[2])
				if team then
					factions[key][4] = #getPlayersInTeam(team) .. " / " .. row[4]
				else
					factions[key][4] = "?? / " .. row[4]
				end
				key = key + 1
			end
			
			mysql_free_result(result)
			triggerClientEvent(thePlayer, "showFactionList", getRootElement(), factions)
		else
			outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID then
				theTeam = nil
				amount = tonumber(amount)
				for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
					local id = getElementData(value, "id")
					
					if id == factionID then
						theTeam = value
					end
				end
				
				if (theTeam) then
					exports.global:setMoney(theTeam, amount)
					outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)

-- /////////////// WAGES
function payWage(player, pay, faction, tax)
	local bankmoney = getElementData(player, "bankmoney")
	local interestrate = 0.004
	
	-- DONATOR PERKS
	local donator = getElementData(player, "donatorlevel")
	local donatormoney = 0 
	if (donator==1) then
		donatormoney = donatormoney + 25
		interestrate = interestrate + 0.001
	elseif (donator==2) then
		donatormoney = donatormoney + 25
		interestrate = interestrate + 0.002
	elseif (donator==3) then
		donatormoney = donatormoney + 75
		interestrate = interestrate + 0.004
	elseif (donator==4) then
		donatormoney = donatormoney + 100
		interestrate = interestrate + 0.004
	elseif (donator==5) then
		donatormoney = donatormoney + 125
		interestrate = interestrate + 0.005
	elseif (donator==6) then
		donatormoney = donatormoney + 150
		interestrate = interestrate + 0.006
	elseif (donator==7) then
		donatormoney = donatormoney + 250
		interestrate = interestrate + 0.006
	end
	
	local interest = math.ceil(interestrate * bankmoney)
	
	-- business money
	local profit = getElementData(player, "businessprofit")
	setElementData(player, "businessprofit", 0, false)
	setElementData(player, "bankmoney", bankmoney+pay+interest+profit+donatormoney)
	
	-- rentable houses
	local rent = 0
	local result = mysql_query( handler, "SELECT SUM(cost) FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" )
	if result then
		rent = tonumber(mysql_result(result, 1, 1)) or 0
		mysql_free_result(result)
		
		if rent > 0 then
			local bankmoney = getElementData(player, "bankmoney")
			if rent > bankmoney then
				-- sell houses
				rent = -1
				
				local result = mysql_query( handler, "SELECT id FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" )
				id = tonumber(mysql_result(result, 1, 1))
				mysql_free_result(result)
				
				call( getResourceFromName( "interior-system" ), "publicSellProperty", player, id, false, true )
			else
				setElementData(player, "bankmoney", bankmoney - rent)
			end
		end
	end

	
	outputChatBox("~-~-~-~-~-~-~-~~-~-~-~-~ PAY SLIP ~-~-~-~-~-~-~-~~-~-~-~-~", player, 255, 194, 14)

	if not faction then
		if pay >= 0 then
			outputChatBox("    State Benefits: " .. pay .. "$", player, 255, 194, 14)
			
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. getElementData(player, "dbid") .. ", " .. pay .. ", '', 6)" ) )
		else
			outputChatBox("    The government could not afford to pay you your state benefits.", player, 255, 0, 0)
			pay = 0
		end
	else
		if pay >= 0 then
			outputChatBox("    Wage Paid: " .. pay .. "$", player, 255, 194, 14)			

			local teamid = getElementData(player, "faction")
			if teamid <= 0 then
				teamid = 0
			else
				teamid = -teamid
			end

			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. teamid .. ", " .. getElementData(player, "dbid") .. ", " .. pay-tax .. ", '', 6)" ) )
		else
			outputChatBox("    Your employer could not afford to pay your wages.", player, 255, 0, 0)
			pay = 0
		end
	end
	
	if profit > 0 then
		outputChatBox("    Business Profit: " .. profit .. "$", player, 255, 194, 14)
	end
	
	if tax > 0 then
		local incomeTax = exports.global:getIncomeTaxAmount()
		outputChatBox("    Income Tax of " .. (incomeTax*100) .. "%: " .. tax .. "$", player, 255, 194, 14)
		pay = pay - tax
	end
	
	outputChatBox("    Bank Interest (" .. interestrate*100 .. "%): " .. interest .. "$", player, 255, 194, 14)
	if (donator>0) then
		outputChatBox("    Donator Money: " .. donatormoney .. "$", player, 255, 194, 14)
	end
	
	if rent > 0 then
		outputChatBox("    Appartment Rent: " .. rent .. "$", player, 255, 194, 14)
	elseif rent == -1 then
		outputChatBox("    You were evicted from your appartment, as you can't pay the rent any longer.", player, 255, 0, 0)
		rent = 0
	end

	outputChatBox("----------------------------------------------------------", player, 255, 194, 14)
	outputChatBox("  Gross Income: " .. pay+profit+interest+donatormoney-rent .. "$ (Wire-Transferred to bank)", player, 255, 194, 14)
	
	-- Insert in Transactions
	mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. getElementData(player, "dbid") .. ", " .. profit+interest+donatormoney-rent .. ", '', 7)" ) )
end

function payAllWages()
	setTimer(payAllWages, 3600000, 1)
	
	local players = exports.pool:getPoolElementsByType("player")
	
	local gresult = mysql_query(handler, "SELECT bankbalance FROM factions WHERE id='3'")
	local govAmount = tonumber(mysql_result(gresult, 1, 1))
	mysql_free_result(gresult)
	
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		local timeinserver = getElementData(value, "timeinserver")
		
		if (logged==1) and (timeinserver>=60) then
			local playerFaction = getElementData(value, "faction")
			if (playerFaction~=-1) then -- In a faction
				local theTeam = getPlayerTeam(value)
				local factionType = getElementData(theTeam, "type")
				
				if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then -- Factions with wages
					local username = getPlayerName(value)
					
					local factionRankresult = mysql_query(handler, "SELECT faction_rank FROM characters WHERE charactername='" .. mysql_escape_string(handler, username) .. "' LIMIT 1")
					local factionRank = mysql_result(factionRankresult, 1, 1)
					mysql_free_result(factionRankresult)
					
					local rankWageresult = mysql_query(handler, "SELECT wage_" .. factionRank .. " FROM factions WHERE id='" .. playerFaction .. "'")
					local rankWage = tonumber(mysql_result(rankWageresult, 1, 1))
					mysql_free_result(rankWageresult)
					
					local taxes = 0
					if not exports.global:takeMoney(theTeam, rankWage) then
						rankWage = -1
					else
						local incomeTax = exports.global:getIncomeTaxAmount()
						taxes = math.ceil( incomeTax * rankWage )
					end
					
					govAmount = govAmount + taxes
					
					payWage( value, rankWage, true, taxes )
				else
					local unemployedPay = 150
					if unemployedPay >= govAmount then
						unemployedPay = -1
					end
					
					payWage( value, unemployedPay, false, 0 )
					govAmount = govAmount - unemployedPay
				end
			else
				local unemployedPay = 150
				if unemployedPay >= govAmount then
					unemployedPay = -1
				end
				
				payWage( value, unemployedPay, false, 0 )
				govAmount = govAmount - unemployedPay
			end
			
			setElementData(value, "timeinserver", timeinserver-60)
			
			triggerClientEvent(value, "cPayDay", value)
			local hoursplayed = getElementData(value, "hoursplayed") or 0
			setElementData(value, "hoursplayed", hoursplayed+1, false)
		elseif (logged==1) and (timeinserver) and (timeinserver<60) then
			outputChatBox("You have not played long enough to recieve a payday. (You require another " .. 60-timeinserver .. " Minutes of play.)", value, 255, 0, 0)
		end
	end
	
	-- Store the government money
	local update = mysql_query(handler, "UPDATE factions SET bankbalance='" .. govAmount .. "' WHERE id='3'")
	mysql_free_result(update)
	exports.irc:sendMessage("[SCRIPT] All wages & state benefits paid.")
end


function adminDoPayday(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:isPlayerLeadAdmin(thePlayer)) then
			payAllWages()
		end
	end
end
addCommandHandler("dopayday", adminDoPayday)

function timeSaved(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local timeinserver = getElementData(thePlayer, "timeinserver")
		
		if (timeinserver>60) then
			timeinserver = 60
		end
		
		outputChatBox("You currently have " .. timeinserver .. " Minutes played.", thePlayer, 255, 195, 14)
		outputChatBox("You require another " .. 60-timeinserver .. " Minutes to obtain a payday.", thePlayer, 255, 195, 14)
	end
end
addCommandHandler("timesaved", timeSaved)


function addToFactionMoney(factionID, amount)
	factionID = tonumber(factionID)
	if factionID then
		theTeam = nil
		for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
			local id = getElementData(value, "id")
		
			if id == factionID then
				theTeam = value
			end
		end
		
		if (theTeam) then
			return exports.global:giveMoney(theTeam, amount)
		end
	end
	return false
end