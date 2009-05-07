local pool = { }

function allocatePlayer()
	for i = 1, #pool+10 do
		if (pool[i]==nil) then
			pool[i] = source
			setElementData(source, "poolid", i)
			break
		end
	end
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