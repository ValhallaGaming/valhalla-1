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

blackMales = {[0] = true, [7] = true, [14] = true, [15] = true, [16] = true, [17] = true, [18] = true, [20] = true, [21] = true, [22] = true, [24] = true, [25] = true, [28] = true, [35] = true, [36] = true, [50] = true, [51] = true, [66] = true, [67] = true, [78] = true, [79] = true, [80] = true, [83] = true, [84] = true, [102] = true, [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [134] = true, [136] = true, [142] = true, [143] = true, [144] = true, [156] = true, [163] = true, [166] = true, [168] = true, [176] = true, [180] = true, [182] = true, [183] = true, [185] = true, [220] = true, [221] = true, [222] = true, [249] = true, [253] = true, [260] = true, [262] = true }
whiteMales = {[23] = true, [26] = true, [27] = true, [29] = true, [30] = true, [32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [37] = true, [38] = true, [43] = true, [44] = true, [45] = true, [46] = true, [47] = true, [48] = true, [50] = true, [51] = true, [52] = true, [53] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [68] = true, [70] = true, [72] = true, [73] = true, [78] = true, [81] = true, [82] = true, [94] = true, [95] = true, [96] = true, [97] = true, [98] = true, [99] = true, [100] = true, [101] = true, [108] = true, [109] = true, [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, [116] = true, [120] = true, [121] = true, [122] = true, [124] = true, [127] = true, [128] = true, [132] = true, [133] = true, [135] = true, [137] = true, [146] = true, [147] = true, [153] = true, [154] = true, [155] = true, [158] = true, [159] = true, [160] = true, [161] = true, [162] = true, [164] = true, [165] = true, [170] = true, [171] = true, [173] = true, [174] = true, [175] = true, [177] = true, [179] = true, [181] = true, [184] = true, [186] = true, [187] = true, [188] = true, [189] = true, [200] = true, [202] = true, [204] = true, [206] = true, [209] = true, [212] = true, [213] = true, [217] = true, [223] = true, [230] = true, [234] = true, [235] = true, [236] = true, [240] = true, [241] = true, [242] = true, [247] = true, [248] = true, [250] = true, [252] = true, [254] = true, [255] = true, [258] = true, [259] = true, [261] = true, [264] = true }
asianMales = {[49] = true, [57] = true, [58] = true, [59] = true, [60] = true, [117] = true, [118] = true, [120] = true, [121] = true, [122] = true, [123] = true, [170] = true, [186] = true, [187] = true, [203] = true, [210] = true, [227] = true, [228] = true, [229] = true}
blackFemales = {[9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [40] = true, [41] = true, [63] = true, [64] = true, [69] = true, [76] = true, [91] = true, [139] = true, [148] = true, [190] = true, [195] = true, [207] = true, [215] = true, [218] = true, [219] = true, [238] = true, [243] = true, [244] = true, [245] = true, [256] = true }
whiteFemales = {[12] = true, [31] = true, [38] = true, [39] = true, [40] = true, [41] = true, [53] = true, [54] = true, [55] = true, [56] = true, [64] = true, [75] = true, [77] = true, [85] = true, [86] = true, [87] = true, [88] = true, [89] = true, [90] = true, [91] = true, [92] = true, [93] = true, [129] = true, [130] = true, [131] = true, [138] = true, [140] = true, [145] = true, [150] = true, [151] = true, [152] = true, [157] = true, [172] = true, [178] = true, [192] = true, [193] = true, [194] = true, [196] = true, [197] = true, [198] = true, [199] = true, [201] = true, [205] = true, [211] = true, [214] = true, [216] = true, [224] = true, [225] = true, [226] = true, [231] = true, [232] = true, [233] = true, [237] = true, [243] = true, [246] = true, [251] = true, [257] = true, [263] = true }
asianFemales = {[38] = true, [53] = true, [54] = true, [55] = true, [56] = true, [88] = true, [141] = true, [169] = true, [178] = true, [224] = true, [225] = true, [226] = true, [263] = true}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}

function removeAnimation(player)
	exports.global:removeAnimation(player)
end

-- callbacks
function useItem(itemID, itemName, itemValue, isWeapon, groundz)
	if isPedDead(source) then return end
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
					id = tonumber(getElementData(value, "dbid"))
					break
				end
			end
			
			if not (found) then
				outputChatBox("You are too far from the vehicle.", source, 255, 194, 14)
			else
				local locked = getElementData(found, "locked")
				
				exports.global:applyAnimation(source, "GHANDS", "gsign3LH", -1, false, false, false)
				
				if (isVehicleLocked(found)) then
					outputChatBox("vehicle ID: " .. tostring(id))
					setVehicleLocked(found, false)
					
					mysql_query(handler, "UPDATE vehicles SET locked='0' WHERE id='" .. tonumber(id) .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "presses on the key to unlock the vehicle. ((" .. getVehicleName(found) .. "))")
				else
					setVehicleLocked(found, true)
                    for i = 0, 5 do
                        setVehicleDoorState(found, i, 0)
                    end

					mysql_query(handler, "UPDATE vehicles SET locked='1' WHERE id='" .. tonumber(id) .. "' LIMIT 1")
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
					setElementData(found, "locked", 0, false)
					mysql_query(handler, "UPDATE interiors SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 0, false)
						end
					end
				else
					setElementData(found, "locked", 1, false)
					mysql_query(handler, "UPDATE interiors SET locked='1' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 1, false)
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
			exports.global:sendLocalMeAction(source, "eats a sandwich.")
			exports.global:takePlayerItem(source, itemID, itemValue)
		elseif (itemID==9) then -- sprunk
			
			local health = getElementHealth(source)
			setElementHealth(source, health+30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", -1, false, true, true)
			toggleAllControls(source, true, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "drinks a sprunk.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==10) then -- red dice
			local output = math.random(1, 6)
			local x, y, z = getElementPosition(source)
			local chatSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(chatSphere)
			local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
			local playerName = string.gsub(getPlayerName(source), "_", " ")
			
			destroyElement(chatSphere)

			for index, nearbyPlayer in ipairs(nearbyPlayers) do
				local logged = getElementData(nearbyPlayer, "loggedin")
				if not(isPedDead(nearbyPlayer)) and (logged==1) then
					outputChatBox(" *((Dice)) " .. playerName .. " rolls a dice and gets " .. output ..".", nearbyPlayer, 255, 51, 102)
				end
			end
		elseif (itemID==11) then -- taco
			
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "eats a taco.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==12) then -- cheeseburger
			
			local health = getElementHealth(source)
			setElementHealth(source, health+10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "eats a cheeseburger.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==13) then -- donut
			
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "eats a donut.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==14) then -- cookie
			
			local health = getElementHealth(source)
			setElementHealth(source, health+80)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "eats a cookie.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==15) then -- water
			
			local health = getElementHealth(source)
			setElementHealth(source, health+90)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "drinks a bottle of water.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			
		elseif (itemID==16) then -- clothes
			local result = mysql_query(handler, "SELECT gender,skincolor FROM characters WHERE charactername='" .. getPlayerName(source) .. "' LIMIT 1")
			local gender = tonumber(mysql_result(result,1,1))
			local race = tonumber(mysql_result(result,1,2))
			mysql_free_result(result)
			
			local skin = tonumber(itemValue)
			if fittingskins[gender] and fittingskins[gender][race] and fittingskins[gender][race][skin] then
				setPedSkin(source, skin)
				setElementData(source, "casualskin", skin, false)
				exports.global:sendLocalMeAction(source, "changes their clothes.")
			else
				outputChatBox("These clothes do not fit you.", source, 255, 0, 0)
			end
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
			
			exports.global:sendLocalMeAction(source, "looks at their watch.")
			outputChatBox("The time is " .. hour .. ":" .. mins .. ".", source, 255, 194, 14)
			exports.global:applyAnimation(source, "COP_AMBIENT", "Coplook_watch", -1, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
		elseif (itemID==18) then -- city guide
			--triggerClientEvent(source, "showCityGuide", source)
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
				local fixedName = "(" .. tostring(pid) .. ") Unknown Person"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "gasmask", 1, false)
			elseif (gasmask==1) then
				exports.global:sendLocalMeAction(source, "slips a black gas mask off their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = string.gsub(getPlayerName(source), "_", " ")
				local fixedName = "(" .. tostring(pid) .. ") " .. name
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "gasmask", 0, false)
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
					setElementData(found, "locked", 0, false)
					mysql_query(handler, "UPDATE interiors SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
					exports.global:sendLocalMeAction(source, "swings the ram into the door, opening it.")
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
						local dbid = getElementData(value, "dbid")
						if (dbid==id) and (value~=found) then
							setElementData(value, "locked", 0, false)
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
		elseif (itemID==49) then
			triggerEvent( "fish", source )
		elseif (itemID==50) then -- highway code book
			local bookTitle = "The Los Santos Highway Code"
			local bookName = "LVHighwayCode"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==51) then -- chemistry book
			local bookTitle = "Chemistry 101"
			local bookName = "Chemistry101"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==52) then -- PD manual book
			local bookTitle = "The Police Officer's Manual"
			local bookName = "PDmanual"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==53) then -- Breathalizer
			outputChatBox("Use /breathtest to use this item.", source, 255, 194, 15)
		elseif (itemID==54) then -- GHETTOBLASTER
			exports.global:sendLocalMeAction(source, "places a ghettoblaster on the ground.")
			local x, y, z = getElementPosition(source)
			local rot = getPedRotation(source)
			x = x - math.sin( math.rad( rot-180 ) ) * 1
			y = y - math.cos( math.rad( rot-180 ) ) * 1
			
			triggerEvent("dropItem", source, itemID, itemValue, itemName, x, y, z, groundz-0.3, nil, nil, true)
		elseif (itemID==55) then -- Stevie's business card
			exports.global:sendLocalMeAction(source, "looks at a piece of paper.")
			outputChatBox("The card reads: 'Steven Pullman - L.V. Freight Depot, Tel: 081016'", source, 255, 51, 102)
		elseif (itemID==56) then -- MASK
			local mask = getElementData(source, "mask")
			
			if not (mask) or (mask==0) then
				exports.global:sendLocalMeAction(source, "slips a mask over their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local fixedName = "(" .. tostring(pid) .. ") Unknown Person"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "mask", 1, false)
			elseif (mask==1) then
				exports.global:sendLocalMeAction(source, "slips a mask off their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = string.gsub(getPlayerName(source), "_", " ")
				local fixedName = "(" .. tostring(pid) .. ") " .. name
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "mask", 0, false)
			end
		elseif (itemID==57) then -- FUEL CAN
			if not (isPedInVehicle(source)) then
				outputChatBox("You are not in a vehicle.", source, 255, 0, 0)
			else
				local fuel = itemValue
				
				local veh = getPedOccupiedVehicle(source)
				local currFuel = getElementData(veh, "fuel")
				
				if (math.ceil(currFuel)==100) then
					outputChatBox("This vehicle is already full.", source)
				elseif (fuel==0) then
					outputChatBox("This fuel can is empty.", source, 255, 0, 0)
				else
					local fuelAdded = fuel
					
					if (fuelAdded+currFuel>100) then
						fuelAdded = 100 - currFuel
					end
					
					outputChatBox("You added " .. math.ceil(fuelAdded) .. " litres of petrol to your car from your fuel can.", source, 0, 255, 0 )
					exports.global:sendLocalMeAction(source, "fills up his vehicle from a small petrol canister.")
					
					exports.global:takePlayerItem(source, 57, itemValue)
					exports.global:givePlayerItem(source, 57, math.ceil(itemValue-fuelAdded))
					
					setElementData(veh, "fuel", currFuel+fuelAdded)
					triggerClientEvent(source, "setClientFuel", source, currFuel+fuelAdded)
				end
			end
		elseif (itemID==59) then -- MUDKIP
			exports.global:sendLocalMeAction(source, "eats a mudkip.")
			exports.global:takePlayerItem(source, itemID, itemValue)
			killPed(source)
		elseif (itemID==60) then 
				local x,y,z = getElementPosition(source)
				local rz = getPedRotation(source)
				local dimension = getElementDimension(source)
				local retval = call(getResourceFromName("interior-system"), "addSafeAtPosition", source, x,y,z, rz) --0 no error, 1 safe already exists, 2 player does not own interior
				if (retval == 0) then
					exports.global:sendLocalMeAction(source, "Places a safe.")
					exports.global:takePlayerItem(source, itemID, itemValue)
				elseif (retval == 2 and dimension == 0) then
					outputChatBox("You are not inside an interior.", source, 255, 0, 0)
				elseif (retval == 2) then
					outputChatBox("You need to own the interior you are placing the safe in!", source, 255, 0, 0)
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

function destroyItem(itemID, itemValue, itemName, isWeapon, items, values)
	if isPedDead(source) then return end
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

function dropItem(itemID, itemValue, itemName, x, y, z, gz, isWeapon, items, itemvalues, forced)
	if isPedDead(source) then return end
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
		setElementData(obj, "id", id, false)
		setElementData(obj, "itemID", itemID)
		setElementData(obj, "itemValue", itemValue)
		setElementData(obj, "itemName", itemName)
		setElementData(obj, "type", "worlditem")
		setElementData(obj, "items", stringitems)
		setElementData(obj, "itemvalues", stringvalues)
		
		-- Check if he drops his current clothes
		if tonumber(itemID) == 16 and tonumber(itemValue) == getPedSkin(source) and not exports.global:doesPlayerHaveItem(source, 16, tonumber(itemValue)) then
			setPedSkin(source, 0)
		end
	else
		if tonumber(getElementData(source, "duty")) > 0 then
			outputChatBox("You can't drop your weapons while being on duty.", source, 255, 0, 0)
		else
			outputChatBox("You dropped a " .. itemName .. ".", source, 255, 194, 14)
			
			if (itemID==nil) then
				itemID = 100
				gz = gz + 0.5
				setPedArmor(source, 0)
			end
			
			triggerClientEvent(source, "saveGuns", source)
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
			setElementData(obj, "id", id, false)
			setElementData(obj, "itemID", itemID)
			setElementData(obj, "itemValue", itemValue)
			setElementData(obj, "itemName", itemName)
			setElementData(obj, "type", "worlditem")
		end
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
			
			
			if (yearday>(wyearday+7)) then
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
					setElementData(obj, "id", tonumber(row[1]), false)
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
					setElementData(obj, "id", tonumber(row[1]), false)
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
					setElementData(obj, "id", tonumber(row[1]), false)
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
	if isPedDead(source) then return end
	exports.global:sendLocalMeAction(source, "shows everyone a " .. itemName .. ".")
end
addEvent("showItem", true)
addEventHandler("showItem", getRootElement(), showItem)

function resetAnim(thePlayer)
	exports.global:removeAnimation(thePlayer)
end

function pickupItem(object, itemID, itemValue, itemName)
	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)

	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<3) then	
		outputChatBox("You picked up a " .. itemName .. ".", source, 255, 194, 14)
		
		-- Animation
		exports.global:applyAnimation(source, "CARRY", "liftup", -1, false, true, true)
		setTimer(resetAnim, 1600, 1, source)
		
		exports.global:sendLocalMeAction(source, "bends over and picks up a " .. itemName .. ".")
		local items = getElementData(object, "items")
		local itemvalues = getElementData(object, "itemvalues")
		local id = getElementData(object, "id")
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
	else
		outputDebugString("Distance between Player and Pickup too large")
		setElementData(object, "pickedup", false)
	end
end
addEvent("pickupItem", true)
addEventHandler("pickupItem", getRootElement(), pickupItem)

function adminItemList(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local result = mysql_query(handler, "SELECT id, item_name, item_description FROM items")
				
		if (result) then
			local items = { }
			local key = 1
			
			for result, row in mysql_rows(result) do
				items[key] = { }
				items[key][1] = row[1]
				items[key][2] = row[2]
				items[key][3] = row[3]
				key = key + 1
			end
			
			mysql_free_result(result)
			triggerClientEvent(thePlayer, "showItemList", getRootElement(), items)
		else
			outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("itemlist", adminItemList, false, false)

function breathTest(thePlayer, commandName, targetPlayer)
	if (exports.global:doesPlayerHaveItem(thePlayer, 53, -1)) then
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
					local alcohollevel = getElementData(targetPlayer, "alcohollevel")
					
					if not (alcohollevel) then alcohollevel = 0 end
					
					outputChatBox(targetPlayerName .. "'s Alcohol Levels: " .. alcohollevel .. ".", thePlayer, 255, 194, 15)
				end
			end
		end
	end
end
addCommandHandler("breathtest", breathTest, false, false)

function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(exports.pool:getPoolElementsByType("object")) do
			local dbid = getElementData(theObject, "id")

			if (dbid) then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)

				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					local objtype = getElementData(theObject, "type")
					if (objtype=="worlditem") then
						outputChatBox("   Item with ID " .. dbid .. ": " .. tostring( getElementData(theObject, "itemName") .. "(" .. getElementData(theObject, "itemID") .. ")" or getElementData(theObject, "itemID") or "?" ) .. " with Value " .. tostring( getElementData(theObject, "itemValue") ), thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyitems", getNearbyItems, false, false)

function delItem(thePlayer, commandName, targetID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
				
			for key, value in ipairs(exports.pool:getPoolElementsByType("object")) do
				local dbid = getElementData(value, "id")
				local objtype = getElementData(value, "type")

				if (dbid) and (objtype=="worlditem") then
					if (dbid==tonumber(targetID)) then
						object = value
					end
				end
			end
			
			if (object) then
				local id = getElementData(object, "id")
				local result = mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'")
						
				if (result) then
					mysql_free_result(result)
				end
						
				outputChatBox("Item #" .. id .. " deleted.", thePlayer)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Item #" .. id .. ".")
				destroyElement(object)
			else
				outputChatBox("Invalid item ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delitem", delItem, false, false)

function showInventoryRemote(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			if targetPlayer then
				triggerClientEvent(thePlayer,"showInventory",thePlayer,targetPlayer)
			else
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("showinv", showInventoryRemote, false, false)