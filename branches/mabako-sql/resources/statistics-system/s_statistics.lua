tick = getTickCount()

function statsStarted(res)
	if (res==getThisResource()) then
		exports.irc:sendMessage("[STATISTICS] Statistics Engine Started.")
	end
end
addEventHandler("onResourceStart", getRootElement(), statsStarted)

-- /UPTIME
function getUptime(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local currTick = getTickCount()
		local uptimeMilliseconds = currTick - tick
		
		local minutes = math.floor((uptimeMilliseconds/1000)/60)
		
		if (minutes==1) then
			outputChatBox("Uptime: " .. minutes .. " Minute.", thePlayer, 255, 194, 14)
		else
			outputChatBox("Uptime: " .. minutes .. " Minutes.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("uptime", getUptime)

-- /astats
function getAdminStats(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("-=-=-=-=-=-=-=-=-= STATISTICS =-=-=-=-=-=-=-=-=-", thePlayer, 255, 194, 14)
		
		-- CURRENT PLAYERS
		local playerCount = getPlayerCount()
		local maxCount = getMaxPlayers()
		outputChatBox("     Current Players: " .. playerCount .. "/" .. maxCount .. ".", thePlayer, 255, 194, 14)
		
		-- UPTIME
		local currTick = getTickCount()
		local uptimeMilliseconds = currTick - tick
		
		local minutes = math.floor((uptimeMilliseconds/1000)/60)
		
		if (minutes==1) then
			outputChatBox("     Uptime: " .. minutes .. " Minute.", thePlayer, 255, 194, 14)
		else
			outputChatBox("     Uptime: " .. minutes .. " Minutes.", thePlayer, 255, 194, 14)
		end
				
		-- VEHICLES
		local counter = 0
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			counter = counter + 1
		end
		outputChatBox("     Vehicles: " .. counter .. ".", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("astats", getAdminStats)