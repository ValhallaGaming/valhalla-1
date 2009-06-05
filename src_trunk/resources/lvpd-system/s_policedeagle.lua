function tazerFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<50) then
		local colshape = createColSphere(px, py, pz, 20)
		exports.pool:allocateElement(colshape)
		for key, value in ipairs(getElementsWithinColShape(colshape)) do
			if (value~=source) then
				triggerClientEvent(value, "showTazerEffect", value, x, y, z) -- show the sparks
			end
		end
		
		if (target) then
			setElementData(target, "tazed", 1)
			toggleAllControls(target, false, true, false)
			setPedAnimation(target, "CRACK", "crckidle2", 10000, false, false, false)
			setTimer(toggleAllControls, 10000, 1, target, true, true, true)
			setTimer(setPedAnimation, 10005, 1, target)
		end
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)