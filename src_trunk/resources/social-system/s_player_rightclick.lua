function retrievePlayerInfo(targetPlayer)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friends, friendsmessage FROM accounts WHERE id='" .. accid .. "' LIMIT 1")

	if (result) then
		local sfriends = mysql_result(result, 1, 1)
		
		local friends = { }
		local count = 1
				
		for i=1, 100 do
			local fid = gettok(sfriends, i, 59)
					
			if (fid) then
				local fresult = mysql_query(handler, "SELECT username, friendsmessage, yearday, year, country, os FROM accounts WHERE id='" .. fid .. "' LIMIT 1")
				
				local aresult = mysql_query(handler, "SELECT id FROM achievements WHERE account='" .. fid .. "'")
				local numachievements = mysql_num_rows(aresult)
				mysql_free_result(aresult)
				
				friends[i] = tonumber(fid)
			else
				break
			end
		end
		mysql_free_result(result)
		
		local result = mysql_query(handler, "SELECT description FROM characters WHERE charactername='" .. getPlayerName(targetPlayer) .. "'")
		local description = tostring(mysql_result(result, 1, 1))
		mysql_free_result(result)
		
		triggerClientEvent(source, "displayPlayerMenu", source, targetPlayer, friends, description)
	end
end
addEvent("sendPlayerInfo", true)
addEventHandler("sendPlayerInfo", getRootElement(), retrievePlayerInfo)

function addFriend(player)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friends FROM accounts WHERE id='" .. accid .. "' LIMIT 1")
	
	if (result) then
		local sfriends = mysql_result(result, 1, 1)
		
		if (tostring(sfriends)==tostring(mysql_null())) then
			sfriends = ""
		end
		
		local friends = { }
		local count = 1
				
		for i=1, 100 do
			local fid = gettok(sfriends, i, 59)
					
			if (fid) then
				count = count + 1
			else
				break
			end
		end
		
		if (count==100) then
			outputChatBox("Your friends list is full!", source, 255, 194, 14)
		else
			sfriends = sfriends .. tonumber(getElementData(player, "gameaccountid")) .. ";"
			mysql_query(handler, "UPDATE accounts SET friends='" .. tostring(sfriends) .. "' WHERE id='" .. accid .. "'")
			outputChatBox("'" .. getPlayerName(player) .. "' was added to your friends list.", source, 255, 194, 14)
		end
	end
end
addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), addFriend)