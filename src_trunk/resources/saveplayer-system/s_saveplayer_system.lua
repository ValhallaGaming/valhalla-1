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
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("savePlayer", value, "Save All")
	end
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

function saveWeapons(thePlayer)
	local weapons = getElementData(thePlayer, "weapons")
	local ammo = getElementData(thePlayer, "ammo")

	if (weapons~=false) and (ammo~=false) then
		mysql_query(handler, "UPDATE characters SET weapons='" .. weapons .. "', ammo='" .. ammo .. "' WHERE charactername='" .. getPlayerName(source) .. "'")
	end
end

function savePlayer(reason)
	local logged = getElementData(source, "loggedin")

	if (logged==1) then
		saveWeapons(source)
		
		local vehicle = getPedOccupiedVehicle(source)
		
		if (vehicle) then
			--exports.savevehicle-system:saveVehicleOnExit(source, getPedOccupiedVehicleSeat(source), vehicle)
			local seat = getPedOccupiedVehicleSeat(source)
			triggerEvent("onVehicleExit", vehicle, source, seat)
		end
		
		removePedFromVehicle(source)
		
		local x, y, z, rot, tag, health, armour, interior, dimension, username, cuffed, skin, muted, hiddenAdmin, radiochannel, duty, adminduty, globalooc, fightstyle, blur, casualskin, adminreports
		
		username = getPlayerName(source)
		
		x, y, z = getElementPosition(source)
		rot = getPedRotation(source)
		health = getElementHealth(source)
		armor = getPedArmor(source)
		interior = getElementInterior(source)
		dimension = getElementDimension(source)
		money = getElementData(source, "money")
		cuffed = getElementData(source, "restrain")
		skin = getElementModel(source)
		
		muted = getElementData(source, "muted")
		hiddenAdmin = getElementData(source, "hiddenadmin")
		
		fightstyle = getPedFightingStyle(source)
		
		radiochannel = getElementData(source, "radiochannel")
		duty = getElementData(source, "duty")
		adminduty = getElementData(source, "adminduty")
		globalooc = getElementData(source, "globalooc")
		blur = getElementData(source, "blur")
		
		adminreports = getElementData(source, "adminreports")
		
		casualskin = getElementData(source, "casualskin")
		
		local bankmoney = getElementData(source, "bankmoney")
		
		local gameAccountUsername = getElementData(source, "gameaccountusername")
		local safegameAccountUsername = mysql_escape_string(handler, gameAccountUsername)
		
		local items = getElementData(source, "items")
		local itemvalues = getElementData(source, "itemvalues")
		
		tag = getElementData(source, "tag")
		
		if not (items) then
			items = ""
		end
		
		if not (itemvalues) then
			itemvalues = ""
		end
		
		if not (duty) then
			duty = 0
		end
		
		-- LAST LOGIN
		local time = getRealTime()
		local yearday = time.yearday
		local year = (1900+time.year)	
		
		-- LAST AREA
		local zone = getElementZoneName(source)
		
		local update = mysql_query(handler, "UPDATE characters SET casualskin='" .. casualskin .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotation='" .. rot .. "', health='" .. health .. "', armor='" .. armor .. "', skin='" .. skin .. "', dimension_id='" .. dimension .. "', interior_id='" .. interior .. "', money='" .. money .. "', cuffed='" .. cuffed .. "', radiochannel='" .. radiochannel .. "', duty='" .. duty .. "', fightstyle='" .. fightstyle .. "', yearday='" .. yearday .. "', year='" .. year .. "', lastarea='" .. zone .. "', items='" .. items .. "', itemvalues='" .. itemvalues .. "', bankmoney='" .. bankmoney .. "', tag='" .. tag .. "' WHERE charactername='" .. username .. "'")
		local update2 = mysql_query(handler, "UPDATE accounts SET muted='" .. muted .. "', hiddenadmin='" .. hiddenAdmin .. "', adminduty='" .. adminduty .. "', globalooc='" .. globalooc .. "', blur='" .. blur .. "', adminreports='" .. adminreports .. "' WHERE username='" .. tostring(safegameAccountUsername) .. "'")
		
		if (update) then
			mysql_free_result(update)
		end
		
		if (update2) then
			mysql_free_result(update2)
		end
		
		outputDebugString("Saved player '" .. getPlayerName(source) .. "' [" .. reason .. "].")
	end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)