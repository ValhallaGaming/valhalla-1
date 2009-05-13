meleeWeapon = {[1], [2], [3], [5], [6] }
gunWeapon

function injurePlayer ( attacker, weapon, bodypart, loss ) -- when a player is damaged
	
	local health = getElementData ( getRootElement(),"health" )
	local stamina = getElementData ( getRootElement(),"stamina" )
	local chance = math.random( 100 )
	---------------
	-- Knockouts --  ( Motion blur as the screen fades to near black. Ped frozen in lay / crack anim. ) caused by being hit over the head with a melee weapon. As stamina decreases chances of being knocked out increases.
	---------------
	if (bodyPart == 9 ) then
		local existingHeadInjury = getElementData( getRootElement(),"injuredHead" )
		if ( existingHeadInjury ~= 1 ) then -- Is the player already knocked out.
			if (weapon == 0) and (stamina <= 50 ) then -- Fist knockout.
				if ( chance <= 5 )then -- 5% chance of being knocked out.
					-- Knock the player out.
					setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as knocked out.
					triggerClientEvent ( "knockout", true ) -- trigger the client side effects.
				end
			elseif (meleeWeapon[weapon]) then -- Knockout 
				if (health >= 25) and (stamina >=25) then -- if health and stamina are both above 25% there is a 10% of being knocked out. If both are lower than 25% there is a 50% chance of being knocked out.
					if ( chance =< 25 )then
						-- Knock the player out.
						setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as concused.	
						triggerClientEvent ( "knockout", true ) -- trigger the client side effects.
					end
				elseif ( chance =< 50 )then -- increased odds of being knocked out.
					-- Knock the player out.
					setElementData( getRootElement(),"injuredHead", 1 ) -- set the player as concused.
					triggerClientEvent ( "knockout", true ) -- trigger the client side effects.
				end
			end
		end
	end
	
	-------------------------------------
	-- Knockout by getting hit by cars --
	-------------------------------------
	-- If a player is hit by a car and the damage is big enough.
	if
		
	end
	
	--------------------------------------------------
	-- Knockout from car damage while driving a car --
	--------------------------------------------------
	-- If a player crashes while driving a vehicle and the damage to the player is big enough the player is knocked out. Same as the other knockout only they remain in the car.
	if
		
	end
		
	---------------
	-- concussion -- ( Motion blur and swaying camera ) Before a player is knocked out & when a player is revived from being knocked out.
	---------------
	if (bodyPart == 9) and (meleeWeapon[weapon]) then 
		if ( stamina <= 25 ) and ( health <= 25 ) or ( stamina <= 10 ) and ( health <= 40 ) then 
			setElementData( getRootElement(),"injuredHead", 2 ) -- set the player as concused.
			triggerClientEvent ( "concussion", true ) -- trigger the client side effects.
		end
	end
		
	-------------------
	-- Arm injuries -- ( Reduces players shooting accurace temporarily ) Caused by damage to the arm.
	-------------------
	if (bodyPart == 5) or ( bodyPart == 6 ) then -- If the damage was to the arms
		local existingArmInjury = getElementData( getRootElement(),"injuredArm" )
		if ( existingArmInjury == 0 ) then -- Is the player's arm already injured?
			if ( health <= 20 ) and not (gunWeapon[weapon]) then
				setElementData( getRootElement(),"injuredArm", 1 ) -- set the players arm to injured state.
				-- decrease the players shooting skill for all weapons.
				-- decrease the players strength.
				armInjuryTimer setTimer( healArm, 60000, 1 ) -- start a timer to stop it.
			elseif ( health <= 20 ) and ( gunWeapon[weapon] ) then -- Arm injury 2 -- ( Prevents player from climbing, shooting or attacking )Caused by being shot in the arm with low health.
				setElementData( getRootElement(),"injuredArm", 1 ) -- set the players arm to injured.
				-- stop player from climbing.
				-- stop player from driving.
				-- stop player from shooting and attacking.
			end
		end
	end
	
	------------------
	-- Leg injuries -- ( prevent running & jumping ) caused by being shot in the leg. High falls.
	------------------
	if (bodyPart == 7) or ( bodyPart == 8) then -- If the damage was to the legs.
		local existingLegInjury = getElementData( getRootElement(),"injuredLeg" )
		if ( existingLegInjury == 0 ) then -- Is the player's leg already injured?
			if ( loss >= 25 ) then
				-- Stop player from sprinting.
				-- stop player from jumping
			end
		end
	end
end
addEventHandler ( "onPlayerDamage", getRootElement (), injurePlayer )

-- create random illnesses that occur when a players stamina reaches a low level.

-- ES treatment. /examine[player] outputs to the ES member what injuries another player has.
-- /treat[player][treatment] corrects a specific injury.
-- Treatments: head, arm, leg, illness?

-- New item Penicilin. Reduces the effect of concussion and sets a timer for it to stop. Small health boost.

--------------------------------
-- Client side injury effects --
--------------------------------
knockedOutText = nil

-- Knockout.
function knockedOut ( thePlayer )
	setPedAnimation ( thePlayer, "CRACK","crckidle2" false, false, false ) -- set the players animation
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
	
	local duration = math.random ( 60000, 300000 ) -- between 1 and 5 minutes.
	knockoutTimer setTimer( bringAround, duration, 1 ) -- the duration of the knockout then revive the player.
end
addEvent( "knockout" )
addEventHandler( "knockout", getRootElement(), knockedOut )

-- bringAround.
function bringAround ( thePlayer )
	triggerEvent ( "concussion", getRootElement() ) -- trigger concussion.
	
	fadeCamera ( thePlayer, true, 5.0 ) -- give the camera a long fade back in but maintain the blur (concussion).
	
	destroyElement(knockedOutText) -- Remove "Knocked out!" text.
	knockedOutText = nil
	
	setPedAnimation ( thePlayer ) -- set the players animation
	toggleAllControls( true, true, true) -- unfreeze the player
	setPedWeaponSlot( 0 )
	setElementData( thePlayer, "freeze", 1 )
end
addEvent( "revive" )
addEventHandler( "revive", getRootElement(), bringAround )

-- concussion.
function concusedEffect ( thePlayer )
	setElementData( getRootElement(),"injuredHead", 2 ) -- set to concused so the effect does not restart.
	outputChatBox ( "That blurred vision can't be good. You should go and see a doctor.", 255, 0, 0 )
	setBlurLevel ( 255 ) -- motion blur.
	-- sway camera slightly.
end
addEvent ( "concussion", true )
addEventHandler ( "concussion", getRootElement(), concusedEffect )