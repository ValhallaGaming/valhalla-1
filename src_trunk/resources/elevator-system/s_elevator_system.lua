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
addEvent("onPlayerInteriorChange", true)

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
			if id then
				local query = mysql_query(handler, "INSERT INTO elevators SET id='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', tpx='" .. ix .. "', tpy='" .. iy .. "', tpz='" .. iz .. "', dimensionwithin='" .. dimensionwithin .. "', interiorwithin='" .. interiorwithin .. "', dimension='" .. dimension .. "', interior='" .. interior .. "'")
				
				if (query) then
					mysql_free_result(query)
					local pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
					local intpickup = createPickup(ix, iy, iz, 3, 1318)
					exports.pool:allocateElement(intpickup)
					
					setElementData(pickup, "dbid", id, false)
					setElementData(pickup, "other", intpickup, false)
					setElementInterior(pickup, interiorwithin)
					setElementDimension(pickup, dimensionwithin)
					
					setElementData(intpickup, "dbid", id, false)
					setElementData(intpickup, "other", pickup, false)
					setElementInterior(intpickup, interior)
					setElementDimension(intpickup, dimension)
					
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
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		removeElementData(thePlayer, "UsedElevator")
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
			
			setElementData(pickup, "dbid", id, false)
			setElementData(pickup, "other", intpickup, false)
			setElementInterior(pickup, interiorwithin)
			setElementDimension(pickup, dimensionwithin)
				
			setElementData(intpickup, "dbid", id, false)
			setElementData(intpickup, "other", pickup, false)
			setElementInterior(intpickup, interior)
			setElementDimension(intpickup, dimension)
			counter = counter + 1
		end
		mysql_free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " Elevators.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllElevators)

function hitInteriorPickup( thePlayer )
	bindKeys(thePlayer, source)
	setTimer(checkLeavePickup, 1000, 1, thePlayer, source)
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), hitInteriorPickup)

function isInPickup( thePlayer, thePickup, distance )
	local ax, ay, az = getElementPosition(thePlayer)
	local bx, by, bz = getElementPosition(thePickup)
	
	return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
end

function checkLeavePickup( thePlayer, thePickup )
	if isElement( thePlayer ) then
		if isInPickup( thePlayer, thePickup ) then
			setTimer(checkLeavePickup, 1000, 1, thePlayer, thePickup)
		else
			unbindKeys(thePlayer, thePickup)
		end
	end
end

function func (player, f, down, player, pickup) enterElevator(player, pickup) end 

function bindKeys(player, pickup)
	if (isElement(player)) then
		if not(isKeyBound(player, "enter", "down", func)) then
			bindKey(player, "enter", "down", func, player, pickup)
		end
		
		if not(isKeyBound(player, "f", "down", func)) then
			bindKey(player, "f", "down", func, player, pickup)
		end
		
		setElementData( player, "interiormarker", true, false )
	end
end

function unbindKeys(player, pickup)
	if (isElement(player)) then
		if (isKeyBound(player, "enter", "down", func)) then
			unbindKey(player, "enter", "down", func, player, pickup)
		end
		
		if (isKeyBound(player, "f", "down", func)) then
			unbindKey(player, "f", "down", func, player, pickup)
		end
		
		removeElementData( player, "interiormarker" )
	end
end


function isInteriorLocked(dimension)
	local result = mysql_query(handler, "SELECT type, locked FROM `interiors` WHERE id = " .. dimension)
	local locked = false
	if result then
		if mysql_num_rows(result) > 0 then
			if tonumber(mysql_result(result, 1, 1)) ~= 2 and tonumber(mysql_result(result, 1, 2)) == 1 then 
				locked = true
			end
		end
		mysql_free_result(result)
	end
	return locked
end


function enterElevator(player, pickup)
	if isInPickup ( player, pickup ) and not getElementData(player, "UsedElevator") and not getPedOccupiedVehicle( player ) then
		local other = getElementData( pickup, "other" )
		
		local x, y, z = getElementPosition( other )
		local interior = getElementInterior( other )
		local dimension = getElementDimension( other )
		
		-- find the pickup inside to see if the house is locked
		local ldimension = getElementDimension( pickup )
		
		local locked = false
		if ldimension == 0 and dimension ~= 0 then -- entering a house
			locked = isInteriorLocked(dimension)
		elseif ldimension ~= 0 and dimension == 0 then -- leaving a house
			locked = isInteriorLocked(ldimension)
		elseif ldimension ~= 0 and dimension ~= 0 and ldimension ~= dimension then -- changing between two houses
			locked = isInteriorLocked(ldimension) or isInteriorLocked(dimension)
		else -- outside
			locked = false
		end
		
		if locked then
			outputChatBox("You try the door handle, but it seems to be locked.", player, 255, 0,0, true)
			return
		end
		
		-- check for entrance fee
		local dbid, thePickup = call( getResourceFromName( "interior-system" ), "findProperty", player, dimension )
		if thePickup then
			if getElementData( player, "adminduty" ) ~= 1 and not exports.global:hasItem( player, 5, getElementData( thePickup, "dbid" ) ) then
				local fee = getElementData( thePickup, "fee" )
				if fee and fee > 0 then
					if not exports.global:takeMoney( player, fee ) then
						outputChatBox( "You don't have enough money with you to enter this interior.", player, 255, 0, 0 )
						return
					else
						local ownerid = getElementData( thePickup, "owner" )
						local query = mysql_query( handler, "UPDATE characters SET bankmoney = bankmoney + " .. fee .. " WHERE id = " .. ownerid )
						if query then
							mysql_free_result( query )
							
							for k, v in pairs( getElementsByType( "player" ) ) do
								if isElement( v ) then
									if getElementData( v, "dbid" ) == ownerid then
										setElementData( v, "businessprofit", getElementData( v, "businessprofit" ) + fee, false )
										break
									end
								end
							end
						else
							outputChatBox( "Error 9019 - Report on Forums.", player, 255, 0, 0 )
						end
					end
				end
			end
		end

		if getElementData(player, "IsInCustomInterior") == 1 then
			removeElementData(player,"IsInCustomInterior")
			local weather, blend = getWeather()
			triggerClientEvent(player, "onClientWeatherChange", getRootElement(), weather, blend)
		end
		if z <= -5 then
			triggerClientEvent (player, "onClientWeatherChange", getRootElement(), 7, nil)
			setElementData(player,"IsInCustomInterior", 1, false)
		end
		
		-- fade camera to black
		fadeCamera ( player, false, 1,0,0,0 )
		
		-- teleport the player during the black fade
		setTimer(function()
			setElementPosition(player, x, y, z)
			setElementInterior(player, interior)
			setCameraInterior(player, interior)
			setElementDimension(player, dimension)
			
			triggerEvent("onPlayerInteriorChange", player, pickup, other)
			
			-- fade camera in
			setTimer(fadeCamera, 1000, 1 , player , true, 2)
			
			if interior == 3 or interior == 4 then
				triggerClientEvent(player, "usedElevator", player)
				setPedFrozen(player, true)
				setPedGravity(player, 0)
			end
			
			resetPlayerData(player)
		end, 1000, 1)
		
		setElementData(player,"UsedElevator", 1, false)
		playSoundFrontEnd(player, 40)
	end
end

function resetGravity()
	setPedFrozen(source, false)
	setPedGravity(source, 0.008)
end
addEvent("resetGravity", true)
addEventHandler("resetGravity", getRootElement(), resetGravity)

function resetPlayerData(player)
	removeElementData(player,"UsedElevator")
end

function deleteElevator(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			
			local counter = 0
			for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
				local pickupID = tonumber(getElementData(thePickup, "dbid"))
				if pickupID == id then
					destroyElement(thePickup)
					counter = counter + 1
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
		for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
			if isInPickup(thePlayer, thePickup) then
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
addCommandHandler("tempdelete", TempDelete, false, false)

function getNearbyElevators(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Elevators:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
			if isInPickup(thePlayer, thePickup, 10) then
				local dbid = getElementData(thePickup, "dbid")
				outputChatBox("   Elevator with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyelevators", getNearbyElevators, false, false)

function SmallestElevatorID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql_query(handler, "SELECT MIN(e1.id+1) AS nextID FROM elevators AS e1 LEFT JOIN elevators AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(mysql_result(result, 1, 1))
		mysql_free_result(result)
		return id
	end
	return false
end

function JoinsInCustomInt()
	dimension = getElementDimension( source )
	interior = getElementInterior( source )
	x,y,z = getElementPosition( source )
	if( interior == 0 and dimension == 0) then
		if z <= -5 then
			setElementData(source,"IsInCustomInterior", 1, false)
			triggerClientEvent (source, "onClientWeatherChange", getRootElement(), 7, nil)
		end
	end
end
addEventHandler("onPlayerSpawn", getRootElement(), JoinsInCustomInt)