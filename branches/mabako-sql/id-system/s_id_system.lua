local ids = { }

function playerJoin()
	local slot = nil
	
	for i = 1, 128 do
		if (ids[i]==nil) and not (slot) then
			slot = i
		end
	end
	
	ids[slot] = source
	setElementData(source, "playerid", slot)
	setElementData(source, "ID #", slot)
	exports.irc:sendMessage("[SCRIPT] Player " .. getPlayerName(source) .. " was assigned ID #" .. slot .. ".")
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function playerQuit()
	local slot = getElementData(source, "playerid")
	
	if (slot) then
		ids[slot] = nil
		exports.irc:sendMessage("[SCRIPT] Player ID #" .. slot .. " became free.")
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function resourceStart()
	local players = exports.pool:getPoolElementsByType("player")
	
	for key, value in ipairs(players) do
		ids[key] = value
		setElementData(value, "playerid", key)
		setElementData(value, "ID #", key)
	end
	exports.irc:sendMessage("[SCRIPT] Assigned " .. #players .. " Player IDs.")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
