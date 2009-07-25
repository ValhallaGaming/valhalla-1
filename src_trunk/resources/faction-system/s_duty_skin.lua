function finishDutySkin(x, y, z, rot, dimension, interior, newskin)
	setElementDimension(source, dimension)
	setElementInterior(source, interior)
	setElementPosition(source, x, y, z)
	setPedRotation(source, rot)
	setCameraTarget(source)
	setElementData(source, "dutyskin", newskin, false)
	
	local duty = tonumber(getElementData(source, "duty"))
	if (duty>0) then -- on duty, let's give them the skin now
		setPedSkin(source, newskin)
	end
end
addEvent("finishDutySkin", true)
addEventHandler("finishDutySkin", getRootElement(), finishDutySkin)
