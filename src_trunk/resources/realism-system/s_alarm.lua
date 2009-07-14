alarmless = { [592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [20]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [581]=true, [510]=true, [509]=true, [522]=true, [481]=true, [461]=true, [462]=true, [448]=true, [521]=true, [468]=true, [463]=true, [586]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [537]=true, [538]=true, [569]=true, [590]=true, [441]=true, [464]=true, [501]=true, [465]=true, [564]=true, [571]=true, [471]=true, [539]=true, [594]=true }

function pickLock(thePlayer)
	if not( alarmless[getVehicleID(source)])then
		if(isVehicleLocked(source))then
			setTimer(CarAlarm, 1000, 20, source, thePlayer)
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), pickLock)

function CarAlarm(theVehicle, thePlayer)
	if ( getVehicleOverrideLights ( theVehicle ) ~= 2 ) then  -- if the current state isn't 'force on'
		setVehicleOverrideLights ( theVehicle, 2 )            -- force the lights on
		
	else
		setVehicleOverrideLights ( theVehicle, 1 )            -- otherwise, force the lights off
		
	end
	local carX, carY, carZ = getElementPosition( theVehicle )
	local alarmSphere = createColSphere( carX, carY, carZ, 100 )
	exports.pool:allocateElement(alarmSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( alarmSphere, "player" )
	for i, key in ipairs( targetPlayers ) do
		playSoundFrontEnd(key, 2)
	end
	destroyElement (alarmSphere)
end
