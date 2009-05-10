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

bankPickup = createPickup(2316.6174316406, -7.3972668647766, 26.7421875, 3, 1274)
exports.pool:allocateElement(bankPickup)
setElementDimension(bankPickup, 128)

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