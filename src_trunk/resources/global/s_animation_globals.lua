function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if not animtime then animtime = -1 end
	if not loop then loop = true end
	if not updatePosition then updatePosition = true end
	if not forced then forced = false end
	
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		toggleAllControls(thePlayer, false, true, false)
		setElementData(thePlayer, "forcedanimation", forced)
		setElementData(thePlayer, "animation", true)
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		return setanim
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