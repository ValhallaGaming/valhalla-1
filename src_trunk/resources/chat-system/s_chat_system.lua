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

-- /ad
function advertMessage(thePlayer, commandName, showNumber, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (...) or not (showNumber) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Show Phone Number 0/1] [Message]", thePlayer, 255, 194, 14)
		else
			if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then
				message = table.concat({...}, " ")
				
				local cost = math.ceil(string.len(message)/6)
				local money = getElementData(thePlayer, "money")
				
				if (cost>money) then
					outputChatBox("You cannot afford to place such an advert, try making it smaller.", thePlayer)
				else
					local name = string.gsub(getPlayerName(thePlayer), "_", " ")
					local phoneNumber = getElementData(thePlayer, "cellnumber")
					outputChatBox("   ADVERT: " .. message .. ". ((" .. name .. "))", getRootElement(), 0, 255, 64)
					
					if (tonumber(showNumber)==1) then
						outputChatBox("   Contact: #" .. phoneNumber .. ".", getRootElement(), 0, 255, 64)
					end
					
					exports.global:takePlayerSafeMoney(thePlayer, cost)
					outputChatBox("Thank you for placing your advert. Total Cost: $" .. cost .. ".", thePlayer)
				end
			else
				outputChatBox("You do not have a cellphone to call the advertisement agency.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("ad", advertMessage, false, false)
					
-- Main chat: Local IC, Me Actions & Faction IC Radio
function chatMain(message, messageType)
	local logged = getElementData(source, "loggedin")
	
	if not (isPedDead(source)) and (logged==1) and not (messageType==2) then -- Player cannot chat while dead or not logged in, unless its OOC
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		
		-- Local IC
		if (messageType==0) then
			local x, y, z = getElementPosition(source)
			local chatSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			local playerName = string.gsub(getPlayerName(source), "_", " ")
			
			destroyElement(chatSphere)
			message = string.gsub(message, "#%x%x%x%x%x%x", "") -- Remove colour codes
			
			-- Show chat to console, for admins + log
			exports.irc:sendMessage("[IC: Local Chat] " .. playerName .. ": " .. message)
			
			for index, nearbyPlayer in ipairs(nearbyPlayers) do
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

				if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
					local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
					if not (isPedDead(nearbyPlayer)) and (logged==1) then
						chatSphere = createColSphere(x, y, z, 20*0.2)
						exports.pool:allocateElement(chatSphere)
			        if isElementWithinColShape(nearbyPlayer, chatSphere) then
			            outputChatBox( "#EEEEEE" .. playerName .. " Says: " .. message, nearbyPlayer, 255, 255, 255, true)
						destroyElement(chatSphere)
						chatSphere = createColSphere(x, y, z, 20*0.4)
						exports.pool:allocateElement(chatSphere)
			        elseif isElementWithinColShape(nearbyPlayer, chatSphere) then
			            outputChatBox( "#DDDDDD" .. playerName .. " Says: " .. message, nearbyPlayer, 255, 255, 255, true)
						destroyElement(chatSphere)
						chatSphere = createColSphere(x, y, z, 20*0.6)
						exports.pool:allocateElement(chatSphere)
			        elseif isElementWithinColShape(nearbyPlayer, chatSphere) then          
						outputChatBox( "#CCCCCC" .. playerName .. " Says: " .. message, nearbyPlayer, 255, 255, 255, true)
						destroyElement(chatSphere)
						chatSphere = createColSphere(x, y, z, 20*0.8)
						exports.pool:allocateElement(chatSphere)
			        elseif isElementWithinColShape(nearbyPlayer, chatSphere) then
			            outputChatBox( "#BBBBBB" .. playerName .. " Says: " .. message, nearbyPlayer, 255, 255, 255, true)
					else
						outputChatBox( "#AAAAAA" .. playerName .. " Says: " .. message, nearbyPlayer, 255, 255, 255, true)
					end
					
					if (chatSphere) then
						destroyElement(chatSphere)
					end
				end
			end
			end
		elseif (messageType==1) then -- Local /me action
		
			if not (message) then
				outputChatBox("SYNTAX: /me [Action]", source, 255, 194, 14)
			else
				local x, y, z = getElementPosition(source)
				local chatSphere = createColSphere(x, y, z, 20)
				exports.pool:allocateElement(chatSphere)
				local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
				local playerName = string.gsub(getPlayerName(source), "_", " ")
				
				destroyElement(chatSphere)
				
				exports.irc:sendMessage("[IC OOC: ME ACTION] *" .. playerName .. " " .. message)
				
				for index, nearbyPlayer in ipairs(nearbyPlayers) do
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				
					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if not(isPedDead(nearbyPlayer)) and (logged==1) then
							outputChatBox(" *" .. playerName .. " " .. message, nearbyPlayer, 255, 51, 102)
						end
					end
				end
			end
		end
	elseif (messageType==2) and (logged==1) then -- Radio
		if (exports.global:doesPlayerHaveItem(source, 6)) then
			local username = string.gsub(getPlayerName(source), "_", " ")
			local theChannel = getElementData(source, "radiochannel")
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local targetChannel = getElementData(value, "radiochannel")
				local logged = getElementData(source, "loggedin")
				
				if (logged==1) and (targetChannel) and (exports.global:doesPlayerHaveItem(value, 6)) then
					if (targetChannel==theChannel) then
						playSoundFrontEnd(value, 47)
						
						-- get faction rank title
						local result = mysql_query(handler, "SELECT faction_id, faction_rank FROM characters WHERE charactername='" .. getPlayerName(source) .. "' LIMIT 1")
								
						local factionID = tonumber(mysql_result(result, 1, 1))
						local factionRank = tonumber(mysql_result(result, 1, 2))
								
						mysql_free_result(result)
								
						local titleresult = mysql_query(handler, "SELECT rank_" .. factionRank .. " FROM factions WHERE id='" .. factionID .. "' LIMIT 1")
						local factionRankTitle = tostring(mysql_result(titleresult, 1, 1))
						mysql_free_result(titleresult)
						
						outputChatBox("[RADIO #" .. theChannel .. "] " .. factionRankTitle .. " - " .. username .. " says: " .. message, value, 0, 102, 255)
						
						-- Show it to people near who can hear his radio
						local x, y, z = getElementPosition(value)
						local chatSphere = createColSphere(x, y, z, 10)
						exports.pool:allocateElement(chatSphere)
						local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
						
						destroyElement(chatSphere)
						
						for k, v in ipairs(nearbyPlayers) do
							if (v~=source) then
								outputChatBox(getPlayerName(value) .. "'s Radio: " .. message, v, 255, 255, 255)
							end
						end
						setTimer(playSoundFrontEnd, 700, 1, value, 48)
						setTimer(playSoundFrontEnd, 800, 1, value, 48)
					end
				end
			end
			
			-- Show the radio to nearby listening in people near the speaker
			local x, y, z = getElementPosition(source)
			local chatSphere = createColSphere(x, y, z, 10)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			destroyElement(chatSphere)
			
			for key, value in ipairs(nearbyPlayers) do
				if (value~=source) then
					outputChatBox(getPlayerName(source) .. " [RADIO] Says: " .. message, value, 255, 255, 255)
				end
			end
		else
			outputChatBox("You do not have a radio.", source, 255, 0, 0)
		end
	end
end

addEventHandler("onPlayerChat", getRootElement(), chatMain)

function blockChatMessage()
    cancelEvent()
end

addEventHandler("onPlayerChat", getRootElement(), blockChatMessage)
-- End of Main Chat

function globalOOC(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	
	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local oocEnabled = exports.global:getOOCState()
			message = table.concat({...}, " ")
			local muted = getElementData(thePlayer, "muted")
			if (oocEnabled==0) and not (exports.global:isPlayerAdmin(thePlayer)) then
				outputChatBox("OOC Chat is currently disabled.", thePlayer, 255, 0, 0)
			elseif (muted==1) then
				outputChatBox("You are currenty muted from the OOC Chat.", thePlayer, 255, 0, 0)
			else	
				local players = exports.pool:getPoolElementsByType("player")
				local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
					
				exports.irc:sendMessage("[OOC: Global Chat] " .. playerName .. ": " .. message)
				for k, arrayPlayer in ipairs(players) do
					local logged = tonumber(getElementData(arrayPlayer, "loggedin"))
					local targetOOCEnabled = getElementData(arrayPlayer, "globalooc")

					if (logged==1) and (targetOOCEnabled==1) then
						outputChatBox("(( " .. playerName .. ": " .. message .. " ))", arrayPlayer, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("o", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)

function playerToggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local playerOOCEnabled = getElementData(thePlayer, "globalooc")
		
		if (playerOOCEnabled==1) then
			outputChatBox("You have now hidden Global OOC Chat.", thePlayer, 255, 194, 14)
			setElementData(thePlayer, "globalooc", 0)
		else
			outputChatBox("You have now enabled Global OOC Chat.", thePlayer, 255, 194, 14)
			setElementData(thePlayer, "globalooc", 1)
		end
	end
end
addCommandHandler("toggleooc", playerToggleOOC, false, false)


local advertisementMessages = { "sincityrp", "ls-rp", "sincity", "eg", "tri0n3", "www.", ".com", ".net", ".co.uk", ".org", "Bryan", "Danny", "everlast", "neverlast", "www.everlastgaming.com"}

function pmPlayer(thePlayer, commandName, who, ...)

		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick] [Message]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer = exports.global:findPlayerByPartialNick(who)
			
			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==1) then
					local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
					local targetPlayerName = string.gsub(getPlayerName(targetPlayer), "_", " ")
				
					-- Check for advertisements
					local foundAdvert = 0
					for k,v in ipairs(advertisementMessages) do
						local found = string.find(string.lower(message), "%s" .. tostring(v))
						local found2 = string.find(string.lower(message), tostring(v) .. "%s")
						if (found) or (found2) or (string.lower(message)==tostring(v)) and (foundAdvert==0) then
							exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(playerName) .. " sent a possible advertisement PM to " .. tostring(targetPlayerName) .. ".")
							exports.global:sendMessageToAdmins("AdmWrn: Message: " .. tostring(message))
							foundAdvert = 1
						end
					end
					
					-- Send the message
					outputChatBox("PM From " .. playerName .. ": " .. message, targetPlayer, 255, 255, 0)
					outputChatBox("PM Sent to " .. targetPlayerName .. ": " .. message, thePlayer, 255, 255, 0)
				elseif (logged==0) then
					outputChatBox("Player is not logged in yet.", thePlayer, 255, 255, 0)
				elseif (pmBlocked==1) then
					outputChatBox("Player is ignoring whispers!", thePlayer, 255, 255, 0)
				end
			else
				outputChatBox("Player not found.", thePlayer, 255, 255, 0)
			end
		end
end
addCommandHandler("pm", pmPlayer, false, false)

function localOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if (logged==1) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			local chatSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
			local message = table.concat({...}, " ")
			
			destroyElement(chatSphere)
			
			exports.irc:sendMessage("[OOC: Local Chat] " .. playerName .. ": " .. message)
			for index, nearbyPlayer in ipairs(nearbyPlayers) do
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				
				if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
					local logged = getElementData(nearbyPlayer, "loggedin")
					if not (isPedDead(nearbyPlayer)) and (logged==1) then
						outputChatBox(playerName .. ": (( " .. message .. " ))", nearbyPlayer, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)

function districtOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if (logged==1) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
			local message = table.concat({...}, " ")
			local zonename = getElementZoneName(thePlayer)
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local playerzone = getElementZoneName(value)
				local playerdimension = getElementDimension(value)
				local playerinterior = getElementInterior(value)
				
				if (zonename==playerzone) and (dimension==playerdimension) and (interior==playerinterior) then
					local logged = getElementData(value, "loggedin")
					if (logged==1) then
						outputChatBox("(( District OOC - " .. playerzone .. " - " .. playerName .. ":  " .. message .. " ))", value, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("d", districtOOC, false, false)
addCommandHandler("district", districtOOC, false, false)

function localDo(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Action/Event]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			local chatSphere = createColSphere(x, y, z, 40)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
			local message = table.concat({...}, " ")
			
			destroyElement(chatSphere)
			
			exports.irc:sendMessage("[IC: Local Do] * " .. message .. " *      ((" .. playerName .. "))")
			for index, nearbyPlayer in ipairs(nearbyPlayers) do
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				
				if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
					local logged = getElementData(nearbyPlayer, "loggedin")
				
					if (logged==1) and not (isPedDead(nearbyPlayer)) then
						outputChatBox(" * " .. message .. " *      ((" .. playerName .. "))", nearbyPlayer, 255, 128, 147)
					end
				end
			end
		end
	end
end
addCommandHandler("do", localDo, false, false)


function localShout(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			local chatSphere = createColSphere(x, y, z, 40)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
			local message = table.concat({...}, " ")
			
			destroyElement(chatSphere)
			
			exports.irc:sendMessage("[IC: Local Shout] " .. playerName .. ": " .. message)
			for index, nearbyPlayer in ipairs(nearbyPlayers) do
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				
				if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
					local logged = getElementData(nearbyPlayer, "loggedin")
				
					if (logged==1) and not (isPedDead(nearbyPlayer)) then
						outputChatBox(playerName .. " shouts: " .. message .. "!!", nearbyPlayer, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("s", localShout, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local factiontype = getElementData(faction, "type")
		
		if (factiontype==2) or (factiontype==3) or (factiontype==4) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			else
				local x, y, z = getElementPosition(thePlayer)
				local chatSphere = createColSphere(x, y, z, 40)
				exports.pool:allocateElement(chatSphere)
				local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
				local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
				local message = table.concat({...}, " ")
				
				destroyElement(chatSphere)
				
				exports.irc:sendMessage("[IC: Megaphone] " .. playerName .. ": " .. message)
				for index, nearbyPlayer in ipairs(nearbyPlayers) do
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					
					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
						local logged = getElementData(nearbyPlayer, "loggedin")
					
						if (logged==1) and not (isPedDead(nearbyPlayer)) then
							outputChatBox("((" .. playerName .. ")) Megaphone <O: " .. message, nearbyPlayer, 255, 255, 0)
						end
					end
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to shout through a megaphone you do not have.", thePlayer, 255, 0 , 0)
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)
	
function factionOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
			
			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("You are not in a faction.", thePlayer)
			else
				local message = table.concat({...}, " ")
				local factionPlayers = getPlayersInTeam(theTeam)
				
				exports.irc:sendMessage("[OOC: Faction Chat] " .. playerName .. ": " .. message)
				for index, arrayPlayer in ipairs(factionPlayers) do
					local logged = getElementData(thePlayer, "loggedin")
					
					if (logged==1) then
						outputChatBox("((OOC Faction Chat)) " .. playerName .. ": " .. message, arrayPlayer, 3, 237, 237)
					end
				end
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)

function setRadioChannel(thePlayer, commandName, channel)
	if not (channel) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Channel Number 0->65535]", thePlayer, 255, 194, 14)
	else
		if (exports.global:doesPlayerHaveItem(thePlayer, 6)) then
			local channel = tonumber(channel)
			setElementData(thePlayer, "radiochannel", tonumber(channel))
			outputChatBox("You retuned your radio to channel #" .. channel .. ".", thePlayer)
			exports.global:sendLocalMeAction(thePlayer, "retunes their radio.")
		end
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)

-- Admin chat
function adminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer))  then
		if not (...) then
			outputChatBox("SYNTAX: /a [Message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = string.gsub(getPlayerName(thePlayer), "_", " ")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if(exports.global:isPlayerAdmin(arrayPlayer)) and (logged==1) then
					outputChatBox(adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 51, 255, 102)
				end
			end
		end
	end
end

addCommandHandler("a", adminChat, false, false)

-- Admin announcement
function adminAnnouncement(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer))  then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = string.gsub(getPlayerName(thePlayer), "_", " ")

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if (logged) then
					outputChatBox("   *** " .. message .. " ***", arrayPlayer, 255, 194, 14)
				end
			end
			exports.irc:sendMessage("[OOC ANNOUNCEMENT] " .. username .. ": " .. message)
		end
	end
end
addCommandHandler("ann", adminAnnouncement, false, false)

function leadAdminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = string.gsub(getPlayerName(thePlayer), "_", " ")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if (exports.global:isPlayerLeadAdmin(arrayPlayer)) and (logged==1) then
					outputChatBox("*4+* " ..adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 204, 102, 255)
				end
			end
		end
	end
end

addCommandHandler("l", leadAdminChat, false, false)

function headAdminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = string.gsub(getPlayerName(thePlayer), "_", " ")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if(exports.global:isPlayerHeadAdmin(arrayPlayer)) and (logged==1) then
					outputChatBox("*5+* " ..adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 255, 204, 51)
				end
			end
		end
	end
end

addCommandHandler("h", headAdminChat, false, false)

-- Misc
function showAdmins(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) then
		local players = exports.pool:getPoolElementsByType("player")
		local counter = 0
		
		outputChatBox("ADMINS:", thePlayer)
		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")
			
			if(exports.global:isPlayerAdmin(arrayPlayer)) and (hiddenAdmin==0) and (logged==1) then
				local username = string.gsub(getPlayerName(arrayPlayer), "_", " ")
				local adminTitle = exports.global:getPlayerAdminTitle(arrayPlayer)
				outputChatBox("    " .. tostring(adminTitle) .. " " .. username, thePlayer)
				counter = counter + 1
			end
		end
		
		if (counter==0) then
			outputChatBox("     Currently no admins online.", thePlayer)
		end
	end
end
addCommandHandler("admins", showAdmins, false, false)

function toggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer)) then
		local players = exports.pool:getPoolElementsByType("player")
		local oocEnabled = exports.global:getOOCState()
		
		if (oocEnabled==0) then
			exports.global:setOOCState(1)
			exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " enabled OOC Chat.")
			
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if	(logged==1) then
					outputChatBox("OOC Chat Enabled by Admin.", arrayPlayer, 0, 255, 0)
				end
			end
		elseif (oocEnabled==1) then
			exports.global:setOOCState(0)
			exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " disabled OOC Chat.")
			
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if	(logged==1) then
					outputChatBox("OOC Chat Disabled by Admin.", arrayPlayer, 255, 0, 0)
				end
			end
		end
	end
end

addCommandHandler("togooc", toggleOOC, false, false)
		
function togglePM(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and ((exports.global:isPlayerAdmin(thePlayer)) or (exports.global:isPlayerBronzeDonator(thePlayer)))then
		local pmenabled = getElementData(thePlayer, "pmblocked")
		
		if (pmenabled==0) then
			setElementData(thePlayer, "pmblocked", 1)
			outputChatBox("PM's are now enabled.", thePlayer, 0, 255, 0)
		else
			setElementData(thePlayer, "pmblocked", 0)
			outputChatBox("PM's are now disabled.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togpm", togglePM)

-- 911
function call911(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Description of Situation]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local theTeam = getTeamFromName("Las Venturas Metropolitan Police Department")
			local theTeamES = getTeamFromName("Las Venturas Emergency Services")
			local teamMembers = getPlayersInTeam(theTeam)
			local teamMembersES = getPlayersInTeam(theTeamES)
			
			for key, value in ipairs(teamMembers) do
				outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
				outputChatBox("[RADIO] '" .. message .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
			end
			
			for key, value in ipairs(teamMembersES) do
				outputChatBox("[RADIO] This is dispatch, We've got a 911 call, Over.", value, 0, 183, 239)
				outputChatBox("[RADIO] '" .. message .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
			end
			
			outputChatBox("Thank you for calling the Las Venturas Emergency Dispatch Board. A unit has been dispatched to your location.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("911", call911, false, false)


-- Taxi Call
function calltaxi(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	local abusedT = getElementData(thePlayer, "TaxiAbuse")	
		if (abusedT==1) then
			outputChatBox("((Taxi Dispatch)) [Cellphone]: We're booked at the moment, call us back in a minute.", thePlayer, 235, 221, 178)		
			setTimer(TaxiAbuseReset, 20000, 1, thePlayer)
		else
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			else

				local message = table.concat({...}, " ")
				local theTeam = getTeamFromName("Las Venturas Transport")
				local teamMembers = getPlayersInTeam(theTeam)
				local playerNumber = getElementData(thePlayer, "cellnumber")
				
				for key, value in ipairs(teamMembers) do
					outputChatBox("[New Fare] " .. getPlayerName(thePlayer) .." Ph:" .. playerNumber .. " " .. message .."." , value, 0, 183, 239)
				end
				
				setElementData(thePlayer, "TaxiAbuse", 1)
				outputChatBox("Your message has been sent to all available drivers. Please wait for a response.", thePlayer, 255, 194, 14)
				setTimer(TaxiAbuseReset, 20000, 1, thePlayer)
			end
		end
	end
end
addCommandHandler("taxi", calltaxi, false, false)

-- Taxi Abuse Reset
function TaxiAbuseReset(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	local abusedT = getElementData(thePlayer, "TaxiAbuse")
	
	if (logged==1) then
		if (abusedT==1) then
			setElementData(thePlayer, "TaxiAbuse", 0)
			outputChatBox("Taxi timer reset", thePlayer, 255, 194, 14)
		end
	end
end


-- /pay
function payPlayer(thePlayer, commandName, targetPlayerNick, amount)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPlayerNick) or not (amount) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick] [Amount]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick)
			
			if not (targetPlayer) then
				outputChatBox("Player is not online.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					amount = tonumber(amount)
					
					local money = getElementData(thePlayer, "money")
					
					if (money<amount) then
						outputChatBox("You do not have enough money.", thePlayer, 255, 0, 0)
					else
						exports.global:setPlayerSafeMoney(thePlayer, money-amount)
						
						local targetMoney = getElementData(targetPlayer, "money")
						exports.global:setPlayerSafeMoney(targetPlayer, targetMoney+amount)
						
						exports.global:sendLocalMeAction(thePlayer, "takes some dollar notes from his wallet and gives them to " .. getPlayerName(targetPlayer) .. ".")
						outputChatBox("You gave $" .. amount .. " to " .. getPlayerName(targetPlayer) .. ".", thePlayer)
						outputChatBox(getPlayerName(thePlayer) .. " gave you $" .. amount .. ".", targetPlayer)
						exports.irc:sendMessage("[MONEY TRANSFER] From '" .. getPlayerName(thePlayer) .. "' to " .. getPlayerName(targetPlayer) .. "' Amount: $" .. amount .. ".")
					end
				else
					outputChatBox("You are too far away from " .. getPlayerName(targetPlayer) .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("pay", payPlayer, false, false)


-- /w(hisper)
function localWhisper(thePlayer, commandName, targetPlayerNick, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (targetPlayerNick) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<3) then
					message = table.concat({...}, " ")
						
					local name = string.gsub(getPlayerName(thePlayer), "_", " ")
					local targetName = string.gsub(getPlayerName(targetPlayer), "_", " ")
					
					exports.global:sendLocalMeAction(thePlayer, " whispers to " .. targetName .. ".")
					outputChatBox(name .. " whispers: " .. message, thePlayer, 255, 255, 255)
					outputChatBox(name .. " whispers: " .. message, targetPlayer, 255, 255, 255)
				else
					outputChatBox("You are too far away from " .. getPlayerName(targetPlayer) .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)

-- /c(lose)
function localClose(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local chatRadius = 2
			local posX, posY, posZ = getElementPosition(thePlayer)
			local chatSphere = createColSphere( posX, posY, posZ, 5)
			exports.pool:allocateElement(chatSphere)
			local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
			destroyElement( chatSphere )
			for index, targetPlayers in ipairs( targetPlayers ) do
										
				message = table.concat({...}, " ")
				local name = string.gsub(getPlayerName(thePlayer), "_", " ")
								
				outputChatBox(name .. " whispers: " .. message, targetPlayers, 255, 255, 255)
			end
		end
	end
end
addCommandHandler("c", localClose, false, false)

bike = { [581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true, [536]=true, [575]=true, [567]=true, [480]=true, [555]=true }

-- /cw(car whisper)
function localCarWhisper(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local id = getElementModel(vehicle)
			
			if (bike[id]) then
				outputChatBox("Car whisper is not available in this vehicle", thePlayer, 255, 194, 14)
			else
				exports.global:sendLocalDoAction(thePlayer, "Strangers whisper in the car." )
				
				for i = 0, 3 do
					player = getVehicleOccupant(vehicle, i)
					
					if (player) then
						message = table.concat({...}, " ")
						local name = string.gsub(getPlayerName(thePlayer), "_", " ")
						outputChatBox("((In Car)) " .. name .. " whispers: " .. message, player, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("cw", localCarWhisper, false, false)