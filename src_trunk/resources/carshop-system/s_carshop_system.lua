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

carshopPickup = createPickup(544.4990234375, -1292.7890625, 17.2421875, 3, 1239)
setElementData(carshopPickup, "shopid", 1, false)

boatshopPickup = createPickup(715.35546875, -1705.5791015625, 2.4296875, 3, 1239)
setElementData(boatshopPickup, "shopid", 2, false)

function pickupUse(thePlayer)
	if getElementData(source, "shopid") then
		if getElementData(thePlayer, "license.car") == 1 then
			triggerClientEvent(thePlayer, "showCarshopUI", thePlayer, getElementData(source, "shopid"))
		else
			outputChatBox("You need a Driving License to buy a car.", thePlayer, 255, 0, 0)
		end
	end
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), pickupUse)

function buyCar(id, cost, col1, col2, x, y, z, rz, px, py, pz, prz, shopID)
	if exports.global:hasMoney(source, cost) then
		outputChatBox("You bought a " .. getVehicleNameFromModel(id) .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
		
		if shopID == 1 then
			outputChatBox("You can set this vehicles spawn position by parking it and typing /park", source, 255, 194, 14)
			outputChatBox("Vehicles parked near the dealership or bus spawn point will be deleted without notice.", source, 255, 0, 0)
		elseif shopID == 2 then
			outputChatBox("You can set this boats spawn position by parking it and typing /park", source, 255, 194, 14)
			outputChatBox("Boats parked near the marina will be deleted without notice.", source, 255, 0, 0)
		end
		outputChatBox("If you do not use /park within an hour, your car will be DELETED.", source, 255, 0, 0)
		outputChatBox("Press 'K' to unlock this vehicle.", source, 255, 194, 14)
		makeCar(source, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
	end
end
addEvent("buyCar", true)
addEventHandler("buyCar", getRootElement(), buyCar)

function makeCar(thePlayer, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
	if not exports.global:takeMoney(thePlayer, cost) then
		return
	end
	
	local rx = 0
	local ry = 0
		
	setElementPosition(thePlayer, px, py, pz)
	setPedRotation(thePlayer, prz)
	
	local username = getPlayerName(thePlayer)
	local dbid = getElementData(thePlayer, "dbid")
	
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90))
	local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
	local locked = 0
		
	local query = mysql_query(handler, "INSERT INTO vehicles SET model='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', faction='-1', owner='" .. dbid .. "', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. rz .. "', locked='" .. locked .. "'")
	local insertid = tonumber( mysql_insert_id ( handler ) )
	if (query) then
		mysql_free_result(query)
		
		local veh = call( getResourceFromName( "vehicle-system" ), "createShopVehicle", insertid, id, x, y, z, 0, 0, rz, plate )
		exports.pool:allocateElement(veh)
		
		setElementData(veh, "fuel", 100)
		setElementData(veh, "Impounded", 0)
		
		setVehicleRespawnPosition(veh, x, y, z, 0, 0, rz)
		setElementData(veh, "respawnposition", {x, y, z, 0, 0, rz}, false)
		setVehicleLocked(veh, false)
		
		setVehicleColor(veh, col1, col2, col1, col2)
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		
		-- make sure it's an unique key
		call( getResourceFromName( "item-system" ), "deleteAll", 3, insertid )
		exports.global:giveItem( thePlayer, 3, insertid )
		
		setElementData(veh, "fuel", 100)
		setElementData(veh, "engine", 0, false)
		setElementData(veh, "oldx", x, false)
		setElementData(veh, "oldy", y, false)
		setElementData(veh, "oldz", z, false)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", dbid, false)
		setElementData(veh, "job", 0, false)
		setElementData(veh, "locked", locked, false)
		triggerEvent("onVehicleSpawn", veh, false)
		exports.global:givePlayerAchievement(thePlayer, 17) -- my ride
		
		exports.logs:logMessage("[CAR SHOP] " .. getPlayerName( thePlayer ) .. " bought car #" .. insertid .. " (" .. getVehicleNameFromModel( id ) .. ")", 9)
	end
end
