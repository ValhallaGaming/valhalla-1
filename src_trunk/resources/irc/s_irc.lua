server = "irc.gtanet.com"
port = 6667
username = "ValhallaGaming"
channel = "#vgmta.admins"
pubchannel = "#mta"
password = "adminmtavg"

conn = nil
timer = nil

function initIRC()
	ircInit()
	conn = ircOpen(server, port, username, channel, password)
	sendMessage("Server Started.")
	displayStatus()
	timer = setTimer(displayStatus, 600000, 0)
	ircJoin(conn, pubchannel)
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

function sendMessage(message)
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
	ircMessage(conn, channel, "[" .. hour .. ":" .. mins .. "] " .. tostring(message))
end

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
	
	averageping = math.floor(totalping / playerCount)
		
	local output = servername .. " - " .. playerCount .. "/" .. maxPlayers .. "(" .. math.ceil((playerCount/maxPlayers)*100) .. "%) - " .. ip .. " - GameMode: Roleplay - Average Ping: " .. averageping .. "."
	ircMessage(conn, channel, output)
end