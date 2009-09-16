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
					outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
--addCommandHandler("cuff", cuffPlayer, false, false)

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
					outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
							
							exports.global:removeAnimation(targetPlayer)
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
--addCommandHandler("uncuff", uncuffPlayer, false, false)

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
						
						local money = exports.global:getMoney(targetPlayer)
						local bankmoney = getElementData(targetPlayer, "bankmoney")
						
						if money + bankmoney < amount then
							outputChatBox("This player cannot afford such a ticket.", thePlayer, 255, 0, 0)
						else
							local takeFromCash = math.min( money, amount )
							local takeFromBank = amount - takeFromCash
							exports.global:takeMoney(targetPlayer, takeFromCash)
							
							
							-- Distribute money between the PD and Government
							local tax = exports.global:getTaxAmount()
								
							exports.global:giveMoney( getTeamFromName("Los Santos Police Department"), math.ceil((1-tax)*amount) )
							exports.global:giveMoney( getTeamFromName("Government of Los Santos"), math.ceil(tax*amount) )
							
							outputChatBox("You ticketed " .. getPlayerName(targetPlayer) .. " for " .. amount .. "$. Reason: " .. reason .. ".", thePlayer)
							outputChatBox("You were ticketed for " .. amount .. "$ by " .. getPlayerName(thePlayer) .. ". Reason: " .. reason .. ".", targetPlayer)
							if takeFromBank > 0 then
								outputChatBox("Since you don't have enough money with you, $" .. takeFromBank .. " have been taken from your bank account.", targetPlayer)
								setElementData(targetPlayer, "bankmoney", bankmoney - takeFromBank)
							end
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

function takeLicense(thePlayer, commandName, targetPartialNick, licenseType)

	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) then
			if not (targetPartialNick) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick][license Type 1:Driving 2:Weapon]", thePlayer)
			else
				if not (licenseType) then
					outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick][license Type 1:Driving 2:Weapon]", thePlayer)
				else
					local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
					local targetPlayerName = getPlayerName(targetPlayer)
					local name = getPlayerName(thePlayer)
					
					if (tonumber(licenseType)==1) then
						if(tonumber(getElementData(targetPlayer, "license.car")) == 1) then
							local query = mysql_query(handler, "UPDATE characters SET car_license='0' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(targetPlayer)) .. "' LIMIT 1")
							mysql_free_result(query)
							outputChatBox(name.." has revoked your driving license.", targetPlayer, 255, 194, 14)
							outputChatBox("You have revoked " .. targetPlayerName .. "'s driving license.", thePlayer, 255, 194, 14)
							setElementData(targetPlayer, "license.car", 0)
						else
							outputChatBox(targetPlayerName .. " does not have a driving license.", thePlayer, 255, 0, 0)
						end
					elseif (tonumber(licenseType)==2) then
						if(tonumber(getElementData(targetPlayer, "license.gun")) == 1) then
							local query = mysql_query(handler, "UPDATE characters SET gun_license='0' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(targetPlayer)) .. "' LIMIT 1")
							mysql_free_result(query)
							outputChatBox(name.." has revoked your weapon license.", targetPlayer, 255, 194, 14)
							outputChatBox("You have revoked " .. targetPlayerName .. "'s weapon license.", thePlayer, 255, 194, 14)
							setElementData(targetPlayer, "license.gun", 0)
						else
							outputChatBox(targetPlayerName .. " does not have a weapon license.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("License type not recognised.", thePlayer, 255, 194, 14)
					end
				end
			end
		end
	end
end
addCommandHandler("takelicense", takeLicense, false, false)

function tellNearbyPlayersVehicleStrobesOn()
	local x, y, z = getElementType(source)
	local checkSphere = createColSphere(x, y, z, 300)
	local nearbyPlayers = getElementsWithinColShape(checkSphere, "player")
	destroyElement(checkSphere)
	
	for _, nearbyPlayer in ipairs(nearbyPlayers) do
		triggerClientEvent(nearbyPlayer, "forceElementStreamIn", source)
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), tellNearbyPlayersVehicleStrobesOn)