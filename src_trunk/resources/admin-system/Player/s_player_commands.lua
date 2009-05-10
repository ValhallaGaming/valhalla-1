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
				setElementData(thePlayer, "glue", true)
				setPedWeaponSlot(thePlayer, slot)
				outputChatBox("You are now glued to the " .. getVehicleName(contactElement) .. ".", thePlayer, 255, 194, 14)
			end
		end
	else
		detachElements(thePlayer)
		outputChatBox("You are now unglued!", thePlayer, 255, 194, 14)
		setElementData(thePlayer, "glue", false)
	end
end
addCommandHandler("glue", gluePlayer, false, false)


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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					takeAllWeapons(targetPlayer)
					outputChatBox(targetPlayerName .. " is now disarmed.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					mysql_query(handler, "UPDATE characters SET cked='1' WHERE charactername='" .. targetPlayerName .. "'")
					
					-- send back to change char screen
					local id = getElementData(targetPlayer, "gameaccountid")
					showCursor(targetPlayer, false)
					triggerEvent("sendAccounts", targetPlayer, targetPlayer, id, true)
					setElementData(targetPlayer, "loggedin", 0, true)
					outputChatBox("Your character was CK'ed by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 194, 14)
					outputChatBox("You have CK'ed ".. getPlayerName(targetPlayer) ..".", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local result = mysql_query(handler, "SELECT cked FROM characters WHERE charactername='" .. tostring(targetPlayer) .. "' AND cked='1'")
			
			if (mysql_num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql_num_rows(result)==0) then
				outputChatBox("Player does not exist or is not CK'ed.", thePlayer, 255, 0, 0)
			else
				mysql_query(handler, "UPDATE characters SET cked='0' WHERE charactername='" .. tostring(targetPlayer) .. "' LIMIT 1")
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
			end
			mysql_free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)

-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
function givePlayerGun(thePlayer, commandName, targetPlayer, weapon, ammo)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (weapon) or not (ammo) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID] [Ammo]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				weapon = tonumber(weapon)
				ammo = tonumber(ammo)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					takeWeapon(targetPlayer, weapon)
					local give = giveWeapon(targetPlayer, weapon, ammo, true)
					
					if not (give) then
						outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Player " .. targetPlayerName .. " now has a " .. getWeaponNameFromID(weapon) .. " with " .. ammo .. " Ammo.", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("givegun", givePlayerGun, false, false)

-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, itemValue)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (itemValue) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				itemValue = tonumber(itemValue)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local result = mysql_query(handler, "SELECT item_name FROM items WHERE id='" .. itemID .. "' LIMIT 1")
					
					if (result) then
						if (mysql_num_rows(result)>0) then
							outputChatBox("Player " .. targetPlayerName .. " now has a " .. tostring(mysql_result(result, 1, 1)) .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.global:givePlayerItem(targetPlayer, itemID, itemValue)
						else
							outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
						end
						mysql_free_result(result)
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(skinID))) == "number") then
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
function asetPlayerName(thePlayer, commandName, targetPlayer, newName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (newName) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				
				local result = mysql_query(handler, "SELECT charactername FROM characters WHERE charactername='" .. mysql_escape_string(handler, newName) .. "'")
				
				if (mysql_num_rows(result)>0) then
					outputChatBox("This name is already in use.", thePlayer, 255, 0, 0)
				else
					setElementData(targetPlayer, "legitnamechange", 1)
					local name = setPlayerName(targetPlayer, tostring(newName))
					
					if (name) then
						mysql_query(handler, "UPDATE characters SET charactername='" .. mysql_escape_string(handler, newName) .. "' WHERE charactername='" .. targetPlayerName .. "'")
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
						end
						outputChatBox("You changed " .. targetPlayerName .. "'s Name to " .. tostring(newName) .. ".", thePlayer, 0, 255, 0)
						setElementData(targetPlayer, "legitnamechange", 0)
					else
						outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
					end
					setElementData(targetPlayer, "legitnamechange", 0)
				end
				mysql_free_result(result)
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

-- /HIDEADMIN
function hideAdmin(thePlayer, commandName)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		
		if (hiddenAdmin==0) then
			setElementData(thePlayer, "hiddenadmin", 1)
			outputChatBox("You are now a hidden admin.", thePlayer, 255, 194, 14)
			setPlayerNametagColor(targetPlayer, 255, 255, 255)
		elseif (hiddenAdmin==1) then
			setElementData(thePlayer, "hiddenadmin", 0)
			outputChatBox("You are no longer a hidden admin.", thePlayer, 255, 194, 14)
			setPlayerNametagColor(targetPlayer, 255, 194, 14)
		end
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						setElementData(targetPlayer, "realinvehicle", 0)
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						setElementData(targetPlayer, "realinvehicle", 0)
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
			
			exports.irc:sendMessage("[OOC: Global Cha] Hidden Admin: " .. message)
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
				outputChatBox("Player not found.", thePlayer, 255, 255, 0)
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
				setElementData(thePlayer, "recony", nil)
				setElementData(thePlayer, "reconz", nil)
				setElementData(thePlayer, "reconrot", nil)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				setPlayerNametagShowing(thePlayer, true)
				outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
			end
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					setElementAlpha(thePlayer, 0)
					local x, y, z = getElementPosition(thePlayer)
					local rot = getPedRotation(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local interior = getElementInterior(thePlayer)
					setElementData(thePlayer, "reconx", x)
					setElementData(thePlayer, "recony", y)
					setElementData(thePlayer, "reconz", z)
					setElementData(thePlayer, "reconrot", rot)
					setElementData(thePlayer, "recondimension", dimension)
					setElementData(thePlayer, "reconinterior", interior)
					setPlayerNametagShowing(thePlayer, false)
					
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
					
					if (hiddenAdmin==0) then
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						
						--mysql_query(handler, "UPDATE accounts SET banned='1', banned_reason='" .. reason .. "', banned_by='" .. playerName .. "' WHERE id='" .. accountID .. "'")
					elseif (hiddenAdmin==1) then
						outputChatBox("AdmBan: Hidden Admin banned " .. targetPlayerName .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Reason: " .. reason, getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Time: " .. hours .. ".", getRootElement(), 255, 0, 51)
						
						local ban = banPlayer(targetPlayer, true, false, false, getRootElement(), reason, seconds)
						
						--mysql_query(handler, "UPDATE accounts SET banned='1', banned_reason='" .. reason .. "', banned_by='" .. playerName .. "' WHERE id='" .. accountID .. "'")
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

--function unbanAccount(ipserial, two)
	--mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ipserial .. "'")
--end
--addEventHandler("onUnban", getRootElement(), unbanAccount)


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
									mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
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
					mysql_query(handler, "UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. ip .. "'")
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
					removePedFromVehicle(thePlayer)
					setElementPosition(veh, 1520.0029296875, -1701.2425537109, 16.546875)
					setVehicleRotation(veh, 0, 0, 275.82763671875)
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementPosition(thePlayer, 1520.0029296875, -1701.2425537109, 16.546875)
					setVehicleRotation(thePlayer, 0, 0, 275.82763671875)
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					warpPedIntoVehicle(thePlayer, veh)
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
					removePedFromVehicle(thePlayer)
					setElementPosition(veh, -1689.0689697266, -536.7919921875, 15.854997634888)
					setVehicleRotation(veh, 0, 0, 252.35975646973)
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementPosition(thePlayer, -1689.0689697266, -536.7919921875, 15.854997634888)
					setVehicleRotation(thePlayer, 0, 0, 252.35975646973)
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					warpPedIntoVehicle(thePlayer, veh)
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
					removePedFromVehicle(thePlayer)
					setElementPosition(veh, 1691.6801757813, 1449.1293945313, 12.765375137329)
					setVehicleRotation(veh, 0, 0, 268.20239257813)
					setElementDimension(veh, 0)
					setElementInterior(veh, 0)
					
					setElementPosition(thePlayer, 1691.6801757813, 1449.1293945313, 12.765375137329)
					setVehicleRotation(thePlayer, 0, 0, 268.20239257813)
					setElementDimension(thePlayer, 0)
					setElementInterior(thePlayer, 0)
					setCameraInterior(thePlayer, 0)
					warpPedIntoVehicle(thePlayer, veh)
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
				
				mysql_query(handler, "UPDATE accounts SET admin='" .. tonumber(rank) .. "', hiddenadmin='0' WHERE id='" .. accountID .. "'")
				
				outputChatBox("You set " .. targetPlayerName .. "'s Admin rank to " .. rank .. ".", thePlayer, 0, 255, 0)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				-- Fix for scoreboard & nametags
				local targetAdminTitle = exports.global:getPlayerAdminTitle(targetPlayer)
				if (rank>0) or (rank==-999999999) then
					setElementData(targetPlayer, "adminduty", 1)
					setElementData(targetPlayer, "Rank", tostring(targetAdminTitle))
					setPlayerNametagColor(targetPlayer, 255, 194, 14)
				else
					setElementData(targetPlayer, "Rank", tostring(targetAdminTitle))
					setElementData(targetPlayer, "adminduty", 0)
					setPlayerNametagColor(targetPlayer, 255, 255, 255)
				end
				
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox(adminTitle .. " " .. username .. " set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " set " .. targetPlayerName .. "'s admin level to " .. rank .. ".")
				else
					outputChatBox("Hidden admin set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
				end
			else
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
			local reason = mysql_escape_string(handler, table.concat({...}, " "))
			
			if (targetPlayer) then
				local targetPlayerNick = getPlayerName(targetPlayer)
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "gameaccountid")
				
				if (jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(thePlayer)) then
					removePedFromVehicle(thePlayer)
				end
				
				if (minutes<999) then
					local theTimer = setTimer(timerUnjailPlayer, 60000, minutes, targetPlayer)
					setElementData(targetPlayer, "jailserved", 0)
					setElementData(targetPlayer, "jailtime", minutes)
					setElementData(targetPlayer, "jailtimer", theTimer)
				end
				
				if (minutes>=999) then
					mysql_query(handler, "UPDATE accounts SET adminjail='1', adminjail_time='" .. minutes .. "', adminjail_permanent='1', adminjail_by='" .. playerName .. "', adminjail_reason='" .. reason .. "' WHERE id='" .. accountID .. "'")
					minutes = "Unlimited"
					setElementData(targetPlayer, "jailtimer", true)
				else
					mysql_query(handler, "UPDATE accounts SET adminjail='1', adminjail_time='" .. minutes .. "', adminjail_permanent='0', adminjail_by='" .. playerName .. "', adminjail_reason='" .. reason .. "' WHERE id='" .. tonumber(accountID) .. "'")
				end
				
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
			else
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
			setElementData(jailedPlayer, "jailserved", timeServed+1)
			local timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft)
		
			if (timeLeft==0) then
				mysql_query(handler, "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. accountID .. "'")
				setElementData(jailedPlayer, "jailtimer", nil)
				setElementPosition(jailedPlayer, 1694.5098876953, 1449.6469726563, 10.763301849365)
				setPedRotation(jailedPlayer, 274.48666381836)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				outputChatBox("Your time has been served, Behave next time!", jailedPlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmJail: " .. getPlayerName(jailedPlayer) .. " has served his jail time.")
				exports.irc:sendMessage("[ADMIN] " .. getPlayerName(jailedPlayer) .. " was unjailed by script (Time Served)")
			else
				mysql_query(handler, "UPDATE accounts SET adminjail_time='" .. timeLeft .. "' WHERE id='" .. accountID .. "'")
			end
		end
	else
		local theTimer = getElementData(jailedPlayer, "jailtimer")
		killTimer(theTimer)
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
					mysql_query(handler, "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. accountID .. "'")
					killTimer(jailed)
					setElementData(targetPlayer, "jailtimer", nil)
					setElementPosition(targetPlayer, 1694.5098876953, 1449.6469726563, 10.763301849365)
					setPedRotation(targetPlayer, 274.48666381836)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
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

----------------------------[GO TO PLAYER]---------------------------------------
function gotoPlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
	
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						setElementPosition(thePlayer, x, y, z)
                        setElementInterior(thePlayer, interior)
                        setElementDimension(thePlayer, dimension)
                        setElementInterior(veh, interior)
                        setElementDimension(veh, dimension)
                        setElementPosition(veh, x, y, z)
                        warpPedIntoVehicle ( thePlayer, veh ) 
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						setElementPosition(veh, x, y, z)
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
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				
				exports.global:setPlayerSafeMoney(targetPlayer, money)
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				
				exports.global:givePlayerSafeMoney(targetPlayer, money)
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
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
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
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
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
			local username = getPlayerName(thePlayer)
			local targetPlayer = exports.global:findPlayerByPartialNick(target)
			local targetPlayerName = getPlayerName(targetPlayer)
			
			local veh = getPedOccupiedVehicle( targetPlayer )
            if (veh) then
                setVehicleFrozen(veh, false)
				toggleAllControls(targetPlayer, true, true, true)
				outputChatBox(" You have been unfrozen by an admin. Thanks for your co-operation.", targetPlayer)
				outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
			else	
				toggleAllControls(targetPlayer, true, true, true)
				setPedWeaponSlot(targetPlayer, 0)

				-- Disable weapon scrolling
				toggleControl(targetPlayer, "next_weapon", false)
				toggleControl(targetPlayer, "previous_weapon", false)
				setElementData(targetPlayer, "freeze", 1)
				outputChatBox(" You have been unfrozen by an admin. Thanks for your co-operation.", targetPlayer)
				outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
			end
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
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
			
			setElementData(thePlayer, "tempMark.x", x)
			setElementData(thePlayer, "tempMark.y", y)
			setElementData(thePlayer, "tempMark.z", z)
			setElementData(thePlayer, "tempMark.interior", interior)
			setElementData(thePlayer, "tempMark.dimension", dimension)
						
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
						setElementPosition(thePlayer, tonumber(getElementData(thePlayer, "tempMark.x")),tonumber(getElementData(thePlayer, "tempMark.y")),tonumber(getElementData(thePlayer, "tempMark.z")))
						setElementInterior(thePlayer, getElementData(thePlayer, "tempMark.interior"))
						setElementDimension(thePlayer, getElementData(thePlayer, "tempMark.dimension"))
					elseif(vehicle and seat == 0) then
						removePedFromVehicle (thePlayer )
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
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
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
						mysql_query(handler, "UPDATE accounts SET donator='0' WHERE id='" .. gameaccountID .. "'")
						levelString = "Non-Donator"
					elseif (level==1) then
						setElementData(targetPlayer, "donatorlevel", 1)
						mysql_query(handler, "UPDATE accounts SET donator='1' WHERE id='" .. gameaccountID .. "'")
						levelString = "Bronze Donator"
					elseif (level==2) then
						setElementData(targetPlayer, "donatorlevel", 2)
						mysql_query(handler, "UPDATE accounts SET donator='2' WHERE id='" .. gameaccountID .. "'")
						levelString = "Silver Donator"
					elseif (level==3) then
						setElementData(targetPlayer, "donatorlevel", 3)
						mysql_query(handler, "UPDATE accounts SET donator='3' WHERE id='" .. gameaccountID .. "'")
						levelString = "Gold Donator"
					elseif (level==4) then
						setElementData(targetPlayer, "donatorlevel", 4)
						mysql_query(handler, "UPDATE accounts SET donator='4' WHERE id='" .. gameaccountID .. "'")
						levelString = "Platinum Donator"
					elseif (level==5) then
						setElementData(targetPlayer, "donatorlevel", 5)
						mysql_query(handler, "UPDATE accounts SET donator='5' WHERE id='" .. gameaccountID .. "'")
						levelString = "Pearl Donator"
					elseif (level==6) then
						setElementData(targetPlayer, "donatorlevel", 6)
						mysql_query(handler, "UPDATE accounts SET donator='6' WHERE id='" .. gameaccountID .. "'")
						levelString = "Diamond Donator"
					elseif (level==7) then
						setElementData(targetPlayer, "donatorlevel", 7)
						mysql_query(handler, "UPDATE accounts SET donator='7' WHERE id='" .. gameaccountID .. "'")
						levelString = "Godly Donator"
					end
					
					if (level>0) then
						exports.global:givePlayerAchievement(targetPlayer, 29)
					end
					outputChatBox("You set " .. targetPlayerName .. " as a " .. levelString .. ".", targetPlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmCmd: " .. username .. " set " .. targetPlayerName .. " as a " .. levelString .. ".")
					exports.irc:sendMessage("[ADMIN] " .. username .. " set " .. targetPlayerName .. " as a " .. levelString .. ".")
				end
			end
		end
	end
end
addCommandHandler("makedonator", makePlayerDonator, false, false)

function adminDuty(thePlayer, commandName)
	local adminlevel = getElementData(thePlayer, "adminlevel")
	
	if (adminlevel>0) then
		local adminduty = getElementData(thePlayer, "adminduty")
		
		local username = getPlayerName(thePlayer)
		
		if (adminduty==0) then
			setElementData(thePlayer, "adminduty", 1)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayeR)
			
			setPlayerNametagColor(thePlayer, 255, 194, 14)
			outputChatBox("You went on admin duty.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " came on duty.")
		elseif (adminduty==1) then
			setElementData(thePlayer, "adminduty", 0)
			
			setPlayerNametagColor(thePlayer, 255, 255, 255)
			outputChatBox("You went off admin duty.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " went off duty.")
		end
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