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

--TAX
tax = 15 -- percent

function randomizeTax()
	tax = math.random(5, 30)
end
setTimer(randomizeTax, 3600000, 0)
randomizeTax()

function getTaxAmount()
	return (tax/100)
end

--INCOME TAX
tax = 10 -- percent


function randomizeIncomeTax()
	tax = math.random(1, 25)
end
setTimer(randomizeIncomeTax, 3600000, 0)
randomizeIncomeTax()

function getIncomeTaxAmount()
	return (tax/100)
end



function giveMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if amount == 0 then
		return true
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor( amount )
		
		setElementData(thePlayer, "money", getMoney( thePlayer ) + amount )
		if getElementType(thePlayer) == "player" then
			mysql_free_result( mysql_query( handler, "UPDATE characters SET money = money + " .. amount .. " WHERE id = " .. getElementData( thePlayer, "dbid" ) ) )
			givePlayerMoney( thePlayer, amount )
		elseif getElementType(thePlayer) == "team" then
			mysql_free_result( mysql_query( handler, "UPDATE factions SET bankbalance = bankbalance + " .. amount .. " WHERE id = " .. getElementData( thePlayer, "id" ) ) )
		end
		return true
	end
	return false
end

function takeMoney(thePlayer, amount, rest)
	amount = tonumber( amount ) or 0
	if amount == 0 then
		return true, 0
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.ceil( amount )
		
		local money = getMoney( thePlayer )
		if rest and amount > money then
			amount = money
		end
		
		if amount == 0 then
			return true, 0
		elseif hasMoney(thePlayer, amount) then
			setElementData(thePlayer, "money", money - amount )
			if getElementType(thePlayer) == "player" then
				mysql_free_result( mysql_query( handler, "UPDATE characters SET money = money - " .. amount .. " WHERE id = " .. getElementData( thePlayer, "dbid" ) ) )
				takePlayerMoney( thePlayer, amount )
			elseif getElementType(thePlayer) == "team" then
				mysql_free_result( mysql_query( handler, "UPDATE factions SET bankbalance = bankbalance - " .. amount .. " WHERE id = " .. getElementData( thePlayer, "id" ) ) )
			end
			return true, amount
		end
	end
	return false, 0
end

function setMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor( amount )
		
		setElementData(thePlayer, "money", amount )
		if getElementType(thePlayer) == "player" then
			mysql_free_result( mysql_query( handler, "UPDATE characters SET money = " .. amount .. " WHERE id = " .. getElementData( thePlayer, "dbid" ) ) )
			setPlayerMoney( thePlayer, amount )
		elseif getElementType(thePlayer) == "team" then
			mysql_free_result( mysql_query( handler, "UPDATE factions SET bankbalance = " .. amount .. " WHERE id = " .. getElementData( thePlayer, "id" ) ) )
		end
		return true
	end
	return false
end

function hasMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor( amount )
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer, nocheck)
	if not nocheck then
		checkMoneyHacks(thePlayer)
	end
	return getElementData(thePlayer, "money") or 0
end

function checkMoneyHacks(thePlayer)
	if not getMoney(thePlayer, true) or getElementType(thePlayer) ~= "player" then return end
	
	local safemoney = getMoney(thePlayer, true)
	local hackmoney = getPlayerMoney(thePlayer)

	if (safemoney~=hackmoney) then
		--banPlayer(thePlayer, getRootElement(), "Money Hacks: " .. hackmoney .. "$.")
		setPlayerMoney(thePlayer, safemoney)
		sendMessageToAdmins("Possible money hack detected: "..getPlayerName(thePlayer))
		return true
	else
		return false
	end
end