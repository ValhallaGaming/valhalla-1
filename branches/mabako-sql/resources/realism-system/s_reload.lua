local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }

function reloadWeapon(thePlayer)
	local weapon = getPlayerWeapon(thePlayer)
	local ammo = getPlayerTotalAmmo(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")
	local jammed = getElementData(thePlayer, "jammed")
	
	if (reloading==false) and not (isPedInVehicle(thePlayer)) and ((jammed==0) or not jammed) then
		if (weapon) and (ammo) then
			if (weapon>21) and (weapon<35) and not (noReloadGuns[weapon]) then
				toggleControl(thePlayer, "fire", false)
				toggleControl(thePlayer, "next_weapon", false)
				toggleControl(thePlayer, "previous_weapon", false)
				setElementData(thePlayer, "reloading", true, false)
				setTimer(checkFalling, 100, 10, thePlayer)
				if not (isPedDucked(thePlayer)) then
					exports.global:applyAnimation(thePlayer, "BUDDY", "buddy_reload", 1000, false, true, true)
					toggleAllControls(thePlayer, true, true, true)
				end
				setTimer(giveReload, 1001, 1, thePlayer, weapon, ammo)
				triggerClientEvent(thePlayer, "cleanupUI", thePlayer, true)
			end
		end
	end
end
addCommandHandler("reload", reloadWeapon)

function checkFalling(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")
	if not (isPedOnGround(thePlayer)) and (reloading) then
		removeElementData(thePlayer, "reloading.timer")
		
		-- reset state
		removeElementData(thePlayer, "reloading.timer")
		exports.global:removeAnimation(thePlayer)
		setElementData(thePlayer, "reloading", false, false)
		toggleControl(thePlayer, "fire", true)
		toggleControl(thePlayer, "next_weapon", true)
		toggleControl(thePlayer, "previous_weapon", true)
	end
end

function giveReload(thePlayer, weapon, ammo)
	removeElementData(thePlayer, "reloading.timer")
	exports.global:removeAnimation(thePlayer)
	takeWeapon(thePlayer, weapon)
	giveWeapon(thePlayer, weapon, ammo, true)
	setElementData(thePlayer, "reloading", false, false)
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