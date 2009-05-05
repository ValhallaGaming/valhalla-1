

local smallRadius = 5 --units

----------------------[CUFF]--------------------
function cuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /cuff [Player Partial Nick]", thePlayer)
		else			
			if not (call(getResourceFromName("CJRPglobal-functions"), "doesPlayerHaveItem", thePlayer, 3)) then
				outputChatBox("You do not have handcuffs in your posession.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = call(getResourceFromName("CJRPglobal-functions"), "findPlayerByPartialNick", targetPartialNick)
			
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local x, y, z = getElementPosition(targetPlayer)
					
					local colSphere = createColSphere(x, y, z, smallRadius)
					
					if (isElementWithinColShape(thePlayer, colSphere)) then
						destroyElement(colSphere)
						outputChatBox("You have been hand cuffed by " .. username .. ".", targetPlayer)
						outputChatBox("You are cuffing " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", false)
						toggleControl(targetPlayer, "fire", false)
						toggleControl(targetPlayer, "jump", false)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
						toggleControl(targetPlayer, "accelerate", false)
						toggleControl(targetPlayer, "brake_reverse", false)

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
addCommandHandler("cuff", cuffPlayer)

----------------------[UNCUFF]--------------------
function uncuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /uncuff [Player Partial Nick]", thePlayer)
		else

			if  not (call(getResourceFromName("CJRPglobal-functions"), "doesPlayerHaveItem", thePlayer, 98))  then
				outputChatBox("You do not have any hand cuff keys in your posession.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = call(getResourceFromName("CJRPglobal-functions"), "findPlayerByPartialNick", targetPartialNick)
			
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local x, y, z = getElementPosition(targetPlayer)
					
					local colSphere = createColSphere(x, y, z, smallRadius)
					
					if (isElementWithinColShape(thePlayer, colSphere)) then
						destroyElement(colSphere)
						outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
					    outputChatBox("You are uncuffing " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						setElementData(targetPlayer, "restrain", 0)
					else
						outputChatBox("You are not within range of " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)						
					end
				end
			end
		end
	end
end
addCommandHandler("uncuff", uncuffPlayer)

----------------------[TAZER]--------------------
function tazerAttack(thePlayer)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then

			local tazerCooldown = getElementData(thePlayer, "tazercooldown")
			
			if (tazerCooldown==1) then
				outputChatBox("Your tazer has not finished reloading yet.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(thePlayer)
				local colSphere = createColSphere(x, y, z, smallRadius)
				local nearbyPlayers = getElementsWithinColShape(colSphere)
				local tazedPlayer = nil
				local tazablePlayers = 0
				
				for k, nearbyPlayer in ipairs(nearbyPlayers) do
					local theTeam = getPlayerTeam(nearbyPlayer)
					local factionType = getElementData(theTeam, "type")
					
					if (factionType~=2) or not (theTeam) then
						local tazed = getElementData(nearbyPlayer, "tazed")
						
						if (tazed==0) and (nearbyPlayer~=thePlayer) then -- Cannot taze yourself, or someone already tazed
							tazedPlayer = nearbyPlayer
							tazablePlayers = tazablePlayers + 1
						end
					end
				end
				
				destroyElement(chatSphere)
				if (tazablePlayers==0) then
					call(getResourceFromName("CJRPglobal-functions"), "sendLocalMeAction", thePlayer, "shoots the tazer into mid air, hitting nothing.")
				else
					local chanceToMiss = math.random(1, 10)
					
					if (chanceToMiss>7) then -- 10% chance to miss
						call(getResourceFromName("CJRPglobal-functions"), "sendLocalMeAction", thePlayer, "shoots the tazer and misses.")
					else
						call(getResourceFromName("CJRPglobal-functions"), "sendLocalMeAction", thePlayer, "shoots the tazer and hits.")
						setPedChoking(tazedPlayer, true)
						setElementData(tazedPlayer, "tazed", 1)
						setElementData(thePlayer, "tazercooldown", 1)
						
						local tazedTime = math.random(6, 12)
						setTimer(function()
							setPedChoking(tazedPlayer, false)
							setElementData(tazedPlayer, "tazed", 0)
						end, tazedTime*1000, 1, tazedPlayer)
						outputChatBox("You were tazed by " .. username .. " for " .. tazedTime .. " seconds.", tazedPlayer)
						setTimer(function()
								setElementData(thePlayer, "tazercooldown", 0)
						end, 3000, 1, thePlayer)
					end
				end
			end
	end
end

-- /ticket
function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("SYNTAX: /ticket [Player Partial Nick] [Amount] [Reason]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = call(getResourceFromName("CJRPglobal-functions"), "findPlayerByPartialNick", targetPlayerNick)
				
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
							setElementData(targetPlayer, "money", money-amount)
							
							
							-- Distribute money between the PD and Government
							local result = executeSQLSelect("factions", "bankbalance", "id='1' OR id='3'", 2)
							if (result) then
								local tax = call(getResourceFromName("CJRPglobal-functions"), "getTaxAmount")
								local currentPDBalance = result[1][1]
								local currentGOVBalance = result[2][1]
								
								local PDMoney = math.ceil((1-tax)*amount)
								local GOVMoney = math.ceil(tax*amount)
								
								local theTeamPD = getTeamFromName("Los Santos Police Department")
								local theTeamGov = getTeamFromName("Government of Los Santos")
								
								setElementData(theTeamPD, "money", (currentPDBalance+PDMoney))
								setElementData(theTeamGov, "money", (currentGOVBalance+GOVMoney))
								
								executeSQLUpdate("factions", "bankbalance='" .. (currentPDBalance+PDMoney) .. "'", "id='1'")
								executeSQLUpdate("factions", "bankbalance='" .. (currentGOVBalance+GOVMoney) .. "'", "id='3'")
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
addCommandHandler("ticket", ticketPlayer)