function hasSpaceForItem( element )
	return call( getResourceFromName( "item-system" ), "hasSpaceForItem", element )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "item-system" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "item-system" ), "getItemName", itemID )
end
