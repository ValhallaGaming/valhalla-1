wRightClick = nil
bInventory = nil
bCloseMenu = nil
ax, ay = nil
localPlayer = getLocalPlayer()
vehicle = nil

wInventory, gVehicleItems, gUserItems, lYou, lVehicle, bGiveItem, bTakeItem, bCloseInventory, lPlate, UIColName, VIColName, bSit = nil

-- INVENTORY
function cVehicleInventory(button, state)
	if (button=="left") then
		local locked = isVehicleLocked(vehicle)
		
		if (locked) then
			outputChatBox("This vehicle is locked.", 255, 0, 0)
		else
			local dbid = getElementData(vehicle, "dbid")
			
			if (dbid<0) then
				outputChatBox("Admin cars do not have inventories.", 255, 0, 0)
			else
				destroyElement(wRightClick)
				wRightClick = nil
				
				wInventory = guiCreateWindow(ax, ay, 400, 300, getVehicleName(vehicle) .. " Inventory", false)
				
				lYou = guiCreateLabel(0.25, 0.1, 0.87, 0.05, "YOU", true, wInventory)
				guiSetFont(lYou, "default-bold-small")
				
				lVehicle = guiCreateLabel(0.675, 0.1, 0.87, 0.05, "VEHICLE", true, wInventory)
				guiSetFont(lVehicle, "default-bold-small")
				
				---------------
				-- PLAYER
				---------------
				gUserItems = guiCreateGridList(0.05, 0.15, 0.45, 0.65, true, wInventory)
				UIColName = guiGridListAddColumn(gUserItems, "Name", 0.9)
				
				local items = getElementData(localPlayer, "items")
				
				for i = 1, 10 do
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
				-- VEHICLE
				---------------
				gVehicleItems = guiCreateGridList(0.5, 0.15, 0.45, 0.65, true, wInventory)
				VIColName = guiGridListAddColumn(gVehicleItems, "Name", 0.9)
				
				local items = getElementData(vehicle, "items")
				
				for i = 1, 20 do
					local itemID = tonumber(gettok(items, i, string.byte(',')))
					if (itemID~=nil) then
						local itemName = exports.global:cgetItemName(itemID)
						local row = guiGridListAddRow(gVehicleItems)
						
						if (itemName) then
							guiGridListSetItemText(gVehicleItems, row, VIColName, tostring(itemName), false, false)
						else
							guiGridListSetItemText(gVehicleItems, row, VIColName, getWeaponNameFromID(itemID-9000), false, false)
						end
						guiGridListSetSortingEnabled(gVehicleItems, false)
					else
						break
					end
				end
				
				bGiveItem = guiCreateButton(0.05, 0.81, 0.45, 0.075, "Move ---->", true, wInventory)
				addEventHandler("onClientGUIClick", bGiveItem, moveItemToVehicle, false)
				
				bTakeItem = guiCreateButton(0.5, 0.81, 0.45, 0.075, "<---- Move ", true, wInventory)
				addEventHandler("onClientGUIClick", bTakeItem, takeItemFromVehicle, false)
				
				bCloseInventory = guiCreateButton(0.05, 0.9, 0.9, 0.075, "Close Inventory", true, wInventory)
				addEventHandler("onClientGUIClick", bCloseInventory, hideVehicleMenu, false)
			end
		end
	end
end

function moveItemToVehicle(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gUserItems)
		
		if (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		elseif not (exports.global:cdoesVehicleHaveSpaceForItem(vehicle)) then
			outputChatBox("This vehicle is full.", 255, 0, 0)
		else
			local items = getElementData(localPlayer, "items")
			local itemvalues = getElementData(localPlayer, "itemvalues")
			
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if (itemID==48) then -- BACKPACK
				outputChatBox("This item cannot be stored in a vehicle.", 255, 0, 0)
				return
			end
			
			if (itemName) and not (exports.global:cdoesPlayerHaveItem(localPlayer, itemID, itemValue)) then
				outputChatBox("You no longer have that item", 255, 0, 0)
				hideVehicleMenu()
				return
			end
			
			if (itemName) then -- ITEM
				guiGridListRemoveRow(gUserItems, row)
				local row = guiGridListAddRow(gVehicleItems)
				guiGridListSetItemText(gVehicleItems, row, VIColName, tostring(itemName), false, false)
				triggerServerEvent("moveItemToVehicle", getLocalPlayer(), vehicle, itemID, itemValue, itemName)
			else -- WEAPON
				local weaponID = getWeaponIDFromName(guiGridListGetItemText(gUserItems, row, col))
				local weaponAmmo = getPedTotalAmmo(localPlayer, getSlotFromWeapon(weaponID))
				guiGridListRemoveRow(gUserItems, row)
				local row = guiGridListAddRow(gVehicleItems)
				guiGridListSetItemText(gVehicleItems, row, VIColName, getWeaponNameFromID(weaponID), false, false)
				triggerServerEvent("moveWeaponToVehicle", getLocalPlayer(), vehicle, weaponID, weaponAmmo)
			end
		end
	end
end

function takeItemFromVehicle(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gVehicleItems)
		
		if (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		else
			local items = getElementData(vehicle, "items")
			local itemvalues = getElementData(vehicle, "itemvalues")
			
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if not (exports.global:cdoesPlayerHaveSpaceForItem(localPlayer)) and (itemName) then
				outputChatBox("Your inventory is full.", 255, 0, 0)
			else
				--if (itemName) and not (exports.global:cdoesVehicleHaveItem(localPlayer, tonumber(itemID), tonumber(itemValue))) then
				--	outputChatBox("This vehicle no longer has that item.", 255, 0, 0)
				--	hideVehicleMenu()
				--	return
				--end

				if (itemName) then -- ITEM
					guiGridListRemoveRow(gVehicleItems, row)
					local row = guiGridListAddRow(gUserItems)
					guiGridListSetItemText(gUserItems, row, UIColName, tostring(itemName), false, false)
					triggerServerEvent("moveItemToPlayer", localPlayer, vehicle, itemID, itemValue, itemName)
				else -- WEAPON
					if (getPedWeapon(localPlayer, getSlotFromWeapon(itemID-9000))==itemID-9000) then
						outputChatBox("You already have one of this item, this item is Unique.", 255, 0, 0)
					else
						local weaponID = getWeaponIDFromName(guiGridListGetItemText(gVehicleItems, row, col))
						local weaponAmmo = itemValue
						guiGridListRemoveRow(gVehicleItems, row)
						local row = guiGridListAddRow(gUserItems)
						guiGridListSetItemText(gUserItems, row, UIColName, getWeaponNameFromID(weaponID), false, false)
						triggerServerEvent("moveWeaponToPlayer", localPlayer, vehicle, weaponID, weaponAmmo)
					end
				end
			end
		end
	end
end

function clickVehicle(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="vehicle") and (button=="right") and (state=="down") and not (wInventory) then
		local x, y, z = getElementPosition(localPlayer)
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
			if (wRightClick) then
				hideVehicleMenu()
			end
			showCursor(true)
			ax = absX
			ay = absY
			vehicle = element
			showVehicleMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickVehicle, true)

function showVehicleMenu()
	wRightClick = guiCreateWindow(ax, ay, 150, 200, getVehicleName(vehicle), false)
	
	lPlate = guiCreateLabel(0.05, 0.13, 0.87, 0.1, "Plate: " .. getVehiclePlateText(vehicle), true, wRightClick)
	guiSetFont(lPlate, "default-bold-small")
	
	bInventory = guiCreateButton(0.05, 0.23, 0.87, 0.1, "Inventory", true, wRightClick)
	addEventHandler("onClientGUIClick", bInventory, cVehicleInventory, false)
	
	local y = 0.37
	if (getElementModel(vehicle)==497) then -- HELICOPTER
		local players = getElementData(vehicle, "players")
		local found = false
		
		if (players) then
			for key, value in ipairs(players) do
				if (value==localPlayer) then
					found = true
				end
			end
		end
		
		if not (found) then
			bSit = guiCreateButton(0.05, 0.37, 0.87, 0.1, "Sit", true, wRightClick)
			addEventHandler("onClientGUIClick", bSit, sitInHelicopter, false)
		else
			bSit = guiCreateButton(0.05, 0.37, 0.87, 0.1, "Stand up", true, wRightClick)
			addEventHandler("onClientGUIClick", bSit, unsitInHelicopter, false)
		end
		y = y + 0.14
	end
	
	bCloseMenu = guiCreateButton(0.05, y, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideVehicleMenu, false)
end

function sitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("sitInHelicopter", localPlayer, vehicle)
		hideVehicleMenu()
	end
end

function unsitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("unsitInHelicopter", localPlayer, vehicle)
		hideVehicleMenu()
	end
end

function hideVehicleMenu()
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

	vehicle = nil

	showCursor(false)
	triggerEvent("cursorHide", getLocalPlayer())
end