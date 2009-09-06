function resourceStart(res)
	setTimer(saveGuns, 60000, 0)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

local dontsave = { [35] = true, [36] = true, [37] = true, [38] = true, [16] = true, [18] = true, [39] = true, [40] = true }

local lastweaponstring = nil
local lastammostring = nil

function saveGuns()
	local loggedin = getElementData(getLocalPlayer(), "loggedin")
	
	if (loggedin==1) then
		local weaponstring = ""
		local ammostring = ""
		
		for i=0, 12 do
			local weapon = getPedWeapon(getLocalPlayer(), i)
			if weapon and not dontsave[weapon] then
				local ammo = math.min( getPedTotalAmmo(getLocalPlayer(), i), getElementData(getLocalPlayer(), "ACweapon" .. weapon) or 0 )
				
				if ammo > 0 then
					weaponstring = weaponstring .. weapon .. ";"
					ammostring = ammostring .. ammo .. ";"
				end
			end
		end
		
		if (ammostring~=lastammostring) or (weaponstring~=lastweaponstring) then -- only sync if it's changed
			triggerServerEvent("syncWeapons", getLocalPlayer(), weaponstring, ammostring)
			lastammostring = ammostring
			lastweaponstring = weaponstring
		end
	end
end

addEvent("saveGuns", true)
addEventHandler("saveGuns", getRootElement(), saveGuns)