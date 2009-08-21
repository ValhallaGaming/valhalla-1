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
		triggerClientEvent(thePlayer, "showCarshopUI", thePlayer, getElementData(source, "shopid"))
	end
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), pickupUse)

function buyCar(id, cost, col1, col2, x, y, z, rz, px, py, pz, prz, shopID)
	if not getElementData(source, "money") then return end
	
	local safemoney = tonumber(getElementData(source, "money"))
	local hackmoney = getPlayerMoney(source)
	if (safemoney == hackmoney and safemoney >= tonumber(cost)) then
		outputChatBox("You bought a " .. getVehicleNameFromModel(id) .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
		
		if shopID == 1 then
			outputChatBox("You can set this vehicles spawn position by parking it and typing /vehpos", source, 255, 194, 14)
			outputChatBox("Vehicles parked near the dealership or bus spawn point will be deleted without notice.", source, 255, 0, 0)
		elseif shopID == 2 then
			outputChatBox("You can set this boats spawn position by parking it and typing /vehpos", source, 255, 194, 14)
			outputChatBox("Boats parked near the marina will be deleted without notice.", source, 255, 0, 0)
		end
		outputChatBox("If you do not use /vehpos within an hour, your car will be DELETED.", source, 255, 0, 0)
		outputChatBox("Press 'K' to unlock this vehicle.", source, 255, 194, 14)
		makeCar(source, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
	end
end
addEvent("buyCar", true)
addEventHandler("buyCar", getRootElement(), buyCar)

local destroyTimers = { }
function makeCar(thePlayer, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
	local rx = 0
	local ry = 0
		
	setElementPosition(thePlayer, px, py, pz)
	setPedRotation(thePlayer, prz)
	
	local username = getPlayerName(thePlayer)
	local dbid = getElementData(thePlayer, "dbid")
		
	exports.global:takePlayerSafeMoney(thePlayer, tonumber(cost))
		
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90))
	local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
		
	local veh = createVehicle(id, x, y, z, 0, 0, rz, plate)
	exports.pool:allocateElement(veh)
	
	setElementData(veh, "fuel", 100)
	setElementData(veh, "Impounded", 0)
	
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
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", dbid, false)
		setElementData(veh, "job", 0, false)
		setElementData(veh, "locked", locked, false)
		triggerEvent("onVehicleSpawn", veh, false)
		exports.global:givePlayerAchievement(thePlayer, 17) -- my ride
		
		setElementData(veh, "requires.vehpos", 1, false)
		local timer = setTimer(checkVehpos, 3600000, 1, veh, insertid)
		table.insert(destroyTimers, {timer, insertid})
	end
end

function checkVehpos(veh, insertid)
	local requires = getElementData(veh, "requires.vehpos")
	
	if (requires) then
		if (requires==1) then
			local id = tonumber(getElementData(veh, "dbid"))
			
			if (id==insertid) then
				exports.irc:sendAdminMessage("Removing vehicle #" .. id .. " (Did not get Vehpossed).")
				destroyElement(veh)
				local query = mysql_query(handler, "DELETE FROM vehicles WHERE id='" .. id .. "' LIMIT 1")
				mysql_free_result(query)
			end
		end
	end
end

-- VEHPOS
function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local owner = getElementData(veh, "owner")
		local dbid = getElementData(veh, "dbid")
		local TowingReturn = call(getResourceFromName("tow-system"), "CanTowTruckDriverVehPos", thePlayer) -- 2 == in towing and in col shape, 1 == colshape only, 0 == not in col shape
		if (exports.global:isPlayerAdmin(thePlayer)) or (owner==playerid and TowingReturn == 0) or (exports.global:doesPlayerHaveItem(thePlayer, 3, dbid)) or (TowingReturn == 2) then
			if (dbid<0) then
				outputChatBox("This vehicle is not permanently spawned.", thePlayer, 255, 0, 0)
			else
				if (call(getResourceFromName("tow-system"), "CanTowTruckDriverGetPaid", thePlayer)) then
					call(getResourceFromName("faction-system"), "addToFactionMoney", 24, 75)
					call(getResourceFromName("faction-system"), "addToFactionMoney", 1, 75)
				end
				removeElementData(veh, "requires.vehpos")
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)
				
				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)
				
				local query = mysql_query(handler, "UPDATE vehicles SET x='" .. x .. "', y='" .. y .."', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "', interior='" .. interior .. "', currinterior='" .. interior .. "', dimension='" .. dimension .. "', currdimension='" .. dimension .. "' WHERE id='" .. dbid .. "'")
				mysql_free_result(query)
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				outputChatBox("Vehicle spawn position set.", thePlayer)
				
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == dbid) then
						local timer = destroyTimers[key][1]
						
						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)