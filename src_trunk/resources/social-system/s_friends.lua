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

----------------------[KEY BINDS]--------------------
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		setElementData(arrayPlayer, "friends.visible", 0)
		if not(isKeyBound(arrayPlayer, "o", "down", toggleFriends)) then
			bindKey(arrayPlayer, "o", "down", toggleFriends)
		end
		
		if not(isKeyBound(arrayPlayer, "m", "down", toggleCursor)) then
			bindKey(arrayPlayer, "m", "down", toggleCursor)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "o", "down", toggleFriends)
	bindKey(source, "m", "down", toggleCursor)
	
	setElementData(source, "friends.visible", 0)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

-- function togles the cursor for the player
function toggleCursor(source)
	if(isCursorShowing(source)) then
		showCursor(source, false)
	else
		showCursor(source, true)
	end
end

function toggleFriends(source)
	local logged = getElementData(source, "gameaccountloggedin")
	
	if (logged==1) then
		local visible = getElementData(source, "friends.visible")
		
		if (visible==0) then -- not already showing
			local accid = tonumber(getElementData(source, "gameaccountid"))
			local result = mysql_query(handler, "SELECT friends, friendsmessage FROM accounts WHERE id='" .. accid .. "' LIMIT 1")
			
			if (result) then
				local sfriends = mysql_result(result, 1, 1)
				local fmessage = mysql_result(result, 1, 2)
				
				if (tostring(sfriends)==tostring(mysql_null())) then
					sfriends = ""
				end
				
				if (tostring(fmessage)==tostring(mysql_null())) then
					fmessage = ""
				end
				
				local friends = { }
				local count = 1
				
				for i=1, 100 do
					local fid = gettok(sfriends, i, 59)
					
					if (fid) then
						local fresult = mysql_query(handler, "SELECT username, friendsmessage, yearday, year, country, os FROM accounts WHERE id='" .. fid .. "' LIMIT 1")
						
						local aresult = mysql_query(handler, "SELECT id FROM achievements WHERE account='" .. fid .. "'")
						local numachievements = mysql_num_rows(aresult)
						mysql_free_result(aresult)
						
						friends[i] = { }
						friends[i][1] = tonumber(fid) -- USER ID
						friends[i][2] = mysql_result(fresult, 1, 1) -- USERNAME
						friends[i][3] = mysql_result(fresult, 1, 2) -- MESSAGE
						friends[i][4] = mysql_result(fresult, 1, 5) -- COUNTRY
						friends[i][7] = tostring(mysql_result(fresult, 1, 6)) -- OPERATING SYSTEM
						friends[i][8] = tostring(numachievements) -- NUM ACHIEVEMENTS
						
						-- Last online
						local time = getRealTime()
						local days = time.monthday
						local months = (time.month+1)
						local years = (1900+time.year)
						
						local yearday = time.yearday
						local fyearday = tonumber(mysql_result(fresult, 1, 3)) -- YEAR DAY
						local fyear = tonumber(mysql_result(fresult, 1, 4)) -- YEAR
						
						local found, player = false
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							if (tonumber(getElementData(value, "gameaccountid"))==friends[i][1]) then
								found = true
								player = value
							end
						end
						
						if (found) then
							friends[i][5] = "Online"
							friends[i][6] = getPlayerName(player)
						elseif (years~=fyear) then
							friends[i][5] = "Last Seen: Last Year"
						elseif (yearday==fyearday) then
							friends[i][5] = "Last Seen: Today"
						else
							local diff = yearday - fyearday
							friends[i][5] = "Last Seen: " .. tostring(diff) .. " days ago."
						end
						mysql_free_result(fresult)
					else
						break
					end
				end
				mysql_free_result(result)
				setElementData(source, "friends.visible", 1)
				triggerClientEvent(source, "showFriendsList", source, friends)
			else
				outputChatBox("Error 600000 - Could not retrieve friends list.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("sendFriends", false)
addEventHandler("sendFriends", getRootElement(), toggleFriends)

function updateFriendsMessage(message)
	local safemessage = mysql_escape_string(handler, tostring(message))
	local accid = getElementData(source, "gameaccountid")
	
	local query = mysql_query(handler, "UPDATE accounts SET friendsmessage='" .. safemessage .. "' WHERE id='" .. accid .. "'")
	if (query) then
		setElementData(source, "friends.visible", 0)
		setElementData(source, "friends.message", tostring(safemessage))
		mysql_free_result(query)
		toggleFriends(source)
	else
		outputChatBox("Error updating friends message - ensure you used no special characters!", source, 255, 0, 0)
	end
end
addEvent("updateFriendsMessage", true)
addEventHandler("updateFriendsMessage", getRootElement(), updateFriendsMessage)

function removeFriend(id, username, dontShowFriends)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friends, friendsmessage FROM accounts WHERE id='" .. accid .. "' LIMIT 1")
	
	if (result) then
		local sfriends = mysql_result(result, 1, 1)
		local fmessage = mysql_result(result, 1, 2)
				
		local friendstring = ""
		local count = 1
				
		for i=1, 100 do
			local fid = gettok(sfriends, i, 59)
					
			if (fid) then 
				if not (tonumber(fid)==id) then
					friendstring = friendstring .. fid .. ";"
				end
			end
		end
		mysql_query(handler, "UPDATE accounts SET friends='" .. friendstring .. "' WHERE id='" .. accid .. "'")
		mysql_free_result(result)
		outputChatBox("You removed '" .. username .. "' from your friends list.", source, 255, 194, 14)
		
		setElementData(source, "friends.visible", 0)
		if (dontShowFriends==false) then
			toggleFriends(source)
		end
	end
end
addEvent("removeFriend", true)
addEventHandler("removeFriend", getRootElement(), removeFriend)