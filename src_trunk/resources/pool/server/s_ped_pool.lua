local pool = { }

function allocatePed(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
			end
		end
	end
end

function deallocatePed()
	if (getElementType(source)=="ped") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocatePed)

function getAllPeds()
	return pool
end

function getPedFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("PEDS: " .. #pool)
end
addCommandHandler("showall", showall)