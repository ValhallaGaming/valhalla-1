function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end
	
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and not getPedOccupiedVehicle(thePlayer) and getElementData(thePlayer, "freeze") ~= 1 then
		if getElementData(thePlayer, "injuriedanimation") or ( not forced and getElementData(thePlayer, "animation") ) then
			return false
		end
		
		toggleAllControls(false, true, false)
		setElementData(thePlayer, "forcedanimation", forced)
		setElementData(thePlayer, "animation", true)
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		if animtime > 50 then
			setElementData(thePlayer, "animationt", setTimer(removeAnimation, animtime, 1, thePlayer), false)
		end
		return setanim
	else
		return false
	end
end

function removeAnimation(thePlayer)
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and getElementData(thePlayer, "freeze") ~= 1 and not getElementData(thePlayer, "injuriedanimation") then
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", false)
		setElementData(thePlayer, "animation", false)
		toggleAllControls(true, true, false)
		setTimer(setPedAnimation, 50, 2, thePlayer)
		setTimer(triggerServerEvent, 100, 1, "onPlayerStopAnimation", thePlayer, true )
		return setanim
	else
		return false
	end
end