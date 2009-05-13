server = "irc.multitheftauto.com"
port = 6667
username = "VGMTAServer"
channel = "#vgmta.admins"
password = "adminmtavg"

conn = nil

function initIRC()
	ircInit()
	conn = ircOpen(server, port, username, channel, password)
	sendMessage("Server Started.")
	ircPart(conn, "#mta")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), initIRC)

function stopIRC()
	sendMessage("Server Stopped.")
	ircPart(conn, channel)
	ircDisconnect(conn)
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