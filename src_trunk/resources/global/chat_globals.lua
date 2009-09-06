oocState = 1

function getOOCState()
	return oocState
end

function setOOCState(state)
	oocState = state
end

function sendMessageToAdmins(message)
	local players = exports.pool:getPoolElementsByType("player")
	
	for k, thePlayer in ipairs(players) do
		if (exports.global:isPlayerAdmin(thePlayer)) then
			outputChatBox(tostring(message), thePlayer, 255, 0, 0)
		end
	end
end

function findPlayerByPartialNick(partialNick)
	local matchNick = nil
	local matchNickAccuracy=0
	local partialNick = string.lower(partialNick)

	local players = exports.pool:getPoolElementsByType("player")
	local count = 0
	
	-- IDS
	if tonumber(partialNick) then
		for key, value in ipairs(players) do
			if isElement(value) then
				local id = getElementData(value, "playerid")
				
				if id and id == tonumber(partialNick) then
					matchNick = getPlayerName(value)
					break
				end
			end
		end
	else -- Look for player nicks
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local playerName = string.lower(getPlayerName(arrayPlayer))
				
				if(string.find(playerName, tostring(partialNick))) then
					local posStart, posEnd = string.find(playerName, tostring(partialNick))
					if posEnd - posStart > matchNickAccuracy then
						-- better match
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
					elseif posEnd - posStart == matchNickAccuracy then
						-- found someone who matches up the same way, so pretend we didnt find any
						matchNick = nil
					end
				end
			end
		end
	end
	
	if matchNick == nil then
		return false
	else
		local matchPlayer = getPlayerFromName(matchNick)
		local dbid = getElementData(matchPlayer, "dbid")
		return matchPlayer, dbid
	end
end

function sendLocalMeAction(thePlayer, message)
	local x, y, z = getElementPosition(thePlayer)
	local chatSphere = createColSphere(x, y, z, 20)
	exports.pool:allocateElement(chatSphere)
	local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
	local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
	
	destroyElement(chatSphere)
	

	for index, nearbyPlayer in ipairs(nearbyPlayers) do
		local logged = getElementData(nearbyPlayer, "loggedin")
		if not isPedDead(nearbyPlayer) and logged==1 and getElementDimension(thePlayer) == getElementDimension(nearbyPlayer) then
			outputChatBox(" *" .. playerName .. " " .. message, nearbyPlayer, 255, 51, 102)
		end
	end
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", getRootElement(), sendLocalMeAction)

function sendLocalDoAction(thePlayer, message)
	local x, y, z = getElementPosition(thePlayer)
	local chatSphere = createColSphere(x, y, z, 20)
	exports.pool:allocateElement(chatSphere)
	local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
	local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
	
	destroyElement(chatSphere)

	for index, nearbyPlayer in ipairs(nearbyPlayers) do
		local logged = getElementData(nearbyPlayer, "loggedin")
		if not isPedDead(nearbyPlayer) and logged==1 and getElementDimension(thePlayer) == getElementDimension(nearbyPlayer) then
			outputChatBox(" * " .. message .. " *      ((" .. playerName .. "))", nearbyPlayer, 255, 51, 102)
		end
	end
end