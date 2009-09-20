-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
local sqlUsername = exports.mysql:getMySQLUsername()
local sqlPassword = exports.mysql:getMySQLPassword()
local sqlDB = exports.mysql:getMySQLDBName()
local sqlHost = exports.mysql:getMySQLHost()
local sqlPort = exports.mysql:getMySQLPort()

sql = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

local function checkMySQL()
	if not (mysql_ping(sql)) then
		sql = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end

local function closeMySQL()
	if (sql) then
		mysql_close(sql)
		sql = nil
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)

-- ////////////////////////////////////
-- //			RUNCODE				 //
-- ////////////////////////////////////		
local rootElement = getRootElement()

function runString (commandstring, outputTo, source)
	local sourceName
	if source then
		sourceName = getPlayerName(source)
	else
		sourceName = "Console"
	end
	outputChatBoxR(sourceName.." executed command: "..commandstring, outputTo)
	
	-- ease the execution of client-side code on the server
	function getLocalPlayer( )
		return source
	end
	_G['source'] = source
	if getElementType(source) == 'player' then
		vehicle = getPedOccupiedVehicle(source) or getPedContactElement(source)
		car = vehicle
	end
	checkMySQL()
	
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBoxR("Error: "..errorMsg, outputTo)
		return
	end
	--Finally, lets execute our function
	results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBoxR("Error: "..results[2], outputTo)
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Command results: "..resultsString, outputTo)
	elseif not errorMsg then
		outputChatBoxR("Command executed!", outputTo)
	end
end

-- run command
--addCommandHandler("run",
--	function (player, command, ...)
--		if (exports.global:isPlayerScripter(player)) then
--		local commandstring = table.concat({...}, " ")
--		return runString(commandstring, rootElement, player)
--		end
--	end
--)

-- silent run command
addCommandHandler("srun",
	function (player, command, ...)
		if (exports.global:isPlayerScripter(player)) then
		local commandstring = table.concat({...}, " ")
		return runString(commandstring, player, player)
		end
	end
)

-- clientside run command
addCommandHandler("crun",
	function (player, command, ...)
		if (exports.global:isPlayerScripter(player)) then
		local commandstring = table.concat({...}, " ")
		if player then
			return triggerClientEvent(player, "doCrun", player, commandstring)
		else
			return runString(commandstring, false, false)
		end
		end
	end
)
