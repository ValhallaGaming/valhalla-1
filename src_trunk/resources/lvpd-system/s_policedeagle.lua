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
		destroyElement(colshape)
		
		if (isElement(target) and getElementType(target)=="player") then
			setElementData(target, "tazed", 1, false)
			toggleAllControls(target, false, true, false)
			exports.global:applyAnimation(target, "ped", "FLOOR_hit_f", -1, false, false, true)
			setTimer(removeAnimation, 10005, 1, target)
		end
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		exports.global:removeAnimation(thePlayer)
		toggleAllControls(thePlayer, true, true, true)
	end
end