alarmless = { [592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [20]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [581]=true, [510]=true, [509]=true, [522]=true, [481]=true, [461]=true, [462]=true, [448]=true, [521]=true, [468]=true, [463]=true, [586]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [537]=true, [538]=true, [569]=true, [590]=true, [441]=true, [464]=true, [501]=true, [465]=true, [564]=true, [571]=true, [471]=true, [539]=true, [594]=true }
local localPlayer = getLocalPlayer()

function resStart(res)
	if (res==getThisResource()) then
		for key, value in ipairs(getElementsByType("vehicle")) do
			setElementData(value, "alarm", nil)
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resStart)

function carAlarm()
	local alarm = getElementData(source, "alarm")
	
	local driver = getVehicleOccupant(source, 0)
	local passenger1 = getVehicleOccupant(source, 1)
	local passenger2 = getVehicleOccupant(source, 2)
	local passenger3 = getVehicleOccupant(source, 3)
	
	if (isVehicleLocked(source)) and (not alarm) and not (alarmless[getElementModel(source)]) and (not driver and not passenger1 and not passenger2 and not passenger3) then
		setTimer(doCarAlarm, 1000, 20, source)
		setElementData(source, "alarm", 1)
		setTimer(resetAlarm, 11000, 1, source)
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), carAlarm)
addEvent("startCarAlarm", true)
addEventHandler("startCarAlarm", getRootElement(), carAlarm)

function resetAlarm(vehicle)
	setElementData(vehicle, "alarm", nil)
end

function doCarAlarm(vehicle)
	local x, y, z = getElementPosition(vehicle)
	local px, py, pz = getElementPosition(localPlayer)
	
	if (getDistanceBetweenPoints3D(x, y, z, px, py, pz)<30) then
		playSound3D("horn.wav", x, y, z)
		
		if ( getVehicleOverrideLights ( vehicle ) ~= 2 ) then  -- if the current state isn't 'force on'
			setVehicleOverrideLights ( vehicle, 2 )            -- force the lights on
			
		else
			setVehicleOverrideLights ( vehicle, 1 )            -- otherwise, force the lights off
		end
	end
end