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
addEventHandler( "onResourceStart", getResourceRootElement(),
	function()
		-- delete all old wiretransfers
		mysql_free_result( mysql_query( handler, "DELETE FROM wiretransfers WHERE time < NOW() - INTERVAL 2 WEEK" ) )
	end
)

bankPickup = createPickup(2356.2719, 2361.5007, 2022.5257, 3, 1274)
exports.pool:allocateElement(bankPickup)
local shape = getElementColShape(bankPickup)
setElementInterior(shape, 3)
setElementInterior(bankPickup, 3)

function pickupUse(thePlayer)
	cancelEvent()
	local result = mysql_query(handler, "SELECT faction_id, faction_leader FROM characters WHERE charactername='" .. getPlayerName(thePlayer) .. "' LIMIT 1")
	
	if (result) then
		local faction_id = tonumber(mysql_result(result, 1, 1))
		local faction_leader = tonumber(mysql_result(result, 1, 2))
		mysql_free_result(result)
		
		local isInFaction = false
		local isFactionLeader = false
		
		if (faction_id>0) then
			isInFaction = true
		end
		
		if (faction_leader==1) then
			isFactionLeader = true
		end
		
		local faction = getPlayerTeam(thePlayer)
		local money = exports.global:getMoney(faction)
		triggerClientEvent(thePlayer, "showBankUI", thePlayer, isInFaction, isFactionLeader, money)
	end
end
addEventHandler("onPickupHit", bankPickup, pickupUse)

function withdrawMoneyPersonal(amount)
	exports.global:giveMoney(source, amount)
	
	local money = getElementData(source, "bankmoney")
	setElementData(source, "bankmoney", money-amount)
	saveBank(source)
	
	mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. getElementData(source, "dbid") .. ", " .. -amount .. ", '', 0)" ) )

	outputChatBox("You withdraw " .. amount .. "$ from your personal account.", source, 255, 194, 14)
end
addEvent("withdrawMoneyPersonal", true)
addEventHandler("withdrawMoneyPersonal", getRootElement(), withdrawMoneyPersonal)

function depositMoneyPersonal(amount)
	if exports.global:takeMoney(source, amount) then
		local money = getElementData(source, "bankmoney")
		setElementData(source, "bankmoney", money+amount)
		saveBank(source)
		
		mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", 0, " .. amount .. ", '', 1)" ) )

		outputChatBox("You deposited " .. amount .. "$ into your personal account.", source, 255, 194, 14)
	end
end
addEvent("depositMoneyPersonal", true)
addEventHandler("depositMoneyPersonal", getRootElement(), depositMoneyPersonal)

function withdrawMoneyBusiness(amount)
	local theTeam = getPlayerTeam(source)
	if exports.global:takeMoney(theTeam, amount) then
		if exports.global:giveMoney(source, amount) then
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(theTeam, "id") .. ", " .. getElementData(source, "dbid") .. ", " .. amount .. ", '', 4)" ) )

			outputChatBox("You withdraw " .. amount .. "$ from your business account.", source, 255, 194, 14)
		end
	end
end
addEvent("withdrawMoneyBusiness", true)
addEventHandler("withdrawMoneyBusiness", getRootElement(), withdrawMoneyBusiness)

function depositMoneyBusiness(amount)
	if exports.global:takeMoney(source, amount) then
		local theTeam = getPlayerTeam(source)
		if exports.global:giveMoney(theTeam, amount) then
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 5)" ) )

			outputChatBox("You deposited " .. amount .. "$ into your business account.", source, 255, 194, 14)
		end
	end
end
addEvent("depositMoneyBusiness", true)
addEventHandler("depositMoneyBusiness", getRootElement(), depositMoneyBusiness)

function transferMoneyToPersonal(business, name, amount, reason)
	reason = mysql_escape_string(handler, reason)
	local reciever = getPlayerFromName(string.gsub(name," ","_"))
	if reciever == source then
		outputChatBox("You can't wiretransfer money to yourself.", source, 255, 0, 0)
		return
	end
	local dbid = nil
	if not reciever then
		local result = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. string.gsub(name," ","_") .. "' LIMIT 1")
		if result then
			if mysql_num_rows(result) > 0 then
				dbid = tonumber(mysql_result(result, 1, 1))
				found = true
			end
			mysql_free_result(result)
		else
			outputDebugString("s_bank_system.lua: mysql_query failed: (" .. mysql_errno(handler) .. ") " .. mysql_error(handler), 1, 255, 0, 0)
		end
	else
		dbid = getElementData(reciever, "dbid")
	end
	
	if not dbid and not reciever then
		outputChatBox("Player not found. Please enter the full character name.", source, 255, 0, 0)
	else
		if business then
			local theTeam = getPlayerTeam(source)
			if exports.global:takeMoney(theTeam, amount) then
				mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. ( -getElementData( theTeam, "id" ) ) .. ", " .. dbid .. ", " .. amount .. ", '" .. reason .. "', 3)" ) )
			end
		else
			setElementData(source, "bankmoney", getElementData(source, "bankmoney") - amount)
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", " .. dbid .. ", " .. amount .. ", '" .. reason .. "', 2)" ) )
		end
		
		if reciever then
			setElementData(reciever, "bankmoney", getElementData(reciever, "bankmoney") + amount)
			saveBank(reciever)
		else
			local query = mysql_query(handler, "UPDATE characters SET bankmoney=bankmoney+" .. amount .. " WHERE id=" .. dbid)
			mysql_free_result(query)
		end
		triggerClientEvent(source, "hideBankUI", source)
		outputChatBox("You transfered " .. amount .. "$ from your "..(business and "business" or "personal").." account to "..name..(string.sub(name,-1) == "s" and "'" or "'s").." account.", source, 255, 194, 14)
		
		saveBank(source)
	end
end
addEvent("transferMoneyToPersonal", true)
addEventHandler("transferMoneyToPersonal", getRootElement(), transferMoneyToPersonal)

-- TRANSACTION HISTORY STUFF

--[[
	Transaction Types:
	0: Withdraw Personal
	1: Deposit Personal
	2: Transfer from Personal to Personal
	3: Transfer from Business to Personal
	4: Withdraw Business
	5: Deposit Business
	6: Wage/State Benefits
	7: everything in payday except Wage/State Benefits
]]

function findTeamByID(id)	
	for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
		if tonumber(getElementData(value, "id")) == id then
			return value
		end
	end
end

function tellTransfersPersonal()
	local dbid = getElementData(source, "dbid")
	tellTransfers(source, dbid, "recievePersonalTransfer")
end

function tellTransfersBusiness()
	local dbid = tonumber(getElementData(getPlayerTeam(source), "id")) or 0
	if dbid > 0 then
		tellTransfers(source, -dbid, "recieveBusinessTransfer")
	end
end

function tellTransfers(source, dbid, event)
	local where = "( `from` = " .. dbid .. " OR `to` = " .. dbid .. " )"
	if dbid < 0 then
		where = where .. " AND type != 6" -- skip paydays for factions 
	else
		where = where .. " AND type != 4 AND type != 5" -- skip stuff that's not paid from bank money
	end
	local query = mysql_query(handler, "SELECT w.*, a.charactername, b.charactername FROM wiretransfers w LEFT JOIN characters a ON a.id = `from` LEFT JOIN characters b ON b.id = `to` WHERE " .. where .. " ORDER BY id DESC LIMIT 40")
	if query then
		for result, row in mysql_rows(query) do
			local id = tonumber(row[1])
			local amount = tonumber(row[4])
			local time = row[6]
			local type = tonumber(row[7])
			local reason = row[5]
			if reason == mysql_null() then
				reason = ""
			end
			
			local from, to = "-", "-"
			if row[8] ~= mysql_null() then
				from = row[8]:gsub("_", " ")
			elseif tonumber(row[2]) then
				num = tonumber(row[2]) 
				if num < 0 then
					from = getTeamName(findTeamByID(-num))
				elseif num == 0 and ( type == 6 or type == 7 ) then
					from = "Government"
				end
			end
			if row[9] ~= mysql_null() then
				to = row[9]:gsub("_", " ")
			elseif tonumber(row[3]) and tonumber(row[3]) < 0 then
				to = getTeamName(findTeamByID(-tonumber(row[3])))
			end
			
			if type >= 2 and type <= 5 and tonumber(row[2]) == dbid then
				amount = -amount
			end
			
			if amount < 0 then
				amount = "-$" .. -amount
			else
				amount = "$" .. amount
			end
			
			triggerClientEvent(source, event, source, id, amount, time, type, from, to, reason)
		end
		mysql_free_result(query)
	else
		outputDebugString(mysql_error(handler), 2)
	end
end

addEvent("tellTransfersPersonal", true)
addEventHandler("tellTransfersPersonal", getRootElement(), tellTransfersPersonal)

addEvent("tellTransfersBusiness", true)
addEventHandler("tellTransfersBusiness", getRootElement(), tellTransfersBusiness)

--

function saveBank( thePlayer )
	if getElementData( thePlayer, "loggedin" ) == 1 then
		mysql_free_result(mysql_query(handler, "UPDATE characters SET bankmoney=" .. (tonumber(getElementData( thePlayer, "bankmoney" )) or 0) .. " WHERE id=" .. getElementData( thePlayer, "dbid" )))
	end
end
