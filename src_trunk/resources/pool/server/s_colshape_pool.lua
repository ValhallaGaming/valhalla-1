local pool = { }

function allocateColshape(element)
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

function deallocateColshape()
	if (string.find(getElementType(source), "col")) then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateColshape)

function getAllColshapes()
	return pool
end

function getColshapeFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end