local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }

function reloadWeapon(thePlayer)
	local weapon = getPlayerWeapon(thePlayer)
	local ammo = getPlayerTotalAmmo(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")

	if (reloading==false) and not (isPedInVehicle(thePlayer)) then
		if (weapon) and (ammo) then
			if (weapon>21) and (weapon<35) and not (noReloadGuns[weapon]) then
				toggleControl(thePlayer, "fire", false)
				toggleControl(thePlayer, "next_weapon", false)
				toggleControl(thePlayer, "previous_weapon", false)
				setElementData(thePlayer, "reloading", true)
				setTimer(checkFalling, 100, 10, thePlayer)
				if not (isPedDucked(thePlayer)) then
					setPedAnimation(thePlayer, "BUDDY", "buddy_reload", 1000, false, false, false)
				end
				setTimer(giveReload, 1001, 1, thePlayer, weapon, ammo)
				triggerClientEvent(thePlayer, "cleanupUI", thePlayer)
			end
		end
	end
end
addCommandHandler("reload", reloadWeapon)

function checkFalling(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")
	if not (isPedOnGround(thePlayer)) and (reloading) then
		setElementData(thePlayer, "reloading.timer", nil)
		
		-- reset state
		setElementData(thePlayer, "reloading.timer", nil)
		setPedAnimation(thePlayer)
		setElementData(thePlayer, "reloading", false)
		toggleControl(thePlayer, "fire", true)
		toggleControl(thePlayer, "next_weapon", true)
		toggleControl(thePlayer, "previous_weapon", true)
	end
end

function giveReload(thePlayer, weapon, ammo)
	setElementData(thePlayer, "reloading.timer", nil)
	setPedAnimation(thePlayer)
	takeWeapon(thePlayer, weapon)
	giveWeapon(thePlayer, weapon, ammo, true)
	setElementData(thePlayer, "reloading", false)
	toggleControl(thePlayer, "fire", true)
	toggleControl(thePlayer, "next_weapon", true)
	toggleControl(thePlayer, "previous_weapon", true)
	exports.global:givePlayerAchievement(thePlayer, 14)
	exports.global:sendLocalMeAction(thePlayer, "reloads their " .. getWeaponNameFromID(weapon) .. ".")
end

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "r", "down", reloadWeapon)) then
			bindKey(arrayPlayer, "r", "down", reloadWeapon)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "r", "down", reloadWeapon)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function giveFakeBullet(weapon, ammo)
	setWeaponAmmo(source, weapon, ammo, 1)
end
addEvent("addFakeBullet", true)
addEventHandler("addFakeBullet", getRootElement(), giveFakeBullet)

function giveWeaponAmmoOnSwitch(weapon, ammo, ammoInClip)
	setWeaponAmmo(source, weapon, ammo, ammoInClip)
	
	-- weapon skill fixes
	setPedStat(source, 77, 999)
	setPedStat(source, 78, 999)
	setPedStat(source, 71, 999)
	setPedStat(source, 72, 999)
end
addEvent("giveWeaponOnSwitch", true)
addEventHandler("giveWeaponOnSwitch", getRootElement(), giveWeaponAmmoOnSwitch)