local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
savedAmmo = { }

function weaponAmmo(prevSlot, currSlot)
	cleanupUI()
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), weaponAmmo)

function disableAutoReload(weapon, ammo, ammoInClip)
	if (ammoInClip==1) and ((ammo-ammoInClip)>0) and not (noReloadGuns[weapon]) and (weapon>21) and (weapon<35) and not (isPedInVehicle(getLocalPlayer())) and not getElementData(getLocalPlayer(), "deagle:reload") and not getElementData(getLocalPlayer(), "scoreboard:reload") then
		-- Message to reload
		addEventHandler("onClientRender", getRootElement(), drawText)
		
		-- this bullet cant be fired and will prevent the reload event from firing off within the SA client
		toggleControl("fire", false)
		setTimer(toggleControl, 100, 1, "fire", false)
		triggerServerEvent("addFakeBullet", getLocalPlayer(), weapon, ammo)
	else
		cleanupUI()
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), disableAutoReload)

function drawText()
	local scrWidth, scrHeight = guiGetScreenSize()
	dxDrawText("Hit 'R' to Reload!", 0, 0, scrWidth, scrHeight, tocolor(255, 255, 255, 170), 1.02, "pricedown", "center", "bottom")
end

function cleanupUI(bplaySound)
	if (bplaySound) then
		playSound("reload.wav")
		setTimer(playSound, 500, 1, "reload.wav")
	end
	removeEventHandler("onClientRender", getRootElement(), drawText)
end
addEvent("cleanupUI", true)
addEventHandler("cleanupUI", getRootElement(), cleanupUI)

function danielWhite()
	outputChatBox("Easter Egg, courtesy of Daniel White <3", 255, 194, 14)
	playSound("whoopee.wav", false)
end
addCommandHandler("danielwhite", danielWhite)