local localPlayer = getLocalPlayer()
local element = nil
local wInventory, gUserItems, UIColName, gElementItems, VIColName, bCloseInventory, bGiveItem, bTakeItem
local sx, sy = guiGetScreenSize()

local function forceUpdate( )
	if not wInventory then
		return
	end
	
	guiGridListClear(gUserItems)
	guiGridListClear(gElementItems)
	---------------
	-- PLAYER
	---------------
	local items = getItems(localPlayer)
	for slot, item in ipairs( items ) do
		if item then
			local row = guiGridListAddRow(gUserItems)
			
			guiGridListSetItemText(gUserItems, row, UIColName, getItemName( item[1] ) .. " - " .. item[2], false, false)
			guiGridListSetItemData(gUserItems, row, UIColName, tostring( slot ) )
		end
	end
	
	-- WEAPONS
	for slot = 0, 12 do
		if getPedWeapon(localPlayer, slot) and getPedWeapon(localPlayer, slot) > 0 then
			local row = guiGridListAddRow(gUserItems)
			
			guiGridListSetItemText(gUserItems, row, UIColName, getWeaponNameFromID( getPedWeapon(localPlayer, slot) ) .. " - " .. getPedTotalAmmo( localPlayer, slot ), false, false)
			guiGridListSetItemData(gUserItems, row, UIColName, tostring( -slot ) )
		end
	end
	
	---------------
	-- ELEMENTS
	---------------
	local items = getItems( element )
	for slot, item in pairs( items ) do
		local row = guiGridListAddRow(gElementItems)
		
		guiGridListSetItemText(gElementItems, row, VIColName, getItemName( item[1] ) .. " - " .. item[2], false, false)
		guiGridListSetItemData(gElementItems, row, VIColName, tostring( slot ) )
	end
end
addEvent( "forceElementMoveUpdate", true )
addEventHandler( "forceElementMoveUpdate", localPlayer, forceUpdate )

local function update()
	if source == localPlayer or source == element then
		forceUpdate()
	end
end

addEventHandler("recieveItems", getRootElement(), update)

local function hideMenu()
	if wInventory then
		destroyElement( wInventory )
		wInventory = nil
		
		triggerServerEvent( "closeFreakinInventory", localPlayer, element )
		
		element = nil
		
		setElementData(localPlayer, "exclusiveGUI", false, false)
		showCursor( false )
	end
end

local function moveToElement( button )
	local row, col = guiGridListGetSelectedItem(gUserItems)
	if button == "left" and col ~= -1 and row ~= -1 then
		local slot = tonumber( guiGridListGetItemData(gUserItems, row, col) )
		if slot then
			if slot > 0 then
				triggerServerEvent( "moveToElement", localPlayer, element, slot )
			else
				slot = -slot
				triggerServerEvent( "moveToElement", localPlayer, element, getPedWeapon( localPlayer, slot ), getPedTotalAmmo( localPlayer, slot ) )
			end
		end
	end
end

local function moveFromElement( button )
	local row, col = guiGridListGetSelectedItem(gElementItems)
	if button == "left" and col ~= -1 and row ~= -1 then
		local slot = tonumber( guiGridListGetItemData(gElementItems, row, col) )
		if slot then
			triggerServerEvent( "moveFromElement", localPlayer, element, slot )
		end
	end
end

local function openElementInventory( ax, ay )
	if not getElementData(localPlayer, "exclusiveGUI") then
		hideMenu()
		
		element = source
		
		local type = ( getElementType(source) == "vehicle" and "Vehicle" or "Safe" )
		setElementData(localPlayer, "exclusiveGUI", true, false)
		
		ax = math.max( 10, math.min( sx - 410, ax ) )
		ay = math.max( 10, math.min( sy - 310, ay ) )
		
		wInventory = guiCreateWindow(ax, ay, 400, 300, type .. " Inventory", false)
		
		lYou = guiCreateLabel(0.25, 0.1, 0.87, 0.05, "YOU", true, wInventory)
		guiSetFont(lYou, "default-bold-small")
		
		lVehicle = guiCreateLabel(0.675, 0.1, 0.87, 0.05, type:upper(), true, wInventory)
		guiSetFont(lVehicle, "default-bold-small")
		
		gUserItems = guiCreateGridList(0.05, 0.15, 0.45, 0.65, true, wInventory)
		UIColName = guiGridListAddColumn(gUserItems, "Name", 0.9)
		
		gElementItems = guiCreateGridList(0.5, 0.15, 0.45, 0.65, true, wInventory)
		VIColName = guiGridListAddColumn(gElementItems, "Name", 0.9)
		
		bCloseInventory = guiCreateButton(0.05, 0.9, 0.9, 0.075, "Close Inventory", true, wInventory)
		addEventHandler("onClientGUIClick", bCloseInventory, hideMenu, false)
		
		bGiveItem = guiCreateButton(0.05, 0.81, 0.45, 0.075, "Move ---->", true, wInventory)
		addEventHandler("onClientGUIClick", bGiveItem, moveToElement, false)
		addEventHandler("onClientGUIDoubleClick", gUserItems, moveToElement, false)
		
		bTakeItem = guiCreateButton(0.5, 0.81, 0.45, 0.075, "<---- Move ", true, wInventory)
		addEventHandler("onClientGUIClick", bTakeItem, moveFromElement, false)
		addEventHandler("onClientGUIDoubleClick", gElementItems, moveFromElement, false)
		
		forceUpdate()
		
		showCursor( true )
	else
		outputChatBox("You can't access that inventory at the moment.", 255, 0, 0)
	end
end

addEvent( "openElementInventory", true )
addEventHandler( "openElementInventory", getRootElement(), openElementInventory )