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

bankPickup = createPickup(2356.2719, 2361.5007, 2022.5257, 3, 1274)
exports.pool:allocateElement(bankPickup)
local shape = getElementColShape(bankPickup)
setElementInterior(shape, 3)
setElementInterior(bankPickup, 3)

function pickupUse(thePlayer)
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
		local money = getElementData(faction, "money")
		triggerClientEvent(thePlayer, "showBankUI", thePlayer, isInFaction, isFactionLeader, money)
	end
end
addEventHandler("onPickupHit", bankPickup, pickupUse)

function withdrawMoneyPersonal(amount)
	exports.global:givePlayerSafeMoney(source, amount)
	
	local money = getElementData(source, "bankmoney")
	setElementData(source, "bankmoney", money-amount)
	
	outputChatBox("You withdraw " .. amount .. "$ from your personal account.", source, 255, 194, 14)
end
addEvent("withdrawMoneyPersonal", true)
addEventHandler("withdrawMoneyPersonal", getRootElement(), withdrawMoneyPersonal)

function depositMoneyPersonal(amount)
	exports.global:takePlayerSafeMoney(source, amount)
	
	local money = getElementData(source, "bankmoney")
	setElementData(source, "bankmoney", money+amount)
	
	outputChatBox("You deposited " .. amount .. "$ into your personal account.", source, 255, 194, 14)
end
addEvent("depositMoneyPersonal", true)
addEventHandler("depositMoneyPersonal", getRootElement(), depositMoneyPersonal)

function withdrawMoneyBusiness(amount)
	local theTeam = getPlayerTeam(source)
	local money = getElementData(theTeam, "money")
	setElementData(theTeam, "money", money-amount)
	mysql_query(handler, "UPDATE factions SET bankbalance='" .. money-amount .. "' WHERE name='" .. getTeamName(theTeam) .. "'")
	exports.global:givePlayerSafeMoney(source, amount)
	outputChatBox("You withdraw " .. amount .. "$ from your business account.", source, 255, 194, 14)
end
addEvent("withdrawMoneyBusiness", true)
addEventHandler("withdrawMoneyBusiness", getRootElement(), withdrawMoneyBusiness)

function depositMoneyBusiness(amount)
	local theTeam = getPlayerTeam(source)
	local money = getElementData(theTeam, "money")
	setElementData(theTeam, "money", money+amount)
	mysql_query(handler, "UPDATE factions SET bankbalance='" .. money+amount .. "' WHERE name='" .. getTeamName(theTeam) .. "'")
	exports.global:takePlayerSafeMoney(source, amount)
	outputChatBox("You deposited " .. amount .. "$ into your business account.", source, 255, 194, 14)
end
addEvent("depositMoneyBusiness", true)
addEventHandler("depositMoneyBusiness", getRootElement(), depositMoneyBusiness)

function transferMoneyToPersonal(business, name, amount)
	local reciever = getPlayerFromName(string.gsub(name," ","_"))
	local dbid = nil
	if not reciever then
		local result = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. string.gsub(name," ","_") .. "' LIMIT 1")
		if result then
			if mysql_num_rows(result) > 0 then
				dbid = tonumber(mysql_result(result, 1, 1))
				mysql_free_result(result)
				found = true
			end
		else
			outputDebugString("s_bank_system.lua: mysql_query failed: (" .. mysql_errno(handler) .. ") " .. mysql_error(handler), 1, 255, 0, 0)
		end
	end
	
	if not dbid and not reciever then
		outputChatBox("Player not found. Please enter the full character name.", source, 255, 0, 0)
	else
		if business then
			local theTeam = getPlayerTeam(source)
			local money = getElementData(theTeam, "money")
			mysql_query(handler, "UPDATE factions SET bankbalance='" .. money - amount .. "' WHERE name='" .. getTeamName(theTeam) .. "'")
			setElementData(theTeam, "money", money - amount)
		else
			setElementData(source, "bankmoney", getElementData(source, "bankmoney") - amount)
		end
		
		if reciever then
			setElementData(reciever, "bankmoney", getElementData(reciever, "bankmoney") + amount)
		else
			mysql_query(handler, "UPDATE characters SET bankmoney=bankmoney+" .. amount .. " WHERE id=" .. dbid)
		end
		triggerClientEvent(source, "hideBankUI", source)
		outputChatBox("You transfered " .. amount .. "$ from your "..(business and "business" or "personal").." account to "..name..(string.sub(name,-1) == "s" and "'" or "'s").." account.", source, 255, 194, 14)
	end
end
addEvent("transferMoneyToPersonal", true)
addEventHandler("transferMoneyToPersonal", getRootElement(), transferMoneyToPersonal)