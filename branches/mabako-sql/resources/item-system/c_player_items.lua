local playeritems = {}

function getPlayerItems(player)
	return playeritems[player]
end

function doesPlayerHaveSpaceForItem(player)
	return #playeritems[player] < getPlayerInventorySlots(player)
end

function getPlayerInventorySlots(player)
	if doesPlayerHaveItem(player, 48, 1) then
		return 20
	else
		return 10
	end
end

function doesPlayerHaveItem(player, id, value)
	for k, v in pairs(playeritems[player]) do
		if v[1] == id and ( value == -1 or value == v[2] ) then
			return true, k, v[2]
		end
	end
	return false
end

function givePlayerItem(player, id, value)
	triggerServerEvent("givePlayerItem", player, id, value)
end

function takePlayerItem(player, id, value)
	triggerServerEvent("takePlayerItem", player, id, value)
end

function recieveItems(items)
	playeritems[source] = items
end
addEvent("recieveItems", true)
addEventHandler( "recieveItems", getRootElement(), recieveItems )
triggerServerEvent( "requestItems", getLocalPlayer() )