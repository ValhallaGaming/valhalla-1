meleeWeapon = {[ ], [ ]}

function injurePlayer ( attacker, weapon, bodypart, loss ) -- when a player is damaged
		local health = getElementData ( getRootElement(),"health" )
		local stamina = getElementData ( getRootElement(),"stamina" )
		
		if (bodyPart == 9) and (meleeWeapon[weapon]) then -- Knockout ( Motion blur as the screen fades to near black. Ped frozen in lay / crack anim. ) caused by being hit over the head with a melee weapon. As stamina decreases chances of being knocked out increases.
			local chance = math.random( 100 )
			if (health >= 25) and (stamina >=25) then -- if health and stamina are both above 25% there is a 10% of being knocked out. If both are lower than 25% there is a 50% chance of being knocked out.
				if ( chance =< 25 )then
					-- Knock the player out.
					setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as concused.
					triggerClientEvent ( "concusion", true ) -- trigger the client side effects.
					setTimer ( ) -- the duration of the knockout then revive player and give them the concusion injury.
				end
			else
				if ( chance =< 50 )then
					-- Knock the player out.
					setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as concused.
					triggerClientEvent ( "concusion", true ) -- trigger the client side effects.
					setTimer ( ) -- the duration of the knockout then trigger the revive event.
				end
			end
		end
		if (bodyPart == 9) and (meleeWeapon[weapon]) then -- Concusion ( Motion blur and swaying camera ) Before a player is knocked out & when a player is revived from being knocked out.
			if ( stamina <= 20 ) or ( health <= 50 ) then 
				setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as concused.
				triggerClientEvent ( "concusion", true ) -- trigger the client side effects.
			end
		end
		-- Arm injuries 1 ( Reduces players shooting accurace temporarily ) Caused by damage to the arm.
		-- Arm injuries 2 ( Prevents player from climbing, shooting or attacking )Caused by being shot in the arm with low health.
		-- Leg injuries ( prevent running & jumping ) caused by being shot in the leg. High falls.
end
addEventHandler ( "onPlayerDamage", getRootElement (), injurePlayer )

-- create random illnesses that occur when a players stamina reaches a low level.

-- ES treatment. /examine[player] outputs to the ES member what injuries another player has.
-- /treat[player][treatment] corrects a specific injury.
-- Treatments: head, arm, leg, illness?

--------------------------------
-- Client side injury effects --
--------------------------------
knockedOutText = nil

-- Knockout.
function knockedOut ( thePlayer )
	setPedAnimation ( thePlayer, ""," " false, false, false ) -- set the players animation
	toggleAllControls( false, true, false ) -- freeze the player
	setPedWeaponSlot( 0 )
	setElementData( thePlayer, "freeze", 1)
	
	outputChatBox ( "Looks like you've been knocked out. You should come around soon but you'll need to see a doctor about the blurred vision.", 255, 0, 0 ) -- output explanation message
	outputChatBox ( "Do NOT use in character chats while knocked out.", 255, 0, 0 )
	
	setBlurLevel ( 255 ) -- begin effects
	fadeCamera ( thePlayer, false, 5.0, 0, 0, 0 )
	
	knockedOutText = guiCreateLabel(0.0, 0.5, 1.0, 0.3, "Knocked Out!", true) -- Create "Knocked out!" text.
	guiSetFont(knockedOutText, "sa-header")
	guiLabelSetHorizontalAlign(knockedOutText, "center", true)
	guiSetAlpha(knockedOutText, 1.0)
end
addEvent( "knockout" )
addEventHandler( "knockout", getRootElement(), knockedOut )

-- bringAround.
function bringAround ( thePlayer )
	triggerEvent ( "concusion", getRootElement() ) -- trigger concusion.
	
	fadeCamera ( thePlayer, true, 5.0 ) -- give the camera a long fade back in but maintain the blur (concusion).
	
	destroyElement(knockedOutText) -- Remove "Knocked out!" text.
	knockedOutText = nil
	
	setPedAnimation ( thePlayer ) -- set the players animation
	toggleAllControls( true, true, true) -- unfreeze the player
	setPedWeaponSlot( 0 )
	setElementData( thePLayer, "freeze", 1 )
end
addEvent( "revive" )
addEventHandler( "revive", getRootElement(), bringAround )

-- Concusion.
function concusedEffect ( thePlayer )
	outputChatBox ( "That blurred vision can't be good. You should go and see a doctor.", 255, 0, 0 )
	setBlurLevel ( 255 ) -- motion blur.
	-- sway camera slightly.
end
addEvent ( "concusion", true )
addEventHandler ( "concusion", getRootElement(), concusedEffect )