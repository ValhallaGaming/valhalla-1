radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

function saveRadio(station)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (vehicle) then
		if not (lawVehicles[getElementModel(vehicle)]) then
			radio = station
			triggerServerEvent("sendRadioSync", getLocalPlayer(), station, getRadioChannelName(station))
		else
			cancelEvent()
			radio = 0
			setRadioChannel(0)
		end
	end
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)

function setRadio(vehicle)
	if not (lawVehicles[getElementModel(vehicle)]) then
		setRadioChannel(radio)
	else
		setRadioChannel(0)
	end
end
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), setRadio)

function syncRadio(station)
	removeEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
	setRadioChannel(tonumber(station))
	addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
end
addEvent("syncRadio", true)
addEventHandler("syncRadio", getRootElement(), syncRadio)

------ MP3 PLAYER - gotta have my boats n hoes!
local currMP3 = 0

function toggleMP3(key, state)
	if (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 19) and not (isPedInVehicle(getLocalPlayer()))) then
		if (key=="-") then -- lower the channel
			if (currMP3==0) then
				currMP3 = 12
			else
				currMP3 = currMP3 - 1
			end
		elseif (key=="=") then -- raise the channel
			if (currMP3==12) then
				currMP3 = 0
			else
				currMP3 = currMP3 + 1
			end
			
		end
		setRadioChannel(currMP3)
		outputChatBox("You switched your MP3 Player to " .. getRadioChannelName(currMP3) .. ".")
	elseif not (isPedInVehicle(getLocalPlayer())) then
		currMP3 = 0
		setRadioChannel(currMP3)
	end		
end
bindKey("-", "down", toggleMP3)
bindKey("=", "down", toggleMP3)