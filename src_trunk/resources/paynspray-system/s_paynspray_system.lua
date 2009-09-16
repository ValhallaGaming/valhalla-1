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
armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

function createSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		local query = mysql_query(handler, "INSERT INTO paynspray SET x='"  .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "'")
		
		if (query) then
			local id = mysql_insert_id(handler)
			mysql_free_result(query)
			
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			setElementData(shape, "dbid", id, false)
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports.pool:allocateElement(sprayblip)
			
			outputChatBox("Pay n Spray spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 200000 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("makepaynspray", createSpray, false, false)

function loadAllSprays(res)
	local result = mysql_query(handler, "SELECT id, x, y, z, interior, dimension FROM paynspray")
	local count = 0
	
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
				
			local x = tonumber(row[2])
			local y = tonumber(row[3])
			local z = tonumber(row[4])
				
			local interior = tonumber(row[5])
			local dimension = tonumber(row[6])
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports.pool:allocateElement(sprayblip)
			
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			setElementData(shape, "dbid", id, false)
				
			count = count + 1
		end
		mysql_free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. count .. " Pay n Sprays.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllSprays)

function getNearbySprays(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Pay n Sprays:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			local x, y = getElementPosition(theColshape)
			local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
			if (distance<=10) then
				local dbid = getElementData(theColshape, "dbid")
				outputChatBox("   Pay n Spray with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbypaynsprays", getNearbySprays, false, false)

function delSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
		
		for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			if (isElementWithinColShape(thePlayer, value)) then
				colShape = value
			end
		end
		
		if (colShape) then
			local id = getElementData(colShape, "dbid")
			local result = mysql_query(handler, "DELETE FROM paynspray WHERE id='" .. id .. "'")
			
			if (result) then
				mysql_free_result(result)
			end
			
			outputChatBox("Pay n Spray #" .. id .. " deleted.", thePlayer)
			exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Pay n Spray #" .. id .. ".")
			destroyElement(colShape)
		else
			outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delpaynspray", delSpray, false, false)

function shapeHit(element, matchingDimension)
	if (isElement(element)) and (getElementType(element)=="vehicle") and (matchingDimension) then
		local thePlayer = getVehicleOccupant(element)
		
		if (thePlayer) then
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			local free = false
			if (ftype==2 or ftype==3 or ftype==4) then
				free = true
			end
			
			if not exports.global:hasMoney(thePlayer, 250) and not free then
				outputChatBox("You cannot afford to have your car worked on.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Welcome to Pay 'n' Spray. Please wait while we work on your " .. getVehicleName(element) .. ".", thePlayer, 255, 194, 14)
				setTimer(spraySoundEffect, 2000, 5, thePlayer, source)
				setTimer(sprayEffect, 10000, 1, element, thePlayer, source, free)
			end
		end
	end
end
addEventHandler("onColShapeHit", getResourceRootElement(), shapeHit)

function spraySoundEffect(thePlayer, shape)
	if (isElementWithinColShape(thePlayer, shape)) then
		playSoundFrontEnd(thePlayer, 46)
	end
end

function sprayEffect(vehicle, thePlayer, shape, free)
	if (isElementWithinColShape(thePlayer, shape)) then
		outputChatBox(" ", thePlayer)
		outputChatBox("Thank you for visting Pay 'n' Spray garage. Have a safe journey.", thePlayer, 255, 194, 14)
		
		if not free then
			exports.global:takeMoney(thePlayer, 250, true)
			outputChatBox("BILL: Car Repair - 250$", thePlayer, 255, 194, 14)
		else
			outputChatBox("BILL: Car Repair - 0$", thePlayer, 255, 194, 14)
		end
		
		fixVehicle(vehicle)
		if armoredCars[ getElementModel( vehicle ) ] then
			setVehicleDamageProof(vehicle, true)
		else
			setVehicleDamageProof(vehicle, false)
		end
	else
		outputChatBox("You forgot to wait for your repair!", thePlayer, 255, 0, 0)
	end
end
