armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
totalTempVehicles = 0
respawnTimer = nil

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
			if (isElement(value)) and (getElementType(value)) then
				local id = getElementData(value, "dbid")
				
				if (id) and (id>=0) then
					local owner = getElementData(value, "owner")
					if (owner==-2) then
						setVehicleLocked(value, false)
						count = count + 1
					end
				end
			end
		end
		
		outputChatBox("Unlocked " .. count .. " civilian vehicles.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)

-- /veh
function createTempVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		local args = {...}
		if (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id/name] [color1] [color2]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1 = #args ~= 1 and tonumber(args[#args - 1]) or -1
			local col2 = #args ~= 1 and tonumber(args[#args]) or -1
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = #args
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd - 1
				until vehicleID or vehicleEnd == -1
				if vehicleEnd == -1 then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				elseif vehicleEnd == #args - 2 then
					col2 = -1
				elseif vehicleEnd == #args - 1 then
					col1 = -1
					col2 = -1
				end
			end
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
			
			local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)
			
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				if (armoredCars[vehicleID]) then
					setVehicleDamageProof(veh, true)
				end

				exports.pool:allocateElement(veh)
				setElementData(veh, "fuel", 100)
				
				setVehicleColor(veh, col1, col2, col1, col2)
				
				setElementInterior(veh, getElementInterior(thePlayer))
				setElementDimension(veh, getElementDimension(thePlayer))
				
				setVehicleOverrideLights(veh, 1)
				setVehicleEngineState(veh, false)
				setVehicleFuelTankExplodable(veh, false)
				
				totalTempVehicles = totalTempVehicles + 1
				local dbid = (-totalTempVehicles)
				
				setElementData(veh, "dbid", dbid)
				setElementData(veh, "fuel", 100)
				setElementData(veh, "Impounded", 0)
				setElementData(veh, "engine", 0, false)
				setElementData(veh, "oldx", x, false)
				setElementData(veh, "oldy", y, false)
				setElementData(veh, "oldz", z, false)
				setElementData(veh, "faction", -1)
				setElementData(veh, "owner", -1, false)
				setElementData(veh, "job", 0, false)
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
function gotoCar(thePlayer, commandName, id)
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
					setElementInterior(thePlayer, getElementInterior(theVehicle))
					setElementDimension(thePlayer, getElementDimension(theVehicle))
					
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
					
					setElementInterior(theVehicle, getElementInterior(thePlayer))
					setElementDimension(theVehicle, getElementDimension(thePlayer))

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
			local owner = getElementData(nearbyVehicle, "owner")
			local faction = getElementData(nearbyVehicle, "faction")
			count = count + 1
			
			local ownerName = ""
			
			if (faction>0) then
				for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
					local dbid = tonumber(getElementData(value, "id"))
					if (dbid==tonumber(faction)) then
						ownerName = getTeamName(value)
						break
					end
				end
			elseif (owner==-1) then
				ownerName = "Admin"
			elseif (owner>0) then
				local query = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
				ownerName = tostring(mysql_result(query, 1, 1))
				mysql_free_result(query)
			else
				ownerName = "Civilian"
			end
			
			if (thisvehid) then
				outputChatBox("   " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
			elseif not (thisvehid) then
				outputChatBox("   " ..  "*Temporary* " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
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
						if armoredCars[ getElementModel( theVehicle ) ] then
							setVehicleDamageProof(theVehicle, true)
						else
							setVehicleDamageProof(theVehicle, false)
						end
						setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
						setElementData(theVehicle, "enginebroke", 0, false)
					else
						respawnVehicle(theVehicle)
						if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
							setVehicleLocked(theVehicle, false)
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

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("There is already a Vehicle Respawn active, /respawnstop to stop it first.", thePlayer, 255, 0, 0)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				outputChatBox("*** All vehicles will be respawned in "..timeToRespawn.." seconds! ***", getRootElement(), 255, 194, 14)
				outputChatBox("You can stop it by typing /respawnstop!", thePlayer)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		
		-- Remove all players from vehicles
		--for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		--	if (isPedInVehicle(value)) then
		--		removePedFromVehicle(value)
		--	end
		--end
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if not (dbid) or (dbid<0) then -- TEMP vehicle
				local driver = getVehicleOccupant(theVehicle)
				local pass1 = getVehicleOccupant(theVehicle, 1)
				local pass2 = getVehicleOccupant(theVehicle, 2)
				local pass3 = getVehicleOccupant(theVehicle, 3)

				if (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) then
					tempoccupied = tempoccupied + 1
				else
					destroyElement(theVehicle)
					tempcounter = tempcounter + 1
				end
			else
				local driver = getVehicleOccupant(theVehicle)
				local pass1 = getVehicleOccupant(theVehicle, 1)
				local pass2 = getVehicleOccupant(theVehicle, 2)
				local pass3 = getVehicleOccupant(theVehicle, 3)

				if (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) then
					occupiedcounter = occupiedcounter + 1
				else
					if isVehicleBlown(theVehicle) or isElementInWater(theVehicle) then
						fixVehicle(theVehicle)
						if armoredCars[ getElementModel( theVehicle ) ] then
							setVehicleDamageProof(theVehicle, true)
						else
							setVehicleDamageProof(theVehicle, false)
						end
						for i = 0, 5 do
							setVehicleDoorState(theVehicle, 4) -- all kind of stuff missing
						end
						setElementHealth(theVehicle, 300) -- lowest possible health
					end
					
					local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, rx, ry, rz)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					
					-- unlock Civ vehicles
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0 then
						respawnVehicle(theVehicle)
						setVehicleLocked(theVehicle, false)
						
						unlockedcivs = unlockedcivs + 1
					end
					counter = counter + 1
					
					-- fix faction vehicles
					if getElementData(theVehicle, "faction") ~= -1 then
						fixVehicle(theVehicle)
						if (getElementData(theVehicle, "Impounded") == 0) then
							setElementData(theVehicle, "enginebroke", 0, false)
							if armoredCars[ getElementModel( theVehicle ) ] then
								setVehicleDamageProof(theVehicle, true)
							else
								setVehicleDamageProof(theVehicle, false)
							end
						end
					end
				end
			end
		end
		outputChatBox(" =-=-=-=-=-=- All Vehicles Respawned =-=-=-=-=-=-=")
		outputChatBox("Respawned " .. counter .. " vehicles. (" .. occupiedcounter .. " Occupied).", thePlayer)
		outputChatBox("Deleted " .. tempcounter .. " temporary vehicles. (" .. tempoccupied .. " Occupied).", thePlayer)
		outputChatBox("Unlocked and Respawned " .. unlockedcivs .. " civilian vehicles.", thePlayer)
		exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " respawned all vehicles.")
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			local name = getPlayerName(thePlayer):gsub("_", " ")
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				name = "Hidden Admin"
			end
			outputChatBox( "*** " .. name .. " cancelled the vehicle respawn ***", getRootElement(), 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function respawnAllCivVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if dbid and dbid > 0 then
				local driver = getVehicleOccupant(theVehicle)
				local pass1 = getVehicleOccupant(theVehicle, 1)
				local pass2 = getVehicleOccupant(theVehicle, 2)
				local pass3 = getVehicleOccupant(theVehicle, 3)

				if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) then
					-- civ vehicles
					if getElementData(theVehicle, "owner") == -2 then
						respawnVehicle(theVehicle)
						setVehicleLocked(theVehicle, false)
						counter = counter + 1
					end
				end
			end
		end
		outputChatBox(" =-=-=-=-=-=- All Civilian Vehicles Respawned =-=-=-=-=-=-=")
		outputChatBox("Respawned " .. counter .. " civilian vehicles.", thePlayer)
		exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " respawned all civilian vehicles.")
	end
end
addCommandHandler("respawnciv", respawnAllCivVehicles, false, false)

function addUpgrade(thePlayer, commandName, target, upgradeID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (upgradeID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Upgrade ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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

function addPaintjob(thePlayer, commandName, target, paintjobID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (paintjobID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Paintjob ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					paintjobID = tonumber(paintjobID)
					if paintjobID == getVehiclePaintjob(theVehicle) then
						outputChatBox("This Vehicle already has this paintjob.", thePlayer, 255, 0, 0)
					else
						local success = setVehiclePaintjob(theVehicle, paintjobID)
						local targetPlayerName = getPlayerName(targetPlayer)
						
						if (success) then
							outputChatBox("Paintjob #" .. paintjobID .. " added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
							outputChatBox("Admin " .. username .. " added Paintjob #" .. paintjobID .. " to your vehicle.", targetPlayer)
						else
							outputChatBox("Invalid Paintjob ID, or this vehicle doesn't support this paintjob.", thePlayer, 255, 0, 0)
						end
					end
				end
			end
		end
	end

end
addCommandHandler("paintjob", addPaintjob, false, false)

function resetUpgrades(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					for key, value in ipairs(getVehicleUpgrades(theVehicle)) do
						removeVehicleUpgrade(theVehicle, value)
					end
					setVehiclePaintjob(theVehicle, 3)
				end
			end
		end
	end
end
addCommandHandler("resetupgrades", resetUpgrades, false, false)

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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						if (getElementData(veh, "Impounded") == 0) then
							setElementData(veh, "enginebroke", 0, false)
							if armoredCars[ getElementModel( veh ) ] then
								setVehicleDamageProof(veh, true)
							else
								setVehicleDamageProof(veh, false)
							end
						end
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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
			if (not getElementData(value, "Impounded")) then
				setElementData(value, "enginebroke", 0, false)
				if armoredCars[ getElementModel( value ) ] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
					triggerEvent("onVehicleDelete", theVehicle)
					if (dbid<0) then -- TEMP vehicle
						destroyElement(theVehicle)
					else
						if (exports.global:isPlayerSuperAdmin(thePlayer)) then
							local query = mysql_query(handler, "DELETE FROM vehicles WHERE id='" .. dbid .. "'")
							call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
							call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
							mysql_free_result(query)
							destroyElement(theVehicle)
							exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted vehicle #" .. dbid .. ".")
						else
							outputChatBox("You do not have permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
							return
						end
					end
					counter = counter + 1
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

-- DELTHISVEH

function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if dbid < 0 or exports.global:isPlayerSuperAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			else
				if dbid > 0 then
					local query = mysql_query(handler, "DELETE FROM vehicles WHERE id='" .. dbid .. "'")
					mysql_free_result(query)
					call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
					call( getResourceFromName( "item-system" ), "clearItems", veh )
					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted vehicle #" .. dbid .. ".")
				end
				destroyElement(veh)
			end
		else
			outputChatBox("You do not have the permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
			return
		end
	end						
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)