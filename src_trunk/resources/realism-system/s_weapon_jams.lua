function toggleFiring(enabled)
	toggleControl(source, "fire", enabled)
end
addEvent("togglefiring", true)
addEventHandler("togglefiring", getRootElement(), toggleFiring)

function resourceStart(res)
	if (res==getThisResource()) then
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			toggleControl(value, "fire", true)
		end
	end
end
addEventHandler("onResourceStart", getRootElement(), resourceStart)