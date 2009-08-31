local PershingSquareCol = createColCuboid( 1410, -1795, -50, 150, 237, 200 )

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
	function( attacker, weapon )
		if attacker and getElementData( attacker, "adminlevel" ) == 0 and getElementData( attacker, "faction" ) ~= 1 and weapon and weapon > 1 then
			kickPlayer( attacker, getRootElement(), "Deathmatch" )
		end
	end
)