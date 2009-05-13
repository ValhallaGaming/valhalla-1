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

local smallRadius = 5 --units

----------------------[CUFF]--------------------
function cuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else			
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			
			if (ftype~=2) then
				outputChatBox("You do not have handcuffs.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
			
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==1) then
						outputChatBox("Player is already restrained.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(targetPlayer)
						
						local colSphere = createColSphere(x, y, z, smallRadius)
						exports.pool:allocateElement(colSphere)
						
						if (isElementWithinColShape(thePlayer, colSphere)) then
							outputChatBox("You have been hand cuffed by " .. username .. ".", targetPlayer)
							outputChatBox("You are cuffing " .. targetPlayerName .. ".", thePlayer)
							toggleControl(targetPlayer, "sprint", false)
							toggleControl(targetPlayer, "jump", false)
							toggleControl(targetPlayer, "next_weapon", false)
							toggleControl(targetPlayer, "previous_weapon", false)
							toggleControl(targetPlayer, "accelerate", false)
							toggleControl(targetPlayer, "brake_reverse", false)
							toggleControl(targetPlayer, "fire", false)
							toggleControl(targetPlayer, "aim_weapon", false)

							setPedWeaponSlot(targetPlayer, 0)
							setElementData(targetPlayer, "restrain", 1)
						else
							outputChatBox("You are not within range of " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)						
						end
						destroyElement(colSphere)
					end
				end
			end
		end
	end
end
addCommandHandler("cuff", cuffPlayer, false, false)

----------------------[UNCUFF]--------------------
function uncuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			
			if (ftype~=2) then
				outputChatBox("You do not have handcuffs.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
			
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==0) then
						outputChatBox("Player is not restrained.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(targetPlayer)
						
						local colSphere = createColSphere(x, y, z, smallRadius)
						exports.pool:allocateElement(colSphere)
						
						if (isElementWithinColShape(thePlayer, colSphere)) then
							outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
							outputChatBox("You are uncuffing " .. targetPlayerName .. ".", thePlayer)
							toggleControl(targetPlayer, "sprint", true)
							toggleControl(targetPlayer, "fire", true)
							toggleControl(targetPlayer, "jump", true)
							toggleControl(targetPlayer, "next_weapon", true)
							toggleControl(targetPlayer, "previous_weapon", true)
							toggleControl(targetPlayer, "accelerate", true)
							toggleControl(targetPlayer, "brake_reverse", true)
							toggleControl(targetPlayer, "aim_weapon", true)
							setElementData(targetPlayer, "restrain", 0)
							
							setPedAnimation(targetPlayer)
						else
							outputChatBox("You are not within range of " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)						
						end
						destroyElement(colSphere)
					end
				end
			end
		end
	end
end
addCommandHandler("uncuff", uncuffPlayer, false, false)

-- /fingerprint
function fingerprintPlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick)
				
				if not (targetPlayer) then
					outputChatBox("Player is not online.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						local fingerprint = getElementData(targetPlayer, "fingerprint")
						outputChatBox(getPlayerName(targetPlayer) .. "'s Fingerprint: " .. tostring(fingerprint) .. ".", thePlayer, 255, 194, 14)
					else
						outputChatBox("You are too far away from " .. getPlayerName(targetPlayer) .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fingerprint", fingerprintPlayer, false, false)

-- /ticket
function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick] [Amount] [Reason]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick)
				
				if not (targetPlayer) then
					outputChatBox("Player is not online.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						amount = tonumber(amount)
						local reason = table.concat({...}, " ")
						
						local money = getElementData(targetPlayer, "money")
						
						if (money<amount) then
							outputChatBox("This player cannot afford such a ticket.", thePlayer, 255, 0, 0)
						else
							exports.global:takePlayerSafeMoney(targetPlayer, amount)
							
							
							-- Distribute money between the PD and Government
							local result = mysql_query(handler, "SELECT bankbalance FROM factions WHERE id='1' OR id='3' LIMIT 2")
							if (result) then
								local tax = exports.global:getTaxAmount()
								local currentPDBalance = mysql_result(result, 1, 1)
								local currentGOVBalance = mysql_result(result, 2, 1)
								
								local PDMoney = math.ceil((1-tax)*amount)
								local GOVMoney = math.ceil(tax*amount)
								
								local theTeamPD = getTeamFromName("Las Venturas Metropolitan Police Department")
								local theTeamGov = getTeamFromName("Government of Las Venturas")
								
								setElementData(theTeamPD, "money", (currentPDBalance+PDMoney))
								setElementData(theTeamGov, "money", (currentGOVBalance+GOVMoney))
								
								mysql_query(handler, "UPDATE factions SET bankbalance='" .. (currentPDBalance+PDMoney) .. "' WHERE id='1'")
								mysql_query(handler, "UPDATE factions SET bankbalance='" .. (currentGOVBalance+GOVMoney) .. "' WHERE id='3'")
								mysql_free_result(result)
							end
							
							outputChatBox("You ticketed " .. getPlayerName(targetPlayer) .. " for " .. amount .. "$. Reason: " .. reason .. ".", thePlayer)
							outputChatBox("You were ticketed for " .. amount .. "$ by " .. getPlayerName(thePlayer) .. ". Reason: " .. reason .. ".", targetPlayer)
						end
					else
						outputChatBox("You are too far away from " .. getPlayerName(targetPlayer) .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("ticket", ticketPlayer, false, false)