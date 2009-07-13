function pickLock(thePlayer)
	if(isVehicleLocked(source))then
		--CarAlarm(source, thePlayer)
		setTimer(CarAlarm, 1000, 20, source, thePlayer)
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
	local alarmSphere = createColSphere( carX, carY, carZ, 200 )
	exports.pool:allocateElement(alarmSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( alarmSphere, "player" )
	for i, key in ipairs( targetPlayers ) do
		playSoundFrontEnd(key, 2)
	end
	destroyElement (alarmSphere)
end
