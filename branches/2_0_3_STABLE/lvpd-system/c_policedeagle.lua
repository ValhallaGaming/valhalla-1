cooldown = 0
cooldownTimer = nil

function switchMode()
	if (getPedWeapon(getLocalPlayer())==24) and (getPedTotalAmmo(getLocalPlayer())>0) then -- has an un-empty deagle
		local mode = getElementData(getLocalPlayer(), "deaglemode")
		if (mode==0) then -- tazer mode
			setElementData(getLocalPlayer(), "deaglemode", 1)
			outputChatBox("You switched your multipurpose handgun to Lethal mode.")
		elseif (mode==1) then -- lethal mode
			setElementData(getLocalPlayer(), "deaglemode", 2)
			outputChatBox("You switched your multipurpose handgun to Radar Gun mode.")
		elseif (mode==2) then -- radar gun mode
			setElementData(getLocalPlayer(), "deaglemode", 0)
			outputChatBox("You switched your multipurpose handgun to Tazer mode.")
		end
	end
end

function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("n", "down", switchMode)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function enableCooldown()
	cooldown = 1
	cooldownTimer = setTimer(disableCooldown, 3000, 1)
	toggleControl("fire", false)
end

function disableCooldown()
	cooldown = 0
	toggleControl("fire", true)

	if (cooldownTimer~=nil) then
		killTimer(cooldownTimer)
		cooldownTimer = nil
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), disableCooldown)

function weaponFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon==24) then -- deagle
		local mode = getElementData(getLocalPlayer(), "deaglemode")
		if (mode==0) then -- tazer mode
			enableCooldown()
			local px, py, pz = getElementPosition(getLocalPlayer())
			local distance = getDistanceBetweenPoints3D(hitX, hitY, hitZ, px, py, pz)
			
			if (distance<35) then
				fxAddSparks(hitX, hitY, hitZ, 1, 1, 1, 1, 10, 0, 0, 0, true, 3, 1)
			end
			playSoundFrontEnd(38)
			triggerServerEvent("tazerFired", getLocalPlayer(), hitX, hitY, hitZ, hitElement) 
		elseif (mode==2) then
			if (hitElement) then
				if (getElementType(hitElement)=="vehicle") then
					local speedx, speedy, speedz = getElementVelocity(hitElement)
					actualspeed = math.ceil(((speedx^2 + speedy^2 + speedz^2)^(0.5)*100))
					outputChatBox(getVehicleName(hitElement) .. " clocked in at " .. actualspeed .. " MPH.", 255, 194, 14)
				end
			end
		end
	end
end
addEventHandler("onClientPedWeaponFire", getLocalPlayer(), weaponFire)

-- code for the target/tazed person
function cancelTazerDamage(attacker, weapon, bodypart, loss)
	if (weapon==24) then -- deagle
		local mode = getElementData(attacker, "deaglemode")
		if (mode==0 or mode==2) then -- tazer mode
			--local hp = getElementHealth(source)
			--setElementHealth(source, hp+loss)
		end
	end
end
addEventHandler("onClientPedDamage", getLocalPlayer(), cancelTazerDamage)

function showTazerEffect(x, y, z)
	fxAddSparks(x, y, z, 1, 1, 1, 1, 100, 0, 0, 0, true, 3, 2)
	playSoundFrontEnd(38)
end
addEvent("showTazerEffect", true )
addEventHandler("showTazerEffect", getRootElement(), showTazerEffect)