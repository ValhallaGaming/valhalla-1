local pool = { }

function allocateTeam(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
			end
		end
	end
end

function deallocateTeam()
	if (getElementType(source)=="team") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateTeam)

function getAllTeam()
	return pool
end

function getTeamFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("TEAMS: " .. #pool)
end
addCommandHandler("showall", showall)