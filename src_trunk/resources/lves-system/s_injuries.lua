local playerInjuries = {} -- create a table to save the injuries

function injuries(attacker, weapon, bodypart, loss)
	-- source = player who was hit
	
	-- BODY ARMOR
	if ( bodypart == 3 or bodypart == 9 ) and getPedArmor(source) > 0 then -- GOT (torso/head) PROTECTION?
		cancelEvent()
		return
	end

	-- katana kill
	if weapon == 8 then
		setPedHeadless(source, true)
		killPed(source, attacker, weapon, bodypart)
		return
	end

	
	-- if we have injuries saved for the player, we add it to their table
	if playerInjuries[source] then
		playerInjuries[source][bodypart] = true
	else
		-- create a new table for that player
		playerInjuries[source] = { [bodypart] = true } -- table
	end
	
	if ( bodypart == 3 and getElementHealth(source) < 40 ) or bodypart == 7 or bodypart == 8 then -- damaged either left or right leg
		if playerInjuries[source][7] and playerInjuries[source][8] then -- both were already hit
			toggleControl(source, 'forwards', false) -- disable walking forwards for the player who was hit
			toggleControl(source, 'left', false)
			toggleControl(source, 'right', false)
			toggleControl(source, 'backwards', false)
			toggleControl(source, 'enter_passenger', false)
			toggleControl(source, 'enter_exit', false)
		end
		
		-- we can be sure at least one of the legs was hit here, since we checked it above
		toggleControl(source, 'sprint', false) -- disable running forwards for the player who was hit
		toggleControl(source, 'jump', false) -- tried jumping with broken legs yet?

		if bodypart == 3 then
			bodypart = math.random( 7, 8 )
			playerInjuries[source][bodypart] = true
			outputChatBox("You broke your " .. ( bodypart == 7 and "Left" or "Right" ) .. " Leg!", source, 255, 0, 0)
		else
			outputChatBox("Your " .. ( bodypart == 7 and "Left" or "Right" ) .. " Leg was hit!", source, 255, 0, 0)
		end
	elseif bodypart == 5 or bodypart == 6 then -- damaged either arm
		if playerInjuries[source][5] and playerInjuries[source][6] then -- both were already hit
			toggleControl(source, 'fire', false) -- disable firing weapons for the player who was hit
		end

		toggleControl(source, 'aim_weapon', false) -- disable aiming for the player who was hit (can still fire, but without crosshair)
		toggleControl(source, 'jump', false) -- can't climb over the wall with a broken arm

		outputChatBox("Your " .. ( bodypart == 5 and "Left" or "Right" ) .. " Arm was hit!", source, 255, 0, 0)
	elseif bodypart == 9 then -- headshot
		setPedHeadless(source, true)
		killPed(source, attacker, weapon, bodypart)
		exports.global:givePlayerAchievement(attacker, 12)
		exports.global:givePlayerAchievement(source, 15)
	end
end

addEventHandler( "onPlayerDamage", getRootElement(), injuries )
addCommandHandler( "fi", function(thePlayer, command, weapon, bodypart) source=thePlayer injuries(nil, tonumber(weapon), tonumber(bodypart), 0) end)

function healInjuries()
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source][7] and playerInjuries[source][8] then
			toggleControl(source, 'forwards', true) -- disable walking forwards for the player who was hit
			toggleControl(source, 'left', true)
			toggleControl(source, 'right', true)
			toggleControl(source, 'backwards', true)
			toggleControl(source, 'enter_passenger', true)
			toggleControl(source, 'enter_exit', true)
		end
		if playerInjuries[source][7] or playerInjuries[source][8] then
			toggleControl(source, 'sprint', true)
			toggleControl(source, 'jump', true)
		end
		
		if playerInjuries[source][5] and playerInjuries[source][6] then
			toggleControl(source, 'fire', true)
		end
		if playerInjuries[source][5] or playerInjuries[source][6] then
			toggleControl(source, 'aim_weapon', true)
			toggleControl(source, 'jump', true)
		end
	end
end

addEvent( "onPlayerHeal", false ) -- add a new event for it (called from /heal)
addEventHandler( "onPlayerHeal", getRootElement(), healInjuries)

function resetInjuries() -- it actually has some parameters, but we only need source right now - the wiki explains them though
	setPedHeadless(source, false)

	if playerInjuries[source] then
		-- reset injuries
		healInjuries()
		
		playerInjuries[source] = nil -- reset the table (non-existant anymore)
	end
end

addEventHandler( "onPlayerSpawn", getRootElement(), resetInjuries) -- make sure old injuries don't carry over
addEventHandler( "onPlayerQuit", getRootElement(), resetInjuries) -- cleanup when the player quits