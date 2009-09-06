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

function addCharacterKillBody( x, y, z, rotation, skin, id, name )
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementData(ped, "ckid", id, false)
	setElementData(ped, "name", name:gsub("_", " "), false)
	--setTimer(setPedAnimation, 100, 1, ped, "WUZI", "CS_Dead_Guy", -1, false, false, false)
	killPed(ped)
end

function loadAllCorpses(res)
	local result = mysql_query(handler, "SELECT x, y, z, skin, rotation, id, charactername FROM characters WHERE cked = 1")
	
	local counter = 0
	local rowc = 1
	
	if (result) then
		for result, row in mysql_rows(result) do
			local x = tonumber(row[1])
			local y = tonumber(row[2])
			local z = tonumber(row[3])
			local skin = tonumber(row[4])
			local rotation = tonumber(row[5])
			local id = tonumber(row[6])
			local name = row[7]
			if name == mysql_null() then
				name = ""
			end
			
			addCharacterKillBody(x, y, z, rotation, skin, id, name)
		end
		mysql_free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)

function getNearbyCKs(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Character Kill Bodies:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, v in ipairs(getElementsByType("ped", getResourceRootElement())) do
			local x, y, z = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			if (distance<=20) then
				outputChatBox("   " .. getElementData(v, "name"), thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbycks", getNearbyCKs, false, false)

-- in remembrance of
local function showCKList( thePlayer, data )
	exports.global:givePlayerAchievement( thePlayer, 40 )
	local result = mysql_query(handler, "SELECT charactername FROM characters WHERE cked = " .. data .. " ORDER BY charactername")
	if result then
		local names = {}
		for result, row in mysql_rows(result) do
			local name = row[1]
			if name ~= mysql_null() then
				names[ #names + 1 ] = name
			end
		end
		triggerClientEvent( thePlayer, "showCKList", thePlayer, names, data )
		mysql_free_result(result)
	end
end

local ckBuried = createPickup( 815, -1100, 25.8, 3, 1254 )
addEventHandler( "onPickupHit", ckBuried,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 2 )
	end
)

local ckMissing = createPickup( 819, -1100, 25.8, 3, 1314 )
addEventHandler( "onPickupHit", ckMissing,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 1 )
	end
)