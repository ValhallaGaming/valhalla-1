local function openInventory( element, ax, ay )
	triggerEvent( "subscribeToInventoryChanges", source, element )
	triggerClientEvent( source, "openElementInventory", element, ax, ay )
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function moveToElement( element, slot, ammo )
	if not hasSpaceForItem( element ) then
		outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
	else
		if not ammo then
			local item = getItems( source )[ slot ]
			if item then
				moveItem( source, element, slot )
			end
		else
			exports.global:takeWeapon( source, slot )
			giveItem( element, -slot, ammo )
		end
	end
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

local function moveFromElement( element, slot )
	local item = getItems( element )[slot]
	if item then
		if item[1] > 0 then
			moveItem( element, source, slot )
		else
			takeItemFromSlot( element, slot )
			exports.global:giveWeapon( source, -item[1], item[2] )
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	end
end

addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )