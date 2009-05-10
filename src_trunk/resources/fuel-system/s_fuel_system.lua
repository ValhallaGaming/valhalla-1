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
		if(isPedInVehicle(v)) then
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
						
						if(engine==1) and (fuel>0) then
							distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
							newFuel = fuel - (distance/200)
							setElementData(veh, "fuel", newFuel)
							setElementData(veh, "oldx", x)
							setElementData(veh, "oldy", y)
							setElementData(veh, "oldz", z)

							if (newFuel<1) then
								triggerClientEvent(v, "setClientFuel", v, newFuel)
								setVehicleEngineState(veh, false)
								setElementData(veh, "engine", 0)
							else
								triggerClientEvent(v, "setClientFuel", v, newFuel)
							end
						elseif (tonumber(fuel)<1) then
							fuel = getElementData(veh, "fuel")
							triggerClientEvent(v, "setClientFuel", v, fuel)
							setVehicleEngineState(veh, false)
						end
					end
				end
			end
		end
	end
end
setTimer(fuelDepleting, 10000, 0)


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
		
			local theSphere = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(theSphere)
			setElementDimension(theSphere, dimension)
			setElementInterior(theSphere, interior)
			setElementData(theSphere, "type", "fuel")
			setElementData(theSphere, "dbid", id)
			
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
	if (res==getThisResource()) then
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
				
				local theSphere = createColSphere(x, y, z, 5)
				exports.pool:allocateElement(theSphere)
				setElementDimension(theSphere, dimension)
				setElementInterior(theSphere, interior)
				setElementData(theSphere, "type", "fuel")
				setElementData(theSphere, "dbid", id)
				counter = counter + 1
			end
			mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " Fuel stations.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadFuelPoints)

function fillVehicle(thePlayer, commandName)
	if not (isPedInVehicle(thePlayer)) then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
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
			local veh = getPedOccupiedVehicle(thePlayer)
			local currFuel = getElementData(veh, "fuel")
				
			if (currFuel==MAX_FUEL) then
				outputChatBox("This vehicle is already full.", thePlayer)
			else
				local money = getElementData(thePlayer, "money")
				
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
					outputChatBox("Refilling Vehicle...", thePlayer)
					setTimer(fuelTheVehicle, 15000, 1, thePlayer, veh, colShape, litresAffordable)
				end
			end
		end
	end
end
addCommandHandler("fill", fillVehicle)

function fuelTheVehicle(thePlayer, theVehicle, theShape, theLitres)
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
	
	-- Check the player didn't move
	if (colShape) then
		if (colShape==theShape) then
			local tax = exports.global:getTaxAmount()
			local fuelCost = math.ceil(theLitres*(FUEL_PRICE + (tax*FUEL_PRICE)))
			exports.global:takePlayerSafeMoney(thePlayer, fuelCost)
		
			local oldFuel = getElementData(theVehicle, "fuel")
			local newFuel = oldFuel+theLitres
			setElementData(theVehicle, "fuel", newFuel)
			triggerClientEvent(thePlayer, "setClientFuel", thePlayer, newFuel)
			
			outputChatBox("Gas Station Receipt:", thePlayer)
			outputChatBox("    " .. math.ceil(theLitres) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
		else
			outputChatBox("Don't want my fuel?", thePlayer)
		end
	else
		outputChatBox("Don't want my fuel?", thePlayer)
	end
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