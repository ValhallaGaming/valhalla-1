weapons = { }

function weaponSwitch(prevSlot, newSlot)
	local weapon = getPlayerWeapon(source, prevSlot)
	
	if (weapons[source] == nil) then
		weapons[source] = { }
	end
	
	if (weapon == 30 or weapon == 31) then
		if (weapons[source][1] == nil or weapons[source][2] ~= weapon or weapons[source][3] ~= isPedDucked(source)) then -- Model never created
			weapons[source][1] = createModel(source, weapon)
			weapons[source][2] = weapon
			weapons[source][3] = isPedDucked(source)
		else
			local object = weapons[source][1]
			destroyElement(object)
			weapons[source] = nil
		end
	elseif (weapons[source][1] ~= nil) then
		local object = weapons[source][1]
		destroyElement(object)
		weapons[source] = nil
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), weaponSwitch)

function createModel(player, weapon)
	local bx, by, bz = getPedBonePosition(player, 3)
	local x, y, z = getElementPosition(player)
	local r = getPedRotation(player)
				
	crouched = isPedDucked(player)
	
	local ox, oy, oz = bx-x-0.13, by-y-0.25, bz-z+0.25
	
	if (crouched) then
		oz = -0.025
	end
	
	local objectID = 355

	if (weapon==31) then
		objectID = 356
	elseif (weapon==30) then
		objectID = 355
	end
	
	local currobject = getElementData(source, "weaponback.object")
	if (isElement(currobject)) then
		destroyElement(currobject)
	end
	
	local object = createObject(objectID, x, y, z)
	local attach = attachElements(object, player, ox, oy, oz, 0, 60, 0)
	outputDebugString(tostring(attach))
	return object
end