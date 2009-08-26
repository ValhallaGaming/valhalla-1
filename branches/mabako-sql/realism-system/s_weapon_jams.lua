function toggleFiring(enabled, showJamMessage)
	toggleControl(source, "fire", enabled)
	
	if (showJamMessage) then
		exports.global:sendLocalMeAction(source, "'s weapon jams.")
	end
end
addEvent("togglefiring", true)
addEventHandler("togglefiring", getRootElement(), toggleFiring)

function resourceStart(res)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		toggleControl(value, "fire", true)
	end
	
	-- garage fix
	for i = 1, 50 do
		setGarageOpen(i-1, true)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)