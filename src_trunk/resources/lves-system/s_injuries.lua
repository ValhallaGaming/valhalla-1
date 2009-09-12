local playerInjuries = {} -- create a table to save the injuries

function copy( t )
	local r = {}
	if type(t) == 'table' then
		for k, v in pairs( t ) do
			r[k] = v
		end
	end
	return r
end

function isMelee( weapon )
	return weapon and weapon <= 15
end

function killknockedout(source)
	setElementHealth(source, 0)
end

function knockout()
	if playerInjuries[source] and not isTimer( playerInjuries[source]['knockout'] ) then
		outputChatBox("You've been knocked out!", source, 255, 0, 0)
		toggleAllControls(source, false, true, false)
		
		fadeCamera(source, false, 120)
		playerInjuries[source]['knockout'] = setTimer(killknockedout, 120000, 1, source)
		
		exports.global:applyAnimation( source, "CRACK", "crckidle2", -1, true, false, true)
		setElementData(source, "injuriedanimation", true)
	end
end

function injuries(attacker, weapon, bodypart, loss)
	if not loss or loss < 0.5 then
		return
	end
	
	-- drowning
	if weapon == 53 then
		return
	end
	
	-- source = player who was hit
	if not bodypart and getPedOccupiedVehicle(source) then
		bodypart = 3
	end
	
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

	-- 2% chance of melee knockout
	if isMelee( weapon ) then
		if math.random( 1, 50 ) == 1 then
			knockout()
		end
		return
	end
	
	-- if we have injuries saved for the player, we add it to their table
	local injuredBefore = copy( playerInjuries[source] )
	if playerInjuries[source] then
		playerInjuries[source][bodypart] = true
	else
		-- create a new table for that player
		playerInjuries[source] = { [bodypart] = true } -- table
	end
	
	if ( bodypart == 3 and loss >= 15 ) or bodypart == 7 or bodypart == 8 then -- damaged either left or right leg
		if bodypart == 3 then
			bodypart = math.random( 7, 8 )
			if not injuredBefore[bodypart] then
				outputChatBox("You broke your " .. ( bodypart == 7 and "Left" or "Right" ) .. " Leg!", source, 255, 0, 0)
			end
			playerInjuries[source][bodypart] = true
		elseif not injuredBefore[bodypart] then
			outputChatBox("Your " .. ( bodypart == 7 and "Left" or "Right" ) .. " Leg was hit!", source, 255, 0, 0)
		end

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
	elseif bodypart == 5 or bodypart == 6 then -- damaged either arm
		if playerInjuries[source][5] and playerInjuries[source][6] then -- both were already hit
			toggleControl(source, 'fire', false) -- disable firing weapons for the player who was hit
		end

		toggleControl(source, 'aim_weapon', false) -- disable aiming for the player who was hit (can still fire, but without crosshair)
		toggleControl(source, 'jump', false) -- can't climb over the wall with a broken arm

		outputChatBox("Your " .. ( bodypart == 5 and "Left" or "Right" ) .. " Arm was hit!", source, 255, 0, 0)
	elseif bodypart == 9 then -- headshot
		if not attacker or weapon ~= 24 or getElementData(attacker, "deaglemode") ~= 0 then 
			setPedHeadless(source, true)
			killPed(source, attacker, weapon, bodypart)
			exports.global:givePlayerAchievement(attacker, 12)
			exports.global:givePlayerAchievement(source, 15)
			return
		end
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

function stabilize()
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			removeElementData(source, "injuriedanimation")
			if isTimer(playerInjuries[source]['knockout']) then
				killTimer(playerInjuries[source]['knockout'])
				playerInjuries[source]['knockout'] = nil
				
				fadeCamera(source, true, 2)
				setPedAnimation(source)
				exports.global:removeAnimation(source)

				toggleControl(source, 'forwards', true)
				toggleControl(source, 'left', true)
				toggleControl(source, 'right', true)
				toggleControl(source, 'backwards', true)
				toggleControl(source, 'enter_passenger', true)
				setElementHealth(source, math.max( 20, getElementHealth(source) ) )
			end
		end
		
		if playerInjuries[source][7] and playerInjuries[source][8] then
			toggleControl(source, 'forwards', true)
			toggleControl(source, 'left', true)
			toggleControl(source, 'right', true)
			toggleControl(source, 'backwards', true)
			toggleControl(source, 'enter_passenger', true)
		end
	end
end

addEvent( "onPlayerStabilize", false )
addEventHandler( "onPlayerStabilize", getRootElement(), stabilize )

function examine(to)
	local name = getPlayerName(source):gsub("_", " ")
	if isPedDead(source) then
		outputChatBox(name .. " is dead.", to, 255, 0, 0)
	elseif playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			outputChatBox(name.. " is knocked out.", to, 255, 255, 0)
		end

		if playerInjuries[source][7] and playerInjuries[source][8] then
			outputChatBox("Both of " .. name .. "s legs are broken.", to, 255, 255, 0)
		elseif playerInjuries[source][7] then
			outputChatBox(name .. "s left leg is broken.", to, 255, 255, 0)
		elseif playerInjuries[source][8] then
			outputChatBox(name .. "s right leg is broken.", to, 255, 255, 0)
		end

		if playerInjuries[source][5] and playerInjuries[source][6] then
			outputChatBox("Both of " .. name .. "s arms are broken.", to, 255, 255, 0)
		elseif playerInjuries[source][5] then
			outputChatBox(name .. "s left arm is broken.", to, 255, 255, 0)
		elseif playerInjuries[source][6] then
			outputChatBox(name .. "s right arm is broken.", to, 255, 255, 0)
		end
	else
		outputChatBox(name .. " is not injured.", to, 255, 255, 0)
	end
end

addEvent( "onPlayerExamine", false )
addEventHandler( "onPlayerExamine", getRootElement(), examine )

function healInjuries(healed)
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			removeElementData(source, "injuriedanimation")
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
		playerInjuries[source] = nil
	end
end

addEvent( "onPlayerHeal", false ) -- add a new event for it (called from /heal)
addEventHandler( "onPlayerHeal", getRootElement(), healInjuries)

function restoreInjuries( )
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source][7] and playerInjuries[source][8] then
			toggleControl(source, 'forwards', false)
			toggleControl(source, 'left', false)
			toggleControl(source, 'right', false)
			toggleControl(source, 'backwards', false)
			toggleControl(source, 'enter_passenger', false)
			toggleControl(source, 'enter_exit', false)
		end
		if playerInjuries[source][7] or playerInjuries[source][8] then
			toggleControl(source, 'sprint', false)
			toggleControl(source, 'jump', false)
		end
		
		if playerInjuries[source][5] and playerInjuries[source][6] then
			toggleControl(source, 'fire', false)
		end
		if playerInjuries[source][5] or playerInjuries[source][6] then
			toggleControl(source, 'aim_weapon', false)
			toggleControl(source, 'jump', false)
		end
	end
end
addEventHandler( "onPlayerStopAnimation", getRootElement(), restoreInjuries )

function resetInjuries() -- it actually has some parameters, but we only need source right now - the wiki explains them though
	setPedHeadless(source, false)

	if playerInjuries[source] then
		-- reset injuries
		healInjuries()
	end
end

addEventHandler( "onPlayerSpawn", getRootElement(), resetInjuries) -- make sure old injuries don't carry over
addEventHandler( "onPlayerQuit", getRootElement(), resetInjuries) -- cleanup when the player quits