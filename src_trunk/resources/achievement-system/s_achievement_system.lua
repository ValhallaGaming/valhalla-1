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

local savedAchievements = {}

function doesPlayerHaveAchievement(thePlayer, id)
	if (getElementType(thePlayer)) then
		if not savedAchievements[thePlayer] then
			savedAchievements[thePlayer] = {}
		elseif savedAchievements[thePlayer][id] then
			return true
		end
		
		local gameaccountID = getElementData(thePlayer, "gameaccountid")

		if (gameaccountID) then
			local result = mysql_query(handler, "SELECT id FROM achievements WHERE achievementid='" .. id .. "' AND account='" .. gameaccountID .. "'")
			if (mysql_num_rows(result)>0) then
				mysql_free_result(result)
				savedAchievements[thePlayer][id] = true
				return true
			else
				mysql_free_result(result)
				return false
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
		
			if result then	
				triggerClientEvent(thePlayer, "onPlayerGetAchievement", thePlayer, id)
				mysql_free_result(result)
				return true
			else
				return false
			end
		end
	end
end
addEvent("cGivePlayerAchievement", true)
addEventHandler("cGivePlayerAchievement", getRootElement(), givePlayerAchievement)

addEventHandler( "onPlayerQuit", getRootElement(), function() savedAchievements[source] = nil end)
