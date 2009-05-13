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

scriptVer = exports.global:getScriptVersion()

salt = "vgrpkeyscotland"

function sendSalt()
	local version = nil
	if (getVersion().type~="Custom" and getVersion().type~="Release") then
		version = tonumber(string.sub(getVersion().type, 10, string.len(getVersion().type)))
	end
	
	triggerClientEvent(source, "sendSalt", source, salt, version)
end
addEvent("getSalt", true)
addEventHandler("getSalt", getRootElement(), sendSalt)

function encrypt(str)
	local hash = 0
	for i = 1, string.len(str) do
		hash = hash + tonumber(string.byte(str, i, i))
	end
	
	if (hash==0) then
		return 0
	end
	hash = hash + 100000000
	return hash
end

function encryptSerial(str)
	local hash = md5(str)
	
	local rhash = "VGRP" .. string.sub(hash, 17, 20) .. string.sub(hash, 1, 2) .. string.sub(hash, 25, 26) .. string.sub(hash, 21, 2)
	
	return rhash
end

function cleanupOnQuit(reason)
	-- clean up blips and markers only visible to this player on quit
	local blips = exports.global:getBlips(source)
	for key, value in ipairs(blips) do
		destroyElement(value)
	end
	
	local markers = exports.global:getMarkers(source)
	for key, value in ipairs(markers) do
		destroyElement(value)
	end
	
	exports.irc:sendMessage("Cleaned up after " .. getPlayerName(source) .. " [" .. reason .. "].")
	exports.irc:sendMessage(#blips .. " blips and " .. #markers .. " markers.")
end
addEventHandler("onPlayerQuit", getRootElement(), cleanupOnQuit)

function resourceStart()
	setGameType("Roleplay")
	setMapName("Valhalla Gaming: Las Venturas")
	
	setRuleValue("Script Version", tostring(scriptVer))
	setRuleValue("Author", "Daniels")

	exports.vgscoreboard:resetScoreboardColumns()
	exports.vgscoreboard:addScoreboardColumn("ID #", getRootElement(), 1, 0.05)

	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("playerJoinResourceStart", value)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
	
function onJoin()
	-- Set the user as not logged in, so they can't see chat or use commands
	setElementData(source, "loggedin", 0)
	setElementData(source, "gameaccountloggedin", 0)
	setElementData(source, "gameaccountusername", "")
	setElementData(source, "gameaccountid", "")
	setElementData(source, "adminlevel", 0)
	setElementData(source, "hiddenadmin", 0)
	setElementData(source, "globalooc", 1)
	setElementData(source, "muted", 0)
	setElementData(source, "loginattempts", 0)
	setElementData(source, "safeweaponstring", "")
	
	setElementDimension(source, 0)
	setElementInterior(source, 0)

	clearChatBox(source)
	outputChatBox("Server is running Valhalla Gaming MTA RP Script V" .. scriptVer, source)
	outputChatBox("Script by Valhalla Gaming Scripting Team.", source)
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)
addEvent("playerJoinResourceStart", false)
addEventHandler("playerJoinResourceStart", getRootElement(), onJoin)


function registerPlayer(username, password)
	local safeusername = mysql_escape_string(handler, username)
	
	local result = mysql_query(handler, "SELECT username FROM accounts WHERE username='" .. safeusername .. "'")
	
	if (mysql_num_rows(result)>0) then
		outputChatBox("An account with this name already exists. Please select another.", source, 255, 0, 0)
	else
		triggerClientEvent(source, "hideUI", source, true)
		triggerEvent("onPlayerRegister", source, username, password)
		
		-- Get registration time & date
		local time = getRealTime()
		local days = time.monthday
		local months = (time.month+1)
		local years = (1900+time.year)
				
		local registerdate = days .. "/" .. months .. "/" .. years
		
		
		local ip = getPlayerIP(source)
		
		local country = exports.global:getPlayerCountry(source)
		
		local keysalt1 = "vg"
		local keysalt2 = "securitykey"
		local securitykey = encryptSerial(keysalt1 .. username .. keysalt2)
		
		local result = mysql_query(handler, "INSERT INTO accounts SET username='" .. safeusername .. "', password=MD5('" .. salt .. password .. "'), registerdate='" .. registerdate .. "', lastlogin='" .. registerdate .. "', ip='" .. ip .. "', securitykey='" .. securitykey .. "', country='" .. tostring(country) .. "', friendsmessage='Sample Message'")
		
		if (result) then
			outputChatBox("You have now registered, Thank you for registering.", source, 0, 255, 0)
			outputChatBox(" ", source)
			outputChatBox("Your security key is " .. tostring(securitykey) .. ". Please write this down somewhere safe.", source, 255, 194, 14)
			outputChatBox("You will be asked for this should you forget your password.", source, 255, 194, 14)
			mysql_free_result(result)
		else
			outputChatBox("Error 100000 - Report on forums.", source, 255, 0, 0)
		end
	end
	
	if (result) then
		mysql_free_result(result)
	end
end
addEvent("onPlayerRegister", false)
addEvent("attemptRegister", true)
addEventHandler("attemptRegister", getRootElement(), registerPlayer)


function spawnCharacter(charname)
	takeAllWeapons(source)
	setElementData(source, "safeweaponstring", "")
	local id = getElementData(source, "gameaccountid")
	charname = string.gsub(tostring(charname), " ", "_")
	
	local safecharname = mysql_escape_string(handler, charname)
	
	local result = mysql_query(handler, "SELECT id, x, y, z, rotation, interior_id, dimension_id, health, armor, skin, money, faction_id, cuffed, radiochannel, masked, duty, cellnumber, fightstyle, pdjail, pdjail_time, job, casualskin, weapons, ammo, items, itemvalues, car_license, gun_license, bankmoney, fingerprint, tag FROM characters WHERE charactername='" .. charname .. "' AND account='" .. id .. "'")
	
	if (result) then
		local id = mysql_result(result, 1, 1)
		local x = mysql_result(result, 1, 2)
		local y = mysql_result(result, 1, 3)
		local z = mysql_result(result, 1, 4)
		
		local rot = tonumber(mysql_result(result, 1, 5))
		local interior = tonumber(mysql_result(result, 1, 6))
		local dimension = tonumber(mysql_result(result, 1, 7))
		local health = tonumber(mysql_result(result, 1, 8))
		local armor = tonumber(mysql_result(result, 1, 9))
		local skin = tonumber(mysql_result(result, 1, 10))
		local money = tonumber(mysql_result(result, 1, 11))
		local factionID = tonumber(mysql_result(result, 1, 12))
		local cuffed = tonumber(mysql_result(result, 1, 13))
		local radiochannel = tonumber(mysql_result(result, 1, 14))
		local masked = tonumber(mysql_result(result, 1, 15))
		local duty = mysql_result(result, 1, 16)
		local cellnumber = tonumber(mysql_result(result, 1, 17))
		local fightstyle = tonumber(mysql_result(result, 1, 18))
		local pdjail = tonumber(mysql_result(result, 1, 19))
		local pdjail_time = tonumber(mysql_result(result, 1, 20))
		local job = tonumber(mysql_result(result, 1, 21))
		local casualskin = tonumber(mysql_result(result, 1, 22))
		
		local weapons = tostring(mysql_result(result, 1, 23))
		local ammo = tostring(mysql_result(result, 1, 24))
		
		local items = tostring(mysql_result(result, 1, 25))
		local itemvalues = tostring(mysql_result(result, 1, 26))
		
		local carlicense = tonumber(mysql_result(result, 1, 27))
		local gunlicense = tonumber(mysql_result(result, 1, 28))
		
		local bankmoney = tonumber(mysql_result(result, 1, 29))
		
		local fingerprint = tostring(mysql_result(result, 1, 30))
		
		local tag = tonumber(mysql_result(result, 1, 31))
		
		if (items~=tostring(mysql_null())) and (itemvalues~=tostring(mysql_null())) then
			setElementData(source, "items", items)
			setElementData(source, "itemvalues", itemvalues)
		end
		
		setElementData(source, "loggedin", 1)
		
		-- Check his name isn't in use by a squatter
		local playerWithNick = getPlayerFromNick(tostring(charname))
		if (playerWithNick) and (playerWithNick~=source) then
			local newname = "Temp_" .. tostring(math.random(10000, 99999))
			setElementData(playerWithNick, "legitnamechange", 1)
			setPlayerName(playerWithNick, tostring(newname))
			setElementData(playerWithNick, "legitnamechange", 0)
		end
		
		-- casual skin
		setElementData(source, "casualskin", casualskin)
		
		-- bleeding
		setElementData(source, "bleeding", 0)
		
		-- Set their name to the characters
		setElementData(source, "legitnamechange", 1)
		setPlayerName(source, tostring(charname))
		local pid = getElementData(source, "playerid")
		local fixedName = "(" .. tostring(pid) .. ")" .. charname

		setPlayerNametagText(source, tostring(fixedName))
		setElementData(source, "legitnamechange", 0)
		
		-- If their an admin change their nametag colour
		local adminlevel = getElementData(source, "adminlevel")
		local hiddenAdmin = getElementData(source, "hiddenadmin")
		local adminduty = getElementData(source, "adminduty")
		local muted = getElementData(source, "muted")
		local donator = getElementData(source, "donator")
		
		if (adminlevel>0) and (adminduty==1) and (hiddenAdmin==0) then
			setPlayerNametagColor(source, 255, 194, 14)
		else
			setPlayerNametagColor(source, 255, 255, 255)
		end
		
		-- Donator
		if (adminlevel==0) or (adminduty==0) or (hiddenadmin==0) then
			if (donator>0) then
				setPlayerNametagColor(source, 167, 133, 63)
			else
				setPlayerNametagColor(source, 255, 255, 255)
			end
		end
		
		-- Server message
		exports.irc:sendMessage("[SERVER] Character " .. charname .. " logged in.")
		clearChatBox(source)
		outputChatBox("You are now playing as " .. charname .. ".", source, 0, 255, 0)
		outputChatBox("Looking for animations? /animlist", source, 255, 194, 14)
		outputChatBox("Need Help? /helpme", source, 255, 194, 14)
		
	
		
		
		-- Load the character info
		spawnPlayer(source, x, y, z, rot, skin)
		setElementHealth(source, health)
		setPedArmor(source, armor)
		
		
		setElementDimension(source, dimension)
		setElementInterior(source, interior, x, y, z)
		setCameraInterior(source, interior)
		
		local motdresult = mysql_query(handler, "SELECT value FROM settings WHERE name='motd' LIMIT 1")
		local motd = mysql_result(motdresult, 1, 1)
		mysql_free_result(motdresult)
		outputChatBox("MOTD: " .. motd, source, 255, 255, 0)
			
		-- ADMIN JAIL
		local jailed = tonumber(getElementData(source, "adminjail"))
		local jailed_time = getElementData(source, "adminjail_time")
		local jailed_by = getElementData(source, "adminjail_by")
		local jailed_reason = getElementData(source, "adminjail_reason")
		
		if (jailed==1) then
			outputChatBox("You still have " .. jailed_time .. " minute(s) to serve of your admin jail sentance.", source, 255, 0, 0)
			outputChatBox(" ", source)
			outputChatBox("You were jailed by: " .. jailed_by .. ".", source, 255, 0, 0)
			outputChatBox("Reason: " .. jailed_reason, source, 255, 0, 0)
				
			local incVal = getElementData(source, "playerid")
				
			setElementDimension(source, 65400+incVal)
			setElementInterior(source, 6)
			setCameraInterior(source, 6)
			setElementPosition(source, 263.821807, 77.848365, 1001.0390625)
			setPedRotation(source, 267.438446)
				
			local theTimer = setTimer(timerUnjailPlayer, 60000, jailed_time, source)
			setElementData(source, "jailserved", 0)
			setElementData(source, "jailtime", jailed_time)
			setElementData(source, "jailtimer", theTimer)
			
			setElementInterior(source, 6)
			setCameraInterior(source, 6)
		end
		
		-- PD JAIL
		if (pdjail==1) then
			outputChatBox("You still have " .. pdjail_time .. " minute(s) to serve of your state jail sentance.", source, 255, 0, 0)
				
			local theTimer = setTimer(timerPDUnjailPlayer, 60000, pdjail_time, source)
			setElementData(source, "pd.jailserved", 0)
			setElementData(source, "pd.jailtime", pdjail_time)
			setElementData(source, "pd.jailtimer", theTimer)
		else
			setElementData(source, "pd.jailserved", 1)
			setElementData(source, "pd.jailtime", 0)
			setElementData(source, "pd.jailtimer", nil)
			if (pdjail_time<0) then
				timerPDUnjailPlayer(source)
			end
		end
			
		-- FACTIONS
		local factionName = nil
		if (factionID~=-1) then
			local fresult = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. factionID .. "'")
			if (mysql_num_rows(fresult)>0) then
				factionName = mysql_result(fresult, 1, 1)
			else
				factionName = "Citizen"
				factionID = -1
				outputChatBox("Your faction has been deleted, and you have been set factionless.", source, 255, 0, 0)
				mysql_query(handler, "UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. id .. "' LIMIT 1")
			end
			
			if (fresult) then
				mysql_free_result(fresult)
			end
		else
			factionName = "Citizen"
		end
		
		local theTeam = getTeamFromName(tostring(factionName))
		setPlayerTeam(source, theTeam)
		-- END FACTIONS
		
		-- number of friends etc
		local playercount = getPlayerCount()
		local maxplayers = getMaxPlayers()
		local percent = math.ceil((playercount/maxplayers)*100)
		
		local friendsonline = 0
		local friends = tostring(getElementData(source, "friends.list"))
		
		local factiononline = 0
		
		for i=1, 100 do
			local fid = gettok(friends, i, 59)
			if (fid) then
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local id = tonumber(getElementData(value, "gameaccountid"))
					if (id==tonumber(fid)) then
						friendsonline = friendsonline + 1
					end
				end
			else
				break
			end
		end
		
		local factiononline = #getPlayersInTeam(theTeam)
		
		
		if (factionName~="Citizen") then
			outputChatBox("Players Online: " .. playercount .. "/" .. maxplayers .. " (" .. percent .. "%)  -   " .. factiononline .. " Faction Member(s) - " .. friendsonline .. " Friend(s).", source, 255, 194, 14)
		else
			outputChatBox("Players Online: " .. playercount .. "/" .. maxplayers .. " (" .. percent .. "%) - " .. friendsonline .. " Friend(s).", source, 255, 194, 14)
		end
		
		-- LAST LOGIN
		local time = getRealTime()
		local days = time.monthday
		local months = (time.month+1)
		local years = (1900+time.year)
				
		local yearday = time.yearday

			
		local username = getPlayerName(source)
		local safeusername = mysql_escape_string(handler, username)
		
		local update = mysql_query(handler, "UPDATE characters SET year='" .. years .. "', yearday='" .. yearday .. "' WHERE charactername='" .. safeusername .. "'")
		
		if (update) then
			mysql_free_result(update)
		end
		
		-- Player is cuffed
		if (cuffed==1) then
			toggleControl(source, "sprint", false)
			toggleControl(source, "fire", false)
			toggleControl(source, "jump", false)
			toggleControl(source, "next_weapon", false)
			toggleControl(source, "previous_weapon", false)
			toggleControl(source, "accelerate", false)
			toggleControl(source, "brake_reverse", false)
		end
			
		setElementData(source, "adminlevel", tonumber(adminlevel))
		setElementData(source, "loggedin", 1)
		setElementData(source, "businessprofit", 0)
		setElementData(source, "dbid", tonumber(id))
		setElementData(source, "hiddenadmin", tonumber(hiddenAdmin))
		setElementData(source, "legitnamechange", 0)
		setElementData(source, "muted", tonumber(muted))
		exports.global:setPlayerSafeMoney(source, money)
		exports.global:checkMoneyHacks(source)
		
		setElementData(source, "faction", factionID)
		setElementData(source, "factionMenu", 0)
		setElementData(source, "restrain", cuffed)
		setElementData(source, "tazed", 0)
		setElementData(source, "cellnumber", cellnumber)
		setElementData(source, "calling", nil)
		setElementData(source, "calltimer", nil)
		setElementData(source, "phonestate", 0)
		setElementData(source, "backpack", 0)
		setElementData(source, "radiochannel", radiochannel)
		setElementData(source, "masked", masked)
		setElementData(source, "bullettype", 0)
		setElementData(source, "armortype", 0)
		setElementData(source, "realinvehicle", 0)
		setElementData(source, "duty", duty)
		setElementData(source, "job", job)
		setElementData(source, "deaglemode", 0)
		setElementData(source, "license.car", carlicense)
		setElementData(source, "license.gun", gunlicense)
		setElementData(source, "bankmoney", bankmoney)
		setElementData(source, "fingerprint", fingerprint)
		setElementData(source, "tag", tag)
		
		-- Let's give them their weapons
		if (tostring(weapons)~=tostring(mysql_null())) and (tostring(ammo)~=tostring(mysql_null())) then -- if player has weapons saved
			for i=0, 12 do
				local tokenweapon = gettok(weapons, i+1, 59)
				local tokenammo = gettok(ammo, i+1, 59)
				
				if (not tokenweapon) or (not tokenammo) then
					break
				else
					giveWeapon(source, tonumber(tokenweapon), tonumber(tokenammo), false)
				end
			end
		end
		
		-- Let's stick some blips on the properties they own
		for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local type = getElementData(value, "type")
			if (type=="interior") then
				local inttype = getElementData(value, "inttype")
				local owner = getElementData(value, "inttype")
				if (owner==id) and (inttype<2) then -- house/business and owned by this player
					local x, y, z = getElementPosition(value)
					if (inttype==0) then -- house
						local blip = createBlip(x, y, z, 31, 2, 255, 0, 0, 255, 0)
						exports.pool:allocateElement(blip)
						setElementVisibleTo(blip, getRootElement(), false)
						setElementVisibleTo(blip, source, true)
						setElementData(blip, "type", "accountblip")
						setElementData(blip, "owner", tonumber(getElementData(source, "gameaccountid")))
					elseif (inttype==2) then -- business
						local blip = createBlip(x, y, z, 32, 2, 255, 0, 0, 255, 0, source)
						exports.pool:allocateElement(blip)
						setElementVisibleTo(blip, getRootElement(), false)
						setElementVisibleTo(blip, source, true)
					end
				end
			end
		end
		
		-- Fight style
		setPedFightingStyle(source, tonumber(fightstyle))
		
		-- Achievement
		if not (exports.global:doesPlayerHaveAchievement(source, 1)) then
			exports.global:givePlayerAchievement(source, 1) -- Welcome to Las Venturas
			triggerClientEvent(source, "showCityGuide", source)
		end
		
		-- BETA ONLY
		--setTimer(giveBetaAchievement, 10000, 1, source)
		
		fadeCamera(source, true, 2)
		triggerEvent("onCharacterLogin", source, charname, factionID)
	end
end
addEvent("onCharacterLogin", false)
addEvent("spawnCharacter", true)
addEventHandler("spawnCharacter", getRootElement(), spawnCharacter)

function giveBetaAchievement(player)
	-- BETA ONLY
	--exports.global:givePlayerAchievement(player, 18) -- BETA ONLY
end

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "gameaccountid")
		
		if (timeServed) then
			setElementData(jailedPlayer, "jailserved", timeServed+1)
			local timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft)
		
			if (timeLeft==0) then
				mysql_query(handler, "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. accountID .. "'")
				setElementData(jailedPlayer, "jailtimer", nil)
				setElementPosition(jailedPlayer, 1694.5098876953, 1449.6469726563, 10.763301849365)
				setPedRotation(jailedPlayer, 274.48666381836)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				outputChatBox("Your time has been served, Behave next time!", jailedPlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmJail: " .. getPlayerName(jailedPlayer) .. " has served his jail time.")
				exports.irc:sendMessage("[ADMIN] " .. getPlayerName(jailedPlayer) .. " was unjailed by script (Time Served)")
			else
				mysql_query(handler, "UPDATE accounts SET adminjail_time='" .. timeLeft .. "' WHERE id='" .. accountID .. "'")
			end
		end
	else
		local theTimer = getElementData(jailedPlayer, "jailtimer")
		killTimer(theTimer)
	end
end


function loginPlayer(username, password, operatingsystem)
	local safeusername = mysql_escape_string(handler, username)
	local result = mysql_query(handler, "SELECT id, admin, hiddenadmin, adminduty, donator, adminjail, adminjail_time, adminjail_by, adminjail_reason, banned, banned_by, banned_reason, muted, globalooc, blur, friendsmessage, friends, adminreports FROM accounts WHERE username='" .. safeusername .. "' AND password='" .. password .. "'")
	
	if (mysql_num_rows(result)>0) then
		triggerEvent("onPlayerLogin", source, username, password)
		
		local id = tonumber(mysql_result(result, 1, 1))
		
		-- Check the account isn't already logged in
		local found = false
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			local accid = tonumber(getElementData(value, "gameaccountid"))
			if (accid) then
				if (accid==id) and (value~=source) then
					found = true
					break
				end
			end
		end
		
		if not (found) then
			triggerClientEvent(source, "hideUI", source, false)
			local admin = tonumber(mysql_result(result, 1, 2))
			local hiddenadmin = tonumber(mysql_result(result, 1, 3))
			local adminduty = tonumber(mysql_result(result, 1, 4))
			local donator = tonumber(mysql_result(result, 1, 5))
			local adminjail = tonumber(mysql_result(result, 1, 6))
			local adminjail_time = tonumber(mysql_result(result, 1, 7))
			local adminjail_by = tostring(mysql_result(result, 1, 8))
			local adminjail_reason = mysql_result(result, 1, 9)
			local banned = tonumber(mysql_result(result, 1, 10))
			local banned_by = mysql_result(result, 1, 11)
			local banned_reason = mysql_result(result, 1, 12)
			local muted = tonumber(mysql_result(result, 1, 13))
			local globalooc = tonumber(mysql_result(result, 1, 14))
			local blur = tonumber(mysql_result(result, 1, 15))
			local fmessage = mysql_result(result, 1, 16)
			local friends = mysql_result(result, 1, 17)
			local adminreports = tonumber(mysql_result(result, 1, 18))
			
			local country = exports.global:getPlayerCountry(source)
			if (username=="Daniels") then
				setElementData(source, "country", "SC")
			else
				setElementData(source, "country", tostring(country))
			end
			
			-- Fix for blank messages
			if (mysql_result(result, 1, 16)==mysql_null()) then
				fmessage = "No Message"
			end
			setElementData(source, "friends.message", fmessage)
			
			-- Fix for blank friends
			if (mysql_result(result, 1, 17)==mysql_null()) then
				friends = ""
			end
			setElementData(source, "friends.list", friends)
			
			setElementData(source, "donatorlevel", tonumber(donator))
			setElementData(source, "adminlevel", tonumber(admin))
			setElementData(source, "hiddenadmin", tonumber(hiddenadmin))
			setElementData(source, "donator", tonumber(donator))
			
			setElementData(source, "blur", blur)
			if (blur==0) then
				setPlayerBlurLevel(source, 0)
			else
				setPlayerBlurLevel(source, 38)
			end
			
			if (banned==1) then
				clearChatBox()
				outputChatBox("You have been banned from this server by: " .. tostring(banned_by) .. ".", source, 255, 0, 0)
				outputChatBox("Ban Reason: " .. tostring(banned_reason) .. ".", source, 255, 0, 0)
				outputChatBox(" ", source)
				outputChatBox("You can appeal against this ban on our forums at http://www.valhallagaming.net/forums")
				setTimer(kickPlayer, 15000, 1, source, getRootElement(), "Account is banned")
			else
				setElementData(source, "gameaccountloggedin", 1)
				setElementData(source, "gameaccountusername", username)
				setElementData(source, "gameaccountid", tonumber(id))
				setElementData(source, "adminduty", tonumber(adminduty))
				setElementData(source, "adminjail", tonumber(adminjail))
				setElementData(source, "adminjail_time", tonumber(adminjail_time))
				setElementData(source, "adminjail_by", tostring(adminjail_by))
				setElementData(source, "adminjail_reason", tostring(adminjail_reason))
				setElementData(source, "globalooc", tonumber(globalooc))
				setElementData(source, "muted", tonumber(muted))
				setElementData(source, "adminreports", adminreports)
				
				sendAccounts(source, id)
				
				-- Get login time & date
				local time = getRealTime()
				local days = time.monthday
				local months = (time.month+1)
				local years = (1900+time.year)
				
				local yearday = time.yearday
				local logindate = days .. "/" .. months .. "/" .. years
				
				local ip = getPlayerIP(source)
				
				local update = mysql_query(handler, "UPDATE accounts SET lastlogin='" .. logindate .. "', year='" .. years .. "', yearday='" .. yearday .. "', ip='" .. ip .. "', country='" .. country .. "', os='" .. operatingsystem .. "' WHERE id='" .. id .. "'")
				
				if (update) then
					mysql_free_result(update)
				end
				
			end
		else
			showChat(source, true)
			outputChatBox("This account is already logged in. You cannot login more than once.", source, 255, 0, 0)
		end
	else
		showChat(source, true)
		local attempts = tonumber(getElementData(source, "loginattempts"))
		attempts = attempts + 1
		setElementData(source, "loginattempts", attempts)
		
		if (attempts>=3) then
			kickPlayer(source, true, false, false, getRootElement(), "Too many login attempts")
		else
			outputChatBox("Invalid Username or Password.", source, 255, 0, 0)
		end
	end
	
	if (result) then
		mysql_free_result(result)
	end
end
addEvent("onPlayerLogin", false)
addEvent("attemptLogin", true)
addEventHandler("attemptLogin", getRootElement(), loginPlayer)

function retrieveDetails(securityKey)
	local safesecurityKey = mysql_escape_string(handler, tostring(securityKey))

	local result = mysql_query(handler, "SELECT username FROM accounts WHERE securitykey='" .. safesecurityKey .. "'")

	if (mysql_num_rows(result)>0) then
		local username = mysql_result(result, 1, 1)

		local letter1 = exports.global:randChar()
		local num = math.random(0, 999999)
		
		-- Randomize the casing
		local randnumber1 = math.random(0, 1)
		local randnumber2 = math.random(0, 1)
		local randnumber3 = math.random(0, 1)
		local randnumber4 = math.random(0, 1)
		
		if (randnumber1==0) then
			letter1 = string.upper(letter1)
		else
			letter1 = string.lower(letter1)
		end
		
		if (randnumber2==0) then
			letter2 = string.upper(letter1)
		else
			letter2 = string.lower(letter1)
		end
		
		if (randnumber3==0) then
			letter3 = string.upper(letter1)
		else
			letter3 = string.lower(letter1)
		end
		
		if (randnumber4==0) then
			letter4 = string.upper(letter1)
		else
			letter4 = string.lower(letter1)
		end
		
		
		
		local letter2 = exports.global:randChar()
		local newPassword = letter2 .. tostring(num) .. letter1
		local update = mysql_query(handler, "UPDATE accounts SET password=MD5('" .. salt .. newPassword .. "') WHERE username='" .. username .. "'")
		
		if (update) then
			outputChatBox("Your account name is '" .. tostring(username) .. "'.", source, 255, 194, 14)
			outputChatBox("Your new password is '" .. tostring(newPassword) .. "' (Write it down!).", source, 255, 194, 14)
			outputChatBox("You can change this password after login.", source, 255, 194, 14)
			mysql_free_result(update)
		else
			outputChatBox("Error 100001 - Report on forums.", source, 255, 0, 0)
		end
	else
		outputChatBox("Invalid security key.", source, 255, 0, 0)
	end
	
	if (result) then
		mysql_free_result(result)
	end
end
addEvent("retrieveDetails", true)
addEventHandler("retrieveDetails", getRootElement(), retrieveDetails)

function sendAccounts(thePlayer, id, isChangeChar)
	takeAllWeapons(thePlayer)
	local accounts = { }
	
	local result = mysql_query(handler, "SELECT id, charactername, cked, lastarea, age, gender, faction_id, faction_rank, skin, yearday, year FROM characters WHERE account='" .. id .. "'")
	
	if (mysql_num_rows(result)>0) then
		if (isChangeChar) then
			triggerEvent("savePlayer", source, "Change Character", source)
		end
		
		local i = 1
		for i=1, mysql_num_rows(result) do
			accounts[i] = { }
			accounts[i][1] = mysql_result(result, i, 1)
			accounts[i][2] = mysql_result(result, i, 2)
			accounts[i][3] = mysql_result(result, i, 3)
			accounts[i][4] = mysql_result(result, i, 4)
			accounts[i][5] = mysql_result(result, i, 5)
			accounts[i][6] = mysql_result(result, i, 6)
			
			local factionID = tonumber(mysql_result(result, i, 7))
			local factionRank = tonumber(mysql_result(result, i, 8))
			
			if (factionID<1) or not (factionID) then
				accounts[i][7] = "Not in a faction"
				accounts[i][8] = "Nullement"
			else
				factionResult = mysql_query(handler, "SELECT name, rank_" .. factionRank .. " FROM factions WHERE id='" .. tonumber(factionID) .. "'")

				if (mysql_num_rows(factionResult)>0) then
					accounts[i][7] = mysql_result(factionResult, 1, 1)
					accounts[i][8] = mysql_result(factionResult, 1, 2)
					
					if (string.len(accounts[i][7])>53) then
						accounts[i][7] = string.sub(accounts[i][7], 1, 32) .. "..."
					end
				else
					accounts[i][7] = "Nullement"
					accounts[i][8] = "Nullement"
				end
				
				if(factionResult) then
					mysql_free_result(factionResult)
				end
			end
			accounts[i][9] = mysql_result(result, i, 9)
			accounts[i][10] = mysql_result(result, i, 10)
			accounts[i][11] = mysql_result(result, i, 11)
			i = i + 1
		end
	end
	
	if (result) then
		mysql_free_result(result)
	end
	
	
	local playerid = getElementData(thePlayer, "playerid")

	spawnPlayer(thePlayer, 258.43417358398, -41.489139556885, 1002.0234375, 268.19247436523, 0, 14, 65000+playerid)
	
	
	-- Get achievements
	local gameAccountID = getElementData(source, "gameaccountid")
	local aresult = mysql_query(handler, "SELECT achievementid, date FROM achievements WHERE account='" .. gameAccountID .. "'")
	
	local allAchievements = mysql_query(handler, "SELECT points FROM achievementslist")
	local achievements = { }
	
	-- Determine the total number of achievements & points
	local achievementCount = 0
	local achievementPointsCount = 0
	local points = 0
	local amount = 0
	if (allAchievements) then
		for result, row in mysql_rows(allAchievements) do
			achievementPointsCount = achievementPointsCount + tonumber(row[1])
			achievementCount = achievementCount + 1
		end
		mysql_free_result(allAchievements)
	end
	
	if (aresult) then
		local key = 1
		for result, row in mysql_rows(aresult) do
			local achievementID = row[1]
			achievements[key] = { }
			achievements[key][4] = row[2]
			
			local achresult = mysql_query(handler, "SELECT name, description, points FROM achievementslist WHERE id='" .. achievementID .. "'")
			if (mysql_num_rows(achresult)>0) then
				achievements[key][1] = tostring(mysql_result(achresult, 1, 1))
				achievements[key][2] = tostring(mysql_result(achresult, 1, 2))
				achievements[key][3] = tonumber(mysql_result(achresult, 1, 3))
				amount = amount + 1
				points = points + tonumber(mysql_result(achresult, 1, 3))
				key = key + 1
			end
			
			if (achresult) then
				mysql_free_result(achresult)
			end
		end
		mysql_free_result(aresult)
	end
	setElementData(thePlayer, "achievements.points", points)
	setElementData(thePlayer, "achievements.count", amount)
	
	triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts, achievementCount, achievementPointsCount, achievements)
end
addEvent("sendAccounts", true)
addEventHandler("sendAccounts", getRootElement(), sendAccounts)

function deleteCharacterByName(charname)
	
	local fixedName = mysql_escape_string(handler, string.gsub(tostring(charname), " ", "_"))
	
	local accountID = getElementData(source, "gameaccountid")
	local result = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. fixedName .. "' AND account='" .. accountID .. "' LIMIT 1")
	local charid = tonumber(mysql_result(result, 1, 1))
	mysql_free_result(result)
		
	if (charid) then -- not ck'ed
		mysql_query(handler, "DELETE FROM characters WHERE charactername='" .. fixedName .. "' AND account='" .. accountID .. "' LIMIT 1")
		mysql_query(handler, "UPDATE interiors SET owner=-1, locked=1 WHERE owner='" .. tonumber(charid) .. "' AND type<2")
		mysql_query(handler, "DELETE FROM vehicles WHERE owner='" .. tonumber(charid) .. "'")
	else
		fixedName = string.sub(fixedName, 0, string.len(fixedName)-11)
		
		local result = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. fixedName .. "' AND account='" .. accountID .. "' LIMIT 1")
		local charid = tonumber(mysql_result(result, 1, 1))
		mysql_free_result(result)
		
		mysql_query(handler, "DELETE FROM characters WHERE charactername='" .. fixedName .. "' AND account='" .. accountID .. "' LIMIT 1")
		mysql_query(handler, "UPDATE interiors SET owner=-1, locked=1 WHERE owner='" .. tonumber(charid) .. "' AND type<2")
		mysql_query(handler, "DELETE FROM vehicles WHERE owner='" .. tonumber(charid) .. "'")
	end
	sendAccounts(source, accountID)
	showChat(source, true)
end
addEvent("deleteCharacter", true)
addEventHandler("deleteCharacter", getRootElement(), deleteCharacterByName)


function clearChatBox(thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
end
addCommandHandler("clearchat", clearChatBox) -- Users can now clear their chat if they wish

function stripPlayer()
	for i = 0, 17 do
		removePedClothes(source, i)
	end
end
addEvent("stripPlayer", true)
addEventHandler("stripPlayer", getRootElement(), stripPlayer)

function declineTOS()
	kickPlayer(source, getRootElement(), "Declined TOS")
end
addEvent("declineTOS", true)
addEventHandler("declineTOS", getRootElement(), declineTOS)

function adjustFatness(val)
	setPedStat(source, 21, tonumber(val))
end
addEvent("adjustFatness", true)
addEventHandler("adjustFatness", getRootElement(), adjustFatness)

function adjustMuscles(val)
	setPedStat(source, 23, tonumber(val))
end
addEvent("adjustMuscles", true)
addEventHandler("adjustMuscles", getRootElement(), adjustMuscles)

function addClothes(texture, model, ctype)
	if (texture=="NONE") and (model=="NONE") then
		local texture, model = getPedClothes(source, ctype)
		removePedClothes(source, tonumber(ctype), texture, model)
	else
		removePedClothes(source, ctype)
		addPedClothes(source, texture, model, ctype)
	end
end
addEvent("addClothes", true)
addEventHandler("addClothes", getRootElement(), addClothes)

function doesCharacterExist(charname)
	charname = string.gsub(tostring(charname), " ", "_")
	local safecharname = mysql_escape_string(handler, charname)
	
	local result = mysql_query(handler, "SELECT charactername FROM characters WHERE charactername='" .. safecharname .. "'")
	
	if (mysql_num_rows(result)>0) then
		triggerClientEvent(source, "characterNextStep", source, true)
	else
		triggerClientEvent(source, "characterNextStep", source, false)
	end
	
	if (result) then
		mysql_free_result(result)
	end
end
addEvent("doesCharacterExist", true)
addEventHandler("doesCharacterExist", getRootElement(), doesCharacterExist)

function resetNick(oldNick, newNick)
	setElementData(source, "legitnamechange", 1)
	setPlayerName(source, oldNick)
	setElementData(source, "legitnamechange", 0)
	exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(oldNick) .. " tried to change name to " .. tostring(newNick) .. ".")
end

addEvent("resetName", true )
addEventHandler("resetName", getRootElement(), resetNick)

-- ////////////////////////////////////////
-- STORE CREATED CHARACTERS
-- ///////////////////////////////////////
leftUpperArmTattoos = { {"NONE", "NONE"}, {"4WEED", "4weed"}, {"4RIP", "4rip"}, {"4SPIDER", "4spider"} }
leftLowerArmTattoos = { {"NONE", "NONE"}, {"5GUN", "5gun"}, {"5CROSS", "5cross"}, {"5CROSS2", "5cross2"}, {"5CROSS3", "5cross3"}  }
rightUpperArmTattoos = { {"NONE", "NONE"}, {"6AZTEC", "6aztec"}, {"6CROWN", "6crown"}, {"6CLOWN", "6clown"}, {"6AFRICA", "6africa"} }
rightLowerArmTattoos = { {"NONE", "NONE"}, {"7CROSS", "7cross"}, {"7CROSS2", "7cross2"}, {"7MARY", "7mary"} }
backTattoos = { {"NONE", "NONE"}, {"8SA", "8sa"}, {"8SA2", "8sa2"}, {"8SA3", "8sa3"}, {"8WESTSD", "8westside"}, {"8SANTOS", "8santos"}, {"8POKER", "8poker"}, {"8GUN", "8gun"} }
leftChestTattoos = { {"NONE", "NONE"}, {"9CROWN", "9crown"}, {"9GUN", "9GUN"}, {"9GUN2", "9gun2"}, {"9HOMBY", "9homeboy"}, {"9BULLT", "9bullet"}, {"9RASTA", "9rasta"} }
rightChestTattoos = { {"NONE", "NONE"}, {"10LS", "10ls"}, {"10LS2", "10ls2"}, {"10LS3", "10ls3"}, {"10LS4", "10ls4"}, {"10ls5", "10ls5"}, {"10OG", "10og"}, {"10WEED", "10weed"} }
stomachTattoos = { {"NONE", "NONE"}, {"11GROVE", "11grove"}, {"11GROV2", "11grove2"}, {"11GROV3", "11grove3"}, {"11DICE", "11dice"}, {"11DICE2", "11dice2"}, {"11JAIL", "11jail"}, {"11GGIFT", "11godsgift"} }
lowerBackTattoos = { {"NONE", "NONE"}, {"12ANGEL", "12angels"}, {"12MAYBR", "12mayabird"}, {"12DAGER", "12dagger"}, {"12BNDIT", "12bandit"}, {"12CROSS", "12cross7"}, {"12MYFAC", "12mayafce"} }

hair = { {"player_face", "head"}, {"hairblond", "head"}, {"hairred", "head"}, {"hairblue", "head"}, {"hairgreen", "head"}, {"hairpink", "head"}, {"bald", "head"}, {"baldbeard", "head"}, {"baldtash", "head"}, {"baldgoatee", "head"}, {"highfade", "head"}, {"highafro", "highafro"}, {"wedge", "wedge"}, {"slope", "slope"}, {"jhericurl", "jheri"}, {"cornrows", "cornrows"}, {"cornrowsb", "cornrows"}, {"tramline", "tramline"}, {"groovecut", "groovecut"}, {"mohawk", "mohawk"}, {"mohawkblond", "mohawk"}, {"mohawkpink", "mohawk"}, {"mohawkbeard", "mohawk"}, {"afro", "afro"}, {"afrotash", "afro"}, {"afrobeard", "afro"}, {"afroblond", "afro"}, {"flattop", "flattop"}, {"elvishair", "elvishair"}, {"beard", "head"}, {"tash", "head"}, {"goatee", "head"}, {"afrogoatee", "afro"} }
hats = { {"NONE", "NONE"}, {"bandred", "bandana"}, {"bandblue", "bandana"}, {"bandgang", "bandana"}, {"bandblack", "bandana"}, {"bandred2", "bandknots"}, {"bandblue2", "bandknots"}, {"bandblack2", "bandknots"}, {"bandgang2", "bandknots"}, {"capknitgrn", "capknit"}, {"captruck", "captruck"}, {"cowboy", "cowboy"}, {"hattiger", "cowboy"}, {"helmet", "helmet"}, {"moto", "moto"}, {"boxingcap", "boxingcap"}, {"hockey", "hockeymask"}, {"capgang", "cap"}, {"capgangback", "capblack"}, {"capgangside", "capside"}, {"capgangover", "capovereye"}, {"capgangup", "caprimup"}, {"bikerhelmet", "bikerhelmet"}, {"capred", "cap"}, {"capredback", "capback"}, {"capredside", "capside"}, {"capredover", "capovereye"}, {"capredup", "caprimup"}, {"capblue", "cap"}, {"capblueback", "capback"}, {"capblueside", "capside"}, {"capblueover", "capovereye"}, {"capblueup", "caprimup"}, {"skullyblk", "scullycap"}, {"skullygrn", "skullycap"}, {"hatmancblk", "hatmanc"}, {"hatmancplaid", "hatmanc"}, {"capzip", "cap"}, {"capzipback", "capback"}, {"capzipside", "capside"}, {"capzipover", "capovereye"}, {"capzipup", "caprimup"}, {"beretred", "beret"}, {"beretblk", "beret"}, {"capblk", "cap"}, {"capblkback", "capback"}, {"capblkside", "capside"}, {"capblkeover", "capovereye"}, {"capblkup", "caprimup"}, {"trilbydrk", "trilby"}, {"trilbylght", "trilby"}, {"bowler", "bowler"}, {"bolwerred", "bowlerred"}, {"bowlerblue", "bowler"}, {"bowleryellow", "bowler"}, {"boater", "boater"}, {"bowlergang", "bowler"}, {"boaterblk", "boater"} }
necks = { {"NONE", "NONE"}, {"dogtag", "neck"}, {"neckafrica", "neck"}, {"stopwatch", "neck"}, {"necksaints", "neck"}, {"neckhash", "neck"}, {"necksilver", "neck2"}, {"neckgold", "neck2"}, {"neckropes", "neck2"}, {"neckropg", "neck2"}, {"neckls", "neck2"}, {"neckdollar", "neck2"}, {"neckcross", "neck2"} }
faces = { {"NONE", "NONE"}, {"groucho", "grouchos"}, {"zorro", "zorromask"}, {"eyepatch", "glasses01"}, {"glasses04", "glasses04"}, {"bandred3", "bandmask"}, {"bandblue3", "bandmask"}, {"bandgang3", "bandmask"}, {"bandblack3", "bandmask"}, {"glasses01dark", "glasses01"}, {"glasses04dark", "glasses04"}, {"glasses03", "glasses03"}, {"glasses03red", "glasses03"}, {"glasses03blue", "glasses03"}, {"glasses03dark", "glasses03"}, {"glasses05dark", "glasses03"}, {"glasses05", "glasses03"} }
upperbody = { {"torso", "player_torso"}, {"vestblack", "vest"}, {"vest", "vest"}, {"tshirt2horiz", "tshirt2"}, {"tshirtwhite", "tshirt"}, {"tshirtlovels", "tshirt"}, {"tshirtblunts", "tshirt"}, {"shirtbplaid", "shirtb"}, {"shirtbcheck", "shirtb"}, {"field", "field"}, {"tshirterisyell", "tshirt"}, {"tshirterisorn", "tshirt"}, {"trackytop2eris", "trackytop2"}, {"bbjackrim", "bbjack"}, {"bbjackrstar", "bbjack"}, {"baskballdrib", "basjball"}, {"sixtyniners", "tshirt"}, {"bandits", "baseball"}, {"tshirtprored", "tshirt"}, {"tshirtproblk", "tshirt"}, {"trackytop1pro", "trackytop1"}, {"hockeytop", "sweat"}, {"bbjersey", "sleevt"}, {"shellsuit", "trackytop1"}, {"tshirtheatwht", "tshirt"}, {"tshirtbobomonk", "tshirt"}, {"tshirtbobored", "tshirt"}, {"tshirtbase5", "tshirt"}, {"tshirtsuburb", "tshirt"}, {"hoodyamerc", "hoodya"}, {"hoodyabase5", "hoodya"}, {"hoodayarockstar", "hoodya"}, {"wcoatblue", "wcoat"}, {"coach", "coach"}, {"coachsemi", "coach"}, {"sweatrstar", "sweat"}, {"hoodyAblue", "hoodyA"}, {"hoodyAblack", "hoodyA"}, {"hoodyAgreen", "hoodyA"}, {"sleevtbrown", "sleevt"}, {"shirtablue", "shirta"}, {"shirtayellow", "shirta"}, {"shirtagrey", "shirta"}, {"shirtbgang", "shirtb"}, {"tshirtzipcrm", "tshirt"}, {"tshirtzipgry", "tshirt"}, {"denimfade", "denim"}, {"bowling", "hawaii"}, {"hoodjackbeige", "hoodjack"}, {"baskballoc", "baskball"}, {"tshirtlocgrey", "tshirt"}, {"tshirtmaddgrey", "tshirt"}, {"tshirtmaddgrn", "tshirt"}, {"suit1grey", "suit1"}, {"suit1blk", "suit1"}, {"leather", "leather"}, {"painter", "painter"}, {"hawaiiwht", "hawaii"}, {"hawaiired", "hawaii"}, {"sportjack", "trackytop1"}, {"suit1red", "suit1"}, {"suit1blue", "suit1"}, {"suit1yellow", "suit1"}, {"suit2grn", "suit2"}, {"tuxedo", "suit2"}, {"suit1gang", "suit1"}, {"letter", "sleevt"} }
wrists = { {"NONE", "NONE"}, {"watchpink", "watch"}, {"watchyellow", "watch"}, {"watchpro", "watch"}, {"watchpro2", "watch"}, {"watchsub1", "watch"}, {"watchsub2", "watch"}, {"watchzip1", "watch"}, {"watchzip2", "watch"}, {"watchgno", "watch"}, {"watchgno2", "watch"}, {"watchcro", "watch"}, {"watchcro2", "watch"} }
lowerbody = { {"player_legs", "legs"}, {"worktrcamogrn", "worktr"}, {"worktrcamogry", "worktr"}, {"worktrgrey", "worktr"}, {"worktrhaki", "worktr"}, {"tracktr", "tracktr"}, {"trackteris", "tracktr"}, {"jeansdenim", "jeans"}, {"legsblack", "legs"}, {"legsheart", "legs"}, {"beiegetr", "chinosb"}, {"trackpro", "tracktr"}, {"tracktrwhstr", "tracktr"}, {"tracktrblue", "tracktr"}, {"tracktrgang", "tracktr"}, {"bbshortwht", "boxingshort"}, {"bbshortred", "boxingshort"}, {"shellsuittr", "tracktr"}, {"shortsgrey", "shorts"}, {"shortskhaki", "shorts"}, {"chongergrey", "chonger"}, {"chongergang", "chonger"}, {"chongerred", "chonger"}, {"chongerblue", "chonger"}, {"shortsgang", "shorts"}, {"denimsgang", "jeans"}, {"denimsred", "jeans"}, {"chinosbiege", "chinosb"}, {"chinoskhaki", "chinosb"}, {"cutoffchinos", "shorts"}, {"cutoffchinesblue", "shorts"}, {"chinosblack", "chinosb"}, {"chinosblue", "chinosb"}, {"leathertr", "leathertr"}, {"leathertrchaps", "leathertr"}, {"suit1trgrey", "suit1tr"}, {"suit1trblk", "suit1tr"}, {"cutoffdenims", "shorts"}, {"suit1trred", "suit1tr"}, {"suit1trblue", "suit1tr"}, {"suit1tryellow", "suit1tr"}, {"suit1trgreen", "suit1tr"}, {"suit1trblk2", "suit1tr"}, {"suit1trgang", "suit1tr"} }
feet = { {"foot", "feet"}, {"cowboyboot2", "biker"}, {"bask2semi", "bask1"}, {"bask1eris", "bask1"}, {"sneakerbincgang", "sneaker"}, {"sneakerbincblue", "sneakers"}, {"sneakerbincblk", "sneaker"}, {"sandal", "flipflop"}, {"sandalsock", "flipflop"}, {"flipflop", "flipflop"}, {"hitop", "bask1"}, {"convproblk", "conv"}, {"convproblu", "conv"}, {"convprogrn", "conv"}, {"sneakerprored", "sneaker"}, {"sneakerproblu", "sneakers"}, {"sneakerprowht", "sneaker"}, {"bask1prowht", "bask1"}, {"bask1problk", "bask1"}, {"boxingshoe", "biker"}, {"convheatblk", "conv"}, {"convheatred", "conv"}, {"convheatorn", "conv"}, {"sneakerheatwht", "sneaker"}, {"sneakerheatgry", "sneaker"}, {"sneakerheatblk", "sneaker"}, {"bask2heatwht", "bask1"}, {"bask2headband", "bask1"}, {"timbergrey", "back1t"}, {"timberred", "bask1"}, {"timberfawn", "bask1"}, {"timberhike", "bask1"}, {"cowboyboot", "biker"}, {"biker", "biker"}, {"snakeskin", "biker"}, {"shoedressblk", "shoe"}, {"shoedressbrn", "shoe"}, {"shoespatz", "shoe"} } 
costumes = { {"NONE", "NONE"}, {"valet", "valet"}, {"countrytr", "countrytr"}, {"croupier", "valet"}, {"pimptr", "pimptr"}, {"policetr", "policetr"} }


function spawnClothes(name)
	local charname = string.gsub(tostring(name), " ", "_")
	local safecharname = mysql_escape_string(handler, name)
	
	local result = mysql_query(handler, "SELECT muscles, fat, shirt, head, trousers, shoes, tattoo_lu, tattoo_ll, tattoo_ru, tattoo_rl, tattoo_back, tattoo_lc, tattoo_rc, tattoo_stomach, tattoo_lb, neck, watch, glasses, hat, extra FROM characters WHERE charactername='" .. safecharname .. "'")
	
	for i = 0, 17 do
		removePedClothes(source, i)
	end
	
	if (result) then
		local muscle = tonumber(mysql_result(result, 1, 1))
		local fat = tonumber(mysql_result(result, 1, 2))
		
		local shirt = tonumber(mysql_result(result, 1, 3))
		local head = tonumber(mysql_result(result, 1, 4))
		local trousers = tonumber(mysql_result(result, 1, 5))
		local shoes = tonumber(mysql_result(result, 1, 6))
		local tattoo_lu = tonumber(mysql_result(result, 1, 7))
		local tattoo_ll = tonumber(mysql_result(result, 1, 8))
		local tattoo_ru = tonumber(mysql_result(result, 1, 9))
		local tattoo_rl = tonumber(mysql_result(result, 1, 10))
		local tattoo_back = tonumber(mysql_result(result, 1, 11))
		local tattoo_lc = tonumber(mysql_result(result, 1, 12))
		local tattoo_rc = tonumber(mysql_result(result, 1, 13))
		local tattoo_stomach = tonumber(mysql_result(result, 1, 14))
		local tattoo_lb = tonumber(mysql_result(result, 1, 15))
		local neck = tonumber(mysql_result(result, 1, 16))
		local watch = tonumber(mysql_result(result, 1, 17))
		local glasses = tonumber(mysql_result(result, 1, 18))
		local hat = tonumber(mysql_result(result, 1, 19))
		local extra = tonumber(mysql_result(result, 1, 20))
	
		setPedStat(source, 23, muscle)
		setPedStat(source, 21, fat)
		
		-- weapon skill fixes
		setPedStat(source, 77, 700)
		setPedStat(source, 78, 700)
		setPedStat(source, 79, 700)
		setPedStat(source, 71, 700)
		setPedStat(source, 70, 700)
		setPedStat(source, 72, 700)
		setPedStat(source, 74, 700)
		setPedStat(source, 76, 700)
		
		-- No more infinite stamina =]
		if (fat>500) then -- Fat people = 70% less stamina
			setPedStat(source, 22, 30)
		else
			setPedStat(source, 22, 100)
		end
		
		-- SHIRT
		if (upperbody[shirt][1]~="NONE") then
			addPedClothes(source, upperbody[shirt][1], upperbody[shirt][2], 0)
		end
		
		-- HEAD
		if (hair[head][1]~="NONE") then
			addPedClothes(source, hair[head][1], hair[head][2], 1)
		end
		
		-- TROUSERS
		if (lowerbody[trousers][1]~="NONE") then
			addPedClothes(source, lowerbody[trousers][1], lowerbody[trousers][2], 2)
		end
		
		-- SHOES
		if (feet[shoes][1]~="NONE") then
			addPedClothes(source, feet[shoes][1], feet[shoes][2], 3)
		end
		
		--  Tattoo: LU
		if (leftUpperArmTattoos[tattoo_lu][1]~="NONE") then
			addPedClothes(source, leftUpperArmTattoos[tattoo_lu][1], leftUpperArmTattoos[tattoo_lu][2], 4)
		end
		
		--  Tattoo: LL
		if (leftLowerArmTattoos[tattoo_ll][1]~="NONE") then
			addPedClothes(source, leftLowerArmTattoos[tattoo_ll][1], leftLowerArmTattoos[tattoo_ll][2], 5)
		end
		
		--  Tattoo: RU
		if (rightUpperArmTattoos[tattoo_ru][1]~="NONE") then
			addPedClothes(source, rightUpperArmTattoos[tattoo_ru][1], rightUpperArmTattoos[tattoo_ru][2], 6)
		end
		
		--  Tattoo: RL
		if (rightLowerArmTattoos[tattoo_rl][1]~="NONE") then
			addPedClothes(source, rightLowerArmTattoos[tattoo_rl][1], rightLowerArmTattoos[tattoo_rl][2], 7)
		end
		
		-- Tattoo: back
		if (backTattoos[tattoo_back][1]~="NONE") then
			addPedClothes(source, backTattoos[tattoo_back][1], backTattoos[tattoo_back][2], 8)
		end
		
		-- Tattoo:  LC
		if (leftChestTattoos[tattoo_lc][1]~="NONE") then
			addPedClothes(source, leftChestTattoos[tattoo_lc][1], leftChestTattoos[tattoo_lc][2], 9)
		end
		
		-- Tattoo:  RC
		if (rightChestTattoos[tattoo_rc][1]~="NONE") then
			addPedClothes(source, rightChestTattoos[tattoo_rc][1], rightChestTattoos[tattoo_rc][2], 10)
		end
		
		-- Tattoo:  Stomach
		if (stomachTattoos[tattoo_stomach][1]~="NONE") then
			addPedClothes(source, stomachTattoos[tattoo_stomach][1], stomachTattoos[tattoo_stomach][2], 11)
		end
		
		-- Tattoo: LB
		if (lowerBackTattoos[tattoo_lb][1]~="NONE") then
			addPedClothes(source, lowerBackTattoos[tattoo_lb][1], lowerBackTattoos[tattoo_lb][2], 12)
		end
		
		-- Neck
		if (necks[neck][1]~="NONE") then
			addPedClothes(source, necks[neck][1], necks[neck][2], 13)
		end
		
		-- Watch
		if (wrists[watch][1]~="NONE") then
			addPedClothes(source, wrists[watch][1], wrists[watch][2], 14)
		end
		
		-- Glasses
		if (faces[glasses][1]~="NONE") then
			addPedClothes(source, faces[glasses][1], faces[glasses][2], 15)
		end
		
		-- Hat
		if (hats[hat][1]~="NONE") then
			addPedClothes(source, hats[hat][1], hats[hat][2], 16)
		end

		-- EXTRA
		if (costumes[extra][1]~="NONE") then
			addPedClothes(source, costumes[extra][1], costumes[extra][2], 17)
		end
		
		mysql_free_result(result)
	end
end
addEvent("spawnClothes", true)
addEventHandler("spawnClothes", getRootElement(), spawnClothes)

function createCharacter(name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, clothes)
	-- Fix the name and check if its already taken...
	local charname = string.gsub(tostring(name), " ", "_")
	local safecharname = mysql_escape_string(handler, charname)

	local result = mysql_query(handler, "SELECT charactername FROM characters WHERE charactername='" .. safecharname .. "'")

	local accountID = getElementData(source, "gameaccountid")
	local accountUsername = getElementData(source, "gameaccountusername")
	
	if (mysql_num_rows(result)>0) then -- Name is already taken
		triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, false)
	else
	
		-- /////////////////////////////////////
		-- TRANSPORT
		-- /////////////////////////////////////
		local x, y, z, r, lastarea = 0, 0, 0, 0, "Unknown"
		
		if (transport==1) then
			x, y, z = 2079.3344726563, 2030.2542724609, 10.8203125
			r = 182.91093444824
			lastarea = "The Strip"
		else
			x, y, z = 1704.1889648438, 1411.068359375, 10.640625
			r = 306.16784667969
			lastarea = "Las Venturas Airport"
		end
		
		local salt = "fingerprintscotland"
		local fingerprint = md5(salt .. safecharname)
		
		local query = mysql_query(handler, "INSERT INTO characters SET charactername='" .. safecharname .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotation='" .. r .. "', faction_id='-1', transport='" .. transport .. "', gender='" .. gender .. "', skincolor='" .. skincolour .. "', weight='" .. weight .. "', height='" .. height .. "', muscles='" .. muscles .. "', fat='" .. fatness .. "', description='" .. description .. "', account='" .. accountID .. "', skin='" .. skin .. "', lastarea='" .. lastarea .. "', age='" .. age .. "', fingerprint='" .. fingerprint .. "', items='16,17,18,', itemvalues='" .. skin .. ",1,1,'")
		
		if (query) then
			local id = mysql_insert_id(handler)
			mysql_free_result(query)
			if (clothes) then -- Store CJ's clothes!
				local update = mysql_query(handler, "UPDATE characters SET head='" .. clothes[1] .. "', hat='" .. clothes[2] .. "', neck='" .. clothes[3] .. "', glasses='" .. clothes[4] .. "', shirt='" .. clothes[5] .. "', watch='" .. clothes[6] .. "', trousers='" .. clothes[7] .. "', shoes='" .. clothes[8] .. "', extra='" .. clothes[9] .. "', tattoo_lu='" .. clothes[10] .. "', tattoo_ll='" .. clothes[11] .. "', tattoo_ru='" .. clothes[12] .. "', tattoo_rl='" .. clothes[13] .. "', tattoo_back='" .. clothes[14] .. "', tattoo_lc='" ..clothes[15] .. "', tattoo_rc='" .. clothes[16] .. "', tattoo_stomach='" .. clothes[17] .. "', tattoo_lb='" .. clothes[18] .. "' WHERE charactername='" .. safecharname .. "'")
				if (update) then
					mysql_free_result(update)
				end
			end
			
			-- CELL PHONE
			
			local cellnumber = id+15000
			local update = mysql_query(handler, "UPDATE characters SET cellnumber='" .. cellnumber .. "' WHERE charactername='" .. safecharname .. "'")
			
			if (update) then
				mysql_free_result(update)
				triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, true)
			else
				outputChatBox("Error 100003 - Report on forums.", source, 255, 0, 0)
			end
		else
			triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, false)
		end
	end
	exports.irc:sendMessage("[ACCOUNT] Character '" ..  charname .. "' was registered to account '" .. accountUsername .. "'")
	sendAccounts(source, accountID)
	
	if (result) then
		mysql_free_result(result)
	end
end
addEvent("onPlayerCreateCharacter", false)
addEvent("createCharacter", true)
addEventHandler("createCharacter", getRootElement(), createCharacter)

function serverToggleBlur(enabled)
	if (enabled) then
		setElementData(source, "blur", 1)
		setPlayerBlurLevel(source, 38)
	else
		setElementData(source, "blur", 0)
		setPlayerBlurLevel(source, 0)
	end
end
addEvent("updateBlurLevel", true)
addEventHandler("updateBlurLevel", getRootElement(), serverToggleBlur)

function cmdToggleBlur(thePlayer, commandName)
	local blur = getElementData(thePlayer, "blur")
	
	if (blur==0) then
		outputChatBox("Vehicle blur enabled.", thePlayer, 255, 194, 14)
		setElementData(thePlayer, "blur", 1)
		setPlayerBlurLevel(thePlayer, 38)
	elseif (blur==1) then
		outputChatBox("Vehicle blur disabled.", thePlayer, 255, 194, 14)
		setElementData(thePlayer, "blur", 0)
		setPlayerBlurLevel(thePlayer, 0)
	end
end
addCommandHandler("toggleblur", cmdToggleBlur)

function cguiSetNewPassword(oldPassword, newPassword)
	
	local gameaccountID = getElementData(source, "gameaccountid")
	
	local safeoldpassword = mysql_escape_string(handler, oldPassword)
	local safenewpassword = mysql_escape_string(handler, newPassword)
	
	local query = mysql_query(handler, "SELECT username FROM accounts WHERE id='" .. gameaccountID .. "' AND password=MD5('" .. salt .. safeoldpassword .. "')")
	
	if not (query) or (mysql_num_rows(query)==0) then
		outputChatBox("Your current password you entered was wrong.", source, 255, 0, 0)
	else
		mysql_free_result(query)
		local update = mysql_query(handler, "UPDATE accounts SET password=MD5('" .. salt .. safenewpassword .. "') WHERE id='" .. gameaccountID .. "'")

		if (update) then
			outputChatBox("You changed your password to '" .. newPassword .. "'", source, 0, 255, 0)
			mysql_free_result(update)
		else
			outputChatBox("Error 100004 - Report on forums.", source, 255, 0, 0)
		end
	end
end
addEvent("cguiSavePassword", true)
addEventHandler("cguiSavePassword", getRootElement(), cguiSetNewPassword)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "pd.jailserved")
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local username = getPlayerName(jailedPlayer)
		setElementData(jailedPlayer, "pd.jailserved", timeServed+1)
		local timeLeft = timeLeft - 1
		setElementData(jailedPlayer, "pd.jailtime", timeLeft)

		if (timeLeft<=0) then
			fadeCamera(jailedPlayer, false)
			mysql_query(handler, "UPDATE characters SET pdjail_time='0', pdjail='0' WHERE charactername='" .. username .. "'")
			setElementData(jailedPlayer, "jailtimer", nil)
			setElementDimension(jailedPlayer, 1)
			setElementInterior(jailedPlayer, 3)
			setCameraInterior(jailedPlayer, 3)
			setElementPosition(jailedPlayer, 233.42037963867, 157.07211303711, 1003.0234375)
			setPedRotation(jailedPlayer, 211.10571289063)
			setElementData(jailedPlayer, "pd.jailserved", 0)
			setElementData(jailedPlayer, "pd.jailtime", 0)
			setElementData(jailedPlayer, "pd.jailtimer", nil)
			fadeCamera(jailedPlayer, true)
			outputChatBox("Your time has been served.", jailedPlayer, 0, 255, 0)
		else
			mysql_query(handler, "UPDATE characters SET pdjail_time='" .. timeLeft .. "' WHERE charactername='" .. username .. "'")
		end
	else
		local theTimer = getElementData(jailedPlayer, "jailtimer")
		killTimer(theTimer)
	end
end