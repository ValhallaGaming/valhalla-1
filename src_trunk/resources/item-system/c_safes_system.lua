wRightClick = nil
bInventory = nil
bCloseMenu = nil
ax, ay = nil
localPlayer = getLocalPlayer()
safe = nil

wInventory, gSafeItems, gUserItems, lYou, lSafe, bGiveItem, bTakeItem, bCloseInventory, lPlate, UIColName, VIColName, bSit = nil

-- INVENTORY
function cSafeInventory(button, state)
	if (button=="left") then
		
		local dbid = getElementData(safe, "dbid")
			
		--if (dbid>0) then
			destroyElement(wRightClick)
			wRightClick = nil
				
			wInventory = guiCreateWindow(ax, ay, 400, 300, "Safe Inventory", false)
			
			lYou = guiCreateLabel(0.25, 0.1, 0.87, 0.05, "YOU", true, wInventory)
			guiSetFont(lYou, "default-bold-small")
			
			lVehicle = guiCreateLabel(0.675, 0.1, 0.87, 0.05, "SAFE", true, wInventory)
			guiSetFont(lVehicle, "default-bold-small")
			
			---------------
			-- PLAYER
			---------------
			gUserItems = guiCreateGridList(0.05, 0.15, 0.45, 0.65, true, wInventory)
			UIColName = guiGridListAddColumn(gUserItems, "Name", 0.9)
			
			local items = getElementData(localPlayer, "items")
			
			local slots = 10
			
			for i = 1, slots do
				local itemID = tonumber(gettok(items, i, string.byte(',')))
				if (itemID~=nil) then
					local itemName = exports.global:cgetItemName(itemID)
					local row = guiGridListAddRow(gUserItems)
					guiGridListSetItemText(gUserItems, row, UIColName, tostring(itemName), false, false)
					guiGridListSetSortingEnabled(gUserItems, false)
				end
			end
			
			-- WEAPONS
			for i = 1, 12 do
				if (getPedWeapon(localPlayer, i)>0) then
					local itemName = getWeaponNameFromID(getPedWeapon(localPlayer, i))
					local row = guiGridListAddRow(gUserItems)
					guiGridListSetItemText(gUserItems, row, UIColName, tostring(itemName), false, false)
					guiGridListSetSortingEnabled(gUserItems, false)
				end
			end
			
			---------------
			-- SAFE
			---------------
			gSafeItems = guiCreateGridList(0.5, 0.15, 0.45, 0.65, true, wInventory)
			VIColName = guiGridListAddColumn(gSafeItems, "Name", 0.9)
			
			local items = getElementData(safe, "items")
			if (items) then
				for i = 1, 20 do
					local itemID = tonumber(gettok(items, i, string.byte(',')))
					if (itemID~=nil) then
						local itemName = exports.global:cgetItemName(itemID)
						local row = guiGridListAddRow(gSafeItems)
						
						if (itemName) then
							guiGridListSetItemText(gSafeItems, row, VIColName, tostring(itemName), false, false)
						else
						guiGridListSetItemText(gSafeItems, row, VIColName, getWeaponNameFromID(itemID-9000), false, false)
						end
						guiGridListSetSortingEnabled(gSafeItems, false)
					else
						break
					end
				end
			end
			

			bCloseInventory = guiCreateButton(0.05, 0.9, 0.9, 0.075, "Close Inventory", true, wInventory)
			addEventHandler("onClientGUIClick", bCloseInventory, hideSafeMenu, false)
			
			bGiveItem = guiCreateButton(0.05, 0.81, 0.45, 0.075, "Move ---->", true, wInventory)
			addEventHandler("onClientGUIClick", bGiveItem, moveItemToSafe, false)
				
			bTakeItem = guiCreateButton(0.5, 0.81, 0.45, 0.075, "<---- Move ", true, wInventory)
			addEventHandler("onClientGUIClick", bTakeItem, takeItemFromSafe, false)
				
		--end
	end
end

function takeItemFromSafe(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gSafeItems)
		
		if (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		else
			local items = getElementData(safe, "items")
			local itemvalues = getElementData(safe, "itemvalues")
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if not (exports.global:cdoesPlayerHaveSpaceForItem(localPlayer)) and (itemName) then
				outputChatBox("Your inventory is full.", 255, 0, 0)
			else
				if (itemName) and not (exports.global:cdoesSafeHaveItem(safe, tonumber(itemID), tonumber(itemValue))) then
					outputChatBox("The safe no longer has that item.", 255, 0, 0)
					hideSafeMenu()
					return
				end

				if (itemName) then -- ITEM
					guiGridListRemoveRow(gSafeItems, row)
					local row = guiGridListAddRow(gUserItems)
					guiGridListSetItemText(gUserItems, row, UIColName, tostring(itemName), false, false)
					triggerServerEvent("moveItemToPlayerFromSafe", localPlayer, safe, itemID, itemValue, itemName)
				else -- WEAPON
					if (getPedWeapon(localPlayer, getSlotFromWeapon(itemID-9000))==itemID-9000) then
						outputChatBox("You already have one of this item, this item is Unique.", 255, 0, 0)
					else
						local weaponID = getWeaponIDFromName(guiGridListGetItemText(gSafeItems, row, col))
						local weaponAmmo = itemValue
						guiGridListRemoveRow(gSafeItems, row)
						local row = guiGridListAddRow(gUserItems)
						guiGridListSetItemText(gUserItems, row, UIColName, getWeaponNameFromID(weaponID), false, false)
						triggerServerEvent("moveWeaponToPlayerFromSafe", localPlayer, safe, weaponID, weaponAmmo)
					end
				end
			end
		end
	end
end

function moveItemToSafe(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gUserItems)
		
		if (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		elseif not (exports.global:cdoesSafeHaveSpaceForItem(safe)) then
			outputChatBox("The safe is full.", 255, 0, 0)
		else
			local items = getElementData(localPlayer, "items")
			local itemvalues = getElementData(localPlayer, "itemvalues")
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if (itemID==48 ) then -- BACKPACK or the key to the safe
				outputChatBox("This item cannot be stored in a safe.", 255, 0, 0)
				return
			end
			if (((itemID == 4 or itemID == 5) and itemValue == getElementDimension(getLocalPlayer())) then
				outputChatBox("This item cannot be stored in a safe.", 255, 0, 0)
				return
			end
			
			if (itemName) and not (exports.global:cdoesPlayerHaveItem(localPlayer, itemID, itemValue)) then
				outputChatBox("You no longer have that item", 255, 0, 0)
				hideSafeMenu()
				return
			end
			
			if (itemName) then -- ITEM
				guiGridListRemoveRow(gUserItems, row)
				local row = guiGridListAddRow(gSafeItems)
				guiGridListSetItemText(gSafeItems, row, VIColName, tostring(itemName), false, false)
				triggerServerEvent("moveItemToSafe", getLocalPlayer(), safe, itemID, itemValue, itemName)
			else -- WEAPON
				local weaponID = getWeaponIDFromName(guiGridListGetItemText(gUserItems, row, col))
				local weaponAmmo = getPedTotalAmmo(localPlayer, getSlotFromWeapon(weaponID))
				guiGridListRemoveRow(gUserItems, row)
				local row = guiGridListAddRow(gSafeItems)
				guiGridListSetItemText(gSafeItems, row, VIColName, getWeaponNameFromID(weaponID), false, false)
				triggerServerEvent("moveWeaponToSafe", getLocalPlayer(), safe, weaponID, weaponAmmo)
			end
		end
	end
end
function clickVehicle(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="object") and (button=="right") and (state=="down") and not (wInventory) and getElementModel(element) == 2332 then
		local x, y, z = getElementPosition(localPlayer)
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
			if (wRightClick) then
				hideSafeMenu()
			end
			
			if (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 5, getElementDimension(getLocalPlayer())) or  exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 4, getElementDimension(getLocalPlayer()))) then
				showCursor(true)
				ax = absX
				ay = absY
				safe = element
				showSafeMenu()
			else
				outputChatBox("You do not have the keys to the safe.", 255, 0, 0)
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickVehicle, true)

function showSafeMenu()
	wRightClick = guiCreateWindow(ax, ay, 150, 100, "Safe", false)

	bInventory = guiCreateButton(0.05, 0.23, 0.87, 0.2, "Inventory", true, wRightClick)
	addEventHandler("onClientGUIClick", bInventory, cSafeInventory, false)
	
	bCloseMenu = guiCreateButton(0.05, 0.63, 0.87, 0.2, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideSafeMenu, false)
end

function hideSafeMenu()
	if (isElement(bInventory)) then
		destroyElement(bInventory)
	end
	bInventory = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wInventory)) then
		destroyElement(wInventory)
	end
	wInventory = nil
	
	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil
	
	ax = nil
	ay = nil


	showCursor(false)
	triggerEvent("cursorHide", getLocalPlayer())
end
