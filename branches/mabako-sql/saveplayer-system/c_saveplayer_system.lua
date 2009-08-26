function resourceStart(res)
	setTimer(saveGuns, 15000, 0)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

local dontsave = { [35] = true, [36] = true, [37] = true, [38] = true, [16] = true, [18] = true, [39] = true, [40] = true }
function saveGuns()
	local loggedin = getElementData(getLocalPlayer(), "loggedin")
	
	if (loggedin==1) then
		local weaponstring = ""
		local ammostring = ""
		
		for i=0, 12 do
			local weapon = getPedWeapon(getLocalPlayer(), i)
			if weapon and not dontsave[weapon] then
				local ammo = getPedTotalAmmo(getLocalPlayer(), i)
				
				if ammo > 0 then
					weaponstring = weaponstring .. weapon .. ";"
					ammostring = ammostring .. ammo .. ";"
				end
			end
		end
		setElementData(getLocalPlayer(), "weapons", weaponstring, true)
		setElementData(getLocalPlayer(), "ammo", ammostring, true)
	end
end
addEvent("saveGuns", true)
addEventHandler("saveGuns", getRootElement(), saveGuns)