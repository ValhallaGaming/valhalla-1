local pool = { }

function allocatePickup(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
				break
			end
		end
	end
end

function deallocatePickup()
	if (getElementType(source)=="pickup") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocatePickup)

function getAllPickups()
	return pool
end

function getPickupFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end