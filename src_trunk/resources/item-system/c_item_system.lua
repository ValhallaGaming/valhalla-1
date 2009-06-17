wItems, gItems, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil
toggleLabel, chkFood, chkKeys, chkDrugs, chkOther, chkBooks, chkClothes, chkElectronics, chkEmpty = nil

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true

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

function getItemType(itemID)
	-- 1 = Food & Drink
	-- 2 = Keys
	-- 3 = Drugs
	-- 4 = Other
	-- 5 = Books
	-- 6 = Clothing & Accessories
	-- 7 = Electronics
	
	if (itemID==1) then
		return 1
	elseif (itemID==2) then
		return 7
	elseif (itemID==3) then
		return 2
	elseif (itemID==4) then
		return 2
	elseif (itemID==5) then
		return 2
	elseif (itemID==6) then
		return 7
	elseif (itemID==7) then
		return 5
	elseif (itemID==8) then
		return 1
	elseif (itemID==9) then
		return 1
	elseif (itemID==10) then
		return 4
	elseif (itemID==11) then
		return 1
	elseif (itemID==12) then
		return 1
	elseif (itemID==13) then
		return 1
	elseif (itemID==14) then
		return 1
	elseif (itemID==15) then
		return 1
	elseif (itemID==16) then
		return 6
	elseif (itemID==17) then
		return 6
	elseif (itemID==18) then
		return 5
	elseif (itemID==19) then
		return 7
	elseif (itemID==20) then
		return 5
	elseif (itemID==21) then
		return 5
	elseif (itemID==22) then
		return 5
	elseif (itemID==23) then
		return 5
	elseif (itemID==24) then
		return 5
	elseif (itemID==25) then
		return 5
	elseif (itemID==26) then
		return 6
	elseif (itemID==27) then
		return 4
	elseif (itemID==28) then
		return 4
	else
		return false
	end
end
	
	--[[
		addEventHandler("onClientGUIClick", chkFood, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkKeys, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkDrugs, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkBooks, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkClothes, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkElectronics, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkOther, toggleCategory, false)
	addEventHandler("onClientGUIClick", chkEmpty, toggleCategory, false)]]
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
	local itemvalues = getElementData(getLocalPlayer(), "itemvalues")
	for i = 1, 10 do
		if (items[i]==nil) then
			if (showEmpty) then
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			end
		else
			local itemid = tonumber(items[i][3])
			local itemvalue = gettok(itemvalues, i, string.byte(','))
			
			local itemtype = getItemType(itemid)
	
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
				end
				
				if (add) then
					local row = guiGridListAddRow(gItems)
					guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
					guiGridListSetItemText(gItems, row, colName, tostring(items[i][1]), false, false)
					guiGridListSetItemText(gItems, row, colValue, tostring(itemvalue), false, false)
				end
			end
		end
	end
end

function showInventory(tableitems)
	local width, height = 600, 500
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wItems = guiCreateWindow(x, y, width, height, "Inventory", false)
	guiWindowSetSizable(wItems, false)
	
	items = tableitems
	
	tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.7, true, wItems)
	tabItems = guiCreateTab("Items", tabPanel)
	tabWeapons = guiCreateTab("Weapons", tabPanel)
	
	
	-- ITEMS
	gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
	addEventHandler("onClientGUIClick", gItems, showDescription, false)
	
	
	colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
	colName = guiGridListAddColumn(gItems, "Name", 0.625)
	colValue = guiGridListAddColumn(gItems, "Value", 0.225)
	
	local itemvalues = getElementData(getLocalPlayer(), "itemvalues")
	
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
	
	for i = 1, 10 do
		if (items[i]==nil) then
			if (showEmpty) then
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			end
		else
			local itemid = tonumber(items[i][3])
			local itemvalue = gettok(itemvalues, i, string.byte(','))
			
			local itemtype = getItemType(itemid)
	
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
				end
				
				if (add) then
					local row = guiGridListAddRow(gItems)
					guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
					guiGridListSetItemText(gItems, row, colName, tostring(items[i][1]), false, false)
					guiGridListSetItemText(gItems, row, colValue, tostring(itemvalue), false, false)
				end
			end
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
		local x, y, z = getElementPosition(getLocalPlayer())
		local groundz = getGroundPosition(x, y, z)
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local itemName = tostring(guiGridListGetItemText(gItems, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gItems, row, 3))
			local itemID = tonumber(items[itemSlot][3])
			triggerServerEvent("useItem", getLocalPlayer(), itemID, itemName, itemValue, false, groundz)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemName = tostring(guiGridListGetItemText(gWeapons, row, 2))
			local itemValue = tonumber(guiGridListGetItemText(gWeapons, row, 3))
			local itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
			triggerServerEvent("useItem", getLocalPlayer(), itemSlot, itemName, itemValue, true, groundz)
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

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(getLocalPlayer(), "gasmask")

	if (weapon==17) and (gasmask==1) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopGasmaskDamage)