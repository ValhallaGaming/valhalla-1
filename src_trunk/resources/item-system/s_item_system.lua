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

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "i", "down", showInventory)) then
			bindKey(arrayPlayer, "i", "down", showInventory)
			setElementData(arrayPlayer, "inventory", 0)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "i", "down", showInventory)
	setElementData(source, "inventory", 0)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showInventory(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local inventory = getElementData(thePlayer, "inventory")
		
		if (inventory==0) then
			setElementData(thePlayer, "inventory", 1)
			local items = getElementData(thePlayer, "items")
			local itemvalues = getElementData(thePlayer, "itemvalues")
			
			local tableitems = { }
			
			if (items) then
				for i = 1, 10 do
					local token = gettok(items, i, string.byte(','))
					
					if (token) then
						local result = mysql_query(handler, "SELECT item_name, item_description FROM items WHERE id='" .. token .. "' LIMIT 1")
						
						if (result) then
							if (mysql_num_rows(result)>0) then
								tableitems[i] = { }
								tableitems[i][1] = mysql_result(result, 1, 1)
								tableitems[i][2] = mysql_result(result, 1, 2)
								tableitems[i][3] = token
								tableitems[i][4] = gettok(itemvalues, i, string.byte(','))
							end
							mysql_free_result(result)
						end
					end
				end
			end
			
			triggerClientEvent(thePlayer, "showInventory", thePlayer, tableitems)
		else
			triggerClientEvent(thePlayer, "hideInventory", thePlayer)
			setElementData(thePlayer, "inventory", 0)
		end
	end
end

function removeAnimation(player)
	exports.global:removeAnimation(player)
end

-- callbacks
function useItem(itemID, itemName, itemValue, isWeapon, groundz)
	if not (isWeapon) then
		if (itemID==1) then -- haggis
			setElementHealth(source, 100)
			exports.global:sendLocalMeAction(source, "eats a plump haggis.")
            exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==2) then -- cellphone
			outputChatBox("Use /call to use this item.", source, 255, 194, 14)
		elseif (itemID==3) then -- car key
			-- unlock nearby cars
			local found, id = nil
			for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
				local dbid = getElementData(value, "dbid")
				local vx, vy, vz = getElementPosition(value)
				local x, y, z = getElementPosition(source)
				
				if (dbid==itemValue) and (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)<=50) then -- car found
					found = value
					id = key
					break
				end
			end
			
			if not (found) then
				outputChatBox("You are too far from the vehicle.", source, 255, 194, 14)
			else
				local locked = getElementData(found, "locked")
				
				if (isVehicleLocked(found)) then
					setVehicleLocked(found, false)
					mysql_query(handler, "UPDATE vehicles SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "presses on the key to unlock the vehicle. ((" .. getVehicleName(found) .. "))")
				else
					setVehicleLocked(found, true)
					mysql_query(handler, "UPDATE vehicles SET locked='1' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "presses on the key to lock the vehicle. ((" .. getVehicleName(found) .. "))")
				end
			end
		elseif (itemID==4) or (itemID==5) then -- house key or business key
			local found, id = nil
			for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData(value, "dbid")
				local vx, vy, vz = getElementPosition(value)
				local x, y, z = getElementPosition(source)
				
				if (dbid==itemValue) and (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)<=5) then -- house found
					found = value
					id = dbid
					break
				end
			end
			
			if not (found) then
				outputChatBox("You are too far from the door.", source, 255, 194, 14)
			else
				local locked = getElementData(found, "locked")
				
				if (locked==1) then
					setElementData(found, "locked", 0)
					mysql_query(handler, "UPDATE interiors SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 0)
						end
					end
				else
					setElementData(found, "locked", 1)
					mysql_query(handler, "UPDATE interiors SET locked='1' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 1)
						end
					end
				end
			end
		elseif (itemID==6) then -- radio
			outputChatBox("Press Y to use this item. You can also use /tuneradio to tune your radio.", source, 255, 194, 14)
		elseif (itemID==7) then -- phonebook
			outputChatBox("Use /phonebook to use this item.", source, 255, 194, 14)
		elseif (itemID==8) then -- sandwich
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+50)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a sandwich.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==9) then -- sprunk
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " drinks a sprunk.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==10) then -- red dice
			local output = math.random(1, 6)
			exports.global:sendLocalMeAction(source, "rolls a dice and gets " .. output .. ".")
		elseif (itemID==11) then -- taco
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a taco.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==12) then -- cheeseburger
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a cheeseburger.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==13) then -- donut
			showInventory(source)
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a donut.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==14) then -- cookie
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+80)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a cookie.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==15) then -- water
			showInventory(source)
			local health = getElementHealth(source)
			setElementHealth(source, health+90)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " drinks a bottle of water.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
		elseif (itemID==16) then -- clothes
			setPedSkin(source, tonumber(itemValue))
			setElementData(source, "casualskin", tonumber(itemValue))
		elseif (itemID==17) then -- watch
			local time = getTime()
			local hours = time.hour
			local mins = time.minute
			exports.global:sendLocalMeAction(source, " looks at their watch.")
			outputChatBox("The time is " .. hours .. ":" .. mins .. ".", source, 255, 194, 14)
			exports.global:applyAnimation(source, "COP_AMBIENT", "Coplook_watch", true, 1.0, false, false)
			setTimer(removeAnimation, 4000, 1, source)
		elseif (itemID==18) then -- city guide
			triggerClientEvent(source, "showCityGuide", source)
		elseif (itemID==19) then -- MP3 PLayer
			outputChatBox("Use the - and = keys to use the MP3 Player.", source, 255, 194, 14)
		elseif (itemID==20) then -- STANDARD FIGHTING
			setPedFightingStyle(source, 4)
			outputChatBox("You read a book on how to do Standard Fighting.", source, 255, 194, 14)
		elseif (itemID==21) then -- BOXING
			setPedFightingStyle(source, 5)
			outputChatBox("You read a book on how to do Boxing.", source, 255, 194, 14)
		elseif (itemID==22) then -- KUNG FU
			setPedFightingStyle(source, 6)
			outputChatBox("You read a book on how to do Kung Fu.", source, 255, 194, 14)
		elseif (itemID==23) then -- KNEE HEAD
			setPedFightingStyle(source, 7)
			outputChatBox("You read a book on how to do Knee Head Fighting.", source, 255, 194, 14)
		elseif (itemID==24) then -- GRAB KICK
			setPedFightingStyle(source, 15)
			outputChatBox("You read a book on how to do Grab Kick Fighting.", source, 255, 194, 14)
		elseif (itemID==25) then -- ELBOWS
			setPedFightingStyle(source, 16)
			outputChatBox("You read a book on how to do Elbow Fighting.", source, 255, 194, 14)
		elseif (itemID==26) then -- GASMASK
			local gasmask = getElementData(source, "gasmask")
			
			if not (gasmask) or (gasmask==0) then
				exports.global:sendLocalMeAction(source, "slips a black gas mask over their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local fixedName = "(" .. tostring(pid) .. ") Unknown_Person"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "gasmask", 1)
			elseif (gasmask==1) then
				exports.global:sendLocalMeAction(source, "slips a black gas mask off their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = getPlayerName(source)
				local fixedName = "(" .. tostring(pid) .. ") " .. name
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "gasmask", 0)
			end
		elseif (itemID==27) then -- FLASHBANG
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
			local x, y, z = getElementPosition(source)
			local rot = getPedRotation(source)
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = groundz
			local obj = createObject(343, x, y, z)
			exports.pool:allocateElement(obj)
			setTimer(explodeFlash, math.random(500, 600), 1, obj, x, y, z)
			exports.global:sendLocalMeAction(source, "throws a flashbang.")
		elseif (itemID==28) then -- GLOWSTICK
			exports.global:takePlayerItem(source, itemID, itemValue)
			showInventory(source)
			local x, y, z = getElementPosition(source)
			local rot = getPedRotation(source)
			local x = x + math.sin(math.rad(-rot)) * 1
			local y = y + math.cos(math.rad(-rot)) * 1
			local marker = createMarker(x, y, groundz, "corona", 1, 0, 255, 0, 150)
			exports.pool:allocateElement(marker)
			exports.global:sendLocalMeAction(source, "drops a glowstick.")
			setTimer(destroyElement, 600000, 1, marker)
		elseif (itemID==29) then -- RAM
			local found, id = nil
			local distance = 99999
			for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData(value, "dbid")
				local vx, vy, vz = getElementPosition(value)
				local x, y, z = getElementPosition(source)
				
				local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
				if (dist<=5) then -- house found
					if (dist<distance) then
						found = value
						id = dbid
						distance = dist
					end
				end
			end
			
			if not (found) then
				outputChatBox("You are not need a door.", source, 255, 194, 14)
			else
				local locked = getElementData(found, "locked")
				
				if (locked==1) then
					setElementData(found, "locked", 0)
					mysql_query(handler, "UPDATE interiors SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "swings the ram into the door, opening it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 0)
						end
					end
				else
					outputChatBox("That door is not locked.", source, 255, 0, 0)
				end
			end
		else
			outputChatBox("Error 800001 - Report on http://bugs.valhallagaming.net", source, 255, 0, 0)
		end
	else
		setPedWeaponSlot(source, tonumber(itemID))
	end
end
addEvent("useItem", true)
addEventHandler("useItem", getRootElement(), useItem)

function explodeFlash(obj, x, y, z)
	local colsphere = createColSphere(x, y, z, 7)
	exports.pool:allocateElement(colsphere)
	local players = getElementsWithinColShape(colsphere, "player")
	
	destroyElement(obj)
	destroyElement(colsphere)
	for key, value in ipairs(players) do
		local gasmask = getElementData(value, "gasmask")
		
		if (not gasmask) or (gasmask==0) then
			playSoundFrontEnd(value, 47)
			fadeCamera(value, false, 0.5, 255, 255, 255)
			setTimer(cancelEffect, 5000, 1, value)
			setTimer(playSoundFrontEnd, 1000, 1, value, 48)
		end
	end
end

function cancelEffect(thePlayer)
	fadeCamera(thePlayer, true, 6.0)
end

tags = {1524, 1525, 1526, 1527, 1528, 1529, 1530, 1531 }

function destroyGlowStick(marker)
	destroyElement(marker)
end

function destroyItem(itemID, itemValue, itemName, isWeapon)
	outputChatBox("You destroyed a " .. itemName .. ".", source, 255, 194, 14)
	if not (isWeapon) then
		exports.global:takePlayerItem(source, tonumber(itemID), tonumber(itemValue))
		
		if (tonumber(itemID)==16) then
			setPedSkin(source, 0)
		end
	else
		if (itemID==nil) then
			setPedArmor(source, 0)
		else
			takeWeapon(source, tonumber(itemID))
		end
	end
end
addEvent("destroyItem", true)
addEventHandler("destroyItem", getRootElement(), destroyItem)

weaponmodels = { [1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341, [15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352, [29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360, [37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366, [43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371, [40]=364, [100]=373 }

function dropItem(itemID, itemValue, itemName, x, y, z, gz, isWeapon)
	if not (isWeapon) then
		local removed = exports.global:takePlayerItem(source, tonumber(itemID), tonumber(itemValue))
		outputChatBox("You dropped a " .. itemName .. ".", source, 255, 194, 14)
		
		-- Animation
		exports.global:applyAnimation(source, "CARRY", "putdwn", true, 1.0, false, false)
		setTimer(removeAnimation, 1500, 1, source)
	
		local objectresult = mysql_query(handler, "SELECT modelid FROM items WHERE id='" .. tonumber(itemID) .. "' LIMIT 1")
		local modelid = tonumber(mysql_result(objectresult, 1, 1))
		mysql_free_result(objectresult)
		
		local obj = createObject(modelid, x, y, z)
		exports.pool:allocateElement(obj)
		
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		setElementInterior(obj, interior)
		setElementDimension(obj, dimension)
		
		moveObject(obj, 200, x, y, gz+0.3)
		
		local time = getRealTime()
		local yearday = time.yearday
		
		mysql_query(handler, "INSERT INTO worlditems SET itemid='" .. itemID .. "', itemvalue='" .. itemValue .. "', itemname='" .. itemName .. "', yearday='" .. yearday .. "', x='" .. x .. "', y='" .. y .. "', z='" .. gz+0.3 .. "', dimension='" .. dimension .. "', interior='" .. interior .. "'")
		local id = mysql_insert_id(handler)
		setElementData(obj, "id", id)
		setElementData(obj, "itemID", itemID)
		setElementData(obj, "itemValue", itemValue)
		setElementData(obj, "itemName", itemName)
		setElementData(obj, "type", "worlditem")
		
		if (tonumber(itemID)==16) then
			setPedSkin(source, 0)
		end
	else
		outputChatBox("You dropped a " .. itemName .. ".", source, 255, 194, 14)
		
		if (itemID==nil) then
			itemID = 100
			gz = gz + 0.5
			setPedArmor(source, 0)
		end
		
		takeWeapon(source, tonumber(itemID))
		
		local modelid = 2969
		-- MODEL ID
		if (itemID==100) then
			modelid = 1242
		elseif (itemID==42) then
			modelid = 2690
		else
			modelid = 2969
		end
		
		local obj = createObject(modelid, x, y, z, 0, 0, 0)
		exports.pool:allocateElement(obj)
		
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		setElementInterior(obj, interior)
		setElementDimension(obj, dimension)
		
		moveObject(obj, 200, x, y, gz+0.1)
		
		local time = getRealTime()
		local yearday = time.yearday
		
		
		mysql_query(handler, "INSERT INTO worlditems SET itemid='" .. itemID .. "', itemvalue='" .. itemValue .. "', itemname='" .. itemName .. "', yearday='" .. yearday .. "', x='" .. x .. "', y='" .. y .. "', z='" .. gz+0.1 .. "', dimension='" .. dimension .. "', interior='" .. interior .. "'")
		local id = mysql_insert_id(handler)
		setElementData(obj, "id", id)
		setElementData(obj, "itemID", itemID)
		setElementData(obj, "itemValue", itemValue)
		setElementData(obj, "itemName", itemName)
		setElementData(obj, "type", "worlditem")
	end
end
addEvent("dropItem", true)
addEventHandler("dropItem", getRootElement(), dropItem)

function loadWorldItems(res)
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT id, itemid, itemvalue, itemname, yearday, x, y, z, dimension, interior FROM worlditems")
		for result, row in mysql_rows(result) do
			local wyearday = tonumber(row[5])
			local time = getRealTime()
			local yearday = time.yearday
			
			if (yearday>(wyearday+30)) then
				mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. tonumber(row[1]) .. "' LIMIT 1")
			elseif (wyearday>yearday) then -- a new year
				mysql_query(handler, "UPDATE worlditems SET yearday='" .. yearday .. "' WHERE id='" .. tonumber(row[1]) .. "' LIMIT 1")
				
				local x = tonumber(row[6])
				local y = tonumber(row[7])
				local z = tonumber(row[8])
				
				local interior = tonumber(row[9])
				local dimension = tonumber(row[10])
				
				if (tostring(row[4])==getWeaponNameFromID(tonumber(row[2])) or tostring(row[4])=="Body Armor") then
					local modelid = 2969
					-- MODEL ID
					if (tonumber(row[2])==100) then
						modelid = 1242
					elseif (tonumber(row[2])==42) then
						modelid = 2690
					else
						modelid = 2969
					end
				
					local obj = createObject(modelid, x, y, z)
					exports.pool:allocateElement(obj)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				else
					local objectresult = mysql_query(handler, "SELECT modelid FROM items WHERE id='" .. tonumber(row[2]) .. "' LIMIT 1")
					local modelid = tonumber(mysql_result(objectresult, 1, 1))
					mysql_free_result(objectresult)
					
					local obj = createObject(modelid, x, y, z)
					exports.pool:allocateElement(obj)
					setElementDimension(obj, dimension)
					setElementInterior(obj, interior)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				end
			else
				local x = tonumber(row[6])
				local y = tonumber(row[7])
				local z = tonumber(row[8])
				
				if (tostring(row[4])==getWeaponNameFromID(tonumber(row[2]))  or tostring(row[4])=="Body Armor") then
					local modelid = 2969
					-- MODEL ID
					if (tonumber(row[2])==100) then
						modelid = 1242
					elseif (tonumber(row[2])==42) then
						modelid = 2690
					else
						modelid = 2969
					end
				
					local obj = createObject(modelid, x, y, z, 0, 0, 0)
					exports.pool:allocateElement(obj)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				else
					local objectresult = mysql_query(handler, "SELECT modelid FROM items WHERE id='" .. tonumber(row[2]) .. "' LIMIT 1")
					local modelid = tonumber(mysql_result(objectresult, 1, 1))
					mysql_free_result(objectresult)
					
					local obj = createObject(modelid, x, y, z, 270, 0, 0)
					exports.pool:allocateElement(obj)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				end
			end
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. tonumber(mysql_num_rows(result)) .. " world items.")
		mysql_free_result(result)
	end
end
addEventHandler("onResourceStart", getRootElement(), loadWorldItems)

function showItem(itemName)
	exports.global:sendLocalMeAction(source, "shows everyone a " .. itemName .. ".")
end
addEvent("showItem", true)
addEventHandler("showItem", getRootElement(), showItem)

function pickupItem(object, id, itemID, itemValue, itemName)
	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)

	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<3) then	
		outputChatBox("You picked up a " .. itemName .. ".", source, 255, 194, 14)
		
		-- Animation
		exports.global:applyAnimation(source, "CARRY", "liftup", true, 1.0, false, false)
		setTimer(resetAnim, 4000, 1, source)
		
		exports.global:sendLocalMeAction(source, "bends over and picks up a " .. itemName .. ".")
		destroyElement(object)
		
		if (tostring(itemName)~=getWeaponNameFromID(tonumber(itemID)) and tostring(itemName)~="Body Armor") then
			mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. tonumber(id) .. "'")
			exports.global:givePlayerItem(source, tonumber(itemID), tonumber(itemValue))
		elseif (tostring(itemName)==getWeaponNameFromID(tonumber(itemID))) then
			mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. tonumber(id) .. "'")
			giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
		elseif (tostring(itemName)=="Body Armor") then
			mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. tonumber(id) .. "'")
			setPedArmor(source, tonumber(itemValue))
		end
	end
end
addEvent("pickupItem", true)
addEventHandler("pickupItem", getRootElement(), pickupItem)