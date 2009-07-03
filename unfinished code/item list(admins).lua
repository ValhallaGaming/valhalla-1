---------------
-- Server side
---------------
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
			triggerClientEvent(thePlayer, "showItemList", getRootElement(), factions)
		else
			outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("itemlist", adminItemList, false, false)


--------------
-- Client side
-------------

wItemList, bItemListClose = nil
function showItemList(items)
	if not (wItemsList) then
		wItemsList = guiCreateWindow(0.15, 0.15, 0.7, 0.7, "Items List", true)
		local gridItems = guiCreateGridList(0.025, 0.1, 0.95, 0.775, true, wItemsList)
		
		local colID = guiGridListAddColumn(gridItems, "ID", 0.18)
		local colName = guiGridListAddColumn(gridItems, "Item Name", 0.6)
		local colType = guiGridListAddColumn(gridItems, "Description", 0.18)
		local scrollPane = guiCreateScrollPane(0.02, 0.02, 0.95, 0.95, true, wItemsList)
		
		for key, value in pairs(items) do
			local itemID = factions[key][1]
			local itemName = tostring(factions[key][2])
			local itemDescription = tonumber(factions[key][3])

			local row = guiGridListAddRow(gridFactions)
			guiGridListSetItemText(gridFactions, row, colID, itemID, false, true)
			guiGridListSetItemText(gridFactions, row, colName, itemName, false, false)
			guiGridListSetItemText(gridFactions, row, colType, itemDescription, false, false)
		end

		bItemListClose = guiCreateButton(0.025, 0.9, 0.95, 0.1, "Close", true, wItemsList)
		addEventHandler("onClientGUIClick", bItemsListClose, closeItemsList, false)
		
		showCursor(true)
	else
		guiSetVisible(wFactionList, true)
		guiBringToFront(wFactionList)
		showCursor(true)
	end
end
addEvent("showItemList", true)
addEventHandler("showItemList", getRootElement(), showItemList)

function closeItemsList(button, state)
	if (source==bItemsListClose) and (button=="left") and (state=="up") then
		showCursor(false)
		guiSetInputEnabled(false)
		destroyElement(wItemsList)
		wItemsList, bItemsListClose = nil, nil
	end
end