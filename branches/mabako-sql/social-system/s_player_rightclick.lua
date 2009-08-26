function retrievePlayerInfo(targetPlayer)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friends, friendsmessage FROM accounts WHERE id='" .. accid .. "' LIMIT 1")

	if (result) then
		local sfriends = mysql_result(result, 1, 1)
		mysql_free_result(result)
		local friends = { }
		local count = 1
		
		if (sfriends) then
			for i=1, 100 do
				local fid = gettok(sfriends, i, 59)
						
				if (fid) then
					local fresult = mysql_query(handler, "SELECT username, friendsmessage, yearday, year, country, os FROM accounts WHERE id='" .. fid .. "' LIMIT 1")
					
					local aresult = mysql_query(handler, "SELECT id FROM achievements WHERE account='" .. fid .. "'")
					local numachievements = mysql_num_rows(aresult)
					mysql_free_result(fresult)
					mysql_free_result(aresult)
					
					friends[i] = tonumber(fid)
				else
					break
				end
			end
		end
		
		local result = mysql_query(handler, "SELECT description, age, weight, height, skincolor FROM characters WHERE charactername='" .. getPlayerName(targetPlayer) .. "'")
		local description = tostring(mysql_result(result, 1, 1))
		local age = tostring(mysql_result(result, 1, 2))
		local weight = tostring(mysql_result(result, 1, 3))
		local height = tostring(mysql_result(result, 1, 4))
		local race = tonumber(mysql_result(result, 1, 5))
		mysql_free_result(result)
		
		triggerClientEvent(source, "displayPlayerMenu", source, targetPlayer, friends, description, age, weight, height, race)
	end
end
addEvent("sendPlayerInfo", true)
addEventHandler("sendPlayerInfo", getRootElement(), retrievePlayerInfo)

function addFriend(player)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friends FROM accounts WHERE id='" .. accid .. "' LIMIT 1")
	
	if (result) then
		local sfriends = mysql_result(result, 1, 1)
		mysql_free_result(result)
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
			local query = mysql_query(handler, "UPDATE accounts SET friends='" .. tostring(sfriends) .. "' WHERE id='" .. accid .. "'")
			mysql_free_result(query)
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
	exports.global:givePlayerItem(source, itemID, itemValue)
end
addEvent("friskTakePlayerItem", true)
addEventHandler("friskTakePlayerItem", getRootElement(), friskTakePlayerItem)

function friskTakePlayerWeapon(player, weaponID, weaponAmmo)
	exports.global:sendLocalMeAction(source, "takes a " .. getWeaponNameFromID(weaponID) .. " from " .. getPlayerName(player) .. ".")
	exports.global:takeWeapon(player, weaponID)
	exports.global:giveWeapon(source, weaponID, weaponAmmo)
end
addEvent("friskTakePlayerWeapon", true)
addEventHandler("friskTakePlayerWeapon", getRootElement(), friskTakePlayerWeapon)

function toggleCuffs(cuffed, player)
	if (cuffed) then
		toggleControl(player, "fire", false)
		toggleControl(player, "sprint", false)
		toggleControl(player, "jump", false)
		toggleControl(player, "next_weapon", false)
		toggleControl(player, "previous_weapon", false)
		toggleControl(player, "accelerate", false)
		toggleControl(player, "brake_reverse", false)
		toggleControl(player, "aim_weapon", false)
	else
		toggleControl(player, "fire", true)
		toggleControl(player, "sprint", true)
		toggleControl(player, "jump", true)
		toggleControl(player, "next_weapon", true)
		toggleControl(player, "previous_weapon", true)
		toggleControl(player, "accelerate", true)
		toggleControl(player, "brake_reverse", true)
		toggleControl(player, "aim_weapon", true)
	end
end

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData(source, "dbid")
	
	setTimer(toggleCuffs, 200, 1, true, player)
	
	outputChatBox("You have been restrained by " .. username .. ".", player)
	outputChatBox("You are restraining " .. targetPlayerName .. ".", source)
	setElementData(player, "restrain", 1)
	setElementData(player, "restrainedObj", restrainedObj)
	setElementData(player, "restrainedBy", dbid, false)

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
	
	setTimer(toggleCuffs, 200, 1, false, player)
	
	setElementData(player, "restrain", 0)
	removeElementData(player, "restrainedBy")
	removeElementData(player, "restrainedObj")
	
	if (restrainedObj==45) then -- If handcuffs.. take the key
		local dbid = getElementData(source, "dbid")
		exports.global:takePlayerItem(source, 47, dbid)
	end
	exports.global:givePlayerItem(source, restrainedObj, 1)
	
	exports.global:removeAnimation(player)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)

-- BLINDFOLDS
function blindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been blindfolded by " .. username .. ".", player)
	outputChatBox("You blindfolded " .. targetPlayerName .. ".", source)
	
	exports.global:takePlayerItem(source, 66, -1) -- take their blindfold
	setElementData(player, "blindfold", 1)
	fadeCamera(player, false)
end
addEvent("blindfoldPlayer", true)
addEventHandler("blindfoldPlayer", getRootElement(), blindfoldPlayer)

function removeblindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have had your blindfold removed by " .. username .. ".", player)
	outputChatBox("You removed " .. targetPlayerName .. "'s blindfold.", source)
	
	exports.global:givePlayerItem(source, 66, -1) -- give the remove the blindfold
	removeElementData(player, "blindfold")
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)