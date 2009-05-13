function doesPlayerHaveItem(thePlayer, itemID, itemValue)
	local items = getElementData(thePlayer, "items")
	local itemvalues = getElementData(thePlayer, "itemvalues")

	for i=1, 30 do
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

function givePlayerItem(thePlayer, itemID, itemValue)
	local items = getElementData(thePlayer, "items")
	local itemvalues = getElementData(thePlayer, "itemvalues")
	
	local count = 0
	if not (items) or not (itemvalues) then -- no items
		count = 0
	else
		for i=1, 30 do
			local token = gettok(items, i, string.byte(','))
			
			if (token) then
				count = count + 1
			else
				break
			end
		end
	end
	
	if (count==30) then
		return false
	elseif (count==0) then
		items = itemID .. ","
		itemvalues = itemValue .. ","
		
		setElementData(thePlayer, "items", items)
		setElementData(thePlayer, "itemvalues", itemvalues)
		return true
	else
		items = items .. itemID .. ","
		itemvalues = itemvalues .. itemValue .. ","
		
		setElementData(thePlayer, "items", items)
		setElementData(thePlayer, "itemvalues", itemvalues)
		return true
	end
end

function takePlayerItem(thePlayer, itemID, itemValue)
	local items = getElementData(thePlayer, "items")
	local itemvalues = getElementData(thePlayer, "itemvalues")
	
	local found = false
	local itemstring = ""
	local itemvaluestring = ""
	if not (items) or not (itemvalues) then -- no items
		found = false
	else
		for i=1, 30 do
			local token = tonumber(gettok(items, i, string.byte(',')))
			local vtoken = tonumber(gettok(itemvalues, i, string.byte(',')))
			
			if (token) then
				if (itemValue==-1) then -- value doesnt matter
					if (token~=itemID) or (found) then
						
						itemstring = itemstring .. token .. ","
						itemvaluestring = itemvaluestring .. vtoken .. ","
					else
						found = true
					end
				else
					if (token~=itemID) or (itemValue~=vtoken) or (found) then
						local vtoken = tonumber(gettok(itemvalues, i, string.byte(',')))
						itemstring = itemstring .. token .. ","
						itemvaluestring = itemvaluestring .. vtoken .. ","
					else
						found = true
					end
				end
			end
		end
	end
	if (found) then
		setElementData(thePlayer, "items", itemstring)
		setElementData(thePlayer, "itemvalues", itemvaluestring)
		return true
	elseif not (found) then
		return false
	end
end