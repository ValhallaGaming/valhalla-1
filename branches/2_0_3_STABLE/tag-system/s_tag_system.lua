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
		local obj = createObject(tags[tag], cx, cy, cz, 0, 0, rot+90)
		exports.pool:allocateElement(obj)
		setElementDimension(obj, dimension)
		setElementInterior(obj, interior)
		
		local query = mysql_query(handler, "INSERT INTO tags SET x='" .. cx .. "', y='" .. cy .. "', z='" .. cz .. "', interior='" .. interior .. "', dimension='" .. dimension .. "', rx='0', ry='0', rz='" .. rot+90 .. "', modelid='" .. tags[tag] .. "'")
		exports.global:sendLocalMeAction(source, "tags the wall.")
		
		local id = mysql_insert_id(handler)
		setElementData(obj, "dbid", id)
		setElementData(obj, "type", "tag")
		outputChatBox("You have tagged the wall!", source, 255, 194, 14)
	else
		local colshape = createColSphere(cx, cy, cz, 10)
		exports.pool:allocateElement(colshape)
		local objects = getElementsWithinColShape(colshape, "object")
		
		local object = nil
		for key, value in ipairs(objects) do
			local objtype = getElementData(value, "type")
			if (objtype=="tag") then
				object = value
				break
			end
		end
		
		if (object) then
			local id = getElementData(object, "dbid")
			outputChatBox("You removed the tag. You earnt 30$ for doing so.", source, 255, 194, 14)
			exports.global:givePlayerSafeMoney(source, 30)
			destroyElement(object)
			mysql_query(handler, "DELETE FROM tags WHERE id='" .. id .. "'")
		end
		destroyElement(colshape)
	end
end
addEvent("createTag", true )
addEventHandler("createTag", getRootElement(), makeTagObject)

function loadAllTags(res)
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT id, x, y, z, interior, dimension, rx, ry, rz, modelid FROM tags")
		local count = 0
		
		if (result) then
			for result, row in mysql_rows(result) do
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
				setElementData(object, "dbid", id)
				setElementData(object, "type", "tag")
					
				count = count + 1
			end
		mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. count .. " Tags.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllTags)