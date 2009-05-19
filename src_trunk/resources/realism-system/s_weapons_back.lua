function createWeaponModelOnBack(x, y, z, weapon)
	local objectID = 355

	if (weapon==31) then
		objectID = 356
	elseif (weapon==30) then
		objectID = 355
	end
	
	local currobject = getElementData(source, "weaponback.object")
	if (currobject~=nil) then
		destroyElement(currobject)
	end
	
	local object = createObject(objectID, x, y, z)
	exports.pool:allocateElement(object)
	setElementData(source, "weaponback.object", object)
	attachElements(object, source, x, y, z, 0, 60, 0)
end
addEvent("createWeaponBackModel", true)
addEventHandler("createWeaponBackModel", getRootElement(), createWeaponModelOnBack)


function destroyWeaponModelOnBack()
	local currobject = getElementData(source, "weaponback.object")

	if (currobject) then
		destroyElement(currobject)
	end
end
addEvent("destroyWeaponBackModel", true)
addEventHandler("destroyWeaponBackModel", getRootElement(), destroyWeaponModelOnBack)