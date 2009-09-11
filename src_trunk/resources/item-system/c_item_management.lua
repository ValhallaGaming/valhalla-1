--[[
x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj) -- returns true if you can put more stuff in

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getInventorySlots(obj) -- returns the number of available inventory slots
]]
local saveditems = {} -- client-side saved items


-- Recieve Items from the server
local function recieveItems( items )
	saveditems[ source ] = items
end

addEvent( "recieveItems", true )
addEventHandler( "recieveItems", getRootElement( ), recieveItems )

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	if not saveditems[element] then
		return false, "Unknown"
	end
	
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			return true, key, value[2], value[3]
		end
	end
	return false
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element)
	if not saveditems[element] then
		return false, "Unknown"
	end

	return #getItems(element) < getInventorySlots(element)
end

-- returns a list of all items of that element
function getItems(element)
	if not saveditems[element] then
		return {}, "Unknown"
	end

	return saveditems[element]
end

-- returns the number of available item slots for that element
function getInventorySlots(element)
	if getElementType( element ) == "player" then
		if hasItem(element, 48) then
			return 20
		else
			return 10
		end
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return 0
		elseif getVehicleType( element ) == "BMX" then
			return 5
		elseif getVehicleType( element ) == "Bike" then
			return 10
		else
			return 20
		end
	else
		return 20
	end
end

-- tell the server we're ready
addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "itemResourceStarted", getLocalPlayer( ) )
	end
)