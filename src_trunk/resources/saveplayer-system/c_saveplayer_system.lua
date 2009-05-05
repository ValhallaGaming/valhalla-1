function resourceStart(res)
	if (res==getThisResource()) then
		setTimer(saveGuns, 15000, 0)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resourceStart)

function saveGuns()
	local loggedin = getElementData(getLocalPlayer(), "loggedin")
	
	if (loggedin==1) then
		local weaponstring = ""
		local ammostring = ""
		
		for i=0, 12 do
			local weapon = tostring(getPedWeapon(getLocalPlayer(), i))
			local ammo = tostring(getPedTotalAmmo(getLocalPlayer(), i))
			
			weaponstring = weaponstring .. weapon .. ";"
			ammostring = ammostring .. ammo .. ";"
		end
		setElementData(getLocalPlayer(), "weapons", weaponstring)
		setElementData(getLocalPlayer(), "ammo", ammostring)
	end
end