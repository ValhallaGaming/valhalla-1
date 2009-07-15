alarmless = { [592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [20]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [581]=true, [510]=true, [509]=true, [522]=true, [481]=true, [461]=true, [462]=true, [448]=true, [521]=true, [468]=true, [463]=true, [586]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [537]=true, [538]=true, [569]=true, [590]=true, [441]=true, [464]=true, [501]=true, [465]=true, [564]=true, [571]=true, [471]=true, [539]=true, [594]=true }

function onVehicleDamage()
	local driver = getVehicleOccupant(source, 0)
	local passenger1 = getVehicleOccupant(source, 1)
	local passenger2 = getVehicleOccupant(source, 2)
	local passenger3 = getVehicleOccupant(source, 3)

	if (isVehicleLocked(source)) and not (alarmless[getVehicleModel(source)])  and (not driver and not passenger1 and not passenger2 and not passenger3) then
		triggerClientEvent("startCarAlarm", source)
	end
end
addEventHandler("onVehicleDamage", getRootElement(), onVehicleDamage)