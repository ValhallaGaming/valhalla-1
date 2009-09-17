local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
local clipSize = { [22]=17, [23]=17, [24]=7, [26]=2, [27]=7, [28]=50, [29]=30, [30]=30, [31]=50, [32]=50 }

function reloadWeapon(thePlayer)
	local weapon = getPlayerWeapon(thePlayer)
	local ammo = getPlayerTotalAmmo(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")
	local jammed = getElementData(thePlayer, "jammed")
	
	if (reloading==false) and not (isPedInVehicle(thePlayer)) and ((jammed==0) or not jammed) then
		if (weapon) and (ammo) then
			if (weapon>21) and (weapon<35) and not (noReloadGuns[weapon]) and not getElementData(thePlayer, "deagle:reload") and not getElementData(thePlayer, "scoreboard:reload") then
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
	local clipsize = 0
	removeElementData(thePlayer, "reloading.timer")
	exports.global:removeAnimation(thePlayer)
	if (ammo < clipSize[weapon]) then
		clipsize = ammo
	else
		clipsize = clipSize[weapon]
	end
	exports.global:setWeaponAmmo(thePlayer, weapon, ammo, clipsize) -- fix for the ammo adding up bug
	--takeWeapon(thePlayer, weapon)
	--giveWeapon(thePlayer, weapon, ammo, true)
	setElementData(thePlayer, "reloading", false, false)
	toggleControl(thePlayer, "fire", true)
	toggleControl(thePlayer, "next_weapon", true)
	toggleControl(thePlayer, "previous_weapon", true)
	exports.global:givePlayerAchievement(thePlayer, 14)
	--exports.global:sendLocalMeAction(thePlayer, "reloads their " .. getWeaponNameFromID(weapon) .. ".")
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
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function giveFakeBullet(weapon, ammo)
	exports.global:setWeaponAmmo(source, weapon, ammo, 1)
end
addEvent("addFakeBullet", true)
addEventHandler("addFakeBullet", getRootElement(), giveFakeBullet)