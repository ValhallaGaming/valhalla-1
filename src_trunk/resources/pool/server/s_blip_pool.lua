local pool = { }

function allocateBlip(element)
	for i = 1, #pool+1 do
		if (pool[i]==nil) then
			pool[i] = element
			setElementData(element, "poolid", i)
		end
	end
end

function deallocateBlip()
	if (getElementType(source)=="blip") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateBlip)

function getAllBlips()
	return pool
end

function getBlipFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("BLIPS: " .. #pool)
end
addCommandHandler("showall", showall)