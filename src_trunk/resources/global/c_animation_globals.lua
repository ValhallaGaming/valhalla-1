function animStopped(thePlayer)
	blendPedAnimation(thePlayer)
end

function syncAnimation(block, name, speed, blendSpeed, startTime, loop, updatePosition, forced)
	blendPedAnimation(source, block, name, speed, blendSpeed, startTime, loop, updatePosition, false, animStopped, source)
end
addEvent("syncAnimation", true)
addEventHandler("syncAnimation", getRootElement(), syncAnimation)