function animStopped(thePlayer)
	blendPedAnimation(thePlayer)
end

function syncAnimation(block, name, speed, blendSpeed, startTime, loop, updatePosition, forced)
	blendPedAnimation(source, block, name, speed, blendSpeed, startTime, loop, updatePosition, false, animStopped, source)
end
addEvent("syncAnimation", true)
addEventHandler("syncAnimation", getRootElement(), syncAnimation)

function applyAnimation(thePlayer, block, name, speed, blendSpeed, startTime, loop, updatePosition, forced)
	if speed==nil then speed = 1.0 end
	if blendSpeed==nil then blendSpeed = 1.0 end
	if startTime==nil then startTime = 0.0 end
	if loop==nil then loop = true end
	if updatePosition==nil then updatePosition = true end
	if forced==nil then forced = true end
	
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		toggleAllControls(false, true, false)
		setElementData(thePlayer, "forcedanimation", true, forced)
		setElementData(thePlayer, "animation", true, true)
		blendPedAnimation(thePlayer, block, name, speed, blendSpeed, startTime, loop, updatePosition, true)
		return true
	else
		return false
	end
end

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", true, false)
		setElementData(thePlayer, "animation", true, false)
		toggleAllControls(true, true, false)
		return setanim
	else
		return false
	end
end