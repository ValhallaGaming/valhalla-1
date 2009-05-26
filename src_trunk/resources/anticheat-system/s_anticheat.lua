function anticheatStarted(res)
	if (res==getThisResource()) then
		outputChatBox("[ANTICHEAT] Version 2.0 Protection Started.")
		exports.irc:sendMessage("[ANTICHEAT] Version 2.0 Protection Started.")
	end
end
addEventHandler("onResourceStart", getRootElement(), anticheatStarted)

function showSpeedToAdmins(velocity)
	exports.global:sendMessageToAdmins("[Possible Speedhack/HandlingHack] " .. getPlayerName(source) .. ": " .. velocity .. "Mph.")
end
addEvent("alertAdminsOfSpeedHacks", true)
addEventHandler("alertAdminsOfSpeedHacks", getRootElement(), showSpeedToAdmins)

function showDMToAdmins(kills)
	exports.global:sendMessageToAdmins("[Possible DeathMatching] " .. getPlayerName(source) .. ": " .. kills .. " kills in <=2 Minutes.")
end
addEvent("alertAdminsOfDM", true)
addEventHandler("alertAdminsOfDM", getRootElement(), showDMToAdmins)

-- [MONEY HACKS]
function scanMoneyHacks()
	local tick = getTickCount()
	local hackers = { }
	local hackersMoney = { }
	local counter = 0
	
	exports.irc:sendMessage("[ANTICHEAT] Scanning for money hacks...")
	local players = exports.pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		if (logged==1) then
			if not (exports.global:isPlayerAdmin(value)) then -- Only check if its not an admin...
				
				local money = getPlayerMoney(value)
				local truemoney = getElementData(value, "money")
				if (money) then
					if (money~=truemoney) then
						counter = counter + 1
						hackers[counter] = value
						hackersMoney[counter] = (money-truemoney)
					end
				end
			end
		end
	end
	local tickend = getTickCount()
	exports.irc:sendMessage("[ANTICHEAT] " .. counter .. " Money Hacker(s) Detected.")
	exports.irc:sendMessage("[ANTICHEAT] Scan completed in " .. tickend-tick .. " millseconds.")
	
	local theConsole = getRootElement()
	for key, value in ipairs(hackers) do
		local money = hackersMoney[key]
		local accountID = getElementData(value, "gameaccountid")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		outputChatBox("AntiCheat: " .. targetPlayerName .. " was auto-banned for Money Hacks. (" .. tostring(money) .. "$)", getRootElement(), 255, 0, 51)
		
		--local ban = banPlayer(value, true, false, false, getRootElement(), "Money Hacks. (" .. tostring(money) .. "$)")
	end
end
setTimer(scanMoneyHacks, 3600000, 0) -- Every 60 minutes