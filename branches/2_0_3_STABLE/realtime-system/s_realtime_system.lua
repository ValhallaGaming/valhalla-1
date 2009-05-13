function ssendRealTime()
	local realtime = getRealTime()
	local hour = realtime.hour

	hour = hour + 8
	if (hour==24) then
		hour = 0
	elseif (hour>24) then
		hour = hour - 24
	end
	
	triggerClientEvent(source, "syncRealTime", source, hour, realtime.minute, realtime.second)
end
addEvent("requestRealTime", true)
addEventHandler("requestRealTime", getRootElement(), ssendRealTime)