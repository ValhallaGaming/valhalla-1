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

-- FRISKING
function friskTakePlayerItem(player, itemID, itemValue, itemName)
	exports.global:sendLocalMeAction(source, "takes a " .. itemName .. " from " .. getPlayerName(player) .. ".")
	exports.global:takePlayerItem(player, itemID, itemValue)
end
addEvent("friskTakePlayerItem", true)
addEventHandler("friskTakePlayerItem", getRootElement(), friskTakePlayerItem)

function friskTakePlayerWeapon(player, weaponID)
	exports.global:sendLocalMeAction(source, "takes a " .. getWeaponNameFromID(weaponID) .. " from " .. getPlayerName(player) .. ".")
	takeWeapon(player, weaponID)
end
addEvent("friskTakePlayerWeapon", true)
addEventHandler("friskTakePlayerWeapon", getRootElement(), friskTakePlayerWeapon)

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData(source, "dbid")
	
	outputChatBox("You have been restrained by " .. username .. ".", player)
	outputChatBox("You are restraining " .. targetPlayerName .. ".", source)
	toggleControl(player, "sprint", false)
	toggleControl(player, "fire", false)
	toggleControl(player, "jump", false)
	toggleControl(player, "next_weapon", false)
	toggleControl(player, "previous_weapon", false)
	toggleControl(player, "accelerate", false)
	toggleControl(player, "brake_reverse", false)
	toggleControl(player, "aim_weapon", false)
	setElementData(player, "restrain", 1)
	setElementData(player, "restrainedObj", restrainedObj)
	setElementData(player, "restrainedBy", dbid)

	exports.global:takePlayerItem(source, restrainedObj, -1)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports.global:givePlayerItem(source, 47, dbid)
	end
	exports.global:removeAnimation(player)
end
addEvent("restrainPlayer", true)
addEventHandler("restrainPlayer", getRootElement(), restrainPlayer)

function unrestrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been unrestrained by " .. username .. ".", player)
	outputChatBox("You are unrestraining " .. targetPlayerName .. ".", source)
	toggleControl(player, "sprint", true)
	toggleControl(player, "fire", true)
	toggleControl(player, "jump", true)
	toggleControl(player, "next_weapon", true)
	toggleControl(player, "previous_weapon", true)
	toggleControl(player, "accelerate", true)
	toggleControl(player, "brake_reverse", true)
	toggleControl(player, "aim_weapon", true)
	setElementData(player, "restrain", 0)
	
	exports.global:givePlayerItem(source, restrainedObj, 1)
	
	if (restrainedObj==45) then -- If handcuffs.. take the key
		local dbid = getElementData(source, "dbid")
		exports.global:takePlayerItem(source, 47, dbid)
	end
	
	exports.global:removeAnimation(player)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)