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

chDimension = 125
chInterior = 3
employmentCollision = createColSphere(360.8212890625, 173.62351989746, 1009.109375, 5)
exports.pool:allocateElement(employmentCollision)

-- /employment at cityhall
function employment(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (isElementWithinColShape(thePlayer, employmentCollision)) then
			triggerClientEvent(thePlayer, "onEmployment", thePlayer)
		end
	end
end
addEventHandler("onColShapeHit", employmentCollision, employment)

-- CALL BACKS FROM CLIENT
function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	
	setElementData(source, "job", jobID)
	mysql_query(handler, "UPDATE characters SET job='" .. jobID .. "' WHERE characteranme='" .. charname .. "' LIMIT 1")
	
	exports.global:givePlayerAchievement(source, 30)
	if (jobID==1) then -- TRUCKER
		initiateTruckerJob(source)
	elseif (jobID==2) then -- STREETCLEANER
		initiateCleanerJob(source)
	elseif (jobID==3) then -- TAXI
		outputChatBox("Please visit the LV Transport office and enquire about employment. ((Visit the Forums)).", source, 255, 194, 14)
	elseif (jobID==4) then -- CITY MAINTENANCE
		giveWeapon(source, 41, 2500, true)
		outputChatBox("Use this paint to paint over tags you find.", source, 255, 194, 14)
		setElementData(source, "tag", 9)
	end
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)