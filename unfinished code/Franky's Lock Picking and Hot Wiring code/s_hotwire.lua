function hotwireEngine ( player, vehicle )
	local chance = math.random ( 1, 5 )
	if ( chance == 1 ) then
		setElementData ( vehicle, "vehicle.enginestate", true )
		setVehicleEngineState ( vehicle, true )
		outputChatBox ( "You got the engine running.", player, 106, 222, 1 )
	else
		outputChatBox ( "The engine made a sound but didn't start!", player, 200, 0, 0 )
	end
end
addEvent( "onHotwireEnd", true )
addEventHandler( "onHotwireEnd", getRootElement(), hotwireEngine )

function createHotwires ( theVehicle )
	local hotwire1 = getElementData ( theVehicle, "vehicle.hotwire1" )
	local hotwire2 = getElementData ( theVehicle, "vehicle.hotwire2" )
	local hotwire3 = getElementData ( theVehicle, "vehicle.hotwire3" )
	if ( hotwire1 == false ) or ( hotwire2 == false ) or ( hotwire3 == false ) then
		local hotwire1 = math.random ( 1, 5 )
		local hotwire2 = math.random ( 1, 5 )
		local hotwire3 = 6
		result = 1
			if ( hotwire1 == hotwire2 ) then
				result = 0
			end
		if ( result == 1 ) then
			setElementData ( theVehicle, "vehicle.hotwire1", tonumber ( hotwire1 ) )
			setElementData ( theVehicle, "vehicle.hotwire2", tonumber ( hotwire2 ) )
			setElementData ( theVehicle, "vehicle.hotwire3", tonumber ( hotwire3 ) )
		else
			createHotwires ( theVehicle )
		end
	end
end
addEvent( "startHotwire", true )
addEventHandler( "startHotwire", getRootElement(), createHotwires )
addEventHandler ( "onPlayerVehicleEnter", getRootElement( ), createHotwires )
