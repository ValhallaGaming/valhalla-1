--[[local PershingSquareCol = createColCuboid( 1410, -1795, -50, 150, 237, 200 )

addEventHandler( "onPlayerDamage", getRootElement(),
	function( attacker, weapon )
		if weapon and weapon > 1 and isElementWithinColShape( source, PershingSquareCol ) and ( not attacker or getElementData( attacker, "faction" ) ~= 1 ) then
			cancelEvent()
			if attacker then
				exports.global:takeAllWeapons( attacker )
				outputChatBox("Your Weapons have been removed due to Possible Deathmatching.", attacker, 255, 0, 0)
			end
		end
	end
)

addEventHandler( "onPlayerWasted", getRootElement(),
	function( ammo, attacker, weapon )
		if isElementWithinColShape( source, PershingSquareCol ) and attacker then
			if getElementType( attacker ) == "vehicle" then
				attacker = getVehicleOccupant( attacker )
				if not attacker then return end
			end
		
			if getElementType( attacker ) == "player" and getElementData( attacker, "adminlevel" ) == 0 and getElementData( attacker, "faction" ) ~= 1 and weapon and weapon > 1 then
				kickPlayer( attacker, getRootElement(), "Deathmatch" )
			end
		end
	end
)]]

--

local coronas =
{
	{ 1465.84, -1608.38, 15.375 },
	{ 1494.36, -1608.38, 15.375 },
	{ 1494.41, -1629.98, 15.5312 },
	{ 1465.89, -1629.98, 15.5312 },
	{ 1466.47, -1637.96, 15.6328, 1 },
	{ 1477.94, -1652.73, 15.6328, 0 },
	{ 1479.38, -1682.31, 15.6328, 0 },
	{ 1479.38, -1692.39, 15.6328, 0 },
	{ 1479.7, -1702.53, 15.625, 0 },
	{ 1479.7, -1716.7, 15.625, 0 },
	
	-- lamps near the roads
	{ 1485.1494140625, -1728.95703125, 21.6497631073, 2 },
	{ 1505.1337890625, -1729.0244140625, 21.633712768555, 2 },
	{ 1467.7880859375, -1729.07421875, 21.582117996216, 2 },
	{ 1451.6787109375, -1728.923828125, 21.628421783447, 2 },
	
	{ 1432.609375, -1702.1943359375, 21.678199768066, 2 },
	{ 1432.3603515625, -1676.6103515625, 21.641231536865, 2 },
	{ 1432.2978515625, -1656.0390625, 21.615036010742, 2 },
	{ 1432.41015625, -1635.77734375, 21.559638977051, 2 },
	{ 1432.4677734375, -1618.89453125, 21.67691993713, 2 },
	
	{ 1451.59375, -1595.3583984375, 21.639394760132, 2 },
	{ 1471.62109375, -1595.30078125, 21.609306335449, 2 },
	{ 1488.8759765625, -1595.3798828125, 21.618810653687, 2 },
	{ 1505.2353515625, -1595.455078125, 21.638525009155, 2 },
	
	{ 1526.65625, -1611.443359375, 21.653305053711, 2 },
	{ 1526.0927734375, -1622.37890625, 21.596796035767, 2 },
	{ 1526.1796875, -1648.0107421875, 21.594993591309, 2 },
	{ 1526.0986328125, -1668.1376953125, 21.662385940552, 2 },
	{ 1526.0625, -1688.5263671875, 21.588069915771, 2 },
	{ 1526.2822265625, -1705.3828125, 21.5895652771, 2 },
	{ 1526.12890625, -1721.5390625, 21.594753265381, 2 }
}

local lamps = {}
function createStreetLamps()
	for k, v in ipairs( coronas ) do
		if not v[4] then
			lamps[ #lamps + 1 ] = createMarker( v[1], v[2], v[3] + 2.65, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
		elseif v[4] == 0 then
			lamps[ #lamps + 1 ] = createMarker( v[1], v[2] + 0.75, v[3] + 2.65, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
			lamps[ #lamps + 1 ] = createMarker( v[1], v[2] - 0.75, v[3] + 2.65, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
		elseif v[4] == 1 then
			lamps[ #lamps + 1 ] = createMarker( v[1] + 0.75, v[2], v[3] + 2.65, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
			lamps[ #lamps + 1 ] = createMarker( v[1] - 0.75, v[2], v[3] + 2.65, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
		elseif v[4] == 2 then
			lamps[ #lamps + 1 ] = createMarker( v[1], v[2], v[3] - 1.3, 'corona', 3, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, math.random( 0, 1 ) * 255, 127 )
		end
	end
end
addEventHandler( "onResourceStart", getResourceRootElement(), createStreetLamps )

--

--[[addEventHandler( "onColShapeHit", PershingSquareCol,
	function( element, matching )
		if isElement( element ) and getElementType( element ) == "player" and matching then
			exports.global:givePlayerAchievement( element, 39 ) -- Party Time
		end
	end
)]]

-- fireworks
local fwTimer = nil

function launchFW()
	local marker = createMarker( 1498.0234375, -1664.6025390625, 34.046875, 'corona', 1, math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) )
	triggerClientEvent( "fireworks", marker, math.random( -60, 60 ), math.random( -80, 80 ), math.random( 40, 70 ), math.random( 5, 15 ) )
	setTimer( destroyElement, 10000, 1, marker )
end

addCommandHandler( "fireworks", 
	function( thePlayer, commandName )
		if exports.global:isPlayerAdmin( thePlayer ) then
			if not fwTimer then
				launchFW()
				fwTimer = setTimer( launchFW, 300, 0 )
				
				-- disable street lamps
				for key, value in pairs( lamps ) do 
					destroyElement( value )
					lamps = {}
				end
				
				setWeather( 4 )

				outputChatBox("You started the fireworks!", thePlayer, 0, 255, 0)
			else
				killTimer( fwTimer )
				fwTimer = nil
				outputChatBox("You stopped the fireworks!", thePlayer, 255, 0, 0)

				-- re-enable street lamps
				createStreetLamps()
			end
		end
	end
)