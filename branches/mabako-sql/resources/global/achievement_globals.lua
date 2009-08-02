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

function doesPlayerHaveAchievement(thePlayer, id)
	if (getElementType(thePlayer)) then
		local gameaccountID = getElementData(thePlayer, "gameaccountid")

		if (gameaccountID) then
			local result = mysql_query(handler, "SELECT id FROM achievements WHERE achievementid='" .. id .. "' AND account='" .. gameaccountID .. "'")
	
			if (mysql_num_rows(result)>0) then
				return true
			else
				return false
			end
			
			if (result) then
				mysql_free_result(result)
			end
		end
	end
end

function givePlayerAchievement(thePlayer, id)
	if not (doesPlayerHaveAchievement(thePlayer, id)) then
		local gameaccountID = getElementData(thePlayer, "gameaccountid")

		if (gameaccountID) then
			local time = getRealTime()
			local days = time.monthday
			local months = (time.month+1)
			local years = (1900+time.year)
					
			local date = days .. "/" .. months .. "/" .. years
		
			local result = mysql_query(handler, "INSERT INTO achievements SET account='" .. gameaccountID .. "', achievementid='" .. id .. "', date='" .. date .. "'")
		
			if (result) then	
				mysql_free_result(result)
				local query = mysql_query(handler, "SELECT name, description, points FROM achievementslist WHERE id='" .. id .. "'")

				if (mysql_num_rows(query)>0) then
					local name = mysql_result(query, 1, 1)
					local desc = mysql_result(query, 1, 2)
					local points = mysql_result(query, 1, 3)
					triggerClientEvent(thePlayer, "onPlayerGetAchievement", thePlayer, name, desc, points)
					return true
				else
					return false
				end
				
				if (query) then
					mysql_free_result(query)
				end
			else
				return false
			end
		end
	end
end
addEvent("cGivePlayerAchievement", true)
addEventHandler("cGivePlayerAchievement", getRootElement(), givePlayerAchievement)