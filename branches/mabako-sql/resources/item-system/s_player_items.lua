local playeritems = {}

addEvent("requestItems", true)
addEventHandler("requestItems", getRootElement(), function() loadPlayerItems(source) end)

function loadPlayerItems(player)
	local id = getElementData(player, "dbid")
	if id then
		local result = mysql_query( handler, 'SELECT * FROM items WHERE type=0 AND id=' .. id )
		if result then
			playeritems[player] = {}
			local count = 0
			repeat
				row = mysql_fetch_assoc(result)
				if row then
					count = count + 1
					playeritems[player][count] = { tonumber(row.itemid), tonumber(row.itemvalue) or row.itemvalue }
				end
			until not row
			outputChatBox("yay")
		else
			outputChatBox("fial")
		end
		sendPlayerItems(player, player)
	end
end

function getPlayerItems(player)
	return playeritems[player]
end

function doesPlayerHaveSpaceForItem(player)
	return #playeritems < getPlayerInventorySlots(player)
end

function getPlayerInventorySlots(player)
	if doesPlayerHaveItem(player, 48, 1) then
		return 20
	else
		return 10
	end
end

function doesPlayerHaveItem(player, id, value)
	for k, v in pairs(playeritems[player]) do
		if v[1] == id and ( value == -1 or value == v[2] ) then
			return true, k, v[2]
		end
	end
	return false
end

function givePlayerItem(player, id, value)
	if not doesPlayerHaveSpaceForItem(player) then
		return false
	end
	
	local result = mysql_query( handler, "INSERT INTO items (type, id, itemid, itemvalue) VALUES (0," .. getElementData(player, "dbid") .. "," .. id .. ",'" .. mysql_escape_string(handler, value) .. "')" ) 
	if result then
		playeritems[player][ #playeritems[player] + 1 ] = { id, value }
		mysql_free_result(result)
		sendPlayerItems(player, player)
		return true
	else
		outputChatBox( "Error 9003 - Report on Forums.", player, 255, 0, 0 )
		mysql_free_result(result)
		return false
	end
end
--addEvent("givePlayerItem", true)
--addEventHandler("givePlayerItem", getRootElement(), function( id, value ) givePlayerItem( source, id, value ) end )

function takePlayerItem(player, id, value)
	local hasitem, slot, value = doesPlayerHaveItem(player, id, value)
	if hasitem then
		takePlayerItemFromSlot(player, slot)
	end
end

function takePlayerItemFromSlot(player, slot)
	if playeritems[player][slot] then
		id = playeritems[player][slot][1]
		value = playeritems[player][slot][2]
		
		if id == 48 then -- backpack
			for i = 20, 11 do 
				takePlayerItemFromSlot(player, i)
			end
		end

		local result = mysql_query( handler, "DELETE FROM items WHERE type=0 AND id=" .. getElementData(player, "dbid") .. " AND itemid=" .. id .. " AND itemvalue='" .. mysql_escape_string(handler, value) .. "' LIMIT 1" ) 
		if result then
			-- shift following items from id to id-1 items
			for i = slot, getPlayerInventorySlots(player) do
				if playeritems[player][i+1] then
					playeritems[player][i] = playeritems[player][i+1]
					playeritems[player][i+1] = nil
				else
					playeritems[player][i] = nil
				end
			end
			sendPlayerItems(player, player)
		end
	end
end

--addEvent("takePlayerItem", true)
--addEventHandler("takePlayerItem", getRootElement(), function( id, value ) takePlayerItem( source, id, value ) end )

function sendPlayerItems(player, target)
	if not target then
		target = getRootElement()
	end
	
	triggerClientEvent(target, "recieveItems", player, getPlayerItems(player))
end

addEventHandler( "onPlayerQuit", getRootElement(), function() playeritems[source] = nil end )