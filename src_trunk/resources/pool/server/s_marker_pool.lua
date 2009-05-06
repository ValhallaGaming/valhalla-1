local pool = { }

function allocateMarker(element)
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

function deallocateMarker()
	if (getElementType(source)=="marker") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateMarker)

function getAllMarkers()
	return pool
end

function getMarkerFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end