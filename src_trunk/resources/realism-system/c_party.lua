--[[local localPlayer = getLocalPlayer()
local PershingSquareCol = createColCuboid( 1410, -1795, -50, 150, 237, 200 )
local PershingRadar = createRadarArea( 1410, -1795, 150, 237, 0, 255, 0, 63 )
local keysTimer = nil

function toggleKeys( state )
	toggleControl( 'fire', state )
	toggleControl( 'aim_weapon', state )
	toggleControl( 'next_weapon', state )
	toggleControl( 'previous_weapon', state )
	toggleControl( 'vehicle_fire', state )
	toggleControl( 'vehicle_secondary_fire', state )
	setPedWeaponSlot( localPlayer, 0 )
end

-- toggle keys as they enter pershing square
addEventHandler( "onClientColShapeHit", PershingSquareCol,
	function( element )
		if getElementData( localPlayer, "adminlevel" ) == 0 then
			if element == localPlayer then
				if getElementData( localPlayer, 'faction' ) ~= 1 then
					toggleKeys( false )
					keysTimer = setTimer( toggleKeys, 500, 0, false )
				end
				
				local vehicle = getPedOccupiedVehicle( localPlayer )
				if vehicle and getElementData( vehicle, 'faction' ) ~= 1 and ( getVehicleType( vehicle ) == "Helicopter" or getVehicleType( vehicle ) == "Plane" ) then
					outputChatBox("Air Traffic over Pershing Square is currently not permitted.", 255, 0, 0)
				else
					outputChatBox("Any Non-Roleplay will be punished and may lead to a jail or a ban.", 255, 0, 0)
				end
			elseif getElementType( element ) == "vehicle" and getElementData( element, 'faction' ) ~= 1 and ( getVehicleType( element ) == "Helicopter" or getVehicleType( element ) == "Plane" ) then
				local vx, vy, vz = getElementVelocity( element )
				setElementVelocity( element, -vx, -vy, math.abs( vz ) )
			end
		end
	end
)

addEventHandler( "onClientColShapeLeave", PershingSquareCol,
	function( element )
		if element == localPlayer then
			if getElementData( localPlayer, 'faction' ) ~= 1 then
				toggleKeys( true )
			end
			
			if isTimer( keysTimer ) then
				killTimer( keysTimer )
				keysTimer = nil
			end
		end
	end
)

addEventHandler( "onClientPlayerDamage", getLocalPlayer(),
	function( attacker, weapon )
		if weapon and weapon > 1 and isElementWithinColShape( localPlayer, PershingSquareCol ) and ( not attacker or ( getElementData( attacker, "adminlevel" ) == 0 and getElementData( attacker, "faction" ) ~= 1 ) ) then
			cancelEvent()
		end
	end
)]]

-- fireworks

local fireworks = { }

addEvent( "fireworks", true )
addEventHandler( "fireworks", getRootElement(), 
	function( movex, movey, movez, size )
		local x, y, z = getElementPosition( source )
		fireworks[ source ] = { fromx=x, fromy=y, fromz=z, movex=movex, movey=movey, movez=movez, time=getTickCount(), size=size }
	end
)

addEventHandler( "onClientPreRender", getRootElement(),
	function()
		local time = getTickCount()
		for key, value in pairs( fireworks ) do
			if isElement( key ) then
				if time - value.time > 5000 then
					if not value.downx then
						value.downx, value.downy, value.downz = getElementPosition( key )
						value.movex = 1/3 * value.movex
						value.movey = 1/3 * value.movey
						value.movez = 1/15 * value.movez
					end
					local rel = ( time - value.time - 5000 ) / 5000
					setElementPosition( key, value.downx + rel * value.movex, value.downy + rel * value.movey, value.downz + rel * rel * value.movez )
				else
					local rel = ( time - value.time ) / 5000
					setElementPosition( key, value.fromx + rel * value.movex, value.fromy + rel * value.movey, value.fromz + rel * value.movez )
					setMarkerSize( key, rel * value.size )
				end
			else
				fireworks[ key ] = nil
			end
		end
	end
)