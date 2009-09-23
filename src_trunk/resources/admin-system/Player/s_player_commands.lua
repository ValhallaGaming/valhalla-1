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

-- /GLUE
local glueSpace = { [406] = 25, [422] = 10, [444] = 10, [455] = 10, [525] = 3, [543] = 10, [554] = 10, [556] = 10, [557] = 10, [600] = 10, [605] = 5 }
function gluePlayer(thePlayer, commandName)
	local glued = getElementData(thePlayer, "glue")
	
	if not (glued) then
		if (isPedInVehicle(thePlayer)) then
			outputChatBox("You are in a vehicle, please exit the vehicle to glue yourself.", thePlayer, 255, 0, 0)
		else
			local contactElement = getPedContactElement(thePlayer)
			
			if not (contactElement) or (getElementType(contactElement)~="vehicle") then
				outputChatBox("There is nothing nearby to glue you to.", thePlayer, 255, 0, 0)
				detachElements(thePlayer)
			elseif getVehicleType(contactElement) == "Bike" or getVehicleType(contactElement) == "BMX" or getVehicleType(contactElement) == "Quad" then
				outputChatBox("You can't glue yourself to this vehicle.", thePlayer, 255, 0, 0)
			elseif getVehicleType(contactElement) == "Automobile" and #getAttachedElements(contactElement) >= (glueSpace[getElementModel(contactElement)] or 1) then
				outputChatBox("This vehicle is full.", thePlayer, 255, 0, 0)
			else
				local px, py, pz = getElementPosition(thePlayer)
				local vx, vy, vz = getElementPosition(contactElement)
				local sx = px - vx
				local sy = py - vy
				local sz = pz - vz
				
				local rotpX = 0
				local rotpY = 0
				local rotpZ = getPedRotation(thePlayer)
				
				local rotvX, rotvY, rotvZ = getVehicleRotation(contactElement)
				
				local t = math.rad(rotvX)
				local p = math.rad(rotvY)
				local f = math.rad(rotvZ)
				
				local ct = math.cos(t)
				local st = math.sin(t)
				local cp = math.cos(p)
				local sp = math.sin(p)
				local cf = math.cos(f)
				local sf = math.sin(f)
				
				local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
				local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
				local y = st*sz - sf*ct*sx + cf*ct*sy
				
				local rotX = rotpX - rotvX
				local rotY = rotpY - rotvY
				local rotZ = rotpZ - rotvZ
				
				local slot = getPedWeaponSlot(thePlayer)
				attachElements(thePlayer, contactElement, x, y, z, rotX, rotY, rotZ)
				setElementData(thePlayer, "glue", true, false)
				setPedWeaponSlot(thePlayer, slot)
				outputChatBox("You are now glued to the " .. getVehicleName(contactElement) .. ".", thePlayer, 255, 194, 14)
			end
		end
	else
		detachElements(thePlayer)
		outputChatBox("You are now unglued!", thePlayer, 255, 194, 14)
		removeElementData(thePlayer, "glue")
	end
end
addCommandHandler("glue", gluePlayer, false, false)

-- /LOOK
function lookPlayer(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
	else
		local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
		
		if not (targetPlayer) then
			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		else
			local targetPlayerName = getPlayerName(targetPlayer)
			local logged = getElementData(targetPlayer, "loggedin")
			local username = getPlayerName(thePlayer)
			
			if (logged==0) then
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			else
				local query = mysql_query(handler, "SELECT description, age, weight, height, skincolor FROM characters WHERE charactername='" .. targetPlayerName .. "'")
				local description = tostring(mysql_result(query, 1, 1))
				local age = tostring(mysql_result(query, 1, 2))
				local weight = tostring(mysql_result(query, 1, 3))
				local height = tostring(mysql_result(query, 1, 4))
				local race = tonumber(mysql_result(query, 1, 5))
				mysql_free_result(query)
				
				if (race==0) then
					race = "Black"
				elseif (race==1) then
					race = "White"
				elseif (race==2) then
					race = "Asian"
				else
					race = "Alien"
				end
				
				outputChatBox("~~~~~~~~~~~~ " .. targetPlayerName .. " ~~~~~~~~~~~~", thePlayer, 255, 194, 14)
				outputChatBox("Age: " .. age .. " years old", thePlayer, 255, 194, 14)
				outputChatBox("Ethnicity: " .. race, thePlayer, 255, 194, 14)
				outputChatBox("Weight: " .. weight .. "kg", thePlayer, 255, 194, 14)
				outputChatBox("Height: " .. height .. "cm", thePlayer, 255, 194, 14)
				outputChatBox("Description: " .. description, thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("look", lookPlayer, false, false)

--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==0) then
						outputChatBox("Player is not restrained.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
						outputChatBox("You have uncuffed " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						setElementData(targetPlayer, "restrain", 0)
						removeElementData(targetPlayer, "restrainedBy")
						removeElementData(targetPlayer, "restrainedObj")
						exports.global:removeAnimation(targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

function infoDisplay(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("---[        Useful Information        ]---", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Ventrilo: 72.37.247.172 Port 3797", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Forums: www.ValhallaGaming.net/forums", getRootElement(), 255, 194, 15)
		outputChatBox("---[ IRC: irc.multitheftauto.com #Valhalla", getRootElement(), 255, 194, 15)
		outputChatBox("---[ UCP: www.ValhallaGaming.net/mtaucp", getRootElement(), 255, 194, 15)

	end
end
addCommandHandler("vginfo", infoDisplay)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")
					
					if (blindfolded==0) then
						outputChatBox("Player is not blindfolded", thePlayer, 255, 0, 0)
					else
						removeElementData(targetPlayer, "blindfold")
						fadeCamera(targetPlayer, true)
						outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local muted = getElementData(targetPlayer, "muted")
					
					if (muted==0) then
						setElementData(targetPlayer, "muted", 1)
						outputChatBox(targetPlayerName .. " is now muted from OOC.", thePlayer, 255, 0, 0)
						outputChatBox("You were muted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 255, 0, 0)
					else
						setElementData(targetPlayer, "muted", 0)
						outputChatBox(targetPlayerName .. " is now unmuted from OOC.", thePlayer, 0, 255, 0)
						outputChatBox("You were unmuted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /RESKICK
function resKick(thePlayer, commandName, amount)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (amount) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Amount of Players to Kick]", thePlayer, 255, 194, 14)
		else
			amount = tonumber(amount)
			local playercount = getPlayerCount()
			if (amount>=playercount) then
				outputChatBox("There is not enough players to kick. (Currently " .. playercount .. " Players)", thePlayer, 255, 0, 0)
			else
				local players = { }
				local count = 1
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					if not (exports.global:isPlayerAdmin(value)) then
						players[count] = value
						count = count + 1
						
						if (count==amount) then
							break
						end
					end
				end
				local kickcount = 0
				for key, value in ipairs(players) do
					if (kickcount<amount) then
						local luck = math.random(0, 1)
						if (luck==1) then
							kickPlayer(value, getRootElement(), "Slot Reservation")
							kickcount = kickcount + 1
						end
					end
				end
				outputChatBox("Kicked " .. kickcount .. "/" .. amount .. " players for slot reservation.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("reskick", resKick, false, false)
				
-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					exports.global:takeAllWeapons(targetPlayer)
					outputChatBox(targetPlayerName .. " is now disarmed.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

-- forceapp
function forceApplication(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			elseif exports.global:isPlayerAdmin(targetPlayer) then
				outputChatBox("No.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local reason = table.concat({...}, " ")
					local id = getElementData(targetPlayer, "gameaccountid")
					local username = getElementData(thePlayer, "gameaccountusername")
					mysql_query(handler, "UPDATE accounts SET appstate = 2, apphandler='" .. username .. "', appreason='" .. mysql_escape_string(handler, reason) .. "' WHERE id='" .. id .. "'")
					outputChatBox(targetPlayerName .. " was forced to re-write their application.", thePlayer, 255, 194, 14)
					
					local port = getServerPort()
					local password = getServerPassword()
					
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " sent " .. targetPlayerName .. " back to the application stage.")
					redirectPlayer(targetPlayer, "67.210.235.106", port, password)
				end
			end
		end
	end
end
addCommandHandler("forceapp", forceApplication, false, false)

-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local query = mysql_query(handler, "UPDATE characters SET cked='1' WHERE charactername='" .. targetPlayerName .. "'")
					
					local x, y, z = getElementPosition(targetPlayer)
					local skin = getPedSkin(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					
					call( getResourceFromName( "realism-system" ), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(targetPlayer, "dbid"), targetPlayerName )
					
					-- send back to change char screen
					local id = getElementData(targetPlayer, "gameaccountid")
					showCursor(targetPlayer, false)
					triggerEvent("sendAccounts", targetPlayer, targetPlayer, id, true)
					setElementData(targetPlayer, "loggedin", 0, false)
					outputChatBox("Your character was CK'ed by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 194, 14)
					showChat(targetPlayer, true)
					outputChatBox("You have CK'ed ".. getPlayerName(targetPlayer) ..".", thePlayer, 255, 194, 1, 14)
					mysql_free_result(query)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. tostring(targetPlayer) .. "' AND cked > 0")
			
			if (mysql_num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql_num_rows(result)==0) then
				outputChatBox("Player does not exist or is not CK'ed.", thePlayer, 255, 0, 0)
			else
				local dbid = tonumber(mysql_result(result, 1, 1)) or 0
				local query = mysql_query(handler, "UPDATE characters SET cked='0' WHERE charactername='" .. tostring(targetPlayer) .. "' LIMIT 1")
				mysql_free_result(query)
				
				-- delete all peds for him
				for key, value in pairs( getElementsByType( "ped" ) ) do
					if isElement( value ) and getElementData( value, "ckid" ) then
						if getElementData( value, "ckid" ) == dbid then
							destroyElement( value )
						end
					end
				end
				
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
			end
			mysql_free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)

-- /BURY
function buryPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql_query(handler, "SELECT id, cked FROM characters WHERE charactername='" .. tostring(targetPlayer) .. "'")
			
			if (mysql_num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql_num_rows(result)==0) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local dbid = tonumber(mysql_result(result, 1, 1)) or 0
				local cked = tonumber(mysql_result(result, 1, 2)) or 0
				if cked == 0 then
					outputChatBox("Player is not CK'ed.", thePlayer, 255, 0, 0)
				elseif cked == 2 then
					outputChatBox("Player is already buried.", thePlayer, 255, 0, 0)
				else
					local query = mysql_query(handler, "UPDATE characters SET cked='2' WHERE charactername='" .. tostring(targetPlayer) .. "' LIMIT 1")
					mysql_free_result(query)
					
					-- delete all peds for him
					for key, value in pairs( getElementsByType( "ped" ) ) do
						if isElement( value ) and getElementData( value, "ckid" ) then
							if getElementData( value, "ckid" ) == dbid then
								destroyElement( value )
							end
						end
					end
					
					outputChatBox(targetPlayer .. " was buried.", thePlayer, 0, 255, 0)
				end
			end
			mysql_free_result(result)
		end
	end
end
addCommandHandler("bury", buryPlayer)

-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					outputChatBox("Player '" .. targetPlayerName .. "' was forced to reconnect.", thePlayer, 255, 0, 0)
					
					local port = getServerPort()
					local password = getServerPassword()
					
					redirectPlayer(targetPlayer, "67.210.235.106", port, password)
				end
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)

-- /GIVEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID/Name] [Ammo]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local weapon = tonumber(args[1])
				local ammo = #args ~= 1 and tonumber(args[#args]) or -1
				
				if not weapon then -- weapon is specified as name
					local weaponEnd = #args
					repeat
						weapon = getWeaponIDFromName(table.concat(args, " ", 1, weaponEnd))
						weaponEnd = weaponEnd - 1
					until weapon or weaponEnd == -1
					if weaponEnd == -1 then
						outputChatBox("Invalid Weapon Name.", thePlayer, 255, 0, 0)
						return
					elseif weaponEnd == #args - 1 then
						ammo = -1
					end
				elseif not getWeaponNameFromID(weapon) then
					outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
				end
				
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					exports.global:takeWeapon(targetPlayer, weapon)
					local give = exports.global:giveWeapon(targetPlayer, weapon, ammo, true)
					
					if not (give) then
						outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Player " .. targetPlayerName .. " now has a " .. getWeaponNameFromID(weapon) .. " with " .. ammo .. " Ammo.", thePlayer, 0, 255, 0)
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a " .. getWeaponNameFromID(weapon) .. " with " .. ammo .. " ammo.")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("givegun", givePlayerGun, false, false)

-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID )
					
					if name then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " now has a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
						else
							outputChatBox("Couldn't give " .. targetPlayerName .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if exports.global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took that Item " .. itemID .. " from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.global:takeItem(targetPlayer, itemID, itemValue)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				local hp = nil
				
				if (tostring(type(tonumber(health))) == "number") then
					hp = setElementHealth(targetPlayer, tonumber(health))
				end
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif not (hp) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " now has " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

-- /SETARMOR
function setPlayerArmour(thePlayer, commandName, targetPlayer, armor)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (armor) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(armor))) == "number") then
					local setArmor = setPedArmor(targetPlayer, tonumber(armor))
					outputChatBox("Player " .. targetPlayerName .. " now has " .. armor .. " Armor.", thePlayer, 0, 255, 0)
				else
					outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)

-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Skin ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0) then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)
					
					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local skin = setPedSkin(targetPlayer, tonumber(skinID))
					
					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) then
						outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Player " .. targetPlayerName .. " now has skin " .. skinID .. ".", thePlayer, 0, 255, 0)
					end
				else
					outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				if newName == targetPlayerName then
					outputChatBox( "The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					local result = mysql_query(handler, "SELECT charactername FROM characters WHERE charactername='" .. mysql_escape_string(handler, newName) .. "' AND id != " .. dbid)
					
					if (mysql_num_rows(result)>0) then
						outputChatBox("This name is already in use.", thePlayer, 255, 0, 0)
					else
						setElementData(targetPlayer, "legitnamechange", 1)
						local name = setPlayerName(targetPlayer, tostring(newName))
						
						if (name) then
							local query = mysql_query(handler, "UPDATE characters SET charactername='" .. mysql_escape_string(handler, newName) .. "' WHERE id = " .. dbid)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
							end
							outputChatBox("You changed " .. targetPlayerName .. "'s Name to " .. tostring(newName) .. ".", thePlayer, 0, 255, 0)
							setElementData(targetPlayer, "legitnamechange", 0)
							mysql_free_result(query)
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						setElementData(targetPlayer, "legitnamechange", 0)
					end
				end
				mysql_free_result(result)
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

-- /HIDEADMIN
function hideAdmin(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		
		if (hiddenAdmin==0) then
			setElementData(thePlayer, "hiddenadmin", 1)
			outputChatBox("You are now a hidden admin.", thePlayer, 255, 194, 14)
		elseif (hiddenAdmin==1) then
			setElementData(thePlayer, "hiddenadmin", 0)
			outputChatBox("You are no longer a hidden admin.", thePlayer, 255, 194, 14)
		end
		exports.global:updateNametagColor(thePlayer)
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)
	
-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("You cannot slap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					
					local x, y, z = getElementPosition(targetPlayer)
					
					if (isPedInVehicle(targetPlayer)) then
						setElementData(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					
					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " slapped " .. targetPlayerName .. ".")
					end
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- /HUGESLAP
function hugeSlapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("You cannot hugeslap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					
					local x, y, z = getElementPosition(targetPlayer)
					
					if (isPedInVehicle(targetPlayer)) then
						setElementData(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					
					setElementPosition(targetPlayer, x, y, z+50)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " huge-slapped " .. targetPlayerName .. ".")
					end
				end
			end
		end
	end
end
addCommandHandler("hugeslap", hugeSlapPlayer, false, false)

-- HEADS Hidden OOC
function hiddenOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local players = exports.pool:getPoolElementsByType("player")
			local message = table.concat({...}, " ")
			
			exports.irc:sendMessage("[OOC: Global Chat] Hidden Admin: " .. message)
			for index, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
			
				if (logged==1) then
					outputChatBox("(( Hidden Admin: " .. message .. " ))", arrayPlayer, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ho", hiddenOOC, false, false)

-- HEADS Hidden Whisper
function hiddenWhisper(thePlayer, command, who, ...)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer = exports.global:findPlayerByPartialNick(who)
			
			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==1) then
					local playerName = getPlayerName(thePlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					outputChatBox("PM From Hidden Admin: " .. message, targetPlayer, 255, 255, 0)
					outputChatBox("Hidden PM Sent to " .. targetPlayerName .. ": " .. message, thePlayer, 255, 255, 0)
				elseif (logged==0) then
					outputChatBox("Player is not logged in yet.", thePlayer, 255, 255, 0)
				end
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 255, 0)
			end
		end
	end
end
addCommandHandler("hw", hiddenWhisper, false, false)

-- RECON
function reconPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				setElementData(thePlayer, "reconx", nil)
				setElementData(thePlayer, "recony", nil, false)
				setElementData(thePlayer, "reconz", nil, false)
				setElementData(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
			end
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			elseif (getPlayerName(targetPlayer)=="Nathan_Daniels") and getElementData(thePlayer, "gameaccountid") ~= 1500 then
				outputChatBox("You cannot recon this person.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					setElementAlpha(thePlayer, 0)
					
					if not getElementData(thePlayer, "reconx") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						setElementData(thePlayer, "reconx", x)
						setElementData(thePlayer, "recony", y, false)
						setElementData(thePlayer, "reconz", z, false)
						setElementData(thePlayer, "reconrot", rot, false)
						setElementData(thePlayer, "recondimension", dimension, false)
						setElementData(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					attachElements(thePlayer, targetPlayer, -10, -10, 5)
					setCameraTarget(thePlayer, targetPlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					outputChatBox("Now reconning " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					if hiddenAdmin == 0 and not exports.global:isPlayerLeadAdmin(thePlayer) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " started reconning " .. targetPlayerName .. ".")
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)

-- Kick
function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						outputChatBox("AdmKick: " .. adminTitle .. " " .. playerName .. " kicked " .. targetPlayerName .. ".", getRootElement(), 255, 0, 51)
						outputChatBox("AdmKick: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						outputChatBox("AdmKick: Hidden Admin kicked " .. targetPlayerName .. ".", getRootElement(), 255, 0, 51)
						outputChatBox("AdmKick: Reason: " .. reason, getRootElement(), 255, 0, 51)
						kickPlayer(targetPlayer, getRootElement(), reason)
					end
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the kick command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)


-- BAN
function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Time in Hours, 0 = Infinite] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			hours = tonumber(hours)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			elseif (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					local accountID = getElementData(targetPlayer, "gameaccountid")
					
					local seconds = ((hours*60)*60)
					
					-- text value
					if (hours==0) then
						hours = "Permanent"
					elseif (hours==1) then
						hours = "1 Hour"
					else
						hours = hours .. " Hours"
					end
					
					reason = reason .. " (" .. hours .. ")"
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						outputChatBox("AdmBan: " .. adminTitle .. " " .. playerName .. " banned " .. targetPlayerName .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
						
						local ban = banPlayer(targetPlayer, true, false, false, thePlayer, reason, seconds)
						
						local query = mysql_query(handler, "UPDATE accounts SET banned='1', banned_reason='" .. reason .. "', banned_by='" .. playerName .. "' WHERE id='" .. accountID .. "'")
						mysql_free_result(query)
					elseif (hiddenAdmin==1) then
						outputChatBox("AdmBan: Hidden Admin banned " .. targetPlayerName .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Reason: " .. reason, getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Time: " .. hours .. ".", getRootElement(), 255, 0, 51)
						
						local ban = banPlayer(targetPlayer, true, false, false, getRootElement(), reason, seconds)
						
						local query = mysql_query(handler, "UPDATE accounts SET banned='1', banned_reason='" .. reason .. "', banned_by='" .. playerName .. "' WHERE id='" .. accountID .. "'")
						mysql_free_result(query)
					end
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the ban command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)

function unbanAccount(theBan)
	local ip = getBanIP(theBan)
	mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
end
addEventHandler("onUnban", getRootElement(), unbanAccount)

function remoteUnban(thePlayer, targetNick)
	local bans = getBans()
	local found = false
	
	local result1 = mysql_query(handler, "SELECT id, ip FROM accounts WHERE username='" .. tostring(targetNick) .. "' LIMIT 1")
	
	if (result1) then
		if (mysql_num_rows(result1)>0) then
			local accountid = tonumber(mysql_result(result1, 1, 1))
			local ip = tostring(mysql_result(result1, 1, 2))
			mysql_free_result(result1)
			local bans = getBans()
			
			for key, value in ipairs(bans) do
				if (ip==getBanIP(value)) then
					exports.global:sendMessageToAdmins(tostring(targetNick) .. " was remote unbanned from UCP by " .. thePlayer .. ".")
					removeBan(value)
					local query = mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
					mysql_free_result(query)
					found = true
					break
				end
			end
		end
	end
	return found
end

-- /UNBAN
function unbanPlayer(thePlayer, commandName, nickName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (nickName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Full Name]", thePlayer, 255, 194, 14)
		else
			local bans = getBans()
			local found = false
			
			local result1 = mysql_query(handler, "SELECT account FROM characters WHERE charactername='" .. tostring(nickName) .. "' LIMIT 1")
			
			if (result1) then
				if (mysql_num_rows(result1)>0) then
					local accountid = tonumber(mysql_result(result1, 1, 1))
					mysql_free_result(result1)
					
					local result = mysql_query(handler, "SELECT ip FROM accounts WHERE id='" .. accountid .. "'")
						
					if (result) then
						if (mysql_num_rows(result)>0) then
							local ip = tostring(mysql_result(result, 1, 1))
							
							for key, value in ipairs(bans) do
								if (ip==getBanIP(value)) then
									exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
									removeBan(value, thePlayer)
									local query = mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
									mysql_free_result(query)
									found = true
									break
								end
							end
						
							if not (found) then
								outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
							end
							mysql_free_result(result)
						else
							outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
				end
				mysql_free_result(result1)
			else
				outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)

-- /UNBANIP
function unbanPlayerIP(thePlayer, commandName, ip)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (ip) then
			outputChatBox("SYNTAX: /" .. commandName .. " [IP]", thePlayer, 255, 194, 14)
		else
			local bans = getBans()
			local found = false
				
			for key, value in ipairs(bans) do
				if (ip==getBanIP(value)) then
					exports.global:sendMessageToAdmins(tostring(ip) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
					removeBan(value, thePlayer)
					local query = mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
					mysql_free_result(query)
					found = true
					break
				end
			end
			
			if not (found) then
				outputChatBox("No ban found for '" .. ip .. "'", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unbanip", unbanPlayerIP, false, false)

function teleportToPresetPoint(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [LS/SF/LV]", thePlayer, 255, 194, 14)
		else
			target = string.lower(tostring(target))
			
			if (target=="ls") then -- LOS SANTOS
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					setElementPosition(veh, 1520.0029296875, -1701.2425537109, 16.546875)
					setVehicleRotation(veh, 0, 0, 275.82763671875)
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
				else
					setElementPosition(thePlayer, 1520.0029296875, -1701.2425537109, 13.546875)
					setPedRotation(thePlayer, 275.82763671875)
					setElementDimension(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					setElementInterior(thePlayer, 0)
				end
				outputChatBox("Teleported to Los Santos!", thePlayer, 0, 255, 0)
			elseif (target=="sf") then -- SAN FIERRO
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setVehicleTurnVelocity(veh, 0, 0, 0)
					setElementPosition(veh, -1689.0689697266, -536.7919921875, 18.854997634888)
					setVehicleRotation(veh, 0, 0, 252.35975646973)
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
				else
					setElementPosition(thePlayer, -1689.0689697266, -536.7919921875, 15.854997634888)
					setPedRotation(thePlayer, 252.35975646973)
					setElementDimension(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					setElementInterior(thePlayer, 0)
				end
				outputChatBox("Teleported to San Fierro!", thePlayer, 0, 255, 0)
			elseif (target=="lv") then -- LAS VENTURAS
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setVehicleTurnVelocity(veh, 0, 0, 0)
					setElementPosition(veh, 1691.6801757813, 1449.1293945313, 12.765375137329)
					setVehicleRotation(veh, 0, 0, 268.20239257813)
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
				else
					setElementPosition(thePlayer, 1691.6801757813, 1449.1293945313, 12.765375137329)
					setPedRotation(thePlayer, 268.20239257813)
					setElementDimension(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					setElementInterior(thePlayer, 0)
				end
				outputChatBox("Teleported to Las Venturas!", thePlayer, 0, 255, 0)
			else
				outputChatBox("Invalid Place Entered!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotoplace", teleportToPresetPoint, false, false)

function makePlayerAdmin(thePlayer, commandName, who, rank)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Rank]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(who)
			
			if (targetPlayer) then
				local targetPlayerName = getPlayerName(targetPlayer)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "gameaccountid")
				
				setElementData(targetPlayer, "adminlevel", tonumber(rank))
				
				rank = tonumber(rank)
				
				if (rank<1337) then
					setElementData(targetPlayer, "hiddenadmin", 0)
				end
				
				local query = mysql_query(handler, "UPDATE accounts SET admin='" .. tonumber(rank) .. "', hiddenadmin='0' WHERE id='" .. accountID .. "'")
				mysql_free_result(query)
				outputChatBox("You set " .. targetPlayerName .. "'s Admin rank to " .. rank .. ".", thePlayer, 0, 255, 0)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				-- Fix for scoreboard & nametags
				local targetAdminTitle = exports.global:getPlayerAdminTitle(targetPlayer)
				if (rank>0) or (rank==-999999999) then
					setElementData(targetPlayer, "adminduty", 1)
				else
					setElementData(targetPlayer, "adminduty", 0)
				end
				exports.global:updateNametagColor(targetPlayer)
				
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox(adminTitle .. " " .. username .. " set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " set " .. targetPlayerName .. "'s admin level to " .. rank .. ".")
				else
					outputChatBox("Hidden admin set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
				end
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makeadmin", makePlayerAdmin, false, false)


----------------------[JAIL]--------------------
function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local minutes = tonumber(minutes)
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Minutes(>=1) 999=Perm] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(who)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local targetPlayerNick = getPlayerName(targetPlayer)
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "gameaccountid")
				
				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(targetPlayer)) then
					setElementData(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end
				
				if (minutes>=999) then
					local query = mysql_query(handler, "UPDATE accounts SET adminjail='1', adminjail_time='" .. minutes .. "', adminjail_permanent='1', adminjail_by='" .. playerName .. "', adminjail_reason='" .. mysql_escape_string(handler, reason) .. "' WHERE id='" .. accountID .. "'")
					mysql_free_result(query)
					minutes = "Unlimited"
					setElementData(targetPlayer, "jailtimer", true, false)
				else
					local query = mysql_query(handler, "UPDATE accounts SET adminjail='1', adminjail_time='" .. minutes .. "', adminjail_permanent='0', adminjail_by='" .. playerName .. "', adminjail_reason='" .. mysql_escape_string(handler, reason) .. "' WHERE id='" .. tonumber(accountID) .. "'")
					mysql_free_result(query)
					local theTimer = setTimer(timerUnjailPlayer, 60000, minutes, targetPlayer)
					setElementData(targetPlayer, "jailserved", 0, false)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
				end
				setElementData(targetPlayer, "adminjailed", true)
				setElementData(targetPlayer, "jailreason", reason, false)
				setElementData(targetPlayer, "jailtime", minutes, false)
				setElementData(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)
				
				outputChatBox("You jailed " .. targetPlayerNick .. " for " .. minutes .. " Minutes.", thePlayer, 255, 0, 0)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox("AdmJail: " .. adminTitle .. " " .. playerName .. " jailed " .. targetPlayerNick .. " for " .. minutes .. " Minutes.", getRootElement(), 255, 0, 0)
					outputChatBox("AdmJail: Reason: " .. reason, getRootElement(), 255, 0, 0)
				else
					outputChatBox("AdmJail: Hidden Admin jailed " .. targetPlayerNick .. " for " .. minutes .. " Minutes.", getRootElement(), 255, 0, 0)
					outputChatBox("AdmJail: Reason: " .. reason, getRootElement(), 255, 0, 0)
				end
				
				local incVal = 0
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local name = getPlayerName(value)
					if (name==getPlayerName(targetPlayer)) then
						incVal = key
						break
					end
				end
				
				setElementDimension(targetPlayer, 65400+incVal)
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				
				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "gameaccountid")
		if (timeServed) then
			setElementData(jailedPlayer, "jailserved", timeServed+1, false)
			local timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft, false)
		
			if (timeLeft<=0) then
				local query = mysql_query(handler, "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. accountID .. "'")
				mysql_free_result(query)
				removeElementData(jailedPlayer, "jailtimer")
				removeElementData(jailedPlayer, "adminjailed")
				removeElementData(jailedPlayer, "jailreason")
				removeElementData(jailedPlayer, "jailtime")
				removeElementData(jailedPlayer, "jailadmin")
				setElementPosition(jailedPlayer, 1519.7177734375, -1697.8154296875, 13.546875)
				setPedRotation(jailedPlayer, 269.92446899414)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				outputChatBox("Your time has been served, Behave next time!", jailedPlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmJail: " .. getPlayerName(jailedPlayer) .. " has served his jail time.")
				exports.irc:sendMessage("[ADMIN] " .. getPlayerName(jailedPlayer) .. " was unjailed by script (Time Served)")
			else
				local query = mysql_query(handler, "UPDATE accounts SET adminjail_time='" .. timeLeft .. "' WHERE id='" .. accountID .. "'")
				mysql_free_result(query)
			end
		end
	end
end

function unjailPlayer(thePlayer, commandName, who)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(who)
			
			if (targetPlayer) then
				local targetPlayerNick = getPlayerName(targetPlayer)
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "gameaccountid")
				
				if not (jailed) then
					outputChatBox(targetPlayerNick .. " is not jailed.", thePlayer, 255, 0, 0)
				else
					local query = mysql_query(handler, "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. accountID .. "'")
					mysql_free_result(query)
					if isTimer(jailed) then
						killTimer(jailed)
					end
					removeElementData(targetPlayer, "jailtimer")
					removeElementData(targetPlayer, "adminjailed")
					removeElementData(targetPlayer, "jailreason")
					removeElementData(targetPlayer, "jailtime")
					removeElementData(targetPlayer, "jailadmin")
					setElementPosition(targetPlayer, 1519.7177734375, -1697.8154296875, 13.546875)
					setPedRotation(targetPlayer, 269.92446899414)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					toggleControl(targetPlayer,'next_weapon',true)
					toggleControl(targetPlayer,'previous_weapon',true)
					toggleControl(targetPlayer,'fire',true)
					toggleControl(targetPlayer,'aim_weapon',true)
					outputChatBox("You were unjailed by " .. username .. ", Behave next time!", targetPlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmJail: " .. targetPlayerNick .. " was unjailed by " .. username .. ".")
					exports.irc:sendMessage("[ADMIN] " .. targetPlayerNick .. " was unjailed by " .. username .. ".")
				end
			else
				outputChatBox("Player is not online.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("~~~~~~~~~ Jailed ~~~~~~~~~", thePlayer, 255, 194, 15)
		
		local players = exports.pool:getPoolElementsByType("player")
		local count = 0
		for key, value in ipairs(players) do
			if getElementData(value, "adminjailed") then
				outputChatBox("[JAIL] " .. getPlayerName(value) .. ", jailed by " .. tostring(getElementData(value, "jailadmin")) .. ", served " .. tostring(getElementData(value, "jailserved")) .. " minutes, " .. tostring(getElementData(value,"jailtime")) .. " minutes left", thePlayer, 255, 194, 15)
				outputChatBox("[JAIL] Reason: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("There is noone jailed.", thePlayer, 255, 194, 15)
		end
	end
end

addCommandHandler("jailed", jailedPlayers, false, false)

----------------------------[GO TO PLAYER]---------------------------------------
function gotoPlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
	
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					
					local x, y, z = getElementPosition(targetPlayer)
					local interior = getElementInterior(targetPlayer)
					local dimension = getElementDimension(targetPlayer)
					local r = getPedRotation(targetPlayer)
					
					-- Maths calculations to stop the player being stuck in the target
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					setCameraInterior(thePlayer, interior)
					
					if (isPedInVehicle(thePlayer)) then
						local veh = getPedOccupiedVehicle(thePlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
                        setElementInterior(thePlayer, interior)
                        setElementDimension(thePlayer, dimension)
                        setElementInterior(veh, interior)
                        setElementDimension(veh, dimension)
                        setElementPosition(veh, x, y, z + 1)
                        warpPedIntoVehicle ( thePlayer, veh ) 
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					else
						setElementPosition(thePlayer, x, y, z)
						setElementInterior(thePlayer, interior)
						setElementDimension(thePlayer, dimension)
					end
					outputChatBox(" You have teleported to player " .. targetPlayerName .. ".", thePlayer)
					outputChatBox(" An admin " .. username .. " has teleported to you. ", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("goto", gotoPlayer, false, false)

----------------------------[GET PLAYER HERE]---------------------------------------
function getPlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
	
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /gethere [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local r = getPedRotation(thePlayer)
					setCameraInterior(targetPlayer, interior)
					
					-- Maths calculations to stop the target being stuck in the player
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					outputChatBox(" You have teleported player " .. targetPlayerName .. " to you.", thePlayer)
					outputChatBox(" An admin " .. username .. " has teleported you to them. ", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("gethere", getPlayer, false, false)

function setMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				
				exports.global:setMoney(targetPlayer, money)
				outputChatBox(targetPlayerName .. " now has " .. money .. " $.", thePlayer)
				outputChatBox("Admin " .. username .. " set your money to " .. money .. " $.", targetPlayer)
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function giveMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				
				exports.global:giveMoney(targetPlayer, money)
				outputChatBox("You have given " .. targetPlayerName .. " $" .. money .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you $" .. money .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

-----------------------------------[FREEZE]----------------------------------
function freezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			if targetPlayer then
				local targetPlayerName = getPlayerName(targetPlayer)
				
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setVehicleFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by an admin. Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else	
					toggleAllControls(targetPlayer, false, true, false)
					setPedWeaponSlot(targetPlayer, 0)
					setElementData(targetPlayer, "freeze", 1)
					outputChatBox(" You have been frozen by an admin. Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /unfreeze [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			if targetPlayer then
				local targetPlayerName = getPlayerName(targetPlayer)
				
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setVehicleFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by an admin. Thanks for your co-operation.", targetPlayer)
					end
					
					if (isElement(thePlayer)) then
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else	
					toggleAllControls(targetPlayer, true, true, true)
					
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					removeElementData(targetPlayer, "freeze")
					outputChatBox(" You have been unfrozen by an admin. Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

------------- [Mark and /gotomark ] commands

function markPosition(thePlayer, command)
	
	local logged = getElementData ( thePlayer, "loggedin" )
	if ( logged == 1) then
		if (exports.global:isPlayerAdmin(thePlayer)) then
		
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension= getElementDimension(thePlayer)
			
			setElementData(thePlayer, "tempMark.x", x, false)
			setElementData(thePlayer, "tempMark.y", y, false)
			setElementData(thePlayer, "tempMark.z", z, false)
			setElementData(thePlayer, "tempMark.interior", interior, false)
			setElementData(thePlayer, "tempMark.dimension", dimension, false)
						
			outputChatBox("Mark set sucessfull.", thePlayer, 0, 255, 0, true)
		
		else
			 outputChatBox( " You are not an admin and are not authorised to use that command.", thePlayer, 255, 0,0, true )
		end
	end
end
addCommandHandler ( "mark", markPosition , false, false)


function gotoMark(thePlayer, command)

	local logged = getElementData ( thePlayer, "loggedin" )
	if ( logged == 1) then
		if (exports.global:isPlayerAdmin(thePlayer)) then
		
			if(getElementData(thePlayer, "tempMark.x") )then
			
				fadeCamera ( thePlayer, false, 1,0,0,0 )
				
				setTimer(function()
				
					local vehicle = nil
					local seat = nil
				
					if(isPedInVehicle ( thePlayer )) then
						 vehicle =  getPedOccupiedVehicle ( thePlayer )
						seat = getPedOccupiedVehicleSeat ( thePlayer )
					end
					
					if(vehicle and (seat ~= 0)) then
						removePedFromVehicle (thePlayer )
						setElementData(thePlayer, "realinvehicle", 0, false)
						setElementPosition(thePlayer, tonumber(getElementData(thePlayer, "tempMark.x")),tonumber(getElementData(thePlayer, "tempMark.y")),tonumber(getElementData(thePlayer, "tempMark.z")))
						setElementInterior(thePlayer, getElementData(thePlayer, "tempMark.interior"))
						setElementDimension(thePlayer, getElementData(thePlayer, "tempMark.dimension"))
					elseif(vehicle and seat == 0) then
						removePedFromVehicle (thePlayer )
						setElementData(thePlayer, "realinvehicle", 0, false)
						setElementPosition(vehicle, tonumber(getElementData(thePlayer, "tempMark.x")),tonumber(getElementData(thePlayer, "tempMark.y")),tonumber(getElementData(thePlayer, "tempMark.z")))
						setElementInterior(vehicle, getElementData(thePlayer, "tempMark.interior"))
						setElementDimension(vehicle, getElementData(thePlayer, "tempMark.dimension"))
						warpPedIntoVehicle ( thePlayer, vehicle, 0)
					else
						setElementPosition(thePlayer, tonumber(getElementData(thePlayer, "tempMark.x")),tonumber(getElementData(thePlayer, "tempMark.y")),tonumber(getElementData(thePlayer, "tempMark.z")))
						setElementInterior(thePlayer, getElementData(thePlayer, "tempMark.interior"))
						setElementDimension(thePlayer, getElementData(thePlayer, "tempMark.dimension"))
					end
					

					
					setTimer(fadeCamera, 1000, 1, thePlayer, true, 1)
				end, 1000, 1)
			
			else
				outputChatBox( "You need to set a position with /mark first.", thePlayer, 255, 0,0, true )
			end
		else
			 outputChatBox( " You are not an admin and are not authorised to use that command.", thePlayer, 255, 0,0, true )
		end
	end

end
addCommandHandler ( "gotomark", gotoMark , false, false)

----------------------------[MAKE DONATOR]---------------------------------------
function makePlayerDonator(thePlayer, commandName, target, level)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if (level) then
			level = tonumber(level)
		end
		
		if not (target) or not (level) or (level<0) or (level>7) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Level 0=None, 1=Bronze, 2=Silver, 3=Gold, 4=Platinum, 5=Pearl, 6=Diamond, 7=Godly]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local levelString = ""
					local gameaccountID = getElementData(targetPlayer, "gameaccountid")
					
					if (level==0) then
						setElementData(targetPlayer, "donatorlevel", 0)
						local query = mysql_query(handler, "UPDATE accounts SET donator='0' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Non-Donator"
					elseif (level==1) then
						setElementData(targetPlayer, "donatorlevel", 1)
						local query = mysql_query(handler, "UPDATE accounts SET donator='1' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Bronze Donator"
					elseif (level==2) then
						setElementData(targetPlayer, "donatorlevel", 2)
						local query = mysql_query(handler, "UPDATE accounts SET donator='2' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Silver Donator"
					elseif (level==3) then
						setElementData(targetPlayer, "donatorlevel", 3)
						local query = mysql_query(handler, "UPDATE accounts SET donator='3' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Gold Donator"
					elseif (level==4) then
						setElementData(targetPlayer, "donatorlevel", 4)
						local query = mysql_query(handler, "UPDATE accounts SET donator='4' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Platinum Donator"
					elseif (level==5) then
						setElementData(targetPlayer, "donatorlevel", 5)
						local query = mysql_query(handler, "UPDATE accounts SET donator='5' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Pearl Donator"
					elseif (level==6) then
						setElementData(targetPlayer, "donatorlevel", 6)
						local query = mysql_query(handler, "UPDATE accounts SET donator='6' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Diamond Donator"
					elseif (level==7) then
						setElementData(targetPlayer, "donatorlevel", 7)
						local query = mysql_query(handler, "UPDATE accounts SET donator='7' WHERE id='" .. gameaccountID .. "'")
						mysql_free_result(query)
						levelString = "Godly Donator"
					end
					
					if (level>0) then
						exports.global:givePlayerAchievement(targetPlayer, 29)
					end
					outputChatBox("You set " .. targetPlayerName .. " as a " .. levelString .. ".", targetPlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmCmd: " .. username .. " set " .. targetPlayerName .. " as a " .. levelString .. ".")
					exports.irc:sendMessage("[ADMIN] " .. username .. " set " .. targetPlayerName .. " as a " .. levelString .. ".")
					exports.global:updateNametagColor(targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("makedonator", makePlayerDonator, false, false)

function adminDuty(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "adminduty")
		local username = getPlayerName(thePlayer)
		
		if (adminduty==0) then
			setElementData(thePlayer, "adminduty", 1)
			outputChatBox("You went on admin duty.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " came on duty.")
		elseif (adminduty==1) then
			setElementData(thePlayer, "adminduty", 0)
			outputChatBox("You went off admin duty.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " went off duty.")
		end
		exports.global:updateNametagColor(thePlayer)
	end
end
addCommandHandler("adminduty", adminDuty, false, false)

----------------------------[SET MOTD]---------------------------------------
function setMOTD(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: " .. commandName .. " [message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local query = mysql_query(handler, "UPDATE settings SET value='" .. message .. "' WHERE name='motd'")
			
			if (query) then
				mysql_free_result(query)
				outputChatBox("MOTD set to '" .. message .. "'.", thePlayer, 0, 255, 0)
			else
				outputChatBox("Failed to set MOTD.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setmotd", setMOTD, false, false)

-- GET PLAYER ID
function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer = exports.global:findPlayerByPartialNick(target)
		
		if (targetPlayer) then
			local targetPlayerName = getPlayerName(targetPlayer)
			
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s ID is " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

-- EJECT
function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			
			if (seat~=0) then
				outputChatBox("You must be the driver to eject.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(target)
				
				if not (targetPlayer) then
					outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
				elseif (targetPlayer==thePlayer) then
					outputChatBox("You cannot eject yourself.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)
					
					if targetvehicle~=vehicle and not exports.global:isPlayerAdmin(thePlayer) then
						outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						setElementData(targetPlayer, "realinvehicle", 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)

-- WARNINGS
function warnPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local warns = getElementData(targetPlayer, "warns")
				warns = warns + 1
				outputChatBox("You have given " .. targetPlayerName .. " a warning. (" .. warns .. "/3).", thePlayer, 255, 0, 0)
				outputChatBox("You have been given a warning by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 0, 0)
				
				setElementData(targetPlayer, "warns", warns, false)
				
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox("AdmWarn: " .. adminTitle .. " " .. playerName .. " warned " .. targetPlayerName .. ". (" .. warns .. "/3)", getRootElement(), 255, 0, 51)
				end
				
				if (warns>=3) then
					banPlayer(targetPlayer, true, false, false, thePlayer, "Received 3 admin warnings.", 0)
					outputChatBox("AdmWarn: " .. targetPlayerName .. " was banned for several admin warnings.", getRootElement(), 255, 0, 51)
					
					local accountID = getElementData(targetPlayer, "gameaccountid")
					local query = mysql_query(handler, "UPDATE accounts SET banned='1', banned_reason='3 Admin Warnings', banned_by='Warn System' WHERE id='" .. accountID .. "'")
					mysql_free_result(query)
				end
			end
		end
	end
end
addCommandHandler("warn", warnPlayer, false, false)

-- recon fix for interior changing
function interiorChanged()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(value, interior)
					setElementInterior(value, interior)
					setElementDimension(value, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", getRootElement(), interiorChanged)

-- stop recon on quit of the player
function removeReconning()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					executeCommandHandler("recon", source)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeReconning)

-- FREECAM
function toggleFreecam(thePlayer)
    if exports.global:isPlayerAdmin(thePlayer) then
        local enabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
        
        if (enabled) then
            removeElementData(thePlayer, "reconx")
            setElementAlpha(thePlayer, 255)
            setPedFrozen(thePlayer, false)
            exports.freecam:setPlayerFreecamDisabled (thePlayer)
        else
            setElementData(thePlayer, "reconx", 0)
            setElementAlpha(thePlayer, 0)
            setPedFrozen(thePlayer, true)
            exports.freecam:setPlayerFreecamEnabled (thePlayer)
        end
    end
end
addCommandHandler("freecam", toggleFreecam)

-- DROP ME

function dropOffFreecam(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local enabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
		if (enabled) then
			local x, y, z = getElementPosition(thePlayer)
			removeElementData(thePlayer, "reconx")
			setElementAlpha(thePlayer, 255)
			setPedFrozen(thePlayer, false)
			exports.freecam:setPlayerFreecamDisabled (thePlayer)
			setElementPosition(thePlayer, x, y, z)
		else
			outputChatBox("This command only works while freecam is on.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("dropme", dropOffFreecam)

-- DISAPPEAR

function toggleInvisibility(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			setElementData(thePlayer, "reconx", false)
			outputChatBox("You are now visible.", thePlayer, 255, 0, 0)
			setElementData(thePlayer, "invisible", false)
		else
			setElementAlpha(thePlayer, 0)
			setElementData(thePlayer, "reconx", true)
			outputChatBox("You are now invisible.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "invisible", true)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)

-- INVULNERABILITY

function invulnerability()
	local thePlayer = getRootElement()
	local enabled = getElementData(thePlayer, "invulnerable")
	if (enabled == true) then
		cancelEvent()
	end
end
addEventHandler("onPlayerDamage", getRootElement(), invulnerability)
	
function toggleInvulnerability(thePlayer)
	local enabled = getElementData(thePlayer, "invulnerable")
	if (enabled == true) then
		setElementData(thePlayer, "invulnerable", false)
		outputChatBox("You are now vulnerable.", thePlayer, 255, 0, 0)
	else
		setElementData(thePlayer, "invulnerable", true)
		outputChatBox("You are now invulnerable.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("togvulnerable", toggleInvulnerability)
					
-- TOGGLE NAMETAG

function toggleMyNametag(thePlayer)
	local visible = getElementData(thePlayer, "reconx")
	if exports.global:isPlayerAdmin(thePlayer) then
		if (visible == true) then
			setPlayerNametagShowing(thePlayer, false)
			setElementData(thePlayer, "reconx", false)
			outputChatBox("Your nametag is now visible.", thePlayer, 255, 0, 0)
		else
			setPlayerNametagShowing(thePlayer, false)
			setElementData(thePlayer, "reconx", true)
			outputChatBox("Your nametag is now hidden.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("togmytag", toggleMyNametag)

-- RESET CHARACTER
function resetCharacter(thePlayer, commandName, character)
    if exports.global:isPlayerLeadAdmin(thePlayer) then
        if not (character) then
            outputChatBox("SYNTAX: /" .. commandName .. " [exact character name]", thePlayer, 255, 0, 0)
        else
            local targetPlayer = getPlayerFromName(character)
            local query = mysql_query(handler, "SELECT id FROM characters WHERE charactername='" .. character .. "'")
            local targetid = tonumber(mysql_result(query, 1, 1))
            local logged = getElementData(targetPlayer, "loggedin")
            mysql_free_result(query)
            if logged == 1 then
                kickPlayer(targetPlayer)
            end
            if (targetid == nil) then
                outputChatBox(character .. " is not a valid character name.", thePlayer, 255, 0, 0)
            else
                query = mysql_query(handler, "UPDATE characters SET money='0', weapons=NULL, ammo=NULL, items=NULL, itemvalues=NULL, car_license='0', gun_license='0', bankmoney='0' WHERE id='" .. targetid .. "'")
                mysql_free_result(query)
				query = mysql_query(handler, "DELETE FROM items WHERE type=1 AND owner=" .. targetid)
                mysql_free_result(query)
                query = mysql_query(handler, "DELETE FROM vehicles WHERE owner='" .. targetid .. "'")
                mysql_free_result(query)
                query = mysql_query(handler, "UPDATE interiors SET owner='-1',locked='1' WHERE owner='" .. targetid .. "'")
                mysql_free_result(query)
                restartResource(getResourceFromName(tostring("item-system")))
                restartResource(getResourceFromName(tostring("interior-system")))
                outputChatBox("You stripped " .. character .. " off their possession.", thePlayer, 0, 255, 0)
                if (hiddenAdmin==0) then
                    local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
                    exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has reset " .. character .. ".")
                end
            end
        end
    else
        outputChatBox("You do not have the required permissions.", thePlayer, 255, 0, 0)
    end
end
--addCommandHandler("resetcharacter", resetCharacter)

-- FIND ALT CHARS
local function showAlts(thePlayer, id)
	result = mysql_query( handler, "SELECT charactername, cked, faction_id FROM characters WHERE account = " .. id )
	if result then
		local name = mysql_query( handler, "SELECT username FROM accounts WHERE id = " .. id )
		if name then
			local uname = mysql_result( name, 1, 1 )
			if uname and uname ~= mysql_null() then
				outputChatBox( "~-~-~-~-~-~ " .. uname .. " ~-~-~-~-~-~", thePlayer, 255, 194, 14 )
			else
				outputChatBox( " ", thePlayer )
			end
			mysql_free_result( name )
		else
			outputChatBox( " ", thePlayer )
		end
		local count = 0
		for result, row in mysql_rows( result ) do
			count = count + 1
			local r = 255
			if getPlayerFromName( row[1] ) then
				r = 0
			end
			
			local text = "#" .. count .. ": " .. row[1]:gsub("_", " ")
			if tonumber( row[2] ) == 1 then
				text = text .. " (Missing)"
			elseif tonumber( row[2] ) == 2 then
				text = text .. " (Buried)"
			end
			
			local faction = tonumber( row[3] ) or 0
			if faction > 0 then
				for key, value in pairs( getElementsByType( "team" ) ) do
					if getElementData( value, "id" ) == faction then
						text = text .. " - " .. getTeamName( value )
						break
					end
				end
			end
			
			outputChatBox( text, thePlayer, r, 255, 0)
		end
		mysql_free_result( result )
	else
		outputChatBox( "Error #9100 - Report on Forums", thePlayer, 255, 0, 0)
		outputDebugString( mysql_error( handler ) )
	end
end

function findAltChars(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerName)
			
			if not targetPlayer then
				-- select by character name
				local result = mysql_query( handler, "SELECT account FROM characters WHERE charactername = '" .. mysql_escape_string( handler, targetPlayerName ) .. "'" )
				if result then
					if mysql_num_rows( result ) == 1 then
						local id = tonumber( mysql_result( result, 1, 1 ) ) or 0
						showAlts( thePlayer, id )
						return
					else
						-- select by account name
						local result2 = mysql_query( handler, "SELECT id FROM accounts WHERE username = '" .. mysql_escape_string( handler, targetPlayerName ) .. "'" )
						if result2 then
							if mysql_num_rows( result2 ) == 1 then
								local id = tonumber( mysql_result( result2, 1, 1 ) ) or 0
								showAlts( thePlayer, id )
								return
							end
							mysql_free_result( result2 )
						end
					end
					mysql_free_result( result )
				end
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local id = getElementData( targetPlayer, "gameaccountid" )
				if id then
					showAlts( thePlayer, id )
				else
					outputChatBox("Game Account is unknown.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler( "findalts", findAltChars )

--give player license
function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Type]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Driver", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Weapon", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerName)
			
			if not targetPlayer then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "driver" or "weapon"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." has already a "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						setElementData(targetPlayer, "license."..licenseType, 1)
						local query = mysql_query(handler, "UPDATE characters SET "..licenseType.."_license='1' WHERE charactername='"..mysql_escape_string(handler, targetPlayerName).."' LIMIT 1")
						mysql_free_result(query)
						outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
						outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("givelicense", givePlayerLicense)

-- Language commands
function getLanguageByName( language )
	for i = 1, call( getResourceFromName( "language-system" ), "getLanguageCount" ) do
		if language:lower() == call( getResourceFromName( "language-system" ), "getLanguageName", i ):lower() then
			return i
		end
	end
	return false
end

function setLanguage(thePlayer, commandName, targetPlayerName, language, skill)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not language or not tonumber( skill ) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Language] [Skill]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick( targetPlayerName )
			if not targetPlayer then
				outputChatBox( "Player not found or multiple were found.", thePlayer, 255, 0, 0 )		
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				local skill = tonumber( skill )
				if not lang then
					outputChatBox( language .. " is not a valid Language.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					local success, reason = call( getResourceFromName( "language-system" ), "learnLanguage", targetPlayer, lang, false, skill )
					if success then
						outputChatBox( getPlayerName( targetPlayer ) .. " learned " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( getPlayerName( targetPlayer ) .. " couldn't learn " .. langname .. ": " .. tostring( reason ), thePlayer, 255, 0, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler("setlanguage", setLanguage)

function deleteLanguage(thePlayer, commandName, targetPlayerName, language)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not language then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Language]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick( targetPlayerName )
			if not targetPlayer then
				outputChatBox( "Player not found or multiple were found.", thePlayer, 255, 0, 0 )		
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				if not lang then
					outputChatBox( language .. " is not a valid Language.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					if call( getResourceFromName( "language-system" ), "removeLanguage", targetPlayer, lang ) then
						outputChatBox( getPlayerName( targetPlayer ) .. " forgot " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( getPlayerName( targetPlayer ) .. " doesn't speak " .. langname, thePlayer, 255, 0, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler("dellanguage", deleteLanguage)