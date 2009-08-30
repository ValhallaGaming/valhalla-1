addEvent("onPlayerInteriorEnter", true)
addEvent("onPlayerInteriorExit", true)
local safeTable = {}

-- START OF INTERIOR SYSTEM SCRIPT

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

function createInterior(thePlayer, commandName, interiorId, inttype, cost, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (interiorId) or not (inttype) or not (cost) or not (...) or ((tonumber(inttype)<0) or (tonumber(inttype)>3)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [TYPE] [Cost] [Name]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 0: House", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1: Business", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2: Government (Unbuyable)", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3: Rentable", thePlayer, 255, 194, 14)
		else
			name = table.concat({...}, " ")
			
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interiorwithin = getElementInterior(thePlayer)
			
			local inttype = tonumber(inttype)
			local owner = nil
			local locked = nil
			
			if (inttype==2) then
				owner = 0
				locked = 0
			else
				owner = -1
				locked = 1
			end
			
			interior = interiors[tonumber(interiorId)]
			if interior then
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				local max_items = interior[6]
				
				local rot = getPedRotation(thePlayer)
				local query = mysql_query(handler, "INSERT INTO interiors SET x='" .. x .. "', y='" .. y .."', z='" .. z .."', type='" .. inttype .. "', owner='" .. owner .. "', locked='" .. locked .. "', cost='" .. cost .. "', name='" .. name .. "', interior='" .. interiorw .. "', interiorx='" .. ix .. "', interiory='" .. iy .. "', interiorz='" .. iz .. "', dimensionwithin='" .. dimension .. "', interiorwithin='" .. interiorwithin .. "', angle='" .. optAngle .. "', angleexit='" .. rot .. "', max_items='" .. max_items .. "'")
				
				if (query) then
					local id = mysql_insert_id(handler) -- Get the ID of the latest insert
					mysql_free_result(query)
					reloadOneInterior(id, false, false)
				else
					outputChatBox("Failed to create interior - Invalid characters used in name of the interior.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Failed to create interior - There is no such interior (" .. ( interiorID or "??" ) .. ").", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addinterior", createInterior, false, false)

function updateInteriorExit(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			local query = mysql_query(handler, "UPDATE interiors SET interiorx='" .. x .. "', interiory='" .. y .. "', interiorz='" .. z .. "', angle='" .. rot .. "' WHERE id='" .. dbid .. "'")
			
			if (query) then
				mysql_free_result(query)
			end
			
			local pickups = exports.pool:getPoolElementsByType("pickup")
			for k, thePickup in ipairs(pickups) do
				local pickupType = getElementData(thePickup, "type")
				
				if (pickupType=="interiorexit") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==dbid) then
						setElementPosition(thePickup, x, y, z)
					end
				elseif (pickupType=="interior") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==dbid) then
						setElementData(thePickup, "x", x, false)
						setElementData(thePickup, "y", y, false)
						setElementData(thePickup, "z", z, false)
					end
				end
			end
			outputChatBox("Interior Exit Position Updated!", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setinteriorexit", updateInteriorExit, false, false)

function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		-- find the entrance and exit
		local entrance, exit = nil, nil
		for key, value in pairs(exports.pool:getPoolElementsByType( "pickup" )) do
			local pickupType = getElementData(value, "type")
			if pickupType == "interior" then
				if getElementData(value, "dbid") == dbid then
					entrance = value
					if entrance and exit then
						break
					end
				end
			elseif pickupType == "interiorexit" then
				if getElementData(value, "dbid") == dbid then
					exit = value
					if entrance and exit then
						break
					end
				end
			end
		end
		return dbid, entrance, exit, getElementData(entrance,"inttype")
	end
	return 0
end

function sellProperty(thePlayer, commandName)
	local dbid, entrance, exit, interiorType = findProperty( thePlayer )
	if dbid > 0 then
		if interiorType == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		else
			if exports.global:isPlayerAdmin(thePlayer) or getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") then
				publicSellProperty(thePlayer, dbid, true)
			else
				outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
			end
		end
	else 
		outputChatBox("You are not in a property.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)

function publicSellProperty(thePlayer, dbid, showmessages)
	local dbid, entrance, exit, interiorType = findProperty( thePlayer, dbid )
	local query = mysql_query(handler, "UPDATE interiors SET owner=-1, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL WHERE id='" .. dbid .. "'")
	if query then
		mysql_free_result(query)
		
		if getElementDimension(thePlayer) == dbid then
			setElementPosition(thePlayer, getElementPosition(entrance))
			removeElementData(thePlayer, "interiormarker")
			
			setElementInterior(thePlayer, getElementInterior(entrance))
			setElementDimension(thePlayer, getElementDimension(entrance))
			setCameraInterior(thePlayer, getElementInterior(entrance))
		end

		if safeTable[dbid] then
			local safe = safeTable[dbid]
			call( getResourceFromName( "item-system" ), "clearItems", safe )
			destroyElement(safe)
		end
		
		if interiorType == 0 or interiorType == 1 then
			if getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") then
				local money = math.ceil(getElementData(entrance, "cost") * 2/3)
				--local money = getElementData(entrance, "cost")
				exports.global:givePlayerSafeMoney(thePlayer, money)
				if showmessages then
					outputChatBox("You sold your property for " .. money .. "$.", thePlayer, 0, 255, 0)
				end
				
				local keytype = 4
				if interiorType == 1 then
					keytype = 5
				end
				exports.global:takeItem(thePlayer, keytype, dbid)
				
				triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
			else
				if showmessages then
					outputChatBox("You set this property to unowned.", thePlayer, 0, 255, 0)
				end
			end
		else
			if showmessages then
				outputChatBox("You are no longer renting this property.", thePlayer, 0, 255, 0)
			end
			exports.global:takeItem(thePlayer, 4, dbid)
			triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
		end

		destroyElement(entrance)
		destroyElement(exit)
		
		reloadOneInterior(dbid, false)
	else
		outputChatBox("Error 504914 - Report on forums.", thePlayer, 255, 0, 0)
	end
end

function sellTo(thePlayer, commandName, targetPlayerName)
	-- only works in dimensions
	local dbid, entrance, exit, interiorType = findProperty( thePlayer )
	if dbid > 0 then
		if interiorType == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif not targetPlayerName then
			outputChatBox("SYNTAX: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sells the Property you're in to that Player.", thePlayer, 255, 194, 14)
			outputChatBox("Ask the buyer to use /pay to recieve the money for the Property.", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 and getElementDimension(targetPlayer) == getElementDimension(thePlayer) then
					if getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") or exports.global:isPlayerAdmin(thePlayer) then
						if getElementData(targetPlayer, "dbid") ~= getElementData(entrance, "owner") then
							if exports.global:hasSpaceForItem(targetPlayer) then
								local query = mysql_query(handler, "UPDATE interiors SET owner = '" .. getElementData(targetPlayer, "dbid") .. "' WHERE id='" .. dbid .. "'")
								if query then
									mysql_free_result(query)
									setElementData(entrance, "owner", getElementData(targetPlayer, "dbid"))
									setElementData(exit, "owner", getElementData(targetPlayer, "dbid"))
									
									-- FIXME: remove all keys for that Property from all people
									local keytype = 4
									if interiorType == 1 then
										keytype = 5
									end
									exports.global:takeItem(thePlayer, keytype, dbid)
									exports.global:giveItem(targetPlayer, keytype, dbid)
									
									triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
									triggerClientEvent(targetPlayer, "createBlipAtXY", targetPlayer, interiorType, getElementPosition(entrance))
									
									outputChatBox("You've successfully sold your property to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
									outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " sold you this property.", targetPlayer, 0, 255, 0)
								else
									outputChatBox("Error 09002 - Report on Forums.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox(targetPlayerName .. " has no space for the property keys.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You can't sell your own property to yourself.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("This property is not yours.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("No such player online.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sell", sellTo)

function deleteInterior(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
			local x, y, z, rot, interior, dimension = nil
			
			local pickups = exports.pool:getPoolElementsByType("pickup")
			for k, thePickup in ipairs(pickups) do
				local pickupType = getElementData(thePickup, "type")
				
				if (pickupType=="interiorexit") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==dbid) then
						x = getElementData(thePickup, "x")
						y = getElementData(thePickup, "y")
						z = getElementData(thePickup, "z")
						rot = getPedRotation(thePlayer)
						destroyElement(thePickup)
					end
				elseif (pickupType=="interior") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==dbid) then
						interior = getElementInterior(thePickup)
						dimension = getElementDimension(thePickup)
						local safe = safeTable[dbid]
						if (safe) then
							call( getResourceFromName( "item-system" ), "clearItems", safe )
							destroyElement(safe)
						end
						destroyElement(thePickup)
					end
				end
			end
			setElementPosition(thePlayer, x, y, z)
			setPedRotation(thePlayer, rot)
			removeElementData(thePlayer, "interiormarker")
			setElementInterior(thePlayer, interior)
			setElementDimension(thePlayer, dimension)
			setCameraInterior(thePlayer, interior)
			local query = mysql_query(handler, "DELETE FROM interiors WHERE id='" .. dbid .. "'")
			
			if (query) then
				mysql_free_result(query)
				outputChatBox("Interior #" .. dbid .. " Deleted!", thePlayer, 0, 255, 0)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted interior #" .. dbid .. ".")
			else
				outputChatBox("Error 50001 - Report on forums.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delinterior", deleteInterior, false, false)

function reloadInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14)
		else
			local dbid, entrance, exit, interiorType = findProperty( thePlayer, tonumber(interiorID) )
			if dbid ~= 0 then
				destroyElement(entrance)
				destroyElement(exit)
				
				reloadOneInterior(dbid, false)
				outputChatBox("Reloaded Interior #" .. dbid, thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("reloadinterior", reloadInterior, false, false)

function reloadOneInterior(id, hasCoroutine, displayircmessage)
	if (hasCoroutine==nil) then
		hasCoroutine = false
	end

	if displayircmessage == nil then
		displayircmessage = false
	end
	local result = mysql_query(handler, "SELECT id, x, y, z , interiorx, interiory, interiorz, type, owner, locked, cost, name, interior, dimensionwithin, interiorwithin, angle, angleexit, items, items_values, max_items, rentable, tennant, rent, money, safepositionX, safepositionY, safepositionZ, safepositionRZ FROM interiors WHERE id='" .. id .. "'")
	
	if (hasCoroutine) then
		coroutine.yield()
	end
	
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
			local x = tonumber(row[2])
			local y = tonumber(row[3])
			local z = tonumber(row[4])
				
			local ix = tonumber(row[5])
			local iy = tonumber(row[6])
			local iz = tonumber(row[7])
				
			local inttype = tonumber(row[8])
			local owner = tonumber(row[9])
			local locked = tonumber(row[10])
			local cost = tonumber(row[11])
			local name = row[12]
			
			if (hasCoroutine) then
				coroutine.yield()
			end
			
			local interior = tonumber(row[13])
			local dimension = tonumber(row[14])
			local interiorwithin = tonumber(row[15])
			local optAngle = tonumber(row[16])
			local exitAngle = tonumber(row[17])
			
			local items = row[18]
			local items_values = row[19]
			local max_items = tonumber(row[20])
			
			local rentable = tonumber(row[21])
			local tennant = row[22]
			local rent = tonumber(row[23])
			
			local money = tonumber(row[24])
			
			if (hasCoroutine) then
				coroutine.yield()
			end
			
			local safeX, safeY, safeZ, safeRZ = row[25], row[26], row[27], row[28]
			-- If the is a house
			if (inttype==0) then -- House
				local pickup
				
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1273)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
				
				local intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
				setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
				setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
			-- if it is a business
			elseif (inttype==1) then -- Business
				local pickup
					
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1272)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
				
				local intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
				setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
				setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
			-- if it is a gov building
			elseif (inttype==2) then -- Interior Owned
				local pickup = createPickup(x, y, z, 3, 1318)
				local intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(pickup)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
				setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
				setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
			-- If the is rentable
			elseif (inttype==3) then -- Rentable
				local pickup
					
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1273)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
					
				local intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
				setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
				setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
			end
			
			if safeX ~= mysql_null() and safeY ~= mysql_null() and safeZ ~= mysql_null() and safeRZ ~= mysql_null() then
				local tempobject = createObject(2332, tonumber(safeX), tonumber(safeY), tonumber(safeZ), 0, 0, tonumber(safeRZ))
				setElementInterior(tempobject, interior)
				setElementDimension(tempobject, id)
				safeTable[id] = tempobject
				
				if items ~= mysql_null() and items_values ~= mysql_null() then
					if #items > 0 and #items_values > 0 then
						for i = 1, 20 do
							local token = tonumber(gettok(items, i, string.byte(',')))
							local vtoken = tonumber(gettok(items_values, i, string.byte(',')))
							
							if token and vtoken then
								local itemID = tonumber(token)
								if itemID >= 9000 then
									itemID = - ( itemID - 9000 )
								end
								exports.global:giveItem( tempobject, itemID, tonumber(vtoken) )
							end
						end

						local query = mysql_query( handler, "UPDATE interiors SET items=NULL, items_values=NULL WHERE id=" .. id )
						if query then
							mysql_free_result( query )
						else
							outputDebugString( mysql_error( handler ) )
						end
					end
				end
			end
		end
		if displayircmessage then
			exports.irc:sendMessage("[SCRIPT] Loaded 1 interior (ID: " .. id .. ")")
		end
		mysql_free_result(result)
	end
end

local threads = { }
function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function loadAllInteriors()
	local result = mysql_query(handler, "SELECT id FROM interiors")
	local counter = 0
		
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		removeElementData(thePlayer, "interiormarker")
	end
		
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
			local co = coroutine.create(reloadOneInterior)
			coroutine.resume(co, id, true)
			table.insert(threads, co)
			counter = counter + 1
		end
		mysql_free_result(result)
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " interiors.")
		setTimer(resume, 1000, 4)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadAllInteriors)

function setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
	if(pickup) then
		setElementData(pickup, "dbid", id, false)
		setElementData(pickup, "x", ix, false)
		setElementData(pickup, "y", iy, false)
		setElementData(pickup, "z", iz, false)
		setElementData(pickup, "angle", optAngle, false)
		setElementData(pickup, "interior", interior, false)
		setElementData(pickup, "locked", locked, false)
		setElementData(pickup, "owner", owner, false)
		setElementData(pickup, "inttype", inttype, false)
		setElementData(pickup, "cost", cost, false)
		setElementData(pickup, "name", name, false)
		setElementData(pickup, "max_items", max_items, false)
		setElementData(pickup, "tennant", tennant, false)
		setElementData(pickup, "rentable", rentable, false)
		setElementData(pickup, "rent", rent, false)
		setElementData(pickup, "money", money, false)
		setElementDimension(pickup, dimension)
		setElementData(pickup, "type", "interior", false)
		setElementInterior(pickup, interiorwithin, x, y, z)
		
		local shape = getElementColShape(pickup)
		setElementDimension(shape, dimension)
		setElementInterior(shape, interiorwithin)
	end
end

function setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
	if(intpickup) then
		-- For Interior Pickup
		setElementData(intpickup, "dbid", id, false)
		setElementData(intpickup, "x", x, false)
		setElementData(intpickup, "y", y, false)
		setElementData(intpickup, "z", z, false)
		setElementData(intpickup, "angle", rot, false)
		setElementData(intpickup, "locked", locked, false)
		setElementData(intpickup, "owner", owner, false)
		setElementData(intpickup, "inttype", inttype, false)
		setElementData(intpickup, "interior", interiorwithin, false)
		setElementData(intpickup, "dimension", dimension, false)
		setElementInterior(intpickup, interior, ix, iy, iz)
		setElementDimension(intpickup, id, false)
		setElementData(intpickup, "type", "interiorexit") -- To identify it later
		
		local shape = getElementColShape(intpickup)
		setElementDimension(shape, id)
		setElementInterior(shape, interior)
	end
end

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "enter", "down", enterInterior)) then
			bindKey(arrayPlayer, "enter", "down", enterInterior)
		end
		if not(isKeyBound(arrayPlayer, "f", "down", enterInterior)) then
			bindKey(arrayPlayer, "f", "down", enterInterior)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "enter", "down", enterInterior)
	bindKey(source, "f", "down", enterInterior)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function hitInteriorPickup(thePlayer)
	local pickuptype = getElementData(source, "type")
	
	if (pickuptype=="interior") or (pickuptype=="interiorexit") then
		local pdimension = getElementDimension(thePlayer)
		local idimension = getElementDimension(source)
		
		if (pdimension==idimension) then -- same dimension?
			local locked = getElementData(source, "locked")
			local inttype = getElementData(source, "inttype")
			
			if(getElementData(source, "type") == "interior") then
				local name = getElementData(source, "name")
				local owner = getElementData(source, "owner")
				local cost = getElementData(source, "cost")
				
				local ownerName = "None"
				local result = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
			
				if (mysql_num_rows(result)>0) then
					ownerName = mysql_result(result, 1, 1)
					ownerName = string.gsub(tostring(ownerName), "_", " ")
				end
				if (result) then
					mysql_free_result(result)
				end
				triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, inttype, cost)
			end
			
			setElementData(thePlayer, "interiormarker", source, false)
			setTimer(resetInteriorMarker, 3000, 1, thePlayer)
		end
		cancelEvent() -- Stop it despawning
	end
end
addEventHandler("onPickupHit", getRootElement(), hitInteriorPickup)

function resetInteriorMarker(thePlayer)
	if(getPlayerName(thePlayer)) then
		removeElementData(thePlayer, "interiormarker")
	end
end

function buyInterior(player, pickup, cost, isHouse, isRentable)
	if isRentable then
		local result = mysql_query( handler, "SELECT COUNT(*) FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" )
		if result then
			local count = tonumber(mysql_result( result, 1, 1 ))
			if count ~= 0 then
				outputChatBox("You are already renting another house.", player, 255, 0, 0)
				return
			end
			mysql_free_result(result)
		end
	elseif not exports.global:hasSpaceForItem(player) then
		outputChatBox("You do not have the space for the keys.", player, 255, 0, 0)
		return
	end
	
	local money = tonumber(getElementData(player, "money"))
	cost = tonumber(cost)
	if (money>=cost) then
		if (isHouse) then
			outputChatBox("Congratulations! You have just bought this house for $" .. cost .. ".", player, 255, 194, 14)
		elseif (isRentable) then
			outputChatBox("Congratulations! You are now renting this property for $" .. cost .. ".", player, 255, 194, 14)
		else
			outputChatBox("Congratulations! You have just bought this business for $" .. cost .. ".", player, 255, 194, 14)
		end
		
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local id = tonumber(getElementData(value, "dbid"))
			if (id==pickupid) then
				destroyElement(value)
			end
		end

		local query = mysql_query(handler, "UPDATE interiors SET owner='" .. charid .. "', locked='0' WHERE id='" .. pickupid .. "'")
		mysql_free_result(query)
		local result = mysql_query(handler, "SELECT id, x, y, z, interiorx, interiory, interiorz, type, owner, locked, cost, name, interior, dimensionwithin, interiorwithin, angle, angleexit, items, items_values, max_items, rentable, tennant, rent, money FROM interiors WHERE id='" .. pickupid .. "'")
		local id = tonumber(mysql_result(result, 1, 1))
		local x = tonumber(mysql_result(result, 1, 2))
		local y = tonumber(mysql_result(result, 1, 3))
		local z = tonumber(mysql_result(result, 1, 4))
					
		local ix = tonumber(mysql_result(result, 1, 5))
		local iy = tonumber(mysql_result(result, 1, 6))
		local iz = tonumber(mysql_result(result, 1, 7))
					
		local inttype = tonumber(mysql_result(result, 1, 8))
		local owner = tonumber(mysql_result(result, 1, 9))
		local locked = tonumber(mysql_result(result, 1, 10))
		local cost = tonumber(mysql_result(result, 1, 11))
		local name = mysql_result(result, 1, 12)

		local interior = tonumber(mysql_result(result, 1, 13))
		local dimension = tonumber(mysql_result(result, 1, 14))
		local interiorwithin = tonumber(mysql_result(result, 1, 15))
		local optAngle = tonumber(mysql_result(result, 1, 16))
		local exitAngle = tonumber(mysql_result(result, 1, 17))
				
		local items = mysql_result(result, 1, 18)
		local items_values = mysql_result(result, 1, 19)
		local max_items = tonumber(mysql_result(result, 1, 20))
				
		local rentable = tonumber(mysql_result(result, 1, 21))
		local tennant = mysql_result(result, 1, 22)
		local rent = tonumber(mysql_result(result, 1, 23))
				
		local money = tonumber(mysql_result(result, 1, 24))
			
		mysql_free_result(result)
		exports.global:takePlayerSafeMoney(player, cost)
		
		if (isHouse) then
			-- Achievement
			exports.global:givePlayerAchievement(player, 9)
			exports.global:giveItem(player, 4, id)
		elseif isRentable then
			exports.global:giveItem(player, 4, id)
		else
			-- Achievement
			exports.global:givePlayerAchievement(player, 10)
			exports.global:giveItem(player, 5, id)
		end
		--[[
		local pickup = createPickup(x+50, y+50, z, 3, 1318)
		setElementData(pickup, "type", "interior")
		setElementPosition(pickup, x, y, z)
		local intpickup = createPickup(ix, iy, iz, 3, 1318)
		exports.pool:allocateElement(pickup)
		exports.pool:allocateElement(intpickup)

		setPickupElementData(pickup, id, ix, iy, iz, optAngle, interior, locked, owner, inttype, cost, name, items, items_values, max_items, tennant, rentable, rent, interiorwithin, x, y, z, dimension, money)
		setIntPickupElementData(intpickup, id, x, y, z, rot, locked, owner, inttype, interiorwithin, dimension, interior, ix, iy, iz)
		reloadOneInterior(tonumber(pickupid), false, false)
		]]--
		reloadOneInterior(tonumber(pickupid), false, false)
		triggerClientEvent(player, "createBlipAtXY", player, inttype, ix, iy)
			
		playSoundFrontEnd(player, 20)
	else
		outputChatBox("Sorry, you cannot afford to purchase this property.", player, 255, 194, 14)
		playSoundFrontEnd(player, 1)
	end
end

function vehicleStartEnter(thePlayer)
	local thePickup = getElementData(thePlayer, "interiormarker")
	
	if (thePickup) then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), vehicleStartEnter)

function enterInterior(source)

	local thePickup = getElementData(source, "interiormarker")

	-- if the player is entering a pickup
	if thePickup and not getPedOccupiedVehicle(source) then
		
		local pickupType = getElementData(thePickup, "type")
		
		
		local pickupDimension = getElementDimension(thePickup)
		local playerDimension = getElementDimension(source)
		
		local username = getPlayerName(source)

		-- if pickup and player are in the same place
		if (pickupDimension==playerDimension)  then
		
			local inttype = getElementData(thePickup, "inttype")
			
			-- if the pickup collided with is an interior
			if (pickupType=="interior") then
				local locked = getElementData(thePickup, "locked")
				local owner = getElementData(thePickup, "owner")
				local cost = getElementData(thePickup, "cost")
				
				local houseID = getElementData(thePickup, "dbid")
                
				-- if the interior is unlocked
				if (locked == 0) then 
					setPlayerInsideInterior(thePickup, source)
				elseif (locked==1) and (inttype==0) and (owner==-1) then -- unowned house
					buyInterior(source, thePickup, cost, true, false)
				elseif (locked==1) and (inttype==1) and (owner==-1) then -- unowned business
					buyInterior(source, thePickup, cost, false, false)
				elseif (locked==1) and (inttype==3) and (owner==-1) then -- unowned rentable appartment
					buyInterior(source, thePickup, cost, false, true)
				else -- interior is locked
					outputChatBox("You try the door handle, but it seems to be locked.", source, 255, 0,0, true)
				end
				
			-- if it is an exit marker, its unlocked or is government then
			elseif (pickupType=="interiorexit") then

				local locked = getElementData(thePickup, "locked")
				local houseID = getElementData(thePickup, "dbid")

				if ((locked == 0) or (inttype==2))  then -- if it is unlocked or its a government building
					local owner = getElementData(thePickup, "owner")
					local x = getElementData(thePickup, "x")
					local y = getElementData(thePickup, "y")
					local z = getElementData(thePickup, "z")
					local rot = getElementData(thePickup, "angle")
					local interior = getElementData(thePickup, "interior")
					local dimension = getElementData(thePickup, "dimension")
					
                    triggerEvent("onPlayerInteriorExit", source, thePickup)
                    
					-- fade camera to black
					fadeCamera ( source, false, 1,0,0,0 )
					setPedFrozen( source, true )
                    
					-- teleport the player during the black fade
					setTimer(function(source)
						setElementInterior(source, interior, x, y, z)
						setCameraInterior(source, interior)
						setElementDimension(source, dimension)
					
						-- fade camera in
						setTimer(fadeCamera, 1000, 1 , source , true, 2)
						setTimer(setPedFrozen, 2000, 1, source, false)
					end, 1000, 1, source)
					
					playSoundFrontEnd(source, 40)
				
				else -- door is locked
					outputChatBox("You try the door handle, but it seems to be locked.", source, 255, 0,0, true)
				end
			end
		end
	end
end


function setPlayerInsideInterior(thePickup, thePlayer)
	-- teleport the player inside the interior
	local dimension = getElementData(thePickup, "dbid")
	local interior = getElementData(thePickup, "interior")
	local x = getElementData(thePickup, "x")
	local y = getElementData(thePickup, "y")
	local z = getElementData(thePickup, "z")
	local rot = getElementData(thePickup, "angle")
	local name = getElementData(thePickup, "name")
	local owner = getElementData(thePickup, "owner")
	local inttype = getElementData(thePickup, "inttype")
	local cost = getElementData(thePickup, "cost")

    triggerEvent("onPlayerInteriorEnter", thePlayer, thePickup)
    
	-- fade camera to black
	fadeCamera ( thePlayer, false, 1,0,0,0 )
	setPedFrozen( thePlayer, true )
					
	-- teleport the player during the black fade
	setTimer(function(thePlayer)
					
		setElementInterior(thePlayer, interior, x, y, z)
		setElementDimension(thePlayer, dimension)
		setCameraInterior(thePlayer, interior)
		setPedRotation(thePlayer, rot)
					
		-- fade camera in
		setTimer(fadeCamera, 1000, 1 , thePlayer , true, 2)
		setTimer(setPedFrozen, 2000, 1, thePlayer, false )
	end, 1000, 1, thePlayer)
	
	local ownerName = "None"
	local result = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
	
	if (mysql_num_rows(result)>0) then
		ownerName = mysql_result(result, 1, 1)
		ownerName = string.gsub(tostring(ownerName), "_", " ")
	end
	
	if (result) then
		mysql_free_result(result)
	end

	triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, inttype, cost)

	setPedRotation(thePlayer, 0)
	playSoundFrontEnd(thePlayer, 40)
end

function getNearbyInteriors(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Interiors:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local pickuptype = getElementData(thePickup, "type")

			if (pickuptype=="interior") then
				local x, y, z = getElementPosition(thePickup)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					local dbid = getElementData(thePickup, "dbid")
					outputChatBox("   Interior with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyinteriors", getNearbyInteriors, false, false)

function changeInteriorName( thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then -- Is the player an admin?
		local id = getElementDimension(thePlayer)
		if not (...) then -- is the command complete?
			outputChatBox("SYNTAX: /" .. commandName .." [New Name]", thePlayer, 255, 194, 14) -- if command is not complete show the syntax.
		elseif (dimension==0) then
			outputChatBox("You are not inside an interior.", thePlayer, 255, 0, 0)
		else
			name = table.concat({...}, " ")
		
			local query = mysql_query(handler, "UPDATE interiors SET name='" .. name .. "' WHERE id='" .. id .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			outputChatBox("Interior name changed to ".. name ..".", thePlayer, 0, 255, 0) -- Output confirmation.
			
			-- update the name on the markers...
			for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local pickupType = getElementData(thePickup, "type")
			
			if (pickupType=="interior") then
				local pickupID = getElementData(thePickup, "dbid")
				if (pickupID==id) then
					setElementData(thePickup, "name", tostring(name), false)
					break
				end
			end
		end
		end
	end
end
addCommandHandler("setinteriorname", changeInteriorName, false, false) -- the command "/setInteriorName".

--[[ SAFES ]]
function addSafeAtPosition( thePlayer, x, y, z, rotz )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if (safeTable[dbid]) then
		outputChatBox("There is already a safe in this property. Type movesafe to move it.", thePlayer, 255, 0, 0)
		return 1
	end
	if ((exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) then
		z = z - 0.5
		rotz = rotz + 180
		local query = mysql_query(handler, "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
		mysql_free_result(query)
		local tempobject = createObject(2332, x, y, z, 0, 0, rotz)
		setElementInterior(tempobject, interior)
		setElementDimension(tempobject, dbid)
		safeTable[dbid] = tempobject
		return 0
	end
	return 2
end
function moveSafe ( thePlayer, commandName )
	local x,y,z = getElementPosition( thePlayer )
	local rotz = getPedRotation( thePlayer )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if ((exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) then
		if (safeTable[dbid]) then
			local oldsafe = safeTable[dbid]
			z = z - 0.5
			rotz = rotz + 180
			local query = mysql_query(handler, "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			setElementPosition(safeTable[dbid], x, y, z)
			setObjectRotation(safeTable[dbid], 0, 0, rotz)
		else
			outputChatBox("You need a safe to move!", thePlayer, 255, 0, 0)
		end
	end
end

addCommandHandler("movesafe", moveSafe)