function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if getElementData(thePlayer, "injuriedanimation") then
		return false
	end
	
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end
	
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and not getPedOccupiedVehicle(thePlayer) and getElementData(thePlayer, "freeze") ~= 1 then
		toggleAllControls(false, true, false)
		setElementData(thePlayer, "forcedanimation", forced, true)
		setElementData(thePlayer, "animation", true, true)
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		return setanim
	else
		return false
	end
end

function removeAnimation(thePlayer)
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and getElementData(thePlayer, "freeze") ~= 1 and not getElementData(thePlayer, "injuriedanimation") then
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", true, false)
		setElementData(thePlayer, "animation", false, true)
		toggleAllControls(true, true, false)
		setTimer(triggerServerEvent, 100, 1, "onPlayerStopAnimation", thePlayer, true )
		return setanim
	else
		return false
	end
end