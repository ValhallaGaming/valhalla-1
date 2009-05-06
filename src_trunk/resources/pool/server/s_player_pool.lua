local pool = { }

function allocatePlayer()
	local id = getElementData(source, "playerid")
	pool[id] = source
end
addEventHandler("onPlayerJoin", getRootElement(), allocatePlayer)

function deallocatePlayer()
	local id = getElementData(source, "playerid")
	pool[id] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), deallocatePlayer)

function getAllPlayers()
	return pool
end

function getPlayerFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("PLAYERS: " .. #pool)
end
addCommandHandler("showall", showall)