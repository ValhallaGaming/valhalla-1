function hotwireEngine ( vehicle )
	toggleControl(source, "accelerate", true)
	toggleControl(source, "brake_reverse", true)
	toggleControl(source, "vehicle_fire", true)
	setVehicleEngineState ( vehicle, true )
	setElementData ( vehicle, "engine", 1, false )
end
addEvent( "onHotwireEnd", true )
addEventHandler( "onHotwireEnd", getRootElement(), hotwireEngine )
