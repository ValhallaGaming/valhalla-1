local playerInjuries = {} -- create a table to save the injuries

function killknockedout(source)
	setElementHealth(source, 0)
end

function knockout()
	outputChatBox("You've been knocked out!", source, 255, 0, 0)
	toggleAllControls(source, false, true, false)
	
	fadeCamera(source, false, 120)
	playerInjuries[source]['knockout'] = setTimer(killknockedout, 120000, 1, source)
	
	exports.global:applyAnimation( source, "CRACK", "crckidle2", 999999, true, false, true)
end

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
		return
	end
	
	if ( getElementHealth(source) < 20 or ( isElement( attacker ) and getElementType( attacker ) == "vehicle" and getElementHealth(source) < 40 ) ) and math.random( 1, 3 ) <= 2 then
		knockout()
	end
end

addEventHandler( "onPlayerDamage", getRootElement(), injuries )

addCommandHandler( "fakeinjury",
	function(thePlayer, command, weapon, bodypart, loss)
		if exports.global:isPlayerAdmin(thePlayer) then
			source = thePlayer
			loss = tonumber(loss)
			setElementHealth(thePlayer, math.max(0, getElementHealth(thePlayer) - loss))
			injuries(nil, tonumber(weapon), tonumber(bodypart), loss)
		end
	end
)

function healInjuries(healed)
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			if isTimer(playerInjuries[source]['knockout']) then
				killTimer(playerInjuries[source]['knockout'])
				playerInjuries[source]['knockout'] = nil
				
				if healed then
					fadeCamera(source, true, 2)
					setPedAnimation(source)
					exports.global:removeAnimation(source)
				end
			end
			toggleAllControls(source, true, true, false)
		else
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