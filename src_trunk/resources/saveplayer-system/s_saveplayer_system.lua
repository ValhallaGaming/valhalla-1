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
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("savePlayer", value, "Save All")
	end
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

tweapons = { }

function initWeapons()
	tweapons[source] = { }
	tweapons[source][1] = ""
	tweapons[source][2] = ""
end
addEventHandler("onPlayerJoin", getRootElement(), initWeapons)

function cleanWeapons(thePlayer)
	tweapons[thePlayer] = nil
end

function saveWeapons(thePlayer)
	if tweapons[thePlayer] then
		local weapons = tweapons[thePlayer][1]
		local ammo = tweapons[thePlayer][2]

		cleanWeapons(thePlayer)
		
		if (weapons~=false) and (ammo~=false) then
			local query = mysql_query(handler, "UPDATE characters SET weapons='" .. weapons .. "', ammo='" .. ammo .. "' WHERE charactername='" .. getPlayerName(source) .. "'")
			mysql_free_result(query)
		end
	end
end

local count = 1
function syncWeapons(weapons, ammo)
	--outputDebugString("Got weapon sync packet #" .. count .. " FROM: " .. getPlayerName(source))
	count = count + 1
	
	if (tweapons[source] == nil) then
		tweapons[source] = { }
	end
	
	tweapons[source][1] = weapons
	tweapons[source][2] = ammo
end
addEvent("syncWeapons", true)
addEventHandler("syncWeapons", getRootElement(), syncWeapons)


function saveAllPlayers()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("savePlayer", value, "Save All")
	end
end

function savePlayer(reason, player)
	local logged = getElementData(source, "loggedin")

	if (logged==1) then
		saveWeapons(source)
		
		local vehicle = getPedOccupiedVehicle(source)
		
		if (vehicle) then
			local seat = getPedOccupiedVehicleSeat(source)
			triggerEvent("onVehicleExit", vehicle, source, seat)
		end
		
		local x, y, z, rot, tag, health, armour, interior, dimension, blindfold, pmblocked, username, cuffed, skin, muted, hiddenAdmin, radiochannel, duty, adminduty, globalooc, fightstyle, blur, casualskin, adminreports, warns, hoursplayed, timeinserver, job
		
		username = getPlayerName(source)
		
		x, y, z = getElementPosition(source)
		rot = getPedRotation(source)
		health = getElementHealth(source)
		armor = getPedArmor(source)
		interior = getElementInterior(source)
		dimension = getElementDimension(source)
		money = exports.global:getMoney(source) + ( getElementData(source, "stevie.money") or 0 )
		cuffed = getElementData(source, "restrain")
		skin = getElementModel(source)
		
		if getElementData(source, "help") then
			dimension, interior, x, y, z = unpack( getElementData(source, "help") )
		end
		
		-- Fix for #0000984
		local businessprofit = tonumber(getElementData(source, "businessprofit"))
		if (businessprofit) then
			money = money + businessprofit
		end
		
		
		muted = getElementData(source, "muted")
		hiddenAdmin = getElementData(source, "hiddenadmin")
		pmblocked = getElementData(source, "pmblocked")
		blindfold = getElementData(source, "blindfold")
		if not (blindfold) then blindfold = 0 end
		
		local restrainedby = getElementData(source, "restrainedBy")
		if not (restrainedby) then restrainedby=-1 end
		
		local restrainedobj = getElementData(source, "restrainedObj")
		if not (restrainedobj) then restrainedobj=-1 end
		
		fightstyle = getPedFightingStyle(source)
		local dutyskin = getElementData(source, "dutyskin")
		
		radiochannel = getElementData(source, "radiochannel")
		duty = getElementData(source, "duty")
		adminduty = getElementData(source, "adminduty")
		globalooc = getElementData(source, "globalooc")
		blur = getElementData(source, "blur")
		
		adminreports = getElementData(source, "adminreports")
		
		casualskin = getElementData(source, "casualskin")
		
		warns = getElementData(source, "warns")
		
		chatbubbles = getElementData(source, "chatbubbles")
		
		timeinserver = getElementData(source, "timeinserver")
		
		local bankmoney = getElementData(source, "bankmoney") + ( getElementData(source, "businessprofit") or 0 )
		
		local gameAccountUsername = getElementData(source, "gameaccountusername")
		local safegameAccountUsername = mysql_escape_string(handler, gameAccountUsername)
		
		job = getElementData(source, "job")
		
		tag = getElementData(source, "tag")
		
		hoursplayed = getElementData(source, "hoursplayed")
		
		if not (duty) then
			duty = 0
		end
		
		-- LAST LOGIN
		--local time = getRealTime()
		--local yearday = time.yearday
		--local year = (1900+time.year)	
		
		-- LANGUAGES
		local lang1 = getElementData(source, "languages.lang1") or 0
		local lang1skill = getElementData(source, "languages.lang1skill") or 0
		
		local lang2 = getElementData(source, "languages.lang2") or 0
		local lang2skill = getElementData(source, "languages.lang2skill") or 0
		
		local lang3 = getElementData(source, "languages.lang3") or 0
		local lang3skill = getElementData(source, "languages.lang3skill") or 0
		
		local currentLanguage = getElementData(source, "languages.current")
		
		if lang1 == 0 then lang1skill = 0 end
		if lang2 == 0 then lang2skill = 0 end
		if lang3 == 0 then lang3skill = 0 end
		
		-- LAST AREA
		local zone = exports.global:getElementZoneName(source)
		
		if not (job) then
			job = 0
		end
		
		local update = mysql_query(handler, "UPDATE characters SET casualskin='" .. casualskin .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotation='" .. rot .. "', health='" .. health .. "', armor='" .. armor .. "', skin='" .. skin .. "', dimension_id='" .. dimension .. "', interior_id='" .. interior .. "', money='" .. money .. "', cuffed='" .. cuffed .. "', radiochannel='" .. radiochannel .. "', duty='" .. duty .. "', fightstyle='" .. fightstyle .. "', lastlogin=NOW(), lastarea='" .. mysql_escape_string(handler, zone) .. "', bankmoney='" .. bankmoney .. "', tag='" .. tag .. "', hoursplayed='" .. hoursplayed .. "', timeinserver='" .. timeinserver .. "', restrainedobj='" .. restrainedobj .. "', restrainedby='" .. restrainedby .. "', dutyskin='" .. dutyskin .. "', job='" .. job .. "', blindfold='" .. blindfold .. "', lang1='" .. lang1 .. "', lang1skill='" .. lang1skill .. "', lang2='" .. lang2 .. "', lang2skill='" .. lang2skill .. "', lang3='" .. lang3 .. "', lang3skill='" .. lang3skill .. "', currLang='" .. currentLanguage .. "' WHERE charactername='" .. username .. "'")
		if (update) then
			mysql_free_result(update)
		else
			outputDebugString( "Saveplayer Update: " .. mysql_error( handler ) )
		end
		
		local update2 = mysql_query(handler, "UPDATE accounts SET muted='" .. muted .. "', hiddenadmin='" .. hiddenAdmin .. "', adminduty='" .. adminduty .. "', globalooc='" .. globalooc .. "', blur='" .. blur .. "', adminreports='" .. adminreports .. "', pmblocked='" .. pmblocked .. "', warns='" .. warns .. "', chatbubbles='" .. chatbubbles .. "' WHERE username='" .. tostring(safegameAccountUsername) .. "'")
		if (update2) then
			mysql_free_result(update2)
		else
			outputDebugString( "Saveplayer Update 2: " .. mysql_error( handler ) )
		end
		
		--outputDebugString("Saved player '" .. getPlayerName(source) .. "' [" .. reason .. "].")
	end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)
setTimer(saveAllPlayers, 3600000, 0)