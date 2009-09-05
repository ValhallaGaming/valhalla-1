local markers = { }

addEventHandler( "onVehicleRespawn", getRootElement( ),
	function( )
		if markers[ source ] then
			destroyElement( markers[ source ] )
			markers[ source ] = nil
		end
	end
)

addEventHandler( "onElementDestroy", getRootElement( ),
	function( )
		if markers[ source ] then
			destroyElement( markers[ source ] )
			markers[ source ] = nil
		end
	end
)

addEventHandler( "onVehicleStartExit", getRootElement( ),
	function( player, seat, jacked )
		if markers[ source ] and seat == 0 then
			destroyElement( markers[ source ] )
			markers[ source ] = nil
		end
	end
)

addEvent( "toggleTaxiLights", true )
addEventHandler( "toggleTaxiLights", getRootElement( ), 
	function( vehicle )
		if markers[ vehicle ] then
			destroyElement( markers[ vehicle ] )
			markers[ vehicle ] = nil
		else
			markers[ vehicle ] = createMarker( 0, 0, 0, 'corona', 1, 255, 255, 0, 90 )
			if getElementModel( vehicle ) == 420 then
				attachElements( markers[ vehicle ], vehicle, 0, -0.46, 0.9 )
			else
				attachElements( markers[ vehicle ], vehicle, 0, 0, 0.8 )
			end
		end
	end
)