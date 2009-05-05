function syncRealTime(h, m, s)
    setTime(h, m)
	-- fix for +- 1 minute inaccuracy
    setMinuteDuration(((60-s)*1000))
	setTimer(fixTime, ((60-s)*1000)+5, 1, h, m)
end
addEvent("syncRealTime", true)
addEventHandler("syncRealTime", getRootElement(), syncRealTime)

function fixTime(h, m)
	setTime(h, m+1)
	setMinuteDuration(60000)
end

function crequestRealTime(res)
	if (res==getThisResource()) then
		triggerServerEvent("requestRealTime", getLocalPlayer())
	end
end
addEventHandler("onClientResourceStart", getRootElement(), crequestRealTime)