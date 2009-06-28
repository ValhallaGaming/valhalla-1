function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end
	
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		toggleAllControls(false, true, false)
		setElementData(thePlayer, "forcedanimation", true, forced)
		setElementData(thePlayer, "animation", true, true)
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		return setanim
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