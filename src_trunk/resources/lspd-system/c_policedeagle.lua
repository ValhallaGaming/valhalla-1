cooldown = 0
cooldownTimer = nil

function switchMode()
	if (getPedWeapon(getLocalPlayer())==24) and (getPedTotalAmmo(getLocalPlayer())>0) then -- has an un-empty deagle
		local mode = getElementData(getLocalPlayer(), "deaglemode")
		if (mode==0) then -- tazer mode
			setElementData(getLocalPlayer(), "deaglemode", 1)
			outputChatBox("You switched your multipurpose handgun to Lethal mode.")
		elseif (mode==1) then -- lethal mode
			setElementData(getLocalPlayer(), "deaglemode", 0)
			outputChatBox("You switched your multipurpose handgun to Tazer mode.")
		end
	end
end

function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("b", "down", switchMode)
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
	if (cooldownTimer) then
		killTimer(cooldownTimer)
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
				fxAddSparks(hitX, hitY, hitZ, 1, 1, 1, 1, 100, 0, 0, 0, true, 3, 1)
			end
			playSoundFrontEnd(38)
			triggerServerEvent("tazerFired", getLocalPlayer(), hitX, hitY, hitZ, hitElement) 
		end
	end
end
addEventHandler("onClientPedWeaponFire", getLocalPlayer(), weaponFire)

-- code for the target/tazed person
function cancelTazerDamage(attacker, weapon, bodypart, loss)
	if (weapon==24) then -- deagle
		local mode = getElementData(attacker, "deaglemode")
		if (mode==0) then -- tazer mode
			cancelEvent()
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