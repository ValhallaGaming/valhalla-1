function cdoesPlayerHaveSpaceForItem(thePlayer)
	local items = getElementData(thePlayer, "items")
	
	local slots = 10
	if (cdoesPlayerHaveItem(thePlayer, 48, -1)) then
		slots = 20
	end
	
	for i=1, slots do
		if not (items) then -- no items
			return true
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if not (token) then
				return true
			end
		end
	end
	return false
end

function cdoesPlayerHaveItem(thePlayer, itemID, itemValue)
	local items = getElementData(thePlayer, "items")
	local itemvalues = getElementData(thePlayer, "itemvalues")

	for i=1, 20 do
		if not (items) or not (itemvalues) then -- no items
			return false
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if (token) then
				if (token==itemID) then
					local value = tonumber(gettok(itemvalues, i, string.byte(',')))
					if (itemValue==-1) or not (itemValue) then -- any value is okay
						return true, i, value
					else
						if (value==itemValue) then
							return true, i, value
						end
					end
				end
			end
		end
	end
	return false
end

function cgetItemName(itemID)
	return call( getResourceFromName( "item-system" ), "getItemName", itemID )
end

function cdoesVehicleHaveSpaceForItem(theVehicle)
	local items = getElementData(theVehicle, "items")
	
	for i=1, 20 do
		if not (items) then -- no items
			return true
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if not (token) then
				return true
			end
		end
	end
	return false
end

function cdoesVehicleHaveItem(theVehicle, itemID, itemValue)
	local items = getElementData(theVehicle, "items")
	local itemvalues = getElementData(theVehicle, "itemvalues")

	for i=1, 20 do
		if not (items) or not (itemvalues) then -- no items
			return false
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if (token) then
				if (token==itemID) then
					if (itemValue==-1) or not (itemValue) then -- any value is okay
						return true, i
					else
						local value = tonumber(gettok(itemvalues, i, string.byte(',')))
						if (value==itemValue) then
							return true, i, value
						end
					end
				end
			end
		end
	end
	return false
end

function cdoesSafeHaveItem(theSafe, itemID, itemValue)
	local items = getElementData(theSafe, "items")
	local itemvalues = getElementData(theSafe, "itemvalues")

	for i=1, 20 do
		if not (items) or not (itemvalues) then -- no items
			return false
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if (token) then
				if (token==itemID) then
					if (itemValue==-1) or not (itemValue) then -- any value is okay
						return true, i
					else
						local value = tonumber(gettok(itemvalues, i, string.byte(',')))
						if (value==itemValue) then
							return true, i, value
						end
					end
				end
			end
		end
	end
	return false
end

function cdoesSafeHaveSpaceForItem(theSafe)
	local items = getElementData(theSafe, "items")
	
	for i=1, 20 do
		if not (items) then -- no items
			return true
		else
			local token = tonumber(gettok(items, i, string.byte(',')))
			if not (token) then
				return true
			end
		end
	end
	return false
end