wItems, gItems, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil
toggleLabel, chkFood, chkKeys, chkDrugs, chkOther, chkBooks, chkClothes, chkElectronics, chkEmpty = nil

wRightClick = nil
bPickup = nil
bCloseMenu = nil
ax, ay = nil
item = nil

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true

showPlayer = nil

function clickItem(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="object") and (button=="right") and (state=="down") then
		local objtype = getElementData(element, "type")
		local pickedup = getElementData(element, "pickedup")
		
		local x, y, z = getElementPosition(getLocalPlayer())
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<3) then
			if (objtype) and not (pickedup) then
				if (objtype=="worlditem") then
					if (wRightClick) then
						hideItemMenu()
					end
					showCursor(true)
					ax = absX
					ay = absY
					item = element
					showItemMenu()
				end
			end
		else
			outputChatBox("You are too far away from that item.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)

function showItemMenu()
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue")
	
	if itemID >= 0 then
		itemName = getItemName(itemID)
	elseif itemID == -100 then
		itemName = "Body Armor"
	else
		itemName = getWeaponNameFromID(-itemID)
	end
	
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName .. " (" .. itemValue .. ")", false)
	
	bPickup = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Pick Item Up", true, wRightClick)
	addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	
	bCloseMenu = guiCreateButton(0.05, 0.27, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
end

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil
	
	ax = nil
	ay = nil

	item = nil

	showCursor(false)
	triggerEvent("cursorHide", getLocalPlayer())
end

function pickupItem(button, state)
	if (button=="left") then
		local restrain = getElementData(getLocalPlayer(), "restrain")
		
		if (restrain) and (restrain==1) then
			outputChatBox("You are cuffed.", 255, 0, 0)
		else
			local itemID = getElementData(item, "itemID")
			local itemValue = getElementData(item, "itemValue")
			local itemName = getElementData(item, "itemName")
			setElementData(item, "pickedup", true)
			showCursor(false)
			triggerEvent("cursorHide", getLocalPlayer())
			triggerServerEvent("pickupItem", getLocalPlayer(), item, itemID, itemValue, itemName)
			hideItemMenu()
		end
	end
end
	
function toggleCategory()
	if (source==chkFood) then
		showFood = not showFood
	elseif (source==chkKeys) then
		showKeys = not showKeys
	elseif (source==chkDrugs) then
		showDrugs = not showDrugs
	elseif (source==chkBooks) then
		showBooks = not showBooks
	elseif (source==chkClothes) then
		showClothes = not showClothes
	elseif (source==chkElectronics) then
		showElectronics = not showElectronics
	elseif (source==chkOther) then
		showOther = not showOther
	elseif (source==chkEmpty) then
		showEmpty = not showEmpty
	end
	
	-- let's add the items again
	guiGridListClear(gItems)
	local items = getPlayerItems(getLocalPlayer())
	for i = 1, getPlayerInventorySlots(getLocalPlayer()) do
		if (items[i]==nil) then
			if (showEmpty) then
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			end
		else
			local itemtype = getItemType(items[i][1])
	
			if not (itemtype) then
				return
			else
				local add = true
				
				if (itemtype==1) and not (showFood) then
					add = false
				elseif (itemtype==2) and not (showKeys) then
					add = false
				elseif (itemtype==3) and not (showDrugs) then
					add = false
				elseif (itemtype==4) and not (showOther) then
					add = false
				elseif (itemtype==5) and not (showBooks) then
					add = false
				elseif (itemtype==6) and not (showClothes) then
					add = false
				elseif (itemtype==7) and not (showElectronics) then
					add = false
				elseif (itemtype==false) then
					add = false
				end
				
				if (add) then
					local row = guiGridListAddRow(gItems)
					guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
					guiGridListSetItemData(gItems, row, colSlot, i)
					guiGridListSetItemText(gItems, row, colName, getItemName(items[i][1]), false, false)
					guiGridListSetItemText(gItems, row, colValue, tostring(items[i][2]), false, false)
				end
			end
		end
	end
end

function toggleInventory()
	if wItems then
		hideInventory()
	elseif not getElementData(getLocalPlayer(), "adminjailed") and not getElementData(getLocalPlayer(), "pd.jailstation") then
		showInventory(getLocalPlayer())
	else
		outputChatBox("You can't access your inventory in jail", 255, 0, 0)
	end
end
bindKey("i", "down", toggleInventory)

function showInventory(player)
	if not (wChemistrySet) then
		if wItems then
			hideInventory()
		end
		showPlayer = player
		local width, height = 600, 500
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		local title = "Inventory"
		if player ~= getLocalPlayer() then
			title = title .. " of " .. getPlayerName(player)
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)

		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.7, true, wItems)
		tabItems = guiCreateTab("Items", tabPanel)
		tabWeapons = guiCreateTab("Weapons", tabPanel)
		
		-- ITEMS
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIClick", gItems, showDescription, false)
		
		
		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Name", 0.625)
		colValue = guiGridListAddColumn(gItems, "Value", 0.225)
		
		-- type checkboxes
		toggleLabel = guiCreateLabel(0.025, 0.77, 0.95, 0.9, "Toggle Item Types:", true, wItems)
		guiSetFont(toggleLabel, "default-bold-small")
		
		chkFood = guiCreateCheckBox(0.025, 0.8, 0.15, 0.05, "Food & Drink", showFood, true, wItems)
		chkKeys = guiCreateCheckBox(0.2, 0.8, 0.1, 0.05, "Keys", showKeys, true, wItems)
		chkDrugs = guiCreateCheckBox(0.3, 0.8, 0.1, 0.05, "Drugs", showDrugs, true, wItems)
		chkBooks = guiCreateCheckBox(0.4, 0.8, 0.1, 0.05, "Books", showBooks, true, wItems)
		chkClothes = guiCreateCheckBox(0.5, 0.8, 0.125, 0.05, "Clothing", showClothes, true, wItems)
		chkElectronics = guiCreateCheckBox(0.625, 0.8, 0.15, 0.05, "Electronics", showElectronics, true, wItems)
		chkOther = guiCreateCheckBox(0.775, 0.8, 0.1, 0.05, "Other", showOther, true, wItems)
		chkEmpty = guiCreateCheckBox(0.875, 0.8, 0.1, 0.05, "Empty", showEmpty, true, wItems)
		
		addEventHandler("onClientGUIClick", chkFood, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkKeys, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkDrugs, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkBooks, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkClothes, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkElectronics, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkOther, toggleCategory, false)
		addEventHandler("onClientGUIClick", chkEmpty, toggleCategory, false)

		source = nil
		toggleCategory()
		
		addEventHandler("onClientGUIDoubleClick", gItems, useItem, false)

		-- WEAPONS
		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
		
		
		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Name", 0.625)
		colWValue = guiGridListAddColumn(gWeapons, "Ammo", 0.225)
		for i = 0, 12 do
			if (getWeaponNameFromID(getPedWeapon(player, i))~="Melee") and (getPedTotalAmmo(player,i)>0) then
				local row = guiGridListAddRow(gWeapons)
				local weapon = getWeaponNameFromID(getPedWeapon(player, i))
				local ammo = getPedTotalAmmo(player, i)
				guiGridListSetItemText(gWeapons, row, colWSlot, tostring(i), false, true)
				guiGridListSetItemText(gWeapons, row, colWName, weapon, false, false)
				guiGridListSetItemText(gWeapons, row, colWValue, tostring(ammo), false, false)
			end
		end
		guiSetVisible(colWSlot, false)
		
		addEventHandler("onClientGUIDoubleClick", gWeapons, useItem, false)
		
		-- ARMOR
		if getPedArmor(player) > 0 then
			local row = guiGridListAddRow(gWeapons)
			guiGridListSetItemText(gWeapons, row, colWSlot, "13", false, true)
			guiGridListSetItemText(gWeapons, row, colWName, "Body Armor", false, false)
			guiGridListSetItemText(gWeapons, row, colWValue, tostring(getPedArmor(player)), false, false)
		end
		
		-- GENERAL
		lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Click an item to see it's description.", true, wItems)
		guiLabelSetHorizontalAlign(lDescription, "center", true)
		guiSetFont(lDescription, "default-bold-small")
		
		-- buttons
		if player == getLocalPlayer() then
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
		else
			bClose = guiCreateButton(0.375, 0.91, 0.2, 0.15, "Close Inventory", true, wItems)
			addEventHandler("onClientGUIClick", bClose, hideInventory)
		end
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function hideInventory()
	showPlayer = nil
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
				
				items = getPlayerItems(getLocalPlayer())
				if (items[slot]==nil) then
					guiSetText(lDescription, "An empty slot.")
					guiSetEnabled(bUseItem, false)
					guiSetEnabled(bDropItem, false)
					guiSetEnabled(bShowItem, false)
					guiSetEnabled(bDestroyItem, false)
				else
					local desc = getItemDescription(items[slot][1])
					local value = tonumber(items[slot][2])
					
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
	if getElementHealth(getLocalPlayer()) == 0 then return end
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local slot = tonumber(guiGridListGetItemText(gItems, row, 1))
			if items[slot] then
				itemID = items[slot][1]
				
				if (itemID==57) then -- FUEL CAN
					hideInventory()
				end
				
				if (itemID==44) then
					hideInventory()
					showChemistrySet()
					return
				end
				
				if (itemID==34) then -- COCAINE
					doDrug1Effect()
				elseif (itemID==35) then
					doDrug2Effect()
				elseif (itemID==36) then
					doDrug3Effect()
				elseif (itemID==37) then
					doDrug4Effect()
				elseif (itemID==38) then
					doDrug5Effect()
				elseif (itemID==39) then
					doDrug6Effect()
				elseif (itemID==40) then
					doDrug3Effect()
					doDrug1Effect()
				elseif (itemID==41) then
					doDrug4Effect()
					doDrug6Effect()
				elseif (itemID==42) then
					doDrug5Effect()
					doDrug2Effect()
				elseif (itemID==43) then
					doDrug4Effect()
					doDrug1Effect()
					doDrug6Effect()
				end
				
				if (itemID==50) or (itemID==51) or (itemID==52) then
					hideInventory()
				end
				
				if itemID == 54 then
					groundz = getGroundPosition(getElementPosition(getLocalPlayer()))
				end
				
				triggerServerEvent("useItem", getLocalPlayer(), itemID, getItemName(itemID), items[slot][2], false, groundz)
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local slot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			setPedWeaponSlot(getLocalPlayer(), slot)
		end
	end
end

function destroyItem(button)
	if getElementHealth(getLocalPlayer()) == 0 then return end
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gItems)
		local slot = tonumber(guiGridListGetItemText(gItems, row, 1))
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			triggerServerEvent("destroyItem", getLocalPlayer(), slot)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			guiGridListRemoveRow(gItems, row)
			
			local weapon = -1
			if slot >= 0 and slot <= 12 then
				weapon = getPedWeapon(getLocalPlayer(), slot)
			end
			triggerServerEvent("destroyItem", getLocalPlayer(), -1, weapon)
		end
	end
end

function dropItem(button)
	if getElementHealth(getLocalPlayer()) == 0 then return end
	if (button=="left") then
		local restrain = getElementData(getLocalPlayer(), "restrain")
		
		if (restrain) and (restrain==1) then
			outputChatBox("You are cuffed.", 255, 0, 0)
		else
			if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
				local row, col = guiGridListGetSelectedItem(gItems)
				local slot = tonumber(guiGridListGetItemText(gItems, row, 1))
				local item = getPlayerItems(getLocalPlayer())[slot]
				if item[1] == 60 then
					outputChatBox("This item cannot be dropped.", 255, 0, 0)
					return
				end
				
				local x, y, z = getElementPosition(getLocalPlayer())
				local rot = getPedRotation(getLocalPlayer())
				x = x + math.sin( math.rad( rot ) ) * 1
				y = y + math.cos( math.rad( rot ) ) * 1
				
				local gz = getGroundPosition(x, y, z)
				triggerServerEvent("dropItem", getLocalPlayer(), slot, false, false, x, y, gz)
			elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
				local row, col = guiGridListGetSelectedItem(gWeapons)
				local slot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
				local weapon = getPedWeapon(getLocalPlayer(), slot)
				local ammo = getPedTotalAmmo(getLocalPlayer(), slot)

				guiGridListRemoveRow(gWeapons, row)
				
				local x, y, z = getElementPosition(getLocalPlayer())
				local rot = getPedRotation(getLocalPlayer())
				x = x + math.sin( math.rad( rot ) ) * 1
				y = y + math.cos( math.rad( rot ) ) * 1
				
				local gz = getGroundPosition(x, y, z)
				
				triggerServerEvent("dropItem", getLocalPlayer(), weapon, ammo, false, x, y, gz)
			end
		end
	end
end

function showItem(button)
	if getElementHealth(getLocalPlayer()) == 0 then return end
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

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(getLocalPlayer(), "gasmask")

	if (weapon==17 or weapon==41) and (gasmask==1) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopGasmaskDamage)

-- /itemlist (admin command to get item IDs)
wItemList, bItemListClose = nil

function showItemList()
	if not wItemsList then
		wItemsList = guiCreateWindow(0.15, 0.15, 0.7, 0.7, "Items List", true)
		local gridItems = guiCreateGridList(0.025, 0.1, 0.95, 0.775, true, wItemsList)
		
		local colID = guiGridListAddColumn(gridItems, "ID", 0.1)
		local colName = guiGridListAddColumn(gridItems, "Item Name", 0.3)
		local colDesc = guiGridListAddColumn(gridItems, "Description", 0.6)
		
		for key, value in pairs(g_items) do
			local row = guiGridListAddRow(gridItems)
			guiGridListSetItemText(gridItems, row, colID, tostring(key), false, true)
			guiGridListSetItemText(gridItems, row, colName, value[1], false, false)
			guiGridListSetItemText(gridItems, row, colDesc, value[2], false, false)
		end

		bItemListClose = guiCreateButton(0.025, 0.9, 0.95, 0.1, "Close", true, wItemsList)
		addEventHandler("onClientGUIClick", bItemListClose, closeItemsList, false)
		
		showCursor(true)
	else
		guiSetVisible(wItemsList, true)
		guiBringToFront(wItemsList)
		showCursor(true)
	end
end
addCommandHandler("itemlist", showItemList)

function closeItemsList(button, state)
	if (source==bItemListClose) and (button=="left") and (state=="up") then
		showCursor(false)
		destroyElement(bItemListClose)
		destroyElement(wItemsList)
		bItemListClose = nil
		wItemsList = nil
	end
end

function checkUpdate(items)
	setTimer(
		function(player) 
			if wItems and player == showPlayer then
				source = nil
				toggleCategory()
			end
		end, 50, 1, source)
end
addEventHandler( "recieveItems", getRootElement(), checkUpdate )

addEventHandler( "onClientChangeChar", getRootElement(), hideInventory)