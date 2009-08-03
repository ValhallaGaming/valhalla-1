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

carshopPickup = createPickup(715.35546875, -1705.5791015625, 2.4296875, 3, 1239)
exports.pool.allocatePickup(carshopPickup)

function pickupUse(thePlayer)
	triggerClientEvent(thePlayer, "showBoatshopUI", thePlayer)
end
addEventHandler("onPickupHit", carshopPickup, pickupUse)

function buyCar(car, cost, id, col1, col2)
	outputChatBox("You bought a " .. car .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
	outputChatBox("You can set this boats spawn position by parking it and typing /vehpos", source, 255, 194, 14)
	outputChatBox("Boats parked near the marina will be deleted without notice.", source, 255, 0, 0)
	outputChatBox("Press I and use your car key to unlock this boat.", source, 255, 194, 14)
	makeCar(source, car, cost, id, col1, col2)
end
addEvent("buyBoat", true)
addEventHandler("buyBoat", getRootElement(), buyCar)

function makeCar(thePlayer, car, cost, id, col1, col2)
	local rx = 0
	local ry = 0
	local rz = 180
	local x, y, z = 721.080078125, -1700.4033203125, -0.55000001192093

	
	setElementPosition(thePlayer, 715.27734375, -1702.7392578125, 2.4296875)
	setPedRotation(thePlayer, 270.99563598633)
	
	local username = getPlayerName(thePlayer)
	local dbid = getElementData(thePlayer, "dbid")

	exports.global:takePlayerSafeMoney(thePlayer, tonumber(cost))
				
	local letter1 = exports.global:randChar()
	local letter2 = exports.global:randChar()
	local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
	
	local veh = createVehicle(id, x, y, z, 0, 0, rz, plate)
	exports.pool:allocateElement(veh)
					
	setElementData(veh, "fuel", 100)
	
	setVehicleRespawnPosition(veh, x, y, z, 0, 0, rz)
	setVehicleLocked(veh, false)
	local locked = 0
	
	setVehicleColor(veh, col1, col2, col1, col2)
						
	setVehicleOverrideLights(veh, 1)
	setVehicleEngineState(veh, false)
	setVehicleFuelTankExplodable(veh, false)
	
	local query = mysql_query(handler, "INSERT INTO vehicles SET model='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', faction='-1', owner='" .. dbid .. "', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. rz .. "', locked='" .. locked .. "'")
	local insertid = mysql_insert_id ( handler )
	if (query) then
		mysql_free_result(query)
							
		exports.global:givePlayerItem(thePlayer, 3, tonumber(insertid))
		setElementData(veh, "dbid", tonumber(insertid))
		setElementData(veh, "fuel", 100)
		setElementData(veh, "engine", 0, false)
		setElementData(veh, "oldx", x, false)
		setElementData(veh, "oldy", y, false)
		setElementData(veh, "oldz", z, false)
		setElementData(veh, "faction", -1, false)
		setElementData(veh, "owner", dbid, false)
		setElementData(veh, "job", 0, false)
		setElementData(veh, "locked", locked, false)
		triggerEvent("onVehicleSpawn", veh)
		exports.global:givePlayerAchievement(thePlayer, 27) -- boat trip
		
		setElementData(veh, "requires.vehpos", 1, false)
		setTimer(checkVehpos, 3600000, 1, veh)
	end
end

function checkVehpos(veh)
	local requires = getElementData(veh, "requires.vehpos")
	
	if (requires) then
		if (requires==1) then
			local id = tonumber(getElementData(veh, "dbid"))
			exports.irc:sendMessage("Removing vehicle #" .. id .. " (Did not get Vehpossed).")
			destroyElement(veh)
			mysql_query(handler, "DELETE FROM vehicles WHERE id='" .. id .. "' LIMIT 1")
		end
	end
end