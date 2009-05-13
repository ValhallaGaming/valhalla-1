rot = 0.0
vehicle = false
effect = false

function realisticDamage(attacker, weapon, bodypart)
	if (source==getLocalPlayer()) then
		
		-- Only AK47, M4 and Sniper can penetrate armor
		local armor = getPedArmor(source)
		
		if (weapon>0) and (attacker) then
			local armorType = getElementData(attacker, "armortype")
			local bulletType = getElementData(attacker, "bullettype")
			
			if (armor>0) and (armorType==1) and (bulletType~=1) and (weapon>0) then
				if ((weapon~=30) and (weapon~=31) and (weapon~=34)) and (bodypart~=9) then
					cancelEvent()
				end
			end
		end
		
		-- Damage effect
		if not (effect) then
			fadeCamera(false, 1.0, 255, 0, 0)
			effect = true
			setTimer(endEffect, 250, 1)
		end
	end
end
addEventHandler("onClientPedDamage", getLocalPlayer(), realisticDamage)

function endEffect()
	fadeCamera(true, 1.0)
	effect = false
end

function playerDeath()
	deathTimer = 30
	deathLabel = nil
	rot = 0.0
	fadeCamera(false, 29, 255, 255, 255)
	vehicle = isPedInVehicle(getLocalPlayer())
	
	local pX, pY, pZ = getElementPosition(getLocalPlayer())

	-- Setup the text
	setTimer(lowerTimer, 1000, 30)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local width = 250
	local height = 100
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/8 - (height/8))
	deathLabel = guiCreateLabel(x, y, width, height, "30 Seconds", false)
	guiSetFont(deathLabel, "sa-gothic")
	
	setGameSpeed(0.5)
end
addEventHandler("onClientPedWasted", getLocalPlayer(), playerDeath)

function lowerTimer()
	deathTimer = deathTimer - 1
	
	if (deathTimer>1) then
		guiSetText(deathLabel, tostring(deathTimer) .. " Seconds")
	else
		guiSetText(deathLabel, tostring(deathTimer) .. " Second")
	end
end

deathTimer = 30
deathLabel = nil

function playerRespawn()
	setGameSpeed(1)
	if (deathLabel) then
		destroyElement(deathLabel)
		guiSetVisible(deathLabel, false)
	end
	setCameraTarget(getLocalPlayer())
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), playerRespawn)

-- weapon fix for #131
function checkWeapons()
	local weapons = { }
	local removedWeapons
	local count = 1
	
	local gunlicense = getElementData(getLocalPlayer(), "license.gun")
	
	for i = 0, 12 do
		local weapon = getPedWeapon(getLocalPlayer(), i)
		local ammo = getPedTotalAmmo(getLocalPlayer(), i)
		local team = getPlayerTeam(getLocalPlayer())
		local factiontype = getElementData(team, "type")
		
		if (weapon) and (ammo~=0) then
			if (weapon>=30) and (weapon<=39) and not (gunlicense==1) and not (factiontype==2) then -- unlicensed weapon
				if (removedWeapons==nil) then
					removedWeapons = getWeaponNameFromID(weapon)
				else
					removedWeapons = removedWeapons .. ", " .. getWeaponNameFromID(weapon)
				end
				weapons[count] = { }
				weapons[count][1] = weapon
				weapons[count][2] = ammo
				weapons[count][3] = 1
			else
				weapons[count] = { }
				weapons[count][1] = weapon
				weapons[count][2] = ammo
				weapons[count][3] = 0
			end
			count = count + 1
		end
	end
	
	if (removedWeapons~=nil) then
		triggerServerEvent("onDeathRemovePlayerWeapons", getLocalPlayer(), weapons, removedWeapons)
	else
		triggerServerEvent("onDeathRemovePlayerWeapons", getLocalPlayer(), weapons)
	end
end
addEventHandler("onClientPedWasted", getLocalPlayer(), checkWeapons)