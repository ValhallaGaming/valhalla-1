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

function realisticDamage(attacker, weapon, bodypart, loss)
	if (attacker) and (weapon) then
		local health = getElementHealth(source)
		local intLoss = loss * health
		local armor = getPedArmor(source)
			

		if (bodypart==9) and not (armor>0) then -- Head and no armor.
			exports.global:givePlayerAchievement(attacker, 12)
			exports.global:givePlayerAchievement(source, 15)
			killPed(source)
		end
		
	end
end
addEventHandler("onPlayerDamage", getRootElement(), realisticDamage)

function playerDeath()
	outputChatBox("Respawn in 30 seconds.", source)
	setTimer(respawnPlayer, 30000, 1, source)
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

function respawnPlayer(thePlayer)
	if (isElement(thePlayer)) then
		local cost = math.random(25,50)
		local money = getElementData(thePlayer, "money")
		
		-- Fix for injected cash
		if (cost>money) then
			cost = money
		end
		
		if (exports.global:isPlayerSilverDonator(thePlayer)) then
			cost = 0
		else
			exports.global:takePlayerSafeMoney(thePlayer, cost)
		end
		
		local result = mysql_query(handler, "SELECT bankbalance FROM factions WHERE id='2' OR id='3' LIMIT 2")
		if (mysql_num_rows(result)>0) then
			local tax = exports.global:getTaxAmount()
			local currentESBalance = mysql_result(result, 1, 1)
			local currentGOVBalance = mysql_result(result, 2, 1)
			
			local ESMoney = math.ceil((1-tax)*cost)
			local GOVMoney = math.ceil(tax*cost)
			
			local theTeamES = getTeamFromName("Las Venturas Emergency Services")
			local theTeamGov = getTeamFromName("Government of Las Venturas")
			
			setElementData(theTeamES, "money", (currentESBalance+ESMoney))
			setElementData(theTeamGov, "money", (currentGOVBalance+GOVMoney+money))
			
			local update = mysql_query(handler, "UPDATE factions SET bankbalance='" .. (currentESBalance+ESMoney) .. "' WHERE id='2'")
			local update2 = mysql_query(handler, "UPDATE factions SET bankbalance='" .. (currentGOVBalance+GOVMoney+money) .. "' WHERE id='3'")
			local update3 = mysql_query(handler, "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(thePlayer)) .. "'")
			
			if (update) then
				mysql_free_result(update)
			end

			if (update2) then
				mysql_free_result(update2)
			end

			if (update3) then
				mysql_free_result(update3)
			end
			mysql_free_result(result)
			
			setCameraInterior(thePlayer, 0)
			
			outputChatBox("You have recieved treatment from the Las Venturas Emergency Services. Cost: " .. cost .. "$", thePlayer, 255, 255, 0)
			
			local theSkin = getPedSkin(thePlayer)
			
			-- Resetting the duty system
			local duty = tonumber(getElementData(thePlayer, "duty"))

			if (duty>0) then
				setElementData(thePlayer, "duty", 0)
			
				theSkin = getElementData(thePlayer, "casualskin")
			end
			
			local theTeam = getPlayerTeam(thePlayer)
			
			local fat = getPedStat(thePlayer, 21)
			local muscle = getPedStat(thePlayer, 23)
			
			setPedStat(thePlayer, 21, fat)
			setPedStat(thePlayer, 23, muscle)

			spawnPlayer(thePlayer, 1607.3410644531, 1821.9310302734, 10.8203125, 358.86193847656, theSkin, 0, 0, theTeam)
			
			fadeCamera(thePlayer, true, 2)
		end
		mysql_free_result(result)
	end
end

function deathRemoveWeapons(weapons, removedWeapons)
	setTimer(giveGunsBack, 30005, 1, source, weapons, removedWeapons)
end
addEvent("onDeathRemovePlayerWeapons", true)
addEventHandler("onDeathRemovePlayerWeapons", getRootElement(), deathRemoveWeapons)

function giveGunsBack(thePlayer, weapons, removedWeapons)
	if (removedWeapons~=nil) then
		outputChatBox("LVES Employee: We have taken away weapons which you did not have a license for. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
	end

	for key, value in ipairs(weapons) do
		local weapon = tonumber(weapons[key][1])
		local ammo = tonumber(weapons[key][2])
		local removed = tonumber(weapons[key][3])
		
		if (removed==0) then
			giveWeapon(thePlayer, weapon, ammo, false)
		else
			takeWeapon(thePlayer, weapon)
		end
	end
end