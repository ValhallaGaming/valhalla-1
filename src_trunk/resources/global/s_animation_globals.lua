function applyAnimation(thePlayer, block, name, forced, blendSpeed, loop, updatePosition)
	if not (blendSpeed) then blendSpeed = 1.0 end
	if loop==nil then loop = true end
	if updatePosition==nil then updatePosition = true end
	if forced==nil then forced = false end
	
	toggleAllControls(thePlayer, false, true, false)
	setElementData(thePlayer, "forcedanimation", forced)
	setElementData(thePlayer, "animation", true)
	local setanim = setPedAnimation(thePlayer, block, name, blendSpeed, loop, updatePosition)
	return setanim
end

function onSpawn()
	setPedAnimation(source)
	toggleAllControls(source, true, true, false)
	setElementData(source, "forcedanimation", false)
	setElementData(source, "animation", false)
end
addEventHandler("onPlayerSpawn", getRootElement(), onSpawn)