local jamcount = 0
local pJam = nil
local state = 0
local jammed = false

function playerFired(weapon, ammo, ammoInClip, x, y, z, element)
	if (weapon==30 or weapon==31) then
		local chance = math.random(1,300)
		if (chance==1) then
			jamcount = 0
			state = 0
			jammed = true
			
			if (pJam) then
				destroyElement(pJam)
			end
			
			pJam = guiCreateProgressBar(0.425, 0.75, 0.2, 0.035, true)
			outputChatBox("Your weapon has jammed, Tap - and = in order to unjam your weapons.", 255, 0, 0)
			local slot = getPedWeaponSlot(getLocalPlayer())
			triggerServerEvent("togglefiring", getLocalPlayer(), false, true)
			bindKey("-", "down", unjamWeapon)
			setElementData(getLocalPlayer(), "jammed", 1, true)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), playerFired)

function unjamWeapon()
	if (state==0) then
		bindKey("=", "down", unjamWeapon)
		unbindKey("-", "down", unjamWeapon)
		state = 1
	elseif (state==1) then
		bindKey("-", "down", unjamWeapon)
		unbindKey("=", "down", unjamWeapon)
		state = 0
	end
	
	jamcount = jamcount + 5
	guiProgressBarSetProgress(pJam, jamcount)
	
	if (jamcount>=100) then
		jammed = false
		setElementData(getLocalPlayer(), "jammed", 0, true)
		destroyElement(pJam)
		triggerServerEvent("togglefiring", getLocalPlayer(), true)
		outputChatBox("Your weapon is now unjammed.", 0, 255, 0)
		unbindKey("-", "down", unjamWeapon)
		unbindKey("=", "down", unjamWeapon)
	end
end

function weaponChangedJammed(prev, curr)

	if (curr==5) then
		if (jammed) then
			setElementData(getLocalPlayer(), "jammed", 1, true)
			pJam = guiCreateProgressBar(0.425, 0.75, 0.2, 0.035, true)
			outputChatBox("Your weapon has jammed, Tap - and = in order to unjam your weapons.", 255, 0, 0)
			local slot = getPedWeaponSlot(getLocalPlayer())
			triggerServerEvent("togglefiring", getLocalPlayer(), false)
			bindKey("-", "down", unjamWeapon)
		end
	elseif	(prev==5) then
		jamcount = 0
		state = 0
		
		if (pJam) then
			destroyElement(pJam)
		end
		
		triggerServerEvent("togglefiring", getLocalPlayer(), true)
		setElementData(getLocalPlayer(), "jammed", 0, true)
		unbindKey("-", "down", unjamWeapon)
		unbindKey("=", "down", unjamWeapon)
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), weaponChangedJammed)