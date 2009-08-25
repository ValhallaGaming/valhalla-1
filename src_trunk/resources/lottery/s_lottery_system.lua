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
		handler = nil
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

function correctTime(res)
	local hour, minutes = getTime()
	if hour == 18 and minutes == 00 then
		drawLottery()
	else
		local minutesLeft = 60 - minutes
		local hoursLeft = 17 - hour
		if hoursLeft < 0 then
			drawTime = ((hoursLeft*60)+1440) + minutesLeft
		else
			drawTime = (hoursLeft*60) + minutesLeft
		end
		drawTimer = setTimer ( drawLottery, drawTime*60000, 1 )
		outputDebugString("Lottery will be drawn in "..drawTime.." minutes.")		
		drawTime = 0
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), correctTime)

function giveTicket(aPlayer)
	local PlayerID = getElementData(aPlayer, "dbid")
	local ticketNumber = tostring(math.random(1000, 9999))
	local result = mysql_query(handler, "SELECT characterid FROM lottery WHERE ticketnumber ='" .. ticketNumber .. "'")
	if (mysql_num_rows(result) == 0) then
		mysql_free_result(mysql_query(handler, "INSERT INTO lottery (characterid, ticketnumber) VALUES (" .. PlayerID .. ", " .. ticketNumber .. " )"))
		local result = mysql_query(handler, "SELECT ammount FROM lotteryjackpot")
		local jackpot = mysql_result(result,1,1) + 40
		mysql_free_result(mysql_query(handler, "UPDATE lotteryjackpot SET ammount='" .. jackpot .. "'"))	
		mysql_free_result(result)
		return tonumber(ticketNumber)
	elseif (mysql_num_rows(mysql_query(handler, "SELECT ticketnumber FROM lottery") >= 8999 then
		return false
	else
		giveTicket(aPlayer)
	end
end

function drawLottery()
	local drawNumbers = tostring(math.random(1000, 9999))
	local result = mysql_query(handler, "SELECT characterid FROM lottery WHERE ticketnumber ='" .. drawNumbers .. "'")
	if (mysql_num_rows(result) ~= 0) then
		local playername = mysql_result(mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. mysql_result(result,1,1) .. "'"),1,1)
		local bankmoney = getElementData(getPlayerFromName(playername), "bankmoney")
		local jackpot = mysql_query(handler, "SELECT ammount FROM lotteryjackpot")
		setElementData(getPlayerFromName(playername), "bankmoney", bankmoney+ tonumber(mysql_result(jackpot,1,1)))
		mysql_query(handler, "DELETE FROM lottery")
		mysql_free_result(mysql_query(handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. mysql_result(result,1,1) .. ", " .. mysql_result(jackpot,1,1) .. ", 'Won lottery', 3)"))
		mysql_free_result(mysql_query(handler, "UPDATE lotteryjackpot SET ammount='0'"))
		mysql_free_result(jackpot)
		outputChatBox("The winner of the lottery is: " .. playername .. "! Congratulations, the money will be transfered to your account.")
	else
		mysql_query(handler, "DELETE FROM lottery")
		outputChatBox("Nobody wins. The jackpot has been accumulated.")
	end
	drawTimer2 = setTimer ( drawLottery, 86400000, 1 )
	mysql_free_result(result)
end