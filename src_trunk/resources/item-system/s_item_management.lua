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
		handler = nil
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

--[[
x loadItems(obj) -- loads all items (caching)
x sendItems(obj, to) -- sends the items to the player

x giveItem(obj, itemID, itemValue, nosqlupdate) -- gives an item
x takeItem(obj, itemID, itemValue = nil) -- takes the item, or if nil/false, the first one with the same item ID
x takeItemFromSlot(obj, slot, nosqlupdate) -- ...

x moveItem(from, to, slot) -- moves an item from any inventory to another (was on from's specified slot before, true if successful, internally only updates the owner in the DB and modifies the arrays

x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj) -- returns true if you can put more stuff in

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getInventorySlots(obj) -- returns the number of available inventory slots
]]--

local saveditems = {}
local subscribers = {}

-- Free Items Table as neccessary
local function destroyInventory( )
	saveditems[source] = nil
	subscribers[source] = nil
	
	-- clear subscriptions
	for key, value in pairs( subscribers ) do
		if value[ source ] then
			value[ source ] = nil
		end
	end
end

addEventHandler( "onElementDestroy", getRootElement(), destroyInventory )
addEventHandler( "onPlayerQuit", getRootElement(), destroyInventory )

-- send items to a player
local function sendItems( element, to )
	loadItems( element )
	triggerClientEvent( to, "recieveItems", element, saveditems[ element ] )
end

-- subscribe/remove from inventory changes
local function subscribeChanges( element )
	sendItems( element, source )
	subscribers[ element ][ source ] = true
end

addEvent( "subscribeToInventoryChanges", true )
addEventHandler( "subscribeToInventoryChanges", getRootElement(), subscribeChanges )

--

local function unsubscribeChanges( element )
	subscribers[ element ][ source ] = nil
	triggerClientEvent( source, "recieveItems", element, nil )
end

addEvent( "unsubscribeFromInventoryChanges", true )
addEventHandler( "unsubscribeFromInventoryChanges", getRootElement(), subscribeChanges )

-- notify all subscribers on inventory change
local function notify( element )
	if subscribers[ element ] then
		for subscriber in pairs( subscribers[ element ] ) do
			sendItems( element, subscriber )
		end
	end
end

-- returns the 'owner' column content
local function getID(element)
	if getElementType(element) == "player" then -- Player
		return getElementData(element, "dbid")
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return getElementData(element, "dbid")
	elseif getElementType(element) == "object" then -- Safe
		return getElementDimension(element)
	else
		return 0
	end
end

-- returns the 'type' column content
local function getType(element)
	if getElementType(element) == "player" then -- Player
		return 1
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return 2
	elseif getElementType(element) == "object" then -- Safe
		return 3
	else
		return 255
	end
end

-- loads all items for that element
function loadItems( element )
	if not saveditems[ element ] then
		local result = mysql_query( handler, "SELECT * FROM items WHERE type = " .. getType( element ) .. " AND owner = " .. getID( element ) )
		if result then
			saveditems[ element ] = {}
			
			local count = 0
			repeat
				row = mysql_fetch_assoc(result)
				if row then
					count = count + 1
					saveditems[element][count] = { tonumber( row.itemID ), tonumber( row.itemValue ) or row.itemValue, tonumber( row.index ) }
				end
			until not row
			
			subscribers[ element ] = {}
			if getElementType( element ) == "player" then
				subscribers[ element ][ element ] = true
				notify( element )
			end
			
			return true
		else
			outputDebugString( mysql_error( handler ) )
			return false
		end
	else
		return true
	end
end

-- load items for all logged in players on resource start
function itemResourceStarted( )
	if getID( source ) then
		loadItems( source )
	end
end
addEvent( "itemResourceStarted", true )
addEventHandler( "itemResourceStarted", getRootElement( ), itemResourceStarted )

-- gives an item to an element
function giveItem( element, itemID, itemValue, itemIndex )
	loadItems( element )
	
	if not hasSpaceForItem( element ) then
		return false, "Inventory is Full"
	end
	
	if not itemIndex then
		local result = mysql_query( handler, "INSERT INTO items (type, owner, itemID, itemValue) VALUES (" .. getType( element ) .. "," .. getID( element ) .. "," .. itemID .. ",'" .. mysql_escape_string(handler, itemValue) .. "')" )
		if result then
			itemIndex = mysql_insert_id( handler )
			mysql_free_result( result )
		else
			outputDebugString( mysql_error( handler ) )
			return false, "MySQL Error"
		end
	end
	
	saveditems[element][ #saveditems[element] + 1 ] = { itemID, itemValue, itemIndex }
	notify( element )
	return true
end

-- takes an item from the element
function takeItem(element, itemID, itemValue)
	loadItems( element )

	local success, slot = hasItem(element, itemID, itemValue)
	if success then
		takeItemFromSlot(element, slot)
		return true
	else
		return false
	end
end

-- permanently removes an item from an element
function takeItemFromSlot(element, slot, nosqlupdate)
	loadItems( element )

	if saveditems[element][slot] then
		id = saveditems[element][slot][1]
		value = saveditems[element][slot][2]
		
		-- special case backpack
		if id == 48 then -- backpack
			for i = 20, 11 do 
				takeItemFromSlot(element, i)
			end
		end

		local success = true
		if not nosqlupdate then
			local result = mysql_query( handler, "DELETE FROM items WHERE type = " .. getType(element) .. " AND owner = " .. getID(element) .. " AND itemID = " .. id .. " AND itemValue = '" .. mysql_escape_string(handler, value) .. "' LIMIT 1" )
			if result then
				mysql_free_result( result )
			else
				success = false
			end
		end
		
		if success then
			-- shift following items from id to id-1 items
			table.remove( saveditems[element], slot )
			notify( element )
			return true
		end
	end
	return false
end

-- moves an item from any element to another element
function moveItem(from, to, slot)
	loadItems( from )
	loadItems( to )

	if saveditems[from] and saveditems[from][slot] then
		if hasSpaceForItem(to) then
			local itemIndex = saveditems[from][slot][3]
			if itemIndex then
				local query = mysql_query( handler, "UPDATE items SET type = " .. getType(to) .. ", owner = " .. getID(to) .. " WHERE index = " .. itemIndex )
				if query then
					mysql_free_result( query )
					
					local itemID = saveditems[from][slot][1]
					local itemValue = saveditems[from][slot][2]
					
					takeItemFromSlot(from, slot, false)
					giveItem(to, itemID, itemValue, itemIndex)

					return true
				else
					outputDebugString( mysql_error( handler ) )
					return false, "MySQL-Query failed."
				end
			else
				return false, "Item does not exist."
			end
		else
			return false, "Target does not have Space for Item."
		end
	else
		return false, "Slot does not exist."
	end
end

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	loadItems( element )

	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			return true, key, value[2], value[3]
		end
	end
	return false
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element)
	loadItems( element )
	return #getItems(element) < getInventorySlots(element)
end

-- returns a list of all items of that element
function getItems(element)
	loadItems( element )
	return saveditems[element]
end

-- returns the number of available item slots for that element
function getInventorySlots(element)
	if getElementType( element ) == "player" then
		if hasItem(element, 48) then
			return 20
		else
			return 10
		end
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return 0
		else
			return 20
		end
	else
		return 20
	end
end
