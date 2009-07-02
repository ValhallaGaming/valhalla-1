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
			
			local health = getElementHealth(source)
			setElementHealth(source, health+50)
			exports.global:applyAnimation(source, "food", "eat_burger", -1, false, true, true)
			toggleAllControls(source, true, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a sandwich.")
			exports.global:takePlayerItem(source, itemID, itemValue)
		elseif (itemID==9) then -- sprunk
			
			local health = getElementHealth(source)
			setElementHealth(source, health+30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", -1, false, true, true)
			toggleAllControls(source, true, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " drinks a sprunk.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==10) then -- red dice
			local output = math.random(1, 6)
			exports.global:sendLocalMeAction(source, "rolls a dice and gets " .. output .. ".")
		elseif (itemID==11) then -- taco
			
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a taco.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==12) then -- cheeseburger
			
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a cheeseburger.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==13) then -- donut
			
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a donut.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==14) then -- cookie
			
			local health = getElementHealth(source)
			setElementHealth(source, health+80)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " eats a cookie.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==15) then -- water
			
			local health = getElementHealth(source)
			setElementHealth(source, health+90)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, " drinks a bottle of water.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==16) then -- clothes
			setPedSkin(source, tonumber(itemValue))
			setElementData(source, "casualskin", tonumber(itemValue))
		elseif (itemID==17) then -- watch
			local realtime = getRealTime()
			local hour = realtime.hour
			local mins = realtime.minute

			hour = hour + 8
			if (hour==24) then
				hour = 0
			elseif (hour>24) then
				hour = hour - 24
			end
			
			exports.global:sendLocalMeAction(source, " looks at their watch.")
			outputChatBox("The time is " .. hour .. ":" .. mins .. ".", source, 255, 194, 14)
			exports.global:applyAnimation(source, "COP_AMBIENT", "Coplook_watch", -1, false, true, true)
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
		elseif (itemID==30) then
			outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", source, 255, 0, 0)
		elseif (itemID==31) then
			outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", source, 255, 0, 0)
		elseif (itemID==32) then
			outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", source, 255, 0, 0)
		elseif (itemID==33) then
			outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", source, 255, 0, 0)
		elseif (itemID>=34 and itemID<=44) then -- DRUGS
			exports.global:takePlayerItem(source, itemID, -1)
			exports.global:sendLocalMeAction(source, "takes some " .. itemName .. ".")
		elseif (itemID==45) or (itemID==46) or (itemID==47) then
			outputChatBox("Right click a player to use this item.", source, 255, 0, 0)
		elseif (itemID==48) then
			outputChatBox("Your inventory is extended.", source, 0, 255, 0)
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

function destroyItem(itemID, itemValue, itemName, isWeapon, items, values)
	if (itemID==48) then -- backpack
		for i = 1, 10 do
			if (items[i]~=nil) then
				local id = items[i]
				local value = values[i]
				exports.global:takePlayerItem(source, id, value)
			end
		end
	end

	outputChatBox("You destroyed a " .. itemName .. ".", source, 255, 194, 14)
	exports.global:sendLocalMeAction(source, "destroyed a " .. itemName .. ".")
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

function dropItem(itemID, itemValue, itemName, x, y, z, gz, isWeapon, items, itemvalues)
	if not (isWeapon) then
		local removed = exports.global:takePlayerItem(source, tonumber(itemID), tonumber(itemValue))
		
		if (not forced) then
			outputChatBox("You dropped a " .. itemName .. ".", source, 255, 194, 14)
			
			-- Animation
			exports.global:applyAnimation(source, "CARRY", "putdwn", -1, false, false, true)
			setTimer(removeAnimation, 500, 1, source)
		end
	
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
		
		local stringitems = ""
		local stringvalues = ""
		if (tonumber(itemID)==48) then -- BACKPACK, lets drop the items inside the bag
			for i = 1, 10 do
				if (items[i]~=nil) then
					if (exports.global:doesPlayerHaveItem(source, tonumber(items[i]), tonumber(itemvalues[i]))) then
						exports.global:takePlayerItem(source, tonumber(items[i]), tonumber(itemvalues[i]))
						stringitems = stringitems .. items[i] .. ","
						stringvalues = stringvalues .. itemvalues[i] .. ","
					end
				end
			end
		end
		
		local insert = mysql_query(handler, "INSERT INTO worlditems SET itemid='" .. itemID .. "', itemvalue='" .. itemValue .. "', itemname='" .. itemName .. "', yearday='" .. yearday .. "', x='" .. x .. "', y='" .. y .. "', z='" .. gz+0.3 .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', items='" .. stringitems .. "', itemvalues='" .. stringvalues .. "'")
		local id = mysql_insert_id(handler)
		setElementData(obj, "id", id)
		setElementData(obj, "itemID", itemID)
		setElementData(obj, "itemValue", itemValue)
		setElementData(obj, "itemName", itemName)
		setElementData(obj, "type", "worlditem")
		setElementData(obj, "items", stringitems)
		setElementData(obj, "itemvalues", stringvalues)
		
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
		local result = mysql_query(handler, "SELECT id, itemid, itemvalue, itemname, yearday, x, y, z, dimension, interior, items, itemvalues FROM worlditems")
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
					setElementDimension(obj, dimension)
					setElementInterior(obj, interior)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				else
					local objectresult = mysql_query(handler, "SELECT modelid FROM items WHERE id='" .. tonumber(row[2]) .. "' LIMIT 1")
					local modelid = tonumber(mysql_result(objectresult, 1, 1))
					local items = tostring(row[11])
					local itemvalues = tostring(row[12])
					outputDebugString(tostring(items))
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
					
					if (tonumber(row[2])==48) then -- BACKPACK
						setElementData(obj, "items", items)
						setElementData(obj, "itemvalues", itemvalues)
					end
				end
			else
				local interior = tonumber(row[10])
				local dimension = tonumber(row[9])
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
					setElementDimension(obj, dimension)
					setElementInterior(obj, interior)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
				else
					local objectresult = mysql_query(handler, "SELECT modelid FROM items WHERE id='" .. tonumber(row[2]) .. "' LIMIT 1")
					local modelid = tonumber(mysql_result(objectresult, 1, 1))
					local items = tostring(row[11])
					local itemvalues = tostring(row[12])
					mysql_free_result(objectresult)
					
					local obj = createObject(modelid, x, y, z, 270, 0, 0)
					exports.pool:allocateElement(obj)
					setElementDimension(obj, dimension)
					setElementInterior(obj, interior)
					setElementData(obj, "id", tonumber(row[1]))
					setElementData(obj, "itemID", tonumber(row[2]))
					setElementData(obj, "itemValue", tonumber(row[3]))
					setElementData(obj, "itemName", tostring(row[4]))
					setElementData(obj, "type", "worlditem")
					
					if (tonumber(row[2])==48) then -- BACKPACK
						setElementData(obj, "items", items)
						setElementData(obj, "itemvalues", itemvalues)
					end
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

function resetAnim(thePlayer)
	exports.global:removeAnimation(thePlayer)
end

function pickupItem(object, id, itemID, itemValue, itemName)
	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)

	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<3) then	
		outputChatBox("You picked up a " .. itemName .. ".", source, 255, 194, 14)
		
		-- Animation
		exports.global:applyAnimation(source, "CARRY", "liftup", -1, false, true, true)
		setTimer(resetAnim, 2000, 1, source)
		
		exports.global:sendLocalMeAction(source, "bends over and picks up a " .. itemName .. ".")
		local items = getElementData(object, "items")
		local itemvalues = getElementData(object, "itemvalues")
		destroyElement(object)

		if (tostring(itemName)~=getWeaponNameFromID(tonumber(itemID)) and tostring(itemName)~="Body Armor") then
			mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. tonumber(id) .. "'")
			exports.global:givePlayerItem(source, tonumber(itemID), tonumber(itemValue))
			
			if (tonumber(itemID)==48) then -- BACKPACK, give the items inside it
				for i=1, 20 do
					if not (items) or not (itemvalues) then -- no items
						return false
					else
						local token = tonumber(gettok(items, i, string.byte(',')))
						if (token) then
							local itemValue = tonumber(gettok(itemvalues, i, string.byte(',')))
							exports.global:givePlayerItem(source, token, itemValue)
						end
					end
				end
			end
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