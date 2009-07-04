local objectmade = false
local crouched = nil
local weapon = nil



function weaponSwitched()
	-- SLOT 5
	
	if (getCameraTarget()~=getLocalPlayer()) and (objectmade) then
		objectmade = false
		triggerServerEvent("destroyWeaponBackModel", getLocalPlayer())
		return
	end
	
	local seat = getElementData(getLocalPlayer(), "seat")
	
	if (seat) and (objectmade) then
		objectmade = false
		triggerServerEvent("destroyWeaponBackModel", getLocalPlayer())
		return
	end
	
	if (getPedWeaponSlot(getLocalPlayer())~=5 and getPedWeapon(getLocalPlayer(), 5)~=0) and not (isPedInVehicle(getLocalPlayer())) and not (seat) then
		local weap = getPedWeapon(getLocalPlayer(), 5)
		if (weap==30 or weap==31) then
			if not (objectmade) or (isPedDucked(getLocalPlayer())~=crouched) or (weap~=weapon) then -- no object, so lets create it
				local bx, by, bz = getPedBonePosition(getLocalPlayer(), 3)
				local x, y, z = getElementPosition(getLocalPlayer())
				local r = getPedRotation(getLocalPlayer())
				weapon = weap
				crouched = isPedDucked(getLocalPlayer())
				
				local ox, oy, oz = bx-x-0.13, by-y-0.25, bz-z+0.25
				
				if (crouched) then
					oz = -0.025
				end
				
				triggerServerEvent("createWeaponBackModel", getLocalPlayer(), ox, oy, oz, weapon)
				objectmade = true
			end
		end
	else
		if (objectmade) then
			objectmade = false
			triggerServerEvent("destroyWeaponBackModel", getLocalPlayer())
		end
	end
end
addEventHandler("onClientRender", getRootElement(), weaponSwitched)