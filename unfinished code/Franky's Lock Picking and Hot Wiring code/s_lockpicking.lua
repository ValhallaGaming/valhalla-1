function pickLock ( theVehicle )
	setVehicleLocked ( theVehicle, false )
end
addEvent( "onLockpickEnd", true )
addEventHandler( "onLockpickEnd", getRootElement(), pickLock )

function createLockCode ( theVehicle, player )
	local lockCode = getElementData ( theVehicle, "vehicle.lockcode" )
	if ( lockCode ) == false then
		local newCode = math.random ( 100000, 999999 )
		result = 1
		for key, value in ipairs( getElementsByType ( "vehicle" ) ) do
			check = tonumber ( getElementData ( value, "vehicle.lockcode" ) )
			if ( check == newCode ) then
				result = 0
			end
		end
		if ( result == 1 ) then
			setElementData ( theVehicle, "vehicle.lockcode", tonumber ( newCode ) )
			outputChatBox ( newCode, player, 111, 111, 111 )
		else
			createLockCode( theVehicle )
		end 
	end
end
addEvent( "startLockPick", true )
addEventHandler( "startLockPick", getRootElement(), createLockCode )
addEventHandler ( "onPlayerVehicleEnter", getRootElement( ), createLockCode )