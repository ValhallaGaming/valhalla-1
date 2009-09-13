wItems, gItems, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil
toggleLabel, chkFood, chkKeys, chkDrugs, chkOther, chkBooks, chkClothes, chkElectronics, chkEmpty = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true

function clickItem(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="object") and (button=="right") and (state=="down") and getElementParent(getElementParent(element)) == getResourceRootElement() then
		local x, y, z = getElementPosition(getLocalPlayer())
		if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) < 3 then
			if (wRightClick) then
				hideItemMenu()
			end
			showCursor(true)
			ax = absX
			ay = absY
			item = element
			showItemMenu()
		else
			outputChatBox("You are too far away from that item.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)

function showItemMenu()
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue")
	local itemName = getItemName( itemID )
	
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName .. " (" .. itemValue .. ")", false)
	
	local y = 0.13
	bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Pick Item Up", true, wRightClick)
	addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	y = y + 0.14
	
	if itemID == 54 then
		-- Ghettoblaster
		if getElementData(item, "itemValue") > 0 then
			bToggle = guiCreateButton(0.05, y, 0.9, 0.1, "Turn Off", true, wRightClick)
			
			y = y + 0.14
			
			bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.1, "Previous", true, wRightClick)
			addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", getLocalPlayer(), item, -1) end, false)
			
			bNextTrack = guiCreateButton(0.53, y, 0.42, 0.1, "Next", true, wRightClick)
			addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", getLocalPlayer(), item, 1) end, false)
		else
			bToggle = guiCreateButton(0.05, y, 0.9, 0.1, "Turn On", true, wRightClick)
		end
		addEventHandler("onClientGUIClick", bToggle, toggleGhettoblaster, false)
	
		y = y + 0.14
	end
	
	bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
end

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

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

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and getElementData(source, "itemID") == 54 then -- update the track while you're in menu
		guiSetText(wRightClick, "GHETTOBLASTER (" .. getElementData(source, "itemValue") .. ")")
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", getLocalPlayer(), item)
	hideItemMenu()
end

function pickupItem(button, state)
	if (button=="left") then
		local restrain = getElementData(getLocalPlayer(), "restrain")
		
		if (restrain) and (restrain==1) then
			outputChatBox("You are cuffed.", 255, 0, 0)
		elseif not hasSpaceForItem(getLocalPlayer()) and getElementData(item, "itemID") > 0 then
			outputChatBox("Your Inventory is full.", 255, 0, 0)
		elseif isElement(item) then
			showCursor(false)
			triggerEvent("cursorHide", getLocalPlayer())
			
			local itemID = tonumber(getElementData(item, "itemID")) or 0
			local itemValue = tonumber(getElementData(item, "itemValue")) or 0
			if itemID < 0 then
				local free, totalfree = exports.weaponcap:getFreeAmmo( -itemID )
				local cap = exports.weaponcap:getAmmoCap( -itemID )
				if totalfree == 0 then
					outputChatBox( "You've got all weapons you can carry.", 255, 0, 0 )
				elseif free == 0 and cap == 0 then
					local weaponName = "other weapon"
					local slot = getSlotFromWeapon( -itemID )
					if slot and slot ~= 0 and getPedTotalAmmo( getLocalPlayer(), slot ) > 0 then
						local weapon = getPedWeapon( getLocalPlayer(), slot )
						weaponName = getWeaponNameFromID( weapon )
					end
					outputChatBox( "You don't carry that weapon, please drop your " .. weaponName .. " first.", 255, 0, 0 )
				elseif free == 0 then
					outputChatBox( "You can't carry any more of that weapon.", 255, 0, 0 )
				else
					triggerServerEvent("pickupItem", getLocalPlayer(), item, free )
				end
			else
				triggerServerEvent("pickupItem", getLocalPlayer(), item)
			end
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
	
	local items, slots = getItems( showinvPlayer ), getInventorySlots( showinvPlayer )
	
	for i = 1, slots do
		if not items[i] then
			if (showEmpty) then
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
			end
		else
			local itemid = items[i][1]
			local itemvalue = items[i][2]
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
				elseif (itemtype==false) then
					add = false
				end
				
				if (add) then
					local row = guiGridListAddRow(gItems)
					guiGridListSetItemText(gItems, row, colSlot, tostring(i), false, true)
					guiGridListSetItemText(gItems, row, colName, getItemName(itemid), false, false)
					guiGridListSetItemText(gItems, row, colValue, tostring(itemvalue), false, false)
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
		showinvPlayer = player
		if wItems then
			hideInventory()
		end
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
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
			if getPedWeapon(player, i) and getWeaponNameFromID(getPedWeapon(player, i)) ~= "Melee" and getPedTotalAmmo(player, i) > 0 then
				local row = guiGridListAddRow(gWeapons)
				local weapon = getWeaponNameFromID(getPedWeapon(player, i))
				local ammo = getPedTotalAmmo(player, i)
				guiGridListSetItemText(gWeapons, row, colWSlot, tostring(i), false, true)
				guiGridListSetItemText(gWeapons, row, colWName, tostring(weapon), false, false)
				guiGridListSetItemText(gWeapons, row, colWValue, tostring(ammo), false, false)
			end
		end
		guiSetVisible(colWSlot, false)
		
		addEventHandler("onClientGUIDoubleClick", gWeapons, useItem, false)
		
		-- ARMOR
		if getPedArmor(player) > 0 then
			local row = guiGridListAddRow(gWeapons)
			guiGridListSetItemText(gWeapons, row, colWSlot, tostring(13), false, true)
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
			addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		end
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	
	colWSlot = nil
	colWName = nil
	colWValue = nil
	
	if wItems then
		destroyElement(wItems)
	end
	wItems = nil
	
	showCursor(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
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
				local items = getItems(showinvPlayer)
				if not items[slot] then
					guiSetText(lDescription, "An empty slot.")
					guiSetEnabled(bUseItem, false)
					guiSetEnabled(bDropItem, false)
					guiSetEnabled(bShowItem, false)
					guiSetEnabled(bDestroyItem, false)
				else
					local desc = tostring( getItemDescription( items[slot][1] ) )
					local value = items[slot][2]
					
					-- percent operators
					desc = string.gsub((desc), "#v", tostring(value))
					
					if (desc=="A Dictionary.") then
						local res = getResourceFromName("language-system")
						local lang = call(res, "getLanguageName", tonumber(value))
						desc = "A " .. lang .. " dictionary."
					end
					
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
		local x, y, z = getElementPosition(getLocalPlayer())
		local groundz = getGroundPosition(x, y, z)
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local itemID = getItems( showinvPlayer )[itemSlot][1]
			local itemName = getItemName( itemID )
			local itemValue = getItems( showinvPlayer )[itemSlot][2]
			local additional = nil
			
			if (itemID==2) then -- cellphone
				hideInventory()
				triggerEvent("showPhoneGUI", getLocalPlayer(), itemValue)
				outputChatBox("Use /call to use this item.", 255, 194, 14)
				return
			elseif (itemID==6) then -- radio
				outputChatBox("Press Y to use this item. You can also use /tuneradio to tune your radio.", 255, 194, 14)
				return
			elseif (itemID==7) then -- phonebook
				outputChatBox("Use /phonebook to use this item.", 255, 194, 14)
				return
			elseif (itemID==18) then -- City Guide
				triggerEvent( "showCityGuide", getLocalPlayer( ) )
				return
			elseif (itemID==19) then -- MP3 PLayer
				outputChatBox("Use the - and = keys to use the MP3 Player.", 255, 194, 14)
				return
			elseif (itemID==27) then -- Flashbang
				local x, y, z = getElementPosition(getLocalPlayer( ))
				local rot = getPedRotation(getLocalPlayer( ))
				x = x + math.sin(math.rad(-rot)) * 10
				y = y + math.cos(math.rad(-rot)) * 10
				z = getGroundPosition(x, y, z + 2)
				additional = { x, y, z }
			elseif (itemID==28 or itemID==54) then -- Glowstick or Ghettoblaster
				local x, y, z = getElementPosition(getLocalPlayer( ))
				local rot = getPedRotation(getLocalPlayer( ))
				x = x + math.sin(math.rad(-rot)) * 2
				y = y + math.cos(math.rad(-rot)) * 2
				z = getGroundPosition(x, y, z)
				additional = { x, y, z - 0.5 }
			elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
				outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", 255, 0, 0)
				return
			elseif (itemID==34) then -- COCAINE
				doDrug1Effect()
			elseif (itemID==35) then
				doDrug2Effect()
			elseif (itemID==36) then
				doDrug3Effect()
			elseif (itemID==37) then
				doDrug4Effect()
			elseif (itemID==38) then
				if not getPedOccupiedVehicle(getLocalPlayer()) then
					doDrug5Effect()
				end
			elseif (itemID==39) then
				doDrug6Effect()
			elseif (itemID==40) then
				doDrug3Effect()
				doDrug1Effect()
			elseif (itemID==41) then
				doDrug4Effect()
				doDrug6Effect()
			elseif (itemID==42) then
				if not getPedOccupiedVehicle(getLocalPlayer()) then
					doDrug5Effect()
					doDrug2Effect()
				end
			elseif (itemID==43) then
				doDrug4Effect()
				doDrug1Effect()
				doDrug6Effect()
			elseif (itemID==44) then
				hideInventory()
				showChemistrySet()
				return
			elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
				outputChatBox("Right click a player to use this item.", source, 255, 0, 0)
				return
			elseif (itemID==48) then
				outputChatBox("Your inventory is extended.", 0, 255, 0)
				return
			elseif (itemID==50) or (itemID==51) or (itemID==52) then
				hideInventory()
			elseif (itemID==53) then -- Breathalizer
				outputChatBox("Use /breathtest to use this item.", 255, 194, 15)
				return
			elseif (itemID==57) then -- FUEL CAN
				hideInventory()
			elseif (itemID==61) then -- Emergency Light Becon
				outputChatBox("Put it in your car inventory and press 'P' to toggle it.", 255, 194, 14)
				return
			elseif (itemID==67) then -- GPS
				outputChatBox("Put it in your car inventory and Press 'F5'.", 255, 194, 14)
				return
			elseif (itemID==70) then -- First Aid Kit
				outputChatBox("Right click on a player who's knocked out to stabilize him.", 255, 194, 14)
				return
			elseif (itemID==71) then -- Notebook
				outputChatBox("Use /writenote [text] to write a note. There are " .. itemValue .. " pages left.", 255, 194, 14)
				return
			elseif (itemID==72) then -- Note
				outputChatBox("The Note reads: " .. itemValue, 255, 194, 14)
			end
			
			triggerServerEvent("useItem", getLocalPlayer(), itemSlot, additional)
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			if itemSlot == 13 then
				outputChatBox("You wear Body Armor.", 0, 255, 0)
			else
				setPedWeaponSlot( getLocalPlayer(), itemSlot )
			end
		end
	end
end

function destroyItem(button)
	if getElementHealth(getLocalPlayer()) == 0 then return end
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			if itemSlot and getItems(getLocalPlayer())[itemSlot] then
				guiGridListRemoveRow(gItems, row)
				
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
				
				for i = 0, getInventorySlots( getLocalPlayer() ) - 1 do
					guiGridListSetItemText(gItems, i, colSlot, tostring(i + 1), false, true)
				end
				
				guiGridListSetSelectedItem(gItems, 0, 0)
				
				triggerServerEvent("destroyItem", getLocalPlayer(), itemSlot)
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
			
			guiGridListSetSelectedItem(gWeapons, 0, 0)
			guiGridListRemoveRow(gWeapons, row)
			
			triggerServerEvent("destroyItem", getLocalPlayer(), itemID, true)
		end
		
		guiSetEnabled(bUseItem, false)
		guiSetEnabled(bDropItem, false)
		guiSetEnabled(bShowItem, false)
		guiSetEnabled(bDestroyItem, false)
	end
end

function dropItem(button)
	if getElementHealth(getLocalPlayer()) == 0 then return end
	if (button=="left") then
		guiSetEnabled(bUseItem, false)
		guiSetEnabled(bDropItem, false)
		guiSetEnabled(bShowItem, false)
		guiSetEnabled(bDestroyItem, false)
		
		if (guiGetSelectedTab(tabPanel)==tabItems) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(gItems)
			local itemSlot = tonumber(guiGridListGetItemText(gItems, row, 1))
			local item = getItems(getLocalPlayer())[itemSlot]
			if item then
				local itemID = item[1]
				if itemID == 60 then
					outputChatBox("This item cannot be dropped.", 255, 0, 0)
					return
				end
				
				guiGridListRemoveRow(gItems, row)
				
				local row = guiGridListAddRow(gItems)
				guiGridListSetItemText(gItems, row, colName, "Empty", false, false)
				guiGridListSetItemText(gItems, row, colValue, "None", false, false)
				
				for i = 0, getInventorySlots( getLocalPlayer() ) - 1 do
					guiGridListSetItemText(gItems, i, colSlot, tostring(i + 1), false, true)
				end

				guiGridListSetSelectedItem(gItems, 0, 0)
				
				local x, y, z = getElementPosition(getLocalPlayer())
				local rot = getPedRotation(getLocalPlayer())
				x = x - math.sin( math.rad( rot ) ) * 1
				y = y - math.cos( math.rad( rot ) ) * 1
				
				local z = getGroundPosition( x, y, z + 2 )
				triggerServerEvent("dropItem", getLocalPlayer(), itemSlot, x, y, z)
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			local itemSlot = tonumber(guiGridListGetItemText(gWeapons, row, 1))
			local itemValue = tonumber(guiGridListGetItemText(gWeapons, row, 3))
			local itemID = 0
			if itemSlot == 13 then
				itemID = 100
				itemValue = getPedArmor(getLocalPlayer())
			else
				itemID = tonumber(getPedWeapon(getLocalPlayer(), itemSlot))
				itemValue = math.min( getPedTotalAmmo(getLocalPlayer(), itemSlot), getElementData(getLocalPlayer(), "ACweapon" .. itemID) or 0 )
			end
			
			if itemValue > 0 then
				guiGridListSetSelectedItem(gWeapons, 0, 0)
				if itemSlot >= 2 and itemSlot <= 9 then
					openWeaponDropGUI(itemID, itemValue, row)
				else
					guiGridListRemoveRow(gWeapons, row)
				
					local x, y, z = getElementPosition(getLocalPlayer())
					local rot = getPedRotation(getLocalPlayer())
					x = x + math.sin( math.rad( rot ) ) * 1
					y = y + math.cos( math.rad( rot ) ) * 1
					
					local z = getGroundPosition( x, y, z + 2 )
					
					triggerServerEvent("dropItem", getLocalPlayer(), itemID, x, y, z, itemValue)
				end
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
	if getElementData(getLocalPlayer(), "adminlevel") == 0 then
		return
	end
	if not (wItemsList) then
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

addEventHandler("onClientChangeChar", getRootElement(), hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
		
		if guiGetSelectedTab( tabPanel ) == tabItems then
			guiSetEnabled(bUseItem, false)
			guiSetEnabled(bDropItem, false)
			guiSetEnabled(bShowItem, false)
			guiSetEnabled(bDestroyItem, false)
		end
	end
end
addEventHandler("recieveItems", getRootElement(), updateInv)