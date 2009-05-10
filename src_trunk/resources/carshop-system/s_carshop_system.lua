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

carshopPickup = createPickup(1947.6556396484, 2068.9575195313, 10.8203125, 3, 1239)
exports.pool:allocateElement(carshopPickup)

function pickupUse(thePlayer)
	triggerClientEvent(thePlayer, "showCarshopUI", thePlayer)
end
addEventHandler("onPickupHit", carshopPickup, pickupUse)

function buyCar(car, cost, id, col1, col2)
	outputChatBox("You bought a " .. car .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
	outputChatBox("You can set this vehicles spawn position by parking it and typing /vehpos", source, 255, 194, 14)
	outputChatBox("Press I and use your car key to unlock this vehicle.", source, 255, 194, 14)
	makeCar(source, car, cost, id, col1, col2)
end
addEvent("buyCar", true)
addEventHandler("buyCar", getRootElement(), buyCar)

function makeCar(thePlayer, car, cost, id, col1, col2)
	local rx = 0
	local ry = 0
	local rz = 358.8362426
	local x, y, z = 1941.2916259766, 2070.7336425781, 10.8203125

	
	setElementPosition(thePlayer, 1945.1477050781, 2069.2805175781, 10.8203125)
	setPedRotation(thePlayer, 93.608)
	
	local username = getPlayerName(thePlayer)
	local dbid = getElementData(thePlayer, "dbid")

	exports.global:takePlayerSafeMoney(thePlayer, cost)
				
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

	if (query) then
		mysql_free_result(query)
		local id = mysql_insert_id(handler)
							
		exports.global:givePlayerItem(thePlayer, 3, tonumber(id))
		setElementData(veh, "dbid", tonumber(id))
		setElementData(veh, "fuel", 100)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", dbid)
		setElementData(veh, "job", 0)
		setElementData(veh, "locked", locked)
		triggerEvent("onVehicleSpawn", veh)
		exports.global:givePlayerAchievement(thePlayer, 17) -- my ride
	end
end