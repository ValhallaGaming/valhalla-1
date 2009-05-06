local pool = { }

function allocateVehicle(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
			end
		end
	end
end

function deallocateVehicle()
	if (getElementType(source)=="vehicle") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateVehicle)

function getAllVehicles()
	return pool
end

function getVehicleFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end