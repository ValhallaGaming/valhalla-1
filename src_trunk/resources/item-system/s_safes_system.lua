-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

------------------------------------------------
-- CLIENT CALLS FROM SAFE RIGHT CLICK
------------------------------------------------
function moveItemToSafe(safe, itemID, itemValue, itemName)
	exports.global:takePlayerItem(source, itemID, itemValue)
	exports.global:giveSafeItem(safe, itemID, itemValue)
	updateSafeItems(safe)
end
addEvent("moveItemToSafe", true)
addEventHandler("moveItemToSafe", getRootElement(), moveItemToSafe)

function moveWeaponToSafe(safe, weaponID, weaponAmmo)
	exports.global:takeWeapon(source, weaponID)

	exports.global:giveSafeItem(safe, 9000+weaponID, weaponAmmo)
	updateSafeItems(safe)
end
addEvent("moveWeaponToSafe", true)
addEventHandler("moveWeaponToSafe", getRootElement(), moveWeaponToSafe)

function moveItemToPlayerFromSafe(safe, itemID, itemValue, itemName)
	exports.global:takeSafeItem(safe, itemID, itemValue)
	exports.global:givePlayerItem(source, itemID, itemValue)
	updateSafeItems(safe)
end
addEvent("moveItemToPlayerFromSafe", true)
addEventHandler("moveItemToPlayerFromSafe", getRootElement(), moveItemToPlayerFromSafe)

function moveWeaponToPlayerFromSafe(safe, weaponID, weaponAmmo)
	exports.global:giveWeapon(source, weaponID, weaponAmmo, true)

	exports.global:takeSafeItem(safe, 9000+weaponID, weaponAmmo)
	updateSafeItems(safe)
end
addEvent("moveWeaponToPlayerFromSafe", true)
addEventHandler("moveWeaponToPlayerFromSafe", getRootElement(), moveWeaponToPlayerFromSafe)

function updateSafeItems(safe)
	local dbid = getElementDimension(safe)
	local items = getElementData(safe, "items")
	local items_values = getElementData(safe, "itemvalues")
	local query = mysql_query(handler, "UPDATE interiors SET items='" .. items .. "', items_values='" .. items_values .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
	mysql_free_result(query)
end
