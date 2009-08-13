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
	if (handler~=nil) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

function loadAllCorpses(res)
	local result = mysql_query(handler, "SELECT x, y, z, skin, rotation FROM characters WHERE cked=1")
	
	local counter = 0
	local rowc = 1
	
	if (result) then
		for result, row in mysql_rows(result) do
			local x = tonumber(row[1])
			local y = tonumber(row[2])
			local z = tonumber(row[3])
			local skin = tonumber(row[4])
			local rotation = tonumber(row[5])
			
			local ped = createPed(skin, x, y, z)
			setPedRotation(ped, rotation)
			--setTimer(setPedAnimation, 100, 1, ped, "WUZI", "CS_Dead_Guy", -1, false, false, false)
			killPed(ped)
		end
		mysql_free_result(result)
	end
end
--addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)