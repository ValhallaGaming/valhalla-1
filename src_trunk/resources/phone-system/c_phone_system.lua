local p_Sound = {}
local stopTimer = {}

function startPhoneRinging(ringType)
	if ringType == 1 then -- phone call
		local x, y, z = getElementPosition(source)
		p_Sound[source] = playSound3D("phonecall.mp3", x, y, z, true)
		getSoundLength(p_Sound[source])
		stopTimer[source] = setTimer(triggerEvent, 10000, 1, "stopRinging", source)
	elseif ringType == 2 then -- sms
		p_Sound[source] = playSound3D("sms.mp3",getElementPosition(source))
	else
		outputDebugString("Ring type "..tostring(ringType).. " doesn't exist!")
	end
	attachElements(p_Sound[source], source)
end
addEvent("startRinging", true)
addEventHandler("startRinging", getRootElement(), startPhoneRinging)

function stopPhoneRinging()
	if p_Sound[source] then
		stopSound(p_Sound[source])
		p_Sound[source] = nil
	end
	if stopTimer[source] then
		killTimer(stopTimer[source])
		stopTimer[source] = nil
	end
end
addEvent("stopRinging", true)
addEventHandler("stopRinging", getRootElement(), stopPhoneRinging)