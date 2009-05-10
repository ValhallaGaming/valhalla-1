armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
totalTempVehicles = 0

-- EVENTS
addEvent("onVehicleDelete", false)

-- /unflip
function unflipCar(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in  vehicle.", thePlayer, 255, 0, 0)
		else
			local veh = getPedOccupiedVehicle(thePlayer)
			local rx, ry, rz = getVehicleRotation(veh)
			setVehicleRotation(veh, 0, ry, rz)
			outputChatBox("Your car was unflipped!", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

-- /unlockcivcars
function unlockAllCivilianCars(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local count = 0
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			local id = getElementData(value, "dbid")
			
			if (id>=0) then
				local owner = getElementData(value, "owner")
				if (owner==-2) then
					setVehicleLocked(value, false)
					count = count + 1
				end
			end
		end
		
		outputChatBox("Unlocked " .. count .. " civilian vehicles.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)

-- /veh
function createTempVehicle(thePlayer, commandName, id, col1, col2)

	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) or not (col1) or not (col2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id] [color1] [color2]", thePlayer, 255, 194, 14)
		else
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			local letter1 = exports.global:randChar()
			local letter2 = exports.global:randChar()
			local letter3 = exports.global:randChar()
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
			
			local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
			exports.pool:allocateElement(veh)
			
			if (armoredCars[(tonumber(id))]) then
				setVehicleDamageProof(veh, true)
			end
			
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				setElementData(veh, "fuel", 100)
				
				setVehicleColor(veh, col1, col2, col1, col2)
				
				setVehicleOverrideLights(veh, 1)
				setVehicleEngineState(veh, false)
				setVehicleFuelTankExplodable(veh, false)
				
				totalTempVehicles = totalTempVehicles + 1
				local dbid = (-totalTempVehicles)
				
				setElementData(veh, "dbid", dbid)
				setElementData(veh, "fuel", 100)
				setElementData(veh, "engine", 0)
				setElementData(veh, "oldx", x)
				setElementData(veh, "oldy", y)
				setElementData(veh, "oldz", z)
				setElementData(veh, "faction", -1)
				setElementData(veh, "owner", -1)
				setElementData(veh, "job", 0)
				outputChatBox(getVehicleName(veh) .. " spawned with TEMP ID " .. dbid .. ".", thePlayer, 255, 194, 14)
			end
		end
	end
end

addCommandHandler("veh", createTempVehicle, false, false)
	
-- /oldcar
function getOldCarID(thePlayer, commandName)
	local oldvehid = getElementData(thePlayer, "lastvehid")
	
	if not (oldvehid) then
		outputChatBox("You have not been in a vehicle yet.", thePlayer, 255, 0, 0)
	else
		outputChatBox("Old Vehicle ID: " .. tostring(oldvehid) .. ".", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("oldcar", getOldCarID, false, false)

-- /thiscar
function getCarID(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	
	if (veh) then
		local dbid = getElementData(veh, "dbid")
		outputChatBox("Current Vehicle ID: " .. dbid, thePlayer, 255, 194, 14)
	else
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("thiscar", getCarID, false, false)

-- /gotocar
function gotoCar(thePlayer, commandNAme, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			ooutputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local vehicles = exports.pool:getPoolElementsByType("vehicle")
			local counter = 0
			
			for k, theVehicle in ipairs(vehicles) do
				local dbid = getElementData(theVehicle, "dbid")

				if (dbid==tonumber(id)) then
					local rx, ry, rz = getVehicleRotation(theVehicle)
					local x, y, z = getElementPosition(theVehicle)
					x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
					y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )
					
					setElementPosition(thePlayer, x, y, z)
					setPedRotation(thePlayer, rz)
					
					counter = counter + 1
					outputChatBox("Teleported to vehicles location.", thePlayer, 255, 194, 14)
				end
			end
			
			if (counter==0) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)

-- /getcar
function getCar(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local vehicles = exports.pool:getPoolElementsByType("vehicle")
			local counter = 0
			
			for k, theVehicle in ipairs(vehicles) do
				local dbid = getElementData(theVehicle, "dbid")

				if (dbid==tonumber(id)) then
					local r = getPedRotation(thePlayer)
					local x, y, z = getElementPosition(thePlayer)
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
					
					if	(getElementHealth(theVehicle)==0) then
						spawnVehicle(theVehicle, x, y, z, 0, 0, r)
					else
						setElementPosition(theVehicle, x, y, z)
						setVehicleRotation(theVehicle, 0, 0, r)
					end
					
					counter = counter + 1
					outputChatBox("Vehicle teleported to your location.", thePlayer, 255, 194, 14)
				end
			end
			
			if (counter==0) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)

function getNearbyVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition( thePlayer )
        local objSphere = createColSphere( posX, posY, posZ, 20 )
		exports.pool:allocateElement(objSphere)
        local nearbyVehicles = getElementsWithinColShape( objSphere, "vehicle" )
        destroyElement( objSphere )
		outputChatBox("Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0
		
        for index, nearbyVehicle in ipairs( nearbyVehicles ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			local vehicleID = getElementModel(nearbyVehicle)
			local vehicleName = getVehicleNameFromModel(vehicleID)
			
			count = count + 1
			
			if (thisvehid) then
				outputChatBox("   " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ".", thePlayer, 255, 126, 0)
			elseif not (thisvehid) then
				outputChatBox("   " ..  "*Temporary* " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ".", thePlayer, 255, 126, 0)
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyvehicles", getNearbyVehicles, false, false)

function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /respawnveh [id]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			local vehicles = exports.pool:getPoolElementsByType("vehicle")
			local counter = 0
			
			for k, theVehicle in ipairs(vehicles) do
				local dbid = getElementData(theVehicle, "dbid")

				if (dbid==tonumber(id)) then
					if (dbid<0) then -- TEMP vehicle
						fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
						setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					else
						local dbid = getElementData(theVehicle, "dbid")
						local x, y, z = getElementPosition(theVehicle)
						local faction = getElementData(theVehicle, "faction")
						local owner = getElementData(theVehicle, "owner")
						
						respawnVehicle(theVehicle)
						
						if (owner==-2) then
							setVehicleLocked(theVehicle, false)
							setElementData(theVehicle, "locked", 0)
						else
							setElementData(theVehicle, "locked", 1)
						end
					end
					counter = counter + 1
					
					outputChatBox("Vehicle respawned.", thePlayer, 255, 194, 14)
				end
			end
			
			if (counter==0) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)

function respawnAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local failedcounter = 0
		local tempcounter = 0
		
		-- Remove all players from vehicles
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			if (isPedInVehicle(value)) then
				removePedFromVehicle(value)
			end
		end
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if (dbid<0) then -- TEMP vehicle
				destroyElement(theVehicle)
				tempcounter = tempcounter + 1
			else
				local res = respawnVehicle(theVehicle)
				if not (res) then
					failedcounter = failedcounter + 1
				end
				counter = counter + 1
			end
		end
		outputChatBox(" =-=-=-=-=-=- All Vehicles Respawned =-=-=-=-=-=-=")
		outputChatBox("Respawned " .. counter .. " vehicles.", thePlayer)
		outputChatBox("Deleted " .. tempcounter .. " temporary vehicles.", thePlayer)
		unlockAllCivilianCars(thePlayer, "unlockcivcars")
		exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " respawned all vehicles. (FAILED: " .. failedcounter .. ").")
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function addUpgrade(thePlayer, commandName, target, upgradeID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (upgradeID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Upgrade ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					local success = addVehicleUpgrade(theVehicle, upgradeID)
					local targetPlayerName = getPlayerName(targetPlayer)
					
					if (success) then
						outputChatBox(getVehicleUpgradeSlotName(upgradeID) .. " upgrade added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Admin " .. username .. " added upgrade " .. getVehicleUpgradeSlotName(upgradeID) .. " to your vehicle.", targetPlayer)
					else
						outputChatBox("Invalid Upgrade ID, or this vehicle doesn't support this upgrade.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("addupgrade", addUpgrade, false, false)

function findVehID(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Name]", thePlayer, 255, 194, 14)
		else
			local vehicleName = table.concat({...}, " ")
			local carID = getVehicleModelFromName(vehicleName)
			
			if (carID) then
				local fullName = getVehicleNameFromModel(carID)
				outputChatBox(fullName .. ": ID " .. carID .. ".", thePlayer)
			else
				outputChatBox("Vehicle not found.", thePlayer, 255, 0 , 0)
			end
		end
	end
end
addCommandHandler("findvehid", findVehID, false, false)
	
-----------------------------[FIX VEH]---------------------------------
function fixPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						outputChatBox("You repaired " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Your vehicle was repaired by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)

-----------------------------[FIX VEH VIS]---------------------------------
function fixPlayerVehicleVisual(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local health = getElementHealth(veh)
						fixVehicle(veh)
						setElementHealth(veh, health)
						outputChatBox("You repaired " .. targetPlayerName .. "'s vehicle visually.", thePlayer)
						outputChatBox("Your vehicle was visually repaired by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixvehvis", fixPlayerVehicleVisual, false, false)

-----------------------------[BLOW CAR]---------------------------------
function blowPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						blowVehicle(veh)
						outputChatBox("You blew up " .. targetPlayerName .. "'s vehicle.", thePlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("blowveh", blowPlayerVehicle, false, false)

-----------------------------[SET CAR HP]---------------------------------
function setCarHP(thePlayer, commandName, target, hp)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Health]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))
						
						if (sethp) then
							outputChatBox("You set " .. targetPlayerName .. "'s vehicle health to " .. hp .. ".", thePlayer)
						else
							outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)

function fixAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
		end
		outputChatBox("All vehicles repaired by Admin " .. username .. ".")
	end
end
addCommandHandler("fixvehs", fixAllVehicles)

-----------------------------[FUEL VEH]---------------------------------
function fuelPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						setElementData(veh, "fuel", 100)
						outputChatBox("You refueled " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Your vehicle was refueled by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			setElementData(value, "fuel", 100)
		end
		outputChatBox("All vehicles refuelled by Admin " .. username .. ".")
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)

-----------------------------[SET COLOR]---------------------------------
function setPlayerVehicleColor(thePlayer, commandName, target, col1, col2)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (col1) or not (col2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Color 1] [Color 2]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local color = setVehicleColor(veh, col1, col2, col1, col2)
						
						if (color) then
							outputChatBox("Vehicle's color was set.", thePlayer)
						else
							outputChatBox("Invalid Color ID.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)

function deleteVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local vehicles = exports.pool:getPoolElementsByType("vehicle")
			local counter = 0
			
			for k, theVehicle in ipairs(vehicles) do
				local dbid = tonumber(getElementData(theVehicle, "dbid"))

				if (dbid==tonumber(id)) then
					if (dbid<0) then -- TEMP vehicle
						destroyElement(theVehicle)
					else
						if (exports.global:isPlayerAdmin(thePlayer)) then
							mysql_query(handler, "DELETE FROM vehicles WHERE id='" .. dbid .. "'")
							destroyElement(theVehicle)
							exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted vehicle #" .. dbid .. ".")
						else
							outputChatBox("You do not have permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
							return
						end
					end
					counter = counter + 1
					triggerEvent("onVehicleDelete", theVehicle)
				end
			end
			
			if (counter==0) then
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Vehicle deleted.", thePlayer)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)

function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local playerid = getElementData(thePlayer, "dbid")
	local owner = getElementData(veh, "owner")
	local dbid = getElementData(veh, "dbid")
	
	if (exports.global:isPlayerAdmin(thePlayer)) or (owner==playerid) or (exports.global:doesPlayerHaveItem(thePlayer, 3, dbid)) then
		
		if not (veh) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			if (dbid<0) then
				outputChatBox("This vehicle is not permanently spawned.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)
				
				mysql_query(handler, "UPDATE vehicles SET x='" .. x .. "', y='" .. y .."', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "' WHERE id='" .. dbid .. "'")
				
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				outputChatBox("Vehicle spawn position set.", thePlayer)
			end
		end
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)