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

function createNewObject(thePlayer, commandName, modelid)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (modelid) then
			outputChatBox("SYNTAX: " .. commandName .. " [Model ID]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local rotation = getPedRotation(thePlayer)
			
			local query = mysql_query(handler, "INSERT INTO objects SET x='"  .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "', modelid='" .. modelid .. "', rotation='" .. rotation .. "'")
			
			if (query) then
				local id = mysql_insert_id(handler)
				mysql_free_result(query)
				
				local object = createObject(tonumber(modelid), x, y, z, 0, 0, rotation)
				exports.pool:allocateElement(object)
				
				if (object) then
					setElementInterior(object, interior)
					setElementDimension(object, dimension)
					setElementData(object, "dbid", id)
					
					outputChatBox("Object " .. modelid .. " spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Error 400001 - Report on forums.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox(tostring(mysql_error(handler)))
				outputChatBox("Error 400000 - Report on forums.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addobject", createNewObject, false, false)

function loadAllObjects(res)
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT id, x, y, z, interior, dimension, rotation, modelid FROM objects")
		local count = 0
		
		if (result) then
			for result, row in mysql_rows(result) do
				local id = tonumber(row[1])
					
				local x = tonumber(row[2])
				local y = tonumber(row[3])
				local z = tonumber(row[4])
					
				local interior = tonumber(row[5])
				local dimension = tonumber(row[6])
				
				local rotation = tonumber(row[7])
				local modelid = tonumber(row[8])
					
				local object = createObject(modelid, x, y, z, 0, 0, rotation)
				exports.pool:allocateElement(object)
				setElementInterior(object, interior)
				setElementDimension(object, dimension)
				setElementData(object, "dbid", id)
					
				count = count + 1
			end
		mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. count .. " Objects.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllObjects)

function getNearbyObjects(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Objects:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(exports.pool:getPoolElementsByType("object")) do
			local dbid = getElementData(theObject, "dbid")
			if (dbid) then
				local x, y = getElementPosition(theColshape)
				local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
				if (distance<=10) then
					local modelid = getElementModel(theObject)
					outputChatBox("   Object (" .. modelid .. ") with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyobjects", getNearbyObjects, false, false)

function delObject(thePlayer, commandName, targetID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
				
			for key, value in ipairs(exports.pool:getPoolElementsByType("object")) do
				local dbid = getElementData(value, "dbid")

				if (dbid) then
					if (dbid==tonumber(targetID)) then
						object = value
					end
				end
			end
			
			if (object) then
				local id = getElementData(object, "dbid")
				local result = mysql_query(handler, "DELETE FROM objects WHERE id='" .. id .. "'")
						
				if (result) then
					mysql_free_result(result)
				end
						
				outputChatBox("Object #" .. id .. " deleted.", thePlayer)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Object #" .. id .. ".")
				destroyElement(object)
			else
				outputChatBox("Invalid object ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delobject", delObject, false, false)