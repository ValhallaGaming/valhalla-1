function applyAnimation(thePlayer, block, name, speed, blendSpeed, startTime, loop, updatePosition, forced)
	if speed==nil then speed = 1.0 end
	if blendSpeed==nil then blendSpeed = 1.0 end
	if startTime==nil then startTime = 0.0 end
	if loop==nil then loop = true end
	if updatePosition==nil then updatePosition = true end
	if forced==nil then forced = true end
	
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		toggleAllControls(thePlayer, false, true, false)
		setElementData(thePlayer, "forcedanimation", forced)
		setElementData(thePlayer, "animation", true)
		triggerClientEvent(getRootElement(), "syncAnimation", thePlayer, block, name, speed, blendSpeed, startTime, loop, updatePosition, forced)
		return true
	else
		return false
	end
end

function onSpawn()
	setPedAnimation(source)
	toggleAllControls(source, true, true, false)
	setElementData(source, "forcedanimation", false)
	setElementData(source, "animation", false)
end
addEventHandler("onPlayerSpawn", getRootElement(), onSpawn)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		local setanim = setPedAnimation(thePlayer)
		setElementData(thePlayer, "forcedanimation", false)
		setElementData(thePlayer, "animation", false)
		toggleAllControls(thePlayer, true, true, false)
		return setanim
	else
		return false
	end
end