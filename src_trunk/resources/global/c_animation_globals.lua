function applyAnimation(thePlayer, block, name, forced, speed, blendSpeed, startTime, loop, updatePosition, callbackFunction, ...)
	if not (speed) then speed = 1.0 end
	if not (blendSpeed) then blendSpeed = 1.0 end
	if not (startTime) then startTime = 0.0 end
	if loop==nil then loop = true end
	if updatePosition==nil then updatePosition = true end
	if forced==nil then forced = false end
	
	setElementData(thePlayer, "forcedanimation", true, forced)
	setElementData(thePlayer, "animation", true, true)
	
	if (thePlayer==getLocalPlayer()) then
		toggleAllControls(false, true, false)
	end
	--local setanim = setPedAnimation(thePlayer, block, name, speed, blendSpeed, startTime, loop, updatePosition, callbackFunction, ...)
	local setanim = setPedAnimation(thePlayer, block, name, -1, loop, updatePosition, false)
	return setanim
end

function removeAnimation(thePlayer)
	setElementData(thePlayer, "forcedanimation", true, false)
	setElementData(thePlayer, "animation", true, false)
	
	if (thePlayer==getLocalPlayer()) then
		toggleAllControls(true, true, false)
	end
	local setanim = setPedAnimation(thePlayer)
	return setanim
end