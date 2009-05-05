wItems, gItems, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

function pickupItem(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (clickedElement) then
		if (getElementType(clickedElement)=="object") then
			local objtype = getElementData(clickedElement, "type")
			local pickedup = getElementData(clickedElement, "pickedup")
			
			if (objtype) and not (pickedup) then
				if (objtype=="worlditem") then
					local id = getElementData(clickedElement, "id")
					local itemID = getElementData(clickedElement, "itemID")
					local itemValue = getElementData(clickedElement, "itemValue")
					local itemName = getElementData(clickedElement, "itemName")
					setElementData(clickedElement, "pickedup", true)
					triggerServerEvent("pickupItem", getLocalPlayer(), clickedElement, id, itemID, itemValue, itemName)
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), pickupItem)

function showInventory(tableitems)
	local width, height = 600, 500
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wItems = guiCreateWindow(x, y, width, height, "Inventory", false)
	guiWindowSetSizable(wItems, false)
	
	items = tableitems
	
	tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.8, true, wItems)
	tabItems = guiCreateTab("Items", tabPanel)
	tabWeapons = guiCreateTab("Weapons", tabPanel)
	
	
	-- ITEMS
	gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.8, true, tabItems)
	addEventHandler("onClientGUIClick", gItems, showDescription, false)
	
	
	colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
	colName = guiGridListAddColumn(gItems, "Name", 0.625)
	colValue = guiGridListAddColumn(gItems, "Value", 0.225)
	
	local itemvalues = getElementData(getLocalPlayer(), "itemvalues")
	
	for i = 1, 30 do
		if (items[i]==nil) then
			local row = guiGridListAddRow(gItems)
			guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
			guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
			guiGridListSetItemText(gItems, row, colValue, "None", false, false)
		else
			local row = guiGridListAddRow(gItems)
			local itemvalue = gettok(itemvalues, i, string.byte(','))
			guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
			guiGridListSetItemText(gItems, row, colName, tostring(items[i][1]), false, false)
			guiGridListSetItemText(gItems, row, colValue, tostring(itemvalue), false, false)
		end
	end
	
	addEventHandler("onClientGUIDoubleClick", gItems, useItem, false)

	-- WEAPONS
	gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.8, true, tabWeapons)
	addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
	
	
	colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
	colWName = guiGridListAddColumn(gWeapons, "Name", 0.625)
	colWValue = guiGridListAddColumn(gWeapons, "Ammo", 0.225)
	for i = 1, 12 do
		if (getWeaponNameFromID(getPedWeapon(getLocalPlayer(), i))~="Melee") then
			local row = guiGridListAddRow(gWeapons)
			local weapon = getWeaponNameFromID(getPedWeapon(getLocalPlayer(), i))
			local ammo = getPedTotalAmmo(getLocalPlayer(), i)
			guiGridListSetItemText(gWeapons, row, colWSlot, tostring(i), false, true)
			guiGridListSetItemText(gWeapons, row, colWName, tostring(weapon), false, false)
			guiGridListSetItemText(gWeapons, row, colWValue, tostring(ammo), false, false)
		end
	end
	guiSetVisible(colWSlot, false)
	
	addEventHandler("onClientGUIDoubleClick", gWeapons, useItem, false)
	
	-- ARMOR
	if (getPedArmor(getLocalPlayer())>0) then
		local row = guiGridListAddRow(gWeapons)
		guiGridListSetItemText(gWeapons, row, colWSlot, tostring(13), false, true)
		guiGridListSetItemText(gWeapons, row, colWName, "Body Armor", false, false)
		guiGridListSetItemText(gWeapons, row, colWValue, tostring(getPedArmor(getLocalPlayer())), false, false)
	end
	
	-- GENERAL
	lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Click an item to see it's description.", true, wItems)
	guiLabelSetHorizontalAlign(lDescription, "center", true)
	guiSetFont(lDescription, "default-bold-small")
	
	-- buttons
	bUseItem = guiCreateButton(0.05, 0.91, 0.2, 0.15, "Use Item", true, wItems)
	addEventHandler("onClientGUIClick", bUseItem, useItem, false)
	guiSetEnabled(bUseItem, false)
	
	bDropItem = guiCreateButton(0.30, 0.91, 0.2, 0.15, "Drop Item", true, wItems)
	addEventHandler("onClientGUIClick", bDropItem, dropItem, false)
	guiSetEnabled(bDropItem, false)
	
	bShowItem = guiCreateButton(0.55, 0.91, 0.2, 0.15, "Show Item", true, wItems)
	addEventHandler("onClientGUIClick", bShowItem, showItem, false)
	guiSetEnabled(bShowItem, false)
	
	bDestroyItem = guiCreateButton(0.8, 0.91, 0.2, 0.15, "Destroy Item", true, wItems)
	addEventHandler("onClientGUIClick", bDestroyItem, destroyItem, false)
	guiSetEnabled(bDestroyItem, false)

	showCursor(true)
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	
	destroyElement(gItems)
	gItems = nil
	
	destroyElement(lDescription)
	lDescription = nil
	
	items = nil
	
	destroyElement(gWeapons)
	gWeapons = nil
	
	colWSlot = nil
	colWName = nil
	colWValue = nil
	
	destroyElement(tabItems)
	tabItems = nil
	
	destroyElement(tabWeapons)
	tabWeapons = nil
	
	destroyElement(tabPanel)
	tabPanel = nil
	
	destroyElement(wItems)
	wItems = nil
	
	showCursor(false)
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", getRootElement(), hideInventory)

function showDescription(button, state)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Click an item to see it's description.")
				guiSetEnabled(bUseItem, false)
				guiSetEnabled(bDropItem, false)
				guiSetEnabled(bShowItem, false)
				guiSetEnabled(bDestroyItem, false)
			else
				local slot = tonumber(guiGridListGetItemText(gItems, row, 1))
				
				if (items[slot]==nil) then
					guiSetText(lDescription, "An empty slot.")
					guiSetEnabled(bUseItem, false)
					guiSetEnabled(bDropItem, false)
					guiSetEnabled(bShowItem, false)
					guiSetEnabled(bDestroyItem, false)
				else
					local desc = tostring(items[slot][2])
					local value = tonumber(guiGridListGetItemText(gItems, row, 3))
					
					-- percent operators
					desc = string.gsub((desc), "#v", tostring(value))
					
					guiSetText(lDescription, desc)
					guiSetEnabled(bUseItem, true)
					guiSetEnabled(bDropItem, true)
					guiSetEnabled(bShowItem, true)
					guiSetEnabled(bDestroyItem, true)
				end
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Click an item to see it's description.")
				guiSetEnabled(bUseItem, false)
				guiSetEnabled(bDropItem, false)
				guiSetEnabled(bShowItem, false)
				guiSetEnabled(bDestroyItem, false)
			else
				local name = tostring(guiGridListGetItemText(gWeapons, row, 2))
				local ammo = tostring(guiGridListGetItemText(gWeapons, row, 3))
				local desc = "A " .. name .. " with " .. ammo .. " ammunition."
					
				guiSetText(lDescription, desc)
				guiSetEnabled(bUseItem, true)
				guiSetEnabled(bDropItem, true)
				guiSetEnabled(bShowItem, true)
				guiSetEnabled(bDestroyItem, true)
			end
		end
	end
end

function useItem(button)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local itemName = tostring(guiGridListGetItemText(gItems, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gItems, row, 3))
			local itemID = tonumber(items[itemSlot][3])
			triggerServerEvent("useItem", getLocalPlayer(), itemID, itemName, itemValue)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemName = tostring(guiGridListGetItemText(gWeapons, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gWeapons, row, 3))
			local itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
			triggerServerEvent("useItem", getLocalPlayer(), itemSlot, itemName, itemValue, true)
		end
	end
end

function destroyItem(button)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local itemName = items[itemSlot][1]
			local itemID = items[itemSlot][3]
			local itemValue = items[itemSlot][4]
			
			guiGridListSetSelectedItem(gItems, 0, 0)
			guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
			guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			guiGridListSetSelectedItem(gItems, row, col)
			guiSetText(lDescription, "An empty slot.")
			guiSetEnabled(bUseItem, false)
			guiSetEnabled(bDropItem, false)
			guiSetEnabled(bShowItem, false)
			guiSetEnabled(bDestroyItem, false)
			
			triggerServerEvent("destroyItem", getLocalPlayer(), itemID, itemValue, itemName)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemName = tostring(guiGridListGetItemText(gWeapons, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gWeapons, row, 3))
			local itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
			
			guiGridListSetSelectedItem(gWeapons, 0, 0)
			guiGridListSetItemText(gWeapons, row, colName, "Empty", false, false)
			guiGridListSetItemText(gWeapons, row, colValue, "None", false, false)
			guiGridListSetSelectedItem(gWeapons, row, col)
			guiSetText(lDescription, "An empty slot.")
			guiSetEnabled(bUseItem, false)
			guiSetEnabled(bDropItem, false)
			guiSetEnabled(bShowItem, false)
			guiSetEnabled(bDestroyItem, false)
			
			triggerServerEvent("destroyItem", getLocalPlayer(), itemID, itemValue, itemName, true)
		end
	end
end

function dropItem(button)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local itemName = items[itemSlot][1]
			local itemID = items[itemSlot][3]
			local itemValue = items[itemSlot][4]
			
			guiGridListSetSelectedItem(gItems, 0, 0)
			guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
			guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			guiGridListSetSelectedItem(gItems, row, col)
			guiSetText(lDescription, "An empty slot.")
			guiSetEnabled(bUseItem, false)
			guiSetEnabled(bDropItem, false)
			guiSetEnabled(bShowItem, false)
			guiSetEnabled(bDestroyItem, false)
			
			local x, y, z = getElementPosition(getLocalPlayer())
			local rot = getPedRotation(getLocalPlayer())
			x = x - math.sin( math.rad( rot ) ) * 1
			y = y - math.cos( math.rad( rot ) ) * 1
			
			local gz = getGroundPosition(x, y, z)
			triggerServerEvent("dropItem", getLocalPlayer(), itemID, itemValue, itemName, x, y, z, gz)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemName = tostring(guiGridListGetItemText(gWeapons, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gWeapons, row, 3))
			local itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
			
			guiGridListSetSelectedItem(gWeapons, 0, 0)
			guiGridListSetItemText(gWeapons, row, colName, "Empty", false, false)
			guiGridListSetItemText(gWeapons, row, colValue, "None", false, false)
			guiGridListSetSelectedItem(gWeapons, row, col)
			guiSetText(lDescription, "An empty slot.")
			guiSetEnabled(bUseItem, false)
			guiSetEnabled(bDropItem, false)
			guiSetEnabled(bShowItem, false)
			guiSetEnabled(bDestroyItem, false)
			
			local x, y, z = getElementPosition(getLocalPlayer())
			local rot = getPedRotation(getLocalPlayer())
			x = x + math.sin( math.rad( rot ) ) * 1
			y = y + math.cos( math.rad( rot ) ) * 1
			
			local gz = getGroundPosition(x, y, z)
			
			triggerServerEvent("dropItem", getLocalPlayer(), itemID, itemValue, itemName, x, y, z, gz, true)
		end
	end
end

function showItem(button)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemName = guiGridListGetItemText(gItems, row, 2)
			triggerServerEvent("showItem", getLocalPlayer(), itemName)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemName = guiGridListGetItemText(gWeapons, row, 2)
			triggerServerEvent("showItem", getLocalPlayer(), itemName)
		end
	end
end