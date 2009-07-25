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

carshopPickup = createPickup(-2433.3547363281, 2313.8015136719, 4.984375, 3, 1239)
exports.pool.allocatePickup(carshopPickup)
blip = createBlip(-2433.3547363281, 2313.8015136719, 4.984375, 9)
exports.pool:allocateElement(blip)

function pickupUse(thePlayer)
	triggerClientEvent(thePlayer, "showBoatshopUI", thePlayer)
end
addEventHandler("onPickupHit", carshopPickup, pickupUse)

function buyCar(car, cost, id, col1, col2)
	outputChatBox("You bought a " .. car .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
	outputChatBox("You can set this boats spawn position by parking it and typing /vehpos", source, 255, 194, 14)
	outputChatBox("Press I and use your car key to unlock this boat.", source, 255, 194, 14)
	makeCar(source, car, cost, id, col1, col2)
end
addEvent("buyBoat", true)
addEventHandler("buyBoat", getRootElement(), buyCar)

function SmallestVehicleID( ) --  Loop which finds the smallest ID in the SQL instead of the biggest one.
	UsedID = {}		
	local id = 0
	local answer = 2 -- 0 = ID = 1 . 1 =Suitable ID found. 2= Still searching for ID.
	local highest = 0
	local result = mysql_query(handler, "SELECT id FROM vehicles")
	if(result) then
		for result, row in mysql_rows(result) do
						
				UsedID[tonumber(row[1])] = 1
				if (tonumber(row[1]) > highest) then
					highest = tonumber(row[1])
				end

		end
		
	end

	if(highest > 0) then
		for i = 1, highest do
			if(UsedID[i] ~= 1) then
				answer = 1
				id = i
				break
			end
		end
	else
		answer = 0
		id = 1

	end
	
	if(answer == 2) then
		answer = 1
		id = highest + 1

	end
	if(answer ~= 2) then
		return id
	else
		return false
	end
end

function makeCar(thePlayer, car, cost, id, col1, col2)
	local rx = 0
	local ry = 0
	local rz = 270
	local x, y, z = -2414.4711914063, 2304.0166015625, -0.55000001192093

	
	setElementPosition(thePlayer, -2416.708984375, 2310.5837402344, 1.5305557250977)
	setPedRotation(thePlayer, 188)
	
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
	
	local insertid = SmallestVehicleID()
	
	local query = mysql_query(handler, "INSERT INTO vehicles SET id='" .. insertid .. "', model='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', faction='-1', owner='" .. dbid .. "', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. rz .. "', locked='" .. locked .. "'")

	if (query) then
		mysql_free_result(query)
							
		exports.global:givePlayerItem(thePlayer, 3, tonumber(id))
		setElementData(veh, "dbid", tonumber(insertid), false)
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
	end
end