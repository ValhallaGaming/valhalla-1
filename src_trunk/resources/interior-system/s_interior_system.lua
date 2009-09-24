addEvent("onPlayerInteriorChange", true)
local intTable = {}
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
				local query = mysql_query(handler, "INSERT INTO interiors SET x='" .. x .. "', y='" .. y .."', z='" .. z .."', type='" .. inttype .. "', owner='" .. owner .. "', locked='" .. locked .. "', cost='" .. cost .. "', name='" .. mysql_escape_string(handler, name) .. "', interior='" .. interiorw .. "', interiorx='" .. ix .. "', interiory='" .. iy .. "', interiorz='" .. iz .. "', dimensionwithin='" .. dimension .. "', interiorwithin='" .. interiorwithin .. "', angle='" .. optAngle .. "', angleexit='" .. rot .. "', max_items='" .. max_items .. "', fee=0")
				
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
			
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				setElementPosition(exit, x, y, z)
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
--[[		local entrance, exit = nil, nil
		for key, value in pairs(getElementsByType( "pickup", getResourceRootElement() )) do
			if getElementData(value, "name") then
				if getElementData(value, "dbid") == dbid then
					entrance = value
					exit = getElementData( value, "other" )
					break
				end
			elseif getElementData(value, "dbid") == dbid then
				exit = value
				entrance = getElementData( value, "other" )
				break
			end
		end
		
		if entrance then
			return dbid, entrance, exit, getElementData(entrance,"inttype")
		end]]
		if intTable[dbid] then
			local entrance, exit = unpack( intTable[dbid] )
			return dbid, entrance, exit, getElementData(entrance,"inttype")
		end
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
				publicSellProperty(thePlayer, dbid, true, true)
			else
				outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
			end
		end
	else 
		outputChatBox("You are not in a property.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)

function publicSellProperty(thePlayer, dbid, showmessages, givemoney)
	local dbid, entrance, exit, interiorType = findProperty( thePlayer, dbid )
	local query = mysql_query(handler, "UPDATE interiors SET owner=-1, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL, fee=0 WHERE id='" .. dbid .. "'")
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
			safeTable[dbid] = nil
		end
		
		if interiorType == 0 or interiorType == 1 then
			if getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") then
				local money = math.ceil(getElementData(entrance, "cost") * 2/3)
				if givemoney then
					exports.global:giveMoney(thePlayer, money)
				end
				
				if showmessages then
					outputChatBox("You sold your property for " .. money .. "$.", thePlayer, 0, 255, 0)
				end
				
				-- take all keys
				call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
				call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
				
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
			call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
			call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
			triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
		end

		destroyElement(entrance)
		destroyElement(exit)
		intTable[dbid] = nil
		
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
									
									local keytype = 4
									if interiorType == 1 then
										keytype = 5
									end
									
									call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
									call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
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
			local dbid, entrance, exit = findProperty( thePlayer )
			if dbid > 0 then
				-- move all players outside
				for key, value in pairs( getElementsByType( "player" ) ) do
					if isElement( value ) and getElementDimension( value ) == dbid then
						setElementPosition( value, getElementPosition( entrance ) )
						setElementInterior( value, getElementInterior( entrance ) )
						setCameraInterior( value, getElementInterior( entrance ) )
						setElementDimension( value, getElementDimension( entrance ) )
						removeElementData( value, "interiormarker" )
						
						triggerEvent("onPlayerInteriorChange", value, exit, entrance)
					end
				end
				
				-- destroy the safe
				local safe = safeTable[dbid]
				if safe then
					call( getResourceFromName( "item-system" ), "clearItems", safe )
					destroyElement(safe)
					safeTable[dbid] = nil
				end
				
				-- destroy the entrance and exit
				destroyElement( entrance )
				destroyElement( exit )
				intTable[dbid] = nil
				
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
				intTable[dbid] = nil
				
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
	local result = mysql_query(handler, "SELECT id, x, y, z , interiorx, interiory, interiorz, type, owner, locked, cost, name, interior, dimensionwithin, interiorwithin, angle, angleexit, max_items, rentable, tennant, rent, money, safepositionX, safepositionY, safepositionZ, safepositionRZ, fee FROM interiors WHERE id='" .. id .. "'")
	
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
			
			local max_items = tonumber(row[18])
			
			local rentable = tonumber(row[19])
			local tennant = row[20]
			local rent = tonumber(row[21])
			
			local money = tonumber(row[22])
			
			if (hasCoroutine) then
				coroutine.yield()
			end
			
			local safeX, safeY, safeZ, safeRZ = row[23], row[24], row[25], row[26]
			local fee = 0
			
			local intpickup, pickup
			-- If the is a house
			if (inttype==0) then -- House
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1273)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
				
				intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
			-- if it is a business
			elseif (inttype==1) then -- Business
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1272)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
				
				intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				
				fee = tonumber(row[27])
				
				if (hasCoroutine) then
					coroutine.yield()
				end
			-- if it is a gov building
			elseif (inttype==2) then -- Interior Owned
				pickup = createPickup(x, y, z, 3, 1318)
				intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(pickup)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
			-- If the is rentable
			elseif (inttype==3) then -- Rentable
				if (owner<1) then
					pickup = createPickup(x, y, z, 3, 1273)
					exports.pool:allocateElement(pickup)
				else
					pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
				end
					
				intpickup = createPickup(ix, iy, iz, 3, 1318)
				exports.pool:allocateElement(intpickup)
				if (hasCoroutine) then
					coroutine.yield()
				end
			else
				outputDebugString("Invalid Interior: " .. tostring( id ))
				return -- dun dun dunno!
			end
			
			setElementData( pickup, "other", intpickup, false )
			setElementData( intpickup, "other", pickup, false )
			
			setPickupElementData(pickup, id, optAngle, locked, owner, inttype, cost, name, max_items, tennant, rent, interiorwithin, dimension, money, fee)
			setIntPickupElementData(intpickup, id, rot, locked, owner, inttype, interior)
			
			if safeX ~= mysql_null() and safeY ~= mysql_null() and safeZ ~= mysql_null() and safeRZ ~= mysql_null() then
				local tempobject = createObject(2332, tonumber(safeX), tonumber(safeY), tonumber(safeZ), 0, 0, tonumber(safeRZ))
				setElementInterior(tempobject, interior)
				setElementDimension(tempobject, id)
				safeTable[id] = tempobject
			end
			
			intTable[id] = { pickup, intpickup }
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

function setPickupElementData(pickup, id, optAngle, locked, owner, inttype, cost, name, max_items, tennant, rent, interiorwithin, dimension, money, fee)
	if(pickup) then
		setElementData(pickup, "dbid", id, false)
		setElementData(pickup, "angle", optAngle, false)
		setElementData(pickup, "locked", locked, false)
		setElementData(pickup, "owner", owner, false)
		setElementData(pickup, "inttype", inttype, false)
		setElementData(pickup, "cost", cost, false)
		setElementData(pickup, "name", name, false)
		setElementData(pickup, "max_items", max_items, false)
		setElementData(pickup, "tennant", tennant, false)
		setElementData(pickup, "rent", rent, false)
		setElementData(pickup, "money", money, false)
		setElementData(pickup, "fee", fee, false)
		setElementDimension(pickup, dimension)
		setElementInterior(pickup, interiorwithin)
	end
end

function setIntPickupElementData(intpickup, id, rot, locked, owner, inttype, interior)
	if(intpickup) then
		-- For Interior Pickup
		setElementData(intpickup, "dbid", id, false)
		setElementData(intpickup, "angle", rot, false)
		setElementData(intpickup, "locked", locked, false)
		setElementData(intpickup, "owner", owner, false)
		setElementData(intpickup, "inttype", inttype, false)
		setElementInterior(intpickup, interior)
		setElementDimension(intpickup, id)
		setElementData(intpickup, "type", "interiorexit") -- To identify it later
	end
end

-- Bind Keys required
function func (player, f, down, player, pickup) enterInterior(player, pickup) end 

function bindKeys(player, pickup)
	if (isElement(player)) then
		if not(isKeyBound(player, "enter", "down", func)) then
			bindKey(player, "enter", "down", func, player, pickup)
		end
		
		if not(isKeyBound(player, "f", "down", func)) then
			bindKey(player, "f", "down", func, player, pickup)
		end
		
		setElementData( player, "interiormarker", true, false )
	end
end

function unbindKeys(player, pickup)
	if (isElement(player)) then
		if (isKeyBound(player, "enter", "down", func)) then
			unbindKey(player, "enter", "down", func, player, pickup)
		end
		
		if (isKeyBound(player, "f", "down", func)) then
			unbindKey(player, "f", "down", func, player, pickup)
		end
		
		removeElementData( player, "interiormarker" )
		triggerClientEvent( player, "displayInteriorName", player )
	end
end

function isInPickup( thePlayer, thePickup, distance )
	if isElement( thePlayer ) and isElement( thePickup ) then
		local ax, ay, az = getElementPosition(thePlayer)
		local bx, by, bz = getElementPosition(thePickup)
		
		return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
	else
		return false
	end
end

function checkLeavePickup( thePlayer, thePickup )
	if isElement( thePlayer ) then
		if isInPickup( thePlayer, thePickup ) then
			setTimer(checkLeavePickup, 1000, 1, thePlayer, thePickup)
		else
			unbindKeys(thePlayer, thePickup)
		end
	end
end

function hitInteriorPickup(thePlayer)
	local pickuptype = getElementData(source, "type")
	
	local pdimension = getElementDimension(thePlayer)
	local idimension = getElementDimension(source)
	
	if pdimension == idimension then -- same dimension?
		local name = getElementData( source, "name" )
		
		if name then
			local owner = getElementData( source, "owner" )
			local cost = getElementData( source, "cost" )
			
			local ownerName = "None"
			local result = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
		
			if result then
				if mysql_num_rows(result) > 0 then
					ownerName = mysql_result(result, 1, 1):gsub("_", " ")
				end
				mysql_free_result(result)
			end
			
			triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, getElementData( source, "inttype" ), cost, getElementData( source, "fee" ) )
		end
		
		bindKeys( thePlayer, source )
		setTimer( checkLeavePickup, 500, 1, thePlayer, source ) 
	end
	cancelEvent() -- Stop it despawning
end
addEventHandler("onPickupHit", getResourceRootElement(), hitInteriorPickup)

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
	
	if exports.global:takeMoney(player, cost) then
		if (isHouse) then
			outputChatBox("Congratulations! You have just bought this house for $" .. cost .. ".", player, 255, 194, 14)
		elseif (isRentable) then
			outputChatBox("Congratulations! You are now renting this property for $" .. cost .. ".", player, 255, 194, 14)
		else
			outputChatBox("Congratulations! You have just bought this business for $" .. cost .. ".", player, 255, 194, 14)
		end
		
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		
		local inttype = getElementData( pickup, "inttype" )
		local ix, iy = getElementPosition( pickup )
		
		for key, value in pairs( intTable[pickupid] ) do
			destroyElement(value)
		end
		intTable[pickupid] = nil
		
		mysql_free_result( mysql_query( handler, "UPDATE interiors SET owner='" .. charid .. "', locked=0 WHERE id='" .. pickupid .. "'") )
		
		-- make sure it's an unqiue key
		call( getResourceFromName( "item-system" ), "deleteAll", 4, pickupid )
		call( getResourceFromName( "item-system" ), "deleteAll", 5, pickupid )
		
		if (isHouse) then
			-- Achievement
			exports.global:givePlayerAchievement(player, 9)
			exports.global:giveItem(player, 4, pickupid)
		elseif isRentable then
			exports.global:giveItem(player, 4, pickupid)
		else
			-- Achievement
			exports.global:givePlayerAchievement(player, 10)
			exports.global:giveItem(player, 5, pickupid)
		end
		
		reloadOneInterior(tonumber(pickupid), false, false)
		triggerClientEvent(player, "createBlipAtXY", player, inttype, ix, iy)
			
		playSoundFrontEnd(player, 20)
	else
		outputChatBox("Sorry, you cannot afford to purchase this property.", player, 255, 194, 14)
		playSoundFrontEnd(player, 1)
	end
end

function vehicleStartEnter(thePlayer)
	if getElementData(thePlayer, "interiormarker") then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), vehicleStartEnter)
addEventHandler("onVehicleStartExit", getRootElement(), vehicleStartEnter)

function enterInterior( thePlayer, thePickup )
	-- if the player is entering a pickup
	if thePickup and not getPedOccupiedVehicle(thePlayer) then
		-- if pickup and player are in the same place
		if getElementDimension(thePickup) == getElementDimension(thePlayer) then
		
			local inttype = getElementData(thePickup, "inttype")
			local locked = getElementData(thePickup, "locked")
			
			-- if the pickup collided with is an interior
			if getElementData(thePickup, "name") then
				local owner = getElementData(thePickup, "owner")
				local cost = getElementData(thePickup, "cost")
                
				-- if the interior is unlocked
				if locked == 0 then 
					setPlayerInsideInterior(thePickup, thePlayer)
				elseif locked == 1 and owner == -1 then
					if inttype == 0 then -- unowned house
						buyInterior(thePlayer, thePickup, cost, true, false)
					elseif inttype == 1 then -- unowned business
						buyInterior(thePlayer, thePickup, cost, false, false)
					elseif inttype == 3 then -- unowned rentable appartment
						buyInterior(thePlayer, thePickup, cost, false, true)
					end
				else -- interior is locked
					outputChatBox("You try the door handle, but it seems to be locked.", thePlayer, 255, 0,0, true)
				end
				
			-- if it is an exit marker, its unlocked or is government then
			else
				if locked == 0 then
					setPlayerInsideInterior( thePickup, thePlayer )
				else
					outputChatBox("You try the door handle, but it seems to be locked.", thePlayer, 255, 0,0, true)
				end
			end
		end
	end
end


function setPlayerInsideInterior(thePickup, thePlayer)
	-- check for entrance fee
	if getElementData( thePlayer, "adminduty" ) ~= 1 and not exports.global:hasItem( thePlayer, 5, getElementData( thePickup, "dbid" ) ) then
		local fee = getElementData( thePickup, "fee" )
		if fee and fee > 0 then
			if not exports.global:takeMoney( thePlayer, fee ) then
				outputChatBox( "You don't have enough money with you to enter this interior.", thePlayer, 255, 0, 0 )
				return
			else
				local ownerid = getElementData( thePickup, "owner" )
				local query = mysql_query( handler, "UPDATE characters SET bankmoney = bankmoney + " .. fee .. " WHERE id = " .. ownerid )
				if query then
					mysql_free_result( query )
					
					for k, v in pairs( getElementsByType( "player" ) ) do
						if isElement( v ) then
							if getElementData( v, "dbid" ) == ownerid then
								setElementData( v, "businessprofit", getElementData( v, "businessprofit" ) + fee, false )
								break
							end
						end
					end
				else
					outputChatBox( "Error 9018 - Report on Forums.", thePlayer, 255, 0, 0 )
				end
			end
		end
	end
	-- teleport the player inside the interior
	local other = getElementData( thePickup, "other" )
	if other then
		local dimension = getElementDimension( other )
		local interior = getElementInterior( other )
		local x, y, z = getElementPosition( other )
		local rot = getElementData(thePickup, "angle")
		
		-- fade camera to black
		fadeCamera ( thePlayer, false, 1,0,0,0 )
		setPedFrozen( thePlayer, true )
						
		-- teleport the player during the black fade
		setTimer(function(thePlayer, thePickup, other)
			setElementPosition(thePlayer, x, y, z)
			setElementInterior(thePlayer, interior)
			setElementDimension(thePlayer, dimension)
			setCameraInterior(thePlayer, interior)
			if rot then
				setPedRotation(thePlayer, rot)
			end
			
			triggerEvent("onPlayerInteriorChange", thePlayer, thePickup, other)
			
			-- fade camera in
			setTimer(fadeCamera, 1000, 1 , thePlayer , true, 2)
			setTimer(setPedFrozen, 2000, 1, thePlayer, false )
		end, 1000, 1, thePlayer, thePickup, other)
		
		local name = getElementData(thePickup, "name")
		if name then
			local owner = getElementData(thePickup, "owner")
			local inttype = getElementData(thePickup, "inttype")
			local cost = getElementData(thePickup, "cost")
			
			local ownerName = "None"
			local result = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
			
			if (mysql_num_rows(result)>0) then
				ownerName = mysql_result(result, 1, 1)
				ownerName = string.gsub(tostring(ownerName), "_", " ")
			end
			
			if (result) then
				mysql_free_result(result)
			end

			triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, inttype, cost, getElementData( thePickup, "fee" ))

			playSoundFrontEnd(thePlayer, 40)
		end
	end
end

function getNearbyInteriors(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Interiors:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local name = getElementData( thePickup, "name" )
			if name then
				local x, y, z = getElementPosition(thePickup)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					local dbid = getElementData(thePickup, "dbid")
					outputChatBox("   Interior with ID " .. dbid .. ": " .. name, thePlayer, 255, 126, 0)
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
		
			local query = mysql_query(handler, "UPDATE interiors SET name='" .. mysql_escape_string(handler, name) .. "' WHERE id='" .. id .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			outputChatBox("Interior name changed to ".. name ..".", thePlayer, 0, 255, 0) -- Output confirmation.
			
			-- update the name on the markers...
			for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData( thePickup, "dbid" )
				if dbid and dbid == id then
					if getElementData( thePickup, "name" ) then
						setElementData( thePickup, "name", name, false )
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
	if dbid == 0 then
		return 2
	elseif safeTable[dbid] then
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
		if dbid > 0 and safeTable[dbid] then
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

local function hasKey( source, key )
	return exports.global:hasItem(source, 4, key) or exports.global:hasItem(source, 5,key)
end
addEvent( "lockUnlockHouse",false )
addEventHandler( "lockUnlockHouse", getRootElement(),
	function( )
		local itemValue = nil
		local found = nil
		local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))
		for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local vx, vy, vz = getElementPosition(value)
			local x, y, z = getElementPosition(source)

			if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 5 then
				local dbid = getElementData(value, "dbid")
				if hasKey(source, dbid)then -- house found
					found = value
					itemValue = dbid
					break
				elseif getElementData( value, "other" ) and getElementParent( getElementParent( value ) ) == elevatorres then
					-- it's an elevator
					if hasKey(source, getElementDimension( value ) ) then
						found = value
						itemValue = getElementDimension( value )
						break
					elseif hasKey(source, getElementDimension( getElementData( value, "other" ) ) ) then
						found = value
						itemValue = getElementDimension( getElementData( value, "other" ) )
						break
					end
				end
			end
		end
		
		if found and itemValue then
			local result = mysql_query(handler, "SELECT 1-locked FROM interiors WHERE id = " .. itemValue)
			local locked = 0
			if result then
				locked = tonumber(mysql_result(result, 1, 1))
				mysql_free_result(result)
			end
			
			mysql_free_result( mysql_query(handler, "UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. itemValue .. "' LIMIT 1") )
			if locked == 0 then
				exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
			else
				exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
			end
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData(value, "dbid")
				if dbid == itemValue then
					setElementData(value, "locked", locked, false)
				end
			end
		else
			cancelEvent( )
		end	
	end
)

function setFee( thePlayer, commandName, theFee )
	if not theFee or not tonumber( theFee ) then
		outputChatBox( "SYNTAX: /" .. commandName .. " [Fee]", thePlayer, 255, 194, 14 )
	else
		local dbid, entrance, exit = findProperty( thePlayer )
		if entrance then
			local theFee = tonumber( theFee )
			if theFee >= 0 then
				if getElementData( entrance, "inttype" ) == 1 then
					if exports.global:isPlayerAdmin( thePlayer ) or getElementData( entrance, "owner" ) == getElementData( thePlayer, "dbid" ) then
						-- check if you can set a fee for that biz
						local x, y, z = getElementPosition( exit )
						local interior = getElementInterior( exit )
						
						local canHazFee, intID = false
						if exports.global:isPlayerSuperAdmin( thePlayer ) then
							canHazFee = true
						elseif getElementData( entrance, "fee" ) > 0 then
							canHazFee = true
						else
							for k, v in pairs( interiors ) do
								if interior == v[1] and getDistanceBetweenPoints3D( x, y, z, v[2], v[3], v[4] ) < 10 then
									if v[7] then
										canHazFee = true
									end
									intID = k
									break
								end
							end
						end
						
						if canHazFee then
							local query = mysql_query( handler, "UPDATE interiors SET fee = " .. theFee .. " WHERE id = " .. dbid )
							if query then
								mysql_free_result( query )
								setElementData( entrance, "fee", theFee )
								
								outputChatBox( "The entrance fee for '" .. getElementData( entrance, "name" ) .. "' is now $" .. theFee .. ".", thePlayer, 0, 255, 0 )
							else
								outputDebugString( "/" .. commandName .. ": " .. mysql_error( handler ) )
								outputChatBox( "Error 9017 - Report on Forums.", thePlayer, 255, 0, 0 )
							end
						else
							outputChatBox( "You can't charge a fee for this business.", thePlayer, 255, 0, 0 )
							outputDebugString( "Int Map ID: " .. tostring( intID ) ) 
						end
					else
						outputChatBox( "This business is not yours.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "This interior is no business.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You can only use positive values!", thePlayer, 255, 0, 0 )
			end
		else
			outputChatBox( "You are not in an interior!", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "setfee", setFee )

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

function gotoHouse( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty( thePlayer, houseID )
			if entrance then
				local dimension = getElementDimension( entrance )
				local interior = getElementInterior( entrance )
				local x, y, z = getElementPosition( entrance )
				
				setElementPosition(thePlayer, x, y, z)
				setElementInterior(thePlayer, interior)
				setElementDimension(thePlayer, dimension)
				setCameraInterior(thePlayer, interior)
				
				outputChatBox( "Teleported to House #" .. houseID, thePlayer, 0, 255, 0 )
			else
				outputChatBox( "Invalid House.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "gotohouse", gotoHouse )

function setInteriorID( thePlayer, commandName, interiorID )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		interiorID = tonumber( interiorID )
		if not interiorID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [interior id] - changes the house interior", thePlayer, 255, 194, 14 )
		elseif not interiors[interiorID] then
			outputChatBox( "Invalid ID.", thePlayer, 255, 0, 0 )
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				local interior = interiors[interiorID]
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local query = mysql_query(handler, "UPDATE interiors SET interior=" .. interiorw .. ", interiorx=" .. ix .. ", interiory=" .. iy .. ", interiorz=" .. iz .. ", angle=" .. optAngle .. " WHERE id=" .. dbid)
				if query then
					mysql_free_result( query )
					
					setElementPosition( exit, ix, iy, iz )
					setElementInterior( exit, interiorw )
					
					for key, value in pairs( getElementsByType( "player" ) ) do
						if isElement( value ) and getElementDimension( value ) == dbid then
							setElementPosition( value, ix, iy, iz )
							setElementInterior( value, interiorw )
							setCameraInterior( value, interiorw )
						end
					end
					
					outputChatBox( "Interior Updated.", thePlayer, 0, 255, 0 )
				else
					outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorid", setInteriorID )