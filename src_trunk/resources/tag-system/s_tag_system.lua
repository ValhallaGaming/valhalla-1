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
tags = {1524, 1525, 1526, 1527, 1528, 1529, 1530, 1531 }

function makeTagObject(cx, cy, cz, rot, interior, dimension)
	local tag = getElementData(source, "tag")
	if (tag~=9) then
		local obj = createObject(tags[tag], cx, cy, cz, 0, 0, rot+91)
		exports.pool:allocateElement(obj)
		setElementDimension(obj, dimension)
		setElementInterior(obj, interior)
		
		local query = mysql_query(handler, "INSERT INTO tags SET x='" .. cx .. "', y='" .. cy .. "', z='" .. cz .. "', interior='" .. interior .. "', dimension='" .. dimension .. "', rx='0', ry='0', rz='" .. rot+90 .. "', modelid='" .. tags[tag] .. "', creationdate=NOW()")
		exports.global:sendLocalMeAction(source, "tags the wall.")
		
		local id = mysql_insert_id(handler)
		mysql_free_result(query)
		setElementData(obj, "dbid", id, false)
		setElementData(obj, "type", "tag")
		outputChatBox("You have tagged the wall!", source, 255, 194, 14)
	else
		local distance = 2
		local colshape = createColSphere(cx, cy, cz, distance)
		exports.pool:allocateElement(colshape)
		local objects = getElementsWithinColShape(colshape, "object")
		
		local object = nil
		for key, value in ipairs(objects) do
			local objtype = getElementData(value, "type")
			if objtype=="tag" then
				local tx, ty, tz = getElementPosition(value)
				local tdistance = getDistanceBetweenPoints3D(cx,cy,cz,tx,ty,tz)
				if tdistance < distance then
					object = value
					distance = tdistance
				end
			end
		end
		
		if (object) then
			local id = getElementData(object, "dbid")
			outputChatBox("You removed the tag. You earnt 30$ for doing so.", source, 255, 194, 14)
			exports.global:giveMoney(source, 30)
			destroyElement(object)
			local query = mysql_query(handler, "DELETE FROM tags WHERE id='" .. id .. "'")
			mysql_free_result(query)
		end
		destroyElement(colshape)
	end
end
addEvent("createTag", true )
addEventHandler("createTag", getRootElement(), makeTagObject)

function clearNearbyTag(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local colshape = createColSphere(x, y, z, 10)
		exports.pool:allocateElement(colshape)
		local objects = getElementsWithinColShape(colshape, "object")
		
		local object = nil
		local dist = 999999
		for key, value in ipairs(objects) do
			local objtype = getElementData(value, "type")
			if (objtype=="tag") then
				local ox, oy, oz = getElementPosition(value)
				local distance = getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)
				if (distance<dist) then
					object = value
					dist = distance
				end
			end
		end
		
		if (object) then
			local id = getElementData(object, "dbid")
			destroyElement(object)
			local query = mysql_query(handler, "DELETE FROM tags WHERE id='" .. id .. "'")
			mysql_free_result(query)
			outputChatBox("Deleted tag with id #" .. id .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("You are not near any tag.", thePlayer, 255, 0, 0)
		end
		destroyElement(colshape)
	end
end
addCommandHandler("clearnearbytag", clearNearbyTag, false, false)

function loadAllTags(res)
	-- delete old tags
	mysql_free_result( mysql_query(handler, "DELETE FROM tags WHERE DATEDIFF(NOW(), creationdate) > 2") )
	local result = mysql_query(handler, "SELECT id, x, y, z, interior, dimension, rx, ry, rz, modelid FROM tags")
	local count = 0
	
	if (result) then
		local highest = 0
		for result, row in mysql_rows(result) do
			local wyearday = tonumber(row[11])
			local id = tonumber(row[1])
				
			local x = tonumber(row[2])
			local y = tonumber(row[3])
			local z = tonumber(row[4])
				
			local interior = tonumber(row[5])
			local dimension = tonumber(row[6])
			
			local rx = tonumber(row[7])
			local ry = tonumber(row[8])
			local rz = tonumber(row[9])
			local modelid = tonumber(row[10])
			
			local object = createObject(modelid, x, y, z, rx, ry, rz)
			exports.pool:allocateElement(object)
			setElementInterior(object, interior)
			setElementDimension(object, dimension)
			setElementData(object, "dbid", id, false)
			setElementData(object, "type", "tag")
			count = count + 1
			if id > highest then
				highest = id
			end
		end
		-- update the auto increment with highest used tag id + 1
		local query = mysql_query(handler, "ALTER TABLE `tags` AUTO_INCREMENT = " .. (highest + 1))
		mysql_free_result(query)
		mysql_free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. count .. " Tags.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllTags)