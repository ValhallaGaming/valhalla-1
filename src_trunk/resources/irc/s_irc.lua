server = "irc.multitheftauto.com"
port = 6667
username = "ValhallaGaming"
username2 = "ValhallaGaming2"
channel = "#Valhalla.echo"
channeladmins = "#Valhalla.admins"
pubchannel = "#mta"
pubchannel2 = "#Valhalla"
password = "adminmtavg"

conn = nil
conn2 = nil
timer = nil
useSecond = false
--[[
function initIRC()
	ircInit()
	conn = ircOpen(server, port, username, channel, password)

	sendMessage("Server Started.")
	conn2 = ircOpen(server, port, username2, channel, password)
	displayStatus()
	timer = setTimer(displayStatus, 900000, 0)
	ircJoin(conn, pubchannel)
	ircJoin(conn2, pubchannel)
	ircJoin(conn, pubchannel2)
	ircJoin(conn2, pubchannel2)
	ircJoin(conn, channeladmins)
	ircJoin(conn2, channeladmins)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), initIRC)

function stopIRC()
	sendMessage("Server Stopped.")
	ircPart(conn, channel)
	ircDisconnect(conn)
	killTimer(timer)
	timer = nil
	conn = nil
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), stopIRC)
]]--
function sendMessage(message)
	--[[
	local time = getRealTime()
	local hour = time.hour
	local mins = time.minute
	
	hour = hour + 8
	if (hour==24) then
		hour = 0
	elseif (hour>24) then
		hour = hour - 24
	end
	
	-- Fix time
	if (hour<10) then
		hour = 0 .. tostring(hour)
	end
	
	if (mins<10) then
		mins = 0 .. tostring(mins)
	end
	
	outputDebugString(tostring(message))
	
	if not (useSecond) then
		useSecond = true
		ircMessage(conn, channel, "[" .. hour .. ":" .. mins .. "] " .. tostring(message))
	else
		useSecond = false
		ircMessage(conn2, channel, "[" .. hour .. ":" .. mins .. "] " .. tostring(message))
	end
	]]--
end

function sendAdminMessage(message)
	--outputDebugString(tostring(message))
	
	--if not (useSecond) then
	--	useSecond = true
	--	ircMessage(conn, channeladmins, tostring(message))
	--else
	--	useSecond = false
	--	ircMessage(conn2, channeladmins, tostring(message))
	--end
end

--[[
function displayStatus()
	local playerCount = getPlayerCount()
	local maxPlayers = getMaxPlayers()
	local servername = getServerName()
	local ip = "67.210.235.106:22003"
		
	local totalping = 0
	local averageping = 0
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		totalping = totalping + getPlayerPing(value)
	end
	
	if (playerCount>0) then
		averageping = math.floor(totalping / playerCount)
	end
		
	local output = servername .. " - " .. playerCount .. "/" .. maxPlayers .. "(" .. math.ceil((playerCount/maxPlayers)*100) .. "%) - " .. ip .. " - GameMode: Roleplay - Average Ping: " .. averageping .. "."
	
	if not (useSecond) then
		useSecond = true
		ircMessage(conn2, channeladmins, output)
		ircMessage(conn2, pubchannel2, output)
	else
		useSecond = false
		ircMessage(conn, channeladmins, output)
		ircMessage(conn, pubchannel2, output)
	end
end
]]--