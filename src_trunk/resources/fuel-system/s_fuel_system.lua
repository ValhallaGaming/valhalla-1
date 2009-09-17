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

fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

FUEL_PRICE = 0.33
MAX_FUEL = 100

function fuelDepleting()
	local players = exports.pool:getPoolElementsByType("player")
	for k, v in ipairs(players) do
		if isPedInVehicle(v) and not exports.global:isPlayerSilverDonator(v) then
			local veh = getPedOccupiedVehicle(v)
			if (veh) then
				local seat = getPedOccupiedVehicleSeat(v)
				
				if (seat==0) then
					local model = getElementModel(veh)
					if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
						
						local oldx = getElementData(veh, "oldx")
						local oldy = getElementData(veh, "oldy")
						local oldz = getElementData(veh, "oldz")
						local fuel = getElementData(veh, "fuel")
						local engine = getElementData(veh, "engine")
						
						local x, y, z = getElementPosition(veh)
						
						if engine == 1 then
							if fuel >= 1 then
								distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
								-- outputChatBox("distance " .. distance .. "!", v, 255, 0, 0)
								if (distance==0) then
									distance = 5  -- fuel leaking away when not moving
								end
								newFuel = fuel - (distance/200)
								setElementData(veh, "fuel", newFuel)
								setElementData(veh, "oldx", x, false)
								setElementData(veh, "oldy", y, false)
								setElementData(veh, "oldz", z, false)
								
								if newFuel < 1 then
									setVehicleEngineState(veh, false)
									setElementData(veh, "engine", 0, false)
									toggleControl(v, 'brake_reverse', false)
								end
							end
						end
					end
				end
			end
		end
	end
end
setTimer(fuelDepleting, 10000, 0)

function FuelDepetingEmptyVehicles()
	local vehicles = exports.pool:getPoolElementsByType("vehicle")
	for ka, theVehicle in ipairs(vehicles) do
		local enginestatus = getElementData(theVehicle, "engine")
		local vehid = getElementData(theVehicle, "dbid")
		
		if (enginestatus == 1) then
			local driver = getVehicleOccupant(theVehicle)
			if (driver == false) then
				local fuel = getElementData(theVehicle, "fuel")
				if fuel >= 1 then
					local newFuel = fuel - (30/200)
					setElementData(theVehicle, "fuel", newFuel)
					if (newFuel<1) then
						setVehicleEngineState(theVehicle, false)
						setElementData(theVehicle, "engine", 0, false)
					end
				end
			end
		end
	end
end
setTimer(FuelDepetingEmptyVehicles, 30000,0)
-- [////ADMIN COMMANDS/////]
function createFuelPoint(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		
		local result = mysql_query(handler, "INSERT INTO fuelstations SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "'")
		
		if (result) then
			local id = mysql_insert_id(handler)
			mysql_free_result(result)
		
			local theSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(theSphere)
			setElementDimension(theSphere, dimension)
			setElementInterior(theSphere, interior)
			setElementData(theSphere, "type", "fuel", false)
			setElementData(theSphere, "dbid", id, false)
			
			outputChatBox("Fuel point added with ID #" .. id .. ".", thePlayer)
			exports.irc:sendMessage("[ADMIN] " .. getPlayerName( thePlayer ) .. " spawned fuel point " .. id)
		else
			outputChatBox("Failed to create fuel point.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addfuelpoint", createFuelPoint, false, false)

function getNearbyFuelpoints(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Fuelpoints:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local colshapeType = getElementData(theColshape, "type")
			if (colshapeType) then
				if (colshapeType=="fuel") then
					local x, y = getElementPosition(theColshape)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					if (distance<=10) then
						local dbid = getElementData(theColshape, "dbid")
						outputChatBox("   Fuelpoint with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyfuelpoints", getNearbyFuelpoints, false, false)

function randomizeFuelPrice()
	FUEL_PRICE = math.random(1, 2) / 3
end
setTimer(randomizeFuelPrice, 3600000, randomizeFuelPrice)

function loadFuelPoints(res)
	local result = mysql_query(handler, "SELECT id, x, y, z, dimension, interior FROM fuelstations")
	local counter = 0
	
	if (result) then
		for result, row in mysql_rows(result) do
			local id = row[1]
			local x = tonumber(row[2])
			local y = tonumber(row[3])
			local z = tonumber(row[4])
			
			local dimension = tonumber(row[5])
			local interior = tonumber(row[6])
			
			local theSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(theSphere)
			setElementDimension(theSphere, dimension)
			setElementInterior(theSphere, interior)
			setElementData(theSphere, "type", "fuel", false)
			setElementData(theSphere, "dbid", id, false)
			counter = counter + 1
		end
		mysql_free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " Fuel stations.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadFuelPoints)

local vehiclesFueling = { }
function fillVehicle(thePlayer, commandName)
	if not (isPedInVehicle(thePlayer)) then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		local colShape = nil
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			if isElement(value) then
				local shapeType = getElementData(value, "type")
				if (shapeType) then
					if (shapeType=="fuel") then
						if (isElementWithinColShape(thePlayer, value)) then
							colShape = value
						end
					end
				end
			end
		end
		
		if (colShape) then
			local veh = getPedOccupiedVehicle(thePlayer)
			local currFuel = tonumber(getElementData(veh, "fuel"))
			outputDebugString(tostring(vehiclesFueling[veh]))
			if (math.ceil(currFuel)==MAX_FUEL) then
				outputChatBox("This vehicle is already full.", thePlayer, 255, 0, 0)
			elseif (vehiclesFueling[veh] ~= nil) then
				outputChatBox("You are already filling this vehicle.", thePlayer, 255, 0, 0)
			elseif (getVehicleEngineState(veh) == true) then
				outputChatBox("You cannot fill a car with a running engine.", thePlayer, 255, 0, 0)
			else
				local faction = getPlayerTeam(thePlayer)
				local ftype = getElementData(faction, "type")
				
				if (ftype~=2) and (ftype~=3) and (ftype~=4) then
					local money = exports.global:getMoney(thePlayer)
					
					local tax = exports.global:getTaxAmount()
					local cost = FUEL_PRICE + (tax*FUEL_PRICE)
					local litresAffordable = math.ceil(money/cost)
					
					if (litresAffordable>100) then
						litresAffordable=100
					end
					
					if (litresAffordable+currFuel>100) then
						litresAffordable = 100 - currFuel
					end
					
					if (litresAffordable==0) then
						outputChatBox("You cannot afford any fuel.", thePlayer, 255, 0, 0)
					else
						vehiclesFueling[veh] = true
						outputChatBox("Refilling Vehicle...", thePlayer)
						setTimer(fuelTheVehicle, 5000, 1, thePlayer, veh, colShape, litresAffordable, false)
					end
				else
					vehiclesFueling[veh] = true
					outputChatBox("Refilling Vehicle...", thePlayer)
					
					litresAffordable = 100
					if (litresAffordable+currFuel>100) then
						litresAffordable = 100 - currFuel
					end
					
					setTimer(fuelTheVehicle, 5000, 1, thePlayer, veh, colShape, litresAffordable, true)
				end
			end
		end
	end
end
addCommandHandler("fill", fillVehicle)

function fillCan(thePlayer, commandName)
	if not (exports.global:hasItem(thePlayer, 57)) then
		outputChatBox("You do not have a fuel can.", thePlayer, 255, 0, 0)
	else
		local colShape = nil
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
		
		if (colShape) then
			local hasItem, slot, currFuel = exports.global:hasItem(thePlayer, 57)

			if (math.ceil(currFuel)==25) then
				outputChatBox("This fuel can is already full.", thePlayer)
			else
				local faction = getPlayerTeam(thePlayer)
				local ftype = getElementData(faction, "type")
				
				if (ftype~=2) and (ftype~=3) and (ftype~=4) then
					local money = exports.global:getMoney(thePlayer)
					
					local tax = exports.global:getTaxAmount()
					local cost = FUEL_PRICE + (tax*FUEL_PRICE)
					local litresAffordable = math.ceil(money/cost)
					
					if (litresAffordable>25) then
						litresAffordable=25
					end
					
					if (litresAffordable+currFuel>25) then
						litresAffordable = 25 - currFuel
					end
						
					if (litresAffordable==0) then
						outputChatBox("You cannot afford any fuel.", thePlayer, 255, 0, 0)
					else
						local fuelCost = math.floor(litresAffordable*cost)
						outputChatBox("Gas Station Receipt:", thePlayer)
						outputChatBox("    " .. math.ceil(litresAffordable) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
						exports.global:takeMoney(thePlayer, fuelCost, true)
						exports.global:takeItem(thePlayer, 57, currFuel)
						exports.global:giveItem(thePlayer, 57, litresAffordable+currFuel)
					end
				else
					litresAffordable = 25
					if (litresAffordable+currFuel>25) then
						litresAffordable = 25 - currFuel
					end
					
					fuelCost = 0
					outputChatBox("Gas Station Receipt:", thePlayer)
					outputChatBox("    " .. math.ceil(litresAffordable) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
					exports.global:takeItem(thePlayer, 57, tonumber(currFuel))
					exports.global:giveItem(thePlayer, 57, math.ceil(litresAffordable+currFuel))
				end
			end
		end
	end
end
addCommandHandler("fillcan", fillCan)

function fuelTheVehicle(thePlayer, theVehicle, theShape, theLitres, free)
	local colShape = nil
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
		if isElement(value) then
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
	end
	
	
	-- Check the player didn't move
	if (colShape) then
		if (colShape==theShape) then
			if (getVehicleEngineState(theVehicle) == false) then
				local tax = exports.global:getTaxAmount()
				local fuelCost = math.floor(theLitres*(FUEL_PRICE + (tax*FUEL_PRICE)))
			
				if (free) then
					fuelCost = 0
				end
				
				exports.global:takeMoney(thePlayer, fuelCost, true)
			
				local oldFuel = getElementData(theVehicle, "fuel")
				local newFuel = oldFuel+theLitres
				setElementData(theVehicle, "fuel", newFuel)
				--triggerClientEvent(thePlayer, "setClientFuel", thePlayer, newFuel)
				
				outputChatBox("Gas Station Receipt:", thePlayer)
				outputChatBox("    " .. math.ceil(theLitres) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
			else
				outputChatBox("Fueling aborted, you've started the engine.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Don't want my fuel?", thePlayer)
		end
	else
		outputChatBox("Don't want my fuel?", thePlayer)
	end
	vehiclesFueling[theVehicle] = nil
end

function delFuelPoint(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
			
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
		
		if (colShape) then
			local shapeType = getElementData(colShape, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					local id = getElementData(colShape, "dbid")
					local result = mysql_query(handler, "DELETE FROM fuelstations WHERE id='" .. id .. "'")
					
					if (result) then
						mysql_free_result(result)
					end
					
					outputChatBox("Fuel station #" .. id .. " deleted.", thePlayer)
					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted fuel station #" .. id .. ".")
					destroyElement(colShape)
				end
			else
				outputChatBox("You are not in a fuel station.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("You are not in a fuel station.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delfuelpoint", delFuelPoint, false, false)