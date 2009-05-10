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
	
	-- IDS
	if ((tostring(type(tonumber(partialNick)))) == "number") then
		for key, value in ipairs(players) do
			local id = getElementData(value, "playerid")
			
			if (id) then
				if (id==tonumber(partialNick)) then
					matchNick = getPlayerName(value)
					break
				end
			end
		end
	elseif not ((tostring(type(tonumber(partialNick)))) == "number") or not (matchNick) then -- Look for player nicks
		for playerKey, arrayPlayer in ipairs(players) do
			local playerName = string.lower(getPlayerName(arrayPlayer))

			if(string.find(playerName, tostring(partialNick))) then
				local posStart, posEnd = string.find(playerName, tostring(partialNick))
				if ((posEnd-posStart) > matchNickAccuracy) then
					matchNickAccuracy = posEnd-posStart
					matchNick = playerName
					break
				end
			end
		end
	end

	if(matchNick==nil) then
		return false
	else
		local matchPlayer = getPlayerFromNick(matchNick)
		local dbid = getElementData(matchPlayer, "dbid")
		return matchPlayer, dbid
	end
end

function randChar()
	local rand = math.random(0, 25)
	
	if (rand==0) then
		return "A"
	elseif (rand==1) then
		return "B"
	elseif (rand==2) then
		return "C"
	elseif (rand==3) then
		return "D"
	elseif (rand==4) then
		return "E"
	elseif (rand==5) then
		return "F"
	elseif (rand==6) then
		return "G"
	elseif (rand==7) then
		return "H"
	elseif (rand==8) then
		return "I"
	elseif (rand==9) then
		return "J"
	elseif (rand==10) then
		return "K"
	elseif (rand==11) then
		return "L"
	elseif (rand==12) then
		return "M"
	elseif (rand==13) then
		return "N"
	elseif (rand==14) then
		return "O"
	elseif (rand==15) then
		return "P"
	elseif (rand==16) then
		return "Q"
	elseif (rand==17) then
		return "R"
	elseif (rand==18) then
		return "S"
	elseif (rand==19) then
		return "T"
	elseif (rand==20) then
		return "U"
	elseif (rand==21) then
		return "V"
	elseif (rand==22) then
		return "W"
	elseif (rand==23) then
		return "X"
	elseif (rand==24) then
		return "Y"
	elseif (rand==25) then
		return "Z"
	else
		return "A"
	end
end

function sendLocalMeAction(thePlayer, message)
	local x, y, z = getElementPosition(thePlayer)
	local chatSphere = createColSphere(x, y, z, 20)
	exports.pool:allocateElement(chatSphere)
	local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
	local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
	
	destroyElement(chatSphere)
	
	outputDebugString("[IC OOC: ME ACTION] *" .. playerName .. " " .. message)

	for index, nearbyPlayer in ipairs(nearbyPlayers) do
		local logged = getElementData(nearbyPlayer, "loggedin")
		if not(isPedDead(nearbyPlayer)) and (logged==1) then
			outputChatBox(" *" .. playerName .. " " .. message, nearbyPlayer, 255, 51, 102)
		end
	end
end

function sendLocalDoAction(thePlayer, message)
	local x, y, z = getElementPosition(thePlayer)
	local chatSphere = createColSphere(x, y, z, 20)
	exports.pool:allocateElement(chatSphere)
	local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
	local playerName = string.gsub(getPlayerName(thePlayer), "_", " ")
	
	destroyElement(chatSphere)

	for index, nearbyPlayer in ipairs(nearbyPlayers) do
		local logged = getElementData(nearbyPlayer, "loggedin")
		if not(isPedDead(nearbyPlayer)) and (logged==1) then
			outputChatBox(" * " .. message .. " *      ((" .. playerName .. "))", nearbyPlayer, 255, 128, 147)
		end
	end
end