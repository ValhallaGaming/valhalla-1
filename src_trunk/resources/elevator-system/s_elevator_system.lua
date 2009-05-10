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

function createElevator(thePlayer, commandName, interior, dimension, ix, iy, iz)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (interior) or not (dimension) or not (ix) or not (iy) or not (iz) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Dimension ID] [X] [Y] [Z]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			
			interior = tonumber(interior)
			dimension = tonumber(dimension)
			local interiorwithin = getElementInterior(thePlayer)
			local dimensionwithin = getElementDimension(thePlayer)
			ix = tonumber(ix)
			iy = tonumber(iy)
			iz = tonumber(iz)
			id = SmallestElevatorID()
			if(id ~= nil and id ~= nil) then
				local query = mysql_query(handler, "INSERT INTO elevators SET id='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', tpx='" .. ix .. "', tpy='" .. iy .. "', tpz='" .. iz .. "', dimensionwithin='" .. dimensionwithin .. "', interiorwithin='" .. interiorwithin .. "', dimension='" .. dimension .. "', interior='" .. interior .. "'")
				
				if (query) then
					mysql_free_result(query)
					local pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
					local intpickup = createPickup(ix, iy, iz, 3, 1318)
					exports.pool:allocateElement(intpickup)
					local shape1 = createColSphere(x, y, z, 2)
					exports.pool:allocateElement(shape1)
					local shape2 = createColSphere(ix, iy, iz, 2)
					exports.pool:allocateElement(shape2)

					setElementData(shape1, "dbid", id)
					setElementData(shape1, "x", ix)
					setElementData(shape1, "y", iy)
					setElementData(shape1, "z", iz)
					setElementData(shape1, "interior", interior)
					setElementData(shape1, "dimension", dimension)
					setElementData(shape1, "type", "elevator")
					setElementData(pickup, "type", "elevator")
					setElementInterior(pickup, interiorwithin)
					setElementDimension(pickup, dimensionwithin)
					setElementInterior(shape1, interiorwithin)
					setElementDimension(shape1, dimensionwithin)
						
					setElementData(shape2, "dbid", id)
					setElementData(shape2, "x", x)
					setElementData(shape2, "y", y)
					setElementData(shape2, "z", z)
					setElementData(shape2, "interior", interiorwithin)
					setElementData(shape2, "dimension", dimensionwithin)
					setElementData(shape2, "type", "elevator")
					setElementData(intpickup, "type", "elevator")
					setElementInterior(intpickup, interior)
					setElementDimension(intpickup, dimension)
					setElementInterior(shape2, interior)
					setElementDimension(shape2, dimension)
					outputChatBox("Elevator created with ID #" .. id .. "!", thePlayer, 0, 255, 0)
				end
			else
				outputChatBox("There was an error while creating an elevator. Try again.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addelevator", createElevator, false, false)

function loadAllElevators(res)
	if (res==getThisResource()) then
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			setElementData(thePlayer, "UsedElevator", nil)
		end
		local result = mysql_query(handler, "SELECT id, x, y, z, tpx, tpy, tpz, dimensionwithin, interiorwithin, dimension, interior FROM elevators")
		local counter = 0
		
		if (result) then
			for result, row in mysql_rows(result) do
				local id = tonumber(row[1])
				local x = tonumber(row[2])
				local y = tonumber(row[3])
				local z = tonumber(row[4])

				local ix = tonumber(row[5])
				local iy = tonumber(row[6])
				local iz = tonumber(row[7])
				
				local dimensionwithin = tonumber(row[8])
				local interiorwithin = tonumber(row[9])
				
				local dimension = tonumber(row[10])
				local interior = tonumber(row[11])
				
				local pickup = createPickup(x, y, z, 3, 1318)
				exports.pool:allocateElement(pickup)
				local intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				local shape1 = createColSphere(x, y, z, 2)
				exports.pool:allocateElement(shape1)
				local shape2 = createColSphere(ix, iy, iz, 2)
				exports.pool:allocateElement(shape2)

				setElementData(shape1, "dbid", id)
				setElementData(shape1, "x", ix)
				setElementData(shape1, "y", iy)
				setElementData(shape1, "z", iz)
				setElementData(shape1, "interior", interior)
				setElementData(shape1, "dimension", dimension)
				setElementData(shape1, "type", "elevator")
				setElementData(pickup, "type", "elevator")
				setElementData(pickup, "dbid", id)
				setElementInterior(pickup, interiorwithin)
				setElementDimension(pickup, dimensionwithin)
				setElementInterior(shape1, interiorwithin)
				setElementDimension(shape1, dimensionwithin)
					
				setElementData(shape2, "dbid", id)
				setElementData(shape2, "x", x)
				setElementData(shape2, "y", y)
				setElementData(shape2, "z", z)
				setElementData(shape2, "interior", interiorwithin)
				setElementData(shape2, "dimension", dimensionwithin)
				setElementData(shape2, "type", "elevator")
				setElementData(intpickup, "type", "elevator")
				setElementInterior(intpickup, interior)
				setElementDimension(intpickup, dimension)
				setElementData(intpickup, "dbid", id)
				setElementInterior(shape2, interior)
				setElementDimension(shape2, dimension)
				counter = counter + 1
			end
			mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " Elevators.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllElevators)

function hitInteriorPickup( thePlayer, matchingDimension )
	if(matchingDimension) then
		local pickuptype = getElementData(source, "type")
		if (pickuptype=="elevator") then
			bindKeys(thePlayer, source)

		end
	end
end
addEventHandler("onColShapeHit", getRootElement(), hitInteriorPickup)

function leaveInteriorPickup( thePlayer, matchingDimension )
	if(matchingDimension) then
		local pickuptype = getElementData(source, "type")
		if (pickuptype=="elevator") then
			unbindKeys(thePlayer, source)
		end
	end
end
addEventHandler("onColShapeLeave", getRootElement(), leaveInteriorPickup)

function PickupEnter()
	cancelEvent()
end
addEventHandler("onPickupHit", getRootElement(), PickupEnter)


function func (playa, f, down, playa, shape) enterElevator(playa, shape) end 

function bindKeys(playa, shape)
	if not(isKeyBound(playa, "enter", "down", func)) then
		bindKey(playa, "enter", "down", func, playa, shape)
	end
	
	if not(isKeyBound(playa, "f", "down", func)) then
		bindKey(playa, "f", "down", func, playa, shape)
	end
end

function unbindKeys(playa, shape)
	if (isKeyBound(playa, "enter", "down", func)) then
		unbindKey(playa, "enter", "down", func, playa, shape)
	end
	
	if (isKeyBound(playa, "f", "down", func)) then
		unbindKey(playa, "f", "down", func, playa, shape)
	end
end



function enterElevator(playa, shape)
	local check1 = isElementWithinColShape ( playa, shape )
	if (check1 == true) then
		local check2 = getElementData(playa, "UsedElevator")
		if(check2 == nil) then
			--unbindKeys(playa, shape)
			local x = getElementData(shape, "x")
			local y = getElementData(shape, "y")
			local z = getElementData(shape, "z")
			local check3 = getElementData(playa,"IsInCustomInterior")
			if(check3 == 1) then
				setElementData(playa,"IsInCustomInterior", nil)
				local weather, blend = getWeather()
				triggerClientEvent (playa, "onClientWeatherChange", getRootElement(), weather, blend)
			end
			if( z <= -5) then
				triggerClientEvent (playa, "onClientWeatherChange", getRootElement(), 7, nil)
				setElementData(playa,"IsInCustomInterior", 1)
			end
			local interior = getElementData(shape, "interior")
			local dimension = getElementData(shape, "dimension")
			setElementPosition(playa, x, y, z)
			setElementInterior(playa, interior)
			setCameraInterior(playa, interior)
			setElementDimension(playa, dimension)
			playSoundFrontEnd(playa, 40)
			setElementData(playa,"UsedElevator", 1)
			
			--setTimer(resetPlayerData, , 1, playa)
			resetPlayerData(playa)
			
		else
			outputChatBox("Please wait before entering/leaving an interior again.", playa, 255, 0, 0)
		end
	end
end

function resetPlayerData(playa)
	setElementData(playa,"UsedElevator", nil)
end

function resetElevatorData()
	setElementData(source,"UsedElevator", nil)
end
addEventHandler("onPlayerJoin", getRootElement(), resetElevatorData)
addEventHandler("onPlayerQuit", getRootElement(), resetElevatorData)

function deleteElevator(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
				
			local counter = 0
			local pickups = exports.pool:getPoolElementsByType("pickup")
			for k, thePickup in ipairs(pickups) do
				local pickupType = getElementData(thePickup, "type")
					
				if (pickupType=="elevator") then
					local pickupID = tonumber(getElementData(thePickup, "dbid"))
					if (pickupID==id) then
						destroyElement(thePickup)
						counter = counter + 1
					end
				end
			end
			local shapes = exports.pool:getPoolElementsByType("colshape")
			for k, v in ipairs(shapes) do
				local shapeType = getElementData(v, "type")
					
				if (shapeType=="elevator") then
					local shapeID = tonumber(getElementData(v, "dbid"))
					
					if (shapeID==tonumber(id)) then
						destroyElement(v)
					end
				end
			end
			if (counter>0) then -- ID Exists
				local query = mysql_query(handler, "DELETE FROM elevators WHERE id='" .. id .. "'")
				
				if (query) then
					mysql_free_result(query)
				end
				
				outputChatBox("Elevator #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted elevator #" .. id .. ".")
			else
				outputChatBox("Elevator ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delelevator", deleteElevator, false, false)

function TempDelete(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		for k, thePickup in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local pickuptype = getElementData(thePickup, "type")
			if (pickuptype=="elevator") then
				local x, y, z = getElementPosition(thePickup)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=2) then
					local dbid = getElementData(thePickup, "dbid")
					local query = mysql_query(handler, "DELETE FROM elevators WHERE id='" .. dbid .. "'")
					if (query) then
						outputChatBox(" Elevator deleted", thePlayer)
						mysql_free_result(query)
					end
				end
			end
		end
	end
end
addCommandHandler("tempdelete", TempDelete, false, false)

function getNearbyElevators(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Elevators:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local pickuptype = getElementData(thePickup, "type")
			if (pickuptype=="elevator") then
				local x, y, z = getElementPosition(thePickup)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					local dbid = getElementData(thePickup, "dbid")
					outputChatBox("   Elevator with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyelevators", getNearbyElevators, false, false)

function SmallestElevatorID( ) --  Loop which finds the smallest ID in the SQL instead of the biggest one.
	UsedID = {}		
	local id = 0
	local answer = 2 -- 0 = ID = 1 . 1 =Suitable ID found. 2= Still searching for ID.
	local highest = 0
	local result = mysql_query(handler, "SELECT id FROM elevators")
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

function JoinsInCustomInt()
	dimension = getElementDimension( source )
	interior = getElementInterior( source )
	x,y,z = getElementPosition( source )
	if( interior == 0 and dimension == 0) then
		if(z <= 5) then
			setElementData(source,"IsInCustomInterior", 1)
			triggerClientEvent (source, "onClientWeatherChange", getRootElement(), 7, nil)
		end
	end
end
addEventHandler("onPlayerSpawn", getRootElement(), JoinsInCustomInt)