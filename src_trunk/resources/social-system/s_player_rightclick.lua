function retrievePlayerInfo(targetPlayer)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local targetID = tonumber(getElementData(targetPlayer, "gameaccountid"))
	local result = mysql_query(handler, "SELECT friend FROM friends WHERE id = " .. accid .. " AND friend = " .. targetID .. " LIMIT 1")

	if result then
		local friend = false
		if mysql_num_rows( result ) == 1 then
			friend = true
		end
		mysql_free_result( result )
		
		local result = mysql_query(handler, "SELECT description, age, weight, height, skincolor FROM characters WHERE charactername='" .. getPlayerName(targetPlayer) .. "'")
		local description = tostring(mysql_result(result, 1, 1))
		local age = tostring(mysql_result(result, 1, 2))
		local weight = tostring(mysql_result(result, 1, 3))
		local height = tostring(mysql_result(result, 1, 4))
		local race = tonumber(mysql_result(result, 1, 5))
		mysql_free_result(result)
		
		triggerClientEvent(source, "displayPlayerMenu", source, targetPlayer, friend, description, age, weight, height, race)
	end
end
addEvent("sendPlayerInfo", true)
addEventHandler("sendPlayerInfo", getRootElement(), retrievePlayerInfo)

function addFriend(player)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local targetID = tonumber(getElementData(player, "gameaccountid"))
	
	local countresult = mysql_query(handler, "SELECT COUNT(*) FROM friends WHERE id='" .. accid .. "' LIMIT 1")
	local count = tonumber(mysql_result(countresult, 1, 1))
	mysql_free_result(countresult)
	
	if (count >=23) then
		outputChatBox("Your friends list is currently full.", source, 255, 0, 0)
	else
		local result = mysql_query( handler, "INSERT INTO friends VALUES (" .. accid .. ", " .. targetID .. ")")
		if result then
			local friends = getElementData(source, "friends")
			if friends then
				friends[ targetID ] = true
				setElementData(source, "friends", friends, false)
			end
			outputChatBox("'" .. getPlayerName(player) .. "' was added to your friends list.", source, 255, 194, 14)
			mysql_free_result( result )
		else
			outputDebugString( "Add Friend: " .. mysql_error( handler ) )
		end
	end
end
addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), addFriend)

-- FRISKING
--[[
function friskTakePlayerItem(player, itemID, itemValue, itemName)
	exports.global:sendLocalMeAction(source, "takes a " .. itemName .. " from " .. getPlayerName(player) .. ".")
	exports.global:takeItem(player, itemID, itemValue)
	exports.global:giveItem(source, itemID, itemValue)
end
addEvent("friskTakePlayerItem", true)
addEventHandler("friskTakePlayerItem", getRootElement(), friskTakePlayerItem)

function friskTakePlayerWeapon(player, weaponID, weaponAmmo)
	exports.global:sendLocalMeAction(source, "takes a " .. getWeaponNameFromID(weaponID) .. " from " .. getPlayerName(player) .. ".")
	exports.global:takeWeapon(player, weaponID)
	exports.global:giveWeapon(source, weaponID, weaponAmmo)
end
addEvent("friskTakePlayerWeapon", true)
addEventHandler("friskTakePlayerWeapon", getRootElement(), friskTakePlayerWeapon)]]

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

	exports.global:takeItem(source, restrainedObj)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports.global:giveItem(source, 47, dbid)
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
		exports.global:takeItem(source, 47, dbid)
	end
	exports.global:giveItem(source, restrainedObj, 1)
	
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
	
	exports.global:takeItem(source, 66) -- take their blindfold
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
	
	exports.global:giveItem(source, 66, -1) -- give the remove the blindfold
	removeElementData(player, "blindfold")
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)


-- STABILIZE
function stabilizePlayer(player)
	local found, slot, itemValue = exports.global:hasItem(source, 70)
	if found then
		exports.global:takeItem(source, 70, itemValue)
		itemValue = itemValue - 1
		if itemValue > 0 then
			exports.global:giveItem(source, 70, itemValue)
		end
		
		local username = getPlayerName(source)
		local targetPlayerName = getPlayerName(player)
	
	
		outputChatBox("You have been stabilized by " .. username .. ".", player)
		outputChatBox("You stabilized " .. targetPlayerName .. ".", source)
		triggerEvent("onPlayerStabilize", player)
	end
end
addEvent("stabilizePlayer", true)
addEventHandler("stabilizePlayer", getRootElement(), stabilizePlayer)