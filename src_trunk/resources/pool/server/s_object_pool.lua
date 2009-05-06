local pool = { }

function allocateObject(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
			end
		end
	end
end

function deallocateObject()
	if (getElementType(source)=="object") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateObject)

function getAllObjects()
	return pool
end

function getObjectFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("OBJECTS: " .. #pool)
end
addCommandHandler("showall", showall)