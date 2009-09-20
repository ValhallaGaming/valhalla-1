
function ChangePlayerWeather(weather, blend)
	setWeather ( tonumber(weather) )
	if(blend ~= nil) then
		setWeatherBlended ( tonumber( blend ))
	end
end
addEvent( "onClientWeatherChange", true )
addEventHandler( "onClientWeatherChange", getRootElement(), ChangePlayerWeather )

elevatortimer = nil
function usedElevator(x, y, z)
	if (isTimer(elevatorTimer)) then killTimer(elevatortimer) end
	
	elevatortimer = setTimer(doGroundCheck, 100, 0)
end
addEvent( "usedElevator", true )
addEventHandler( "usedElevator", getRootElement(), usedElevator )

function doGroundCheck()
	local x, y, z = getElementPosition(getLocalPlayer())
	local groundz = getGroundPosition(x, y, z)
	
	local clear = isLineOfSightClear(x, y, z, x, y, z-10, true, true, true, true, false, false, false, false, getLocalPlayer())

	if (not clear) then
		triggerServerEvent("resetGravity", getLocalPlayer())
		killTimer(elevatortimer)
		elevatortimer = nil
	end
end

addEventHandler( "onClientPlayerVehicleEnter", getLocalPlayer(),
	function( vehicle )
		setElementData( vehicle, "groundoffset", 0.2 + getElementDistanceFromCentreOfMassToBaseOfModel( vehicle ) )
	end
)

addEvent( "CantFallOffBike", true )
addEventHandler( "CantFallOffBike", getLocalPlayer(),
	function( )
		setPedCanBeKnockedOffBike( getLocalPlayer(), false )
		setTimer( setPedCanBeKnockedOffBike, 1050, 1, getLocalPlayer(), true )
	end
)