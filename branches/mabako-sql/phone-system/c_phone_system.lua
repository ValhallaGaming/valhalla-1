local wPhoneMenu, gRingtones, ePhoneNumber, bCall, bOK, bCancel

local sx, sy = guiGetScreenSize()
local p_Sound = {}
local stopTimer = {}

function showPhoneGui(itemValue)
	wPhoneMenu = guiCreateWindow(sx/2 - 125,sy/2 - 175,250,310,"Phone Menu",false)
	bCall = guiCreateButton(0.0424,0.0831,0.2966,0.0855,"Call",true,wPhoneMenu)
	ePhoneNumber = guiCreateEdit(0.3559,0.0831,0.5975,0.0855,"",true,wPhoneMenu)
	gRingtones = guiCreateGridList(0.0381,0.1977,0.9153,0.6706,true,wPhoneMenu)
				 guiGridListAddColumn(gRingtones,"ringtones",0.85)
				 guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, "vibrate mode", false, false)
				 for i, filename in ipairs(ringtones) do
					guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, filename:sub(1,-5), false, false)
				 end
				 guiGridListSetSelectedItem(gRingtones, itemValue, 1)
	bOK = guiCreateButton(0.0381,0.8821,0.4492,0.0742,"OK",true,wPhoneMenu)
	bCancel = guiCreateButton(0.5212,0.8821,0.4322,0.0742,"Cancel",true,wPhoneMenu)
	addEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	showCursor(true)
end
addEvent("showPhoneGUI", true)
addEventHandler("showPhoneGUI", getRootElement(), showPhoneGui)

function onGuiClick(button)
	if button == "left" then
		if p_Sound["playing"] then
			stopSound(p_Sound["playing"])
		end
		if source == bCall then
			local phoneNumber = guiGetText(wPhoneMenu)
			triggerServerEvent("remoteCall", getLocalPlayer(), getLocalPlayer(), "call", phoneNumber)
			hidePhoneGUI()
		elseif source == gRingtones then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				p_Sound["playing"] = playSound(ringtones[guiGridListGetSelectedItem(gRingtones)])
			end
		elseif source == bCancel then
			hidePhoneGUI()
		elseif source == bOK then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				triggerServerEvent("saveRingtone", getLocalPlayer(), guiGridListGetSelectedItem(gRingtones))
			end
			hidePhoneGUI()
		end
	end
end

function hidePhoneGUI()
	if wPhoneMenu then
		destroyElement(wPhoneMenu)
	end
	removeEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	showCursor(false)
end

function startPhoneRinging(ringType, itemValue)
	if ringType == 1 then -- phone call
		local x, y, z = getElementPosition(source)
		if not itemValue or itemValue < 0 then itemValue = 1 end
		p_Sound[source] = playSound3D(ringtones[itemValue], x, y, z, true)
		setSoundVolume(p_Sound[source], 0.4)
		setSoundMaxDistance(p_Sound[source], 20)
		getSoundLength(p_Sound[source])
		stopTimer[source] = setTimer(triggerEvent, 10000, 1, "stopRinging", source)
	elseif ringType == 2 then -- sms
		p_Sound[source] = playSound3D("sms.mp3",getElementPosition(source))
	else
		outputDebugString("Ring type "..tostring(ringType).. " doesn't exist!", 2)
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