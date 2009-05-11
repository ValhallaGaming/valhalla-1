---------
-- sql --
---------
INSERT INTO items SET id='26', item_name='Fuel Can', item_description='A small red fuel can.';

-------------------------------
-- server side item resource --
-------------------------------
fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

-- use item function
elseif (itemID==26) then -- Fuel Can
			showInventory(source)
			local theVehicle = getPedOccupiedVehicle(source) -- is the player in a vehicle?
			if (theVehicle) then
				if not (fuellessVehicle[theVehicle]) then -- check the vehicle is not fuelless
					if (itemValue>0) then
						local fuelAmount = getElementData(theVehicle, "fuel") -- get the fuel amount and check its not full.
						if (fuelAmount+itemValue<=100) then
							setElementData(theVehicle, "fuel", (fuelAmount + itemValue)) -- add the value to the fuel amount
							local vehicleName = getVehicleName (theVehicle) -- get the vehicle plus model name.
							exports.global:sendLocalMeAction(source, " refuels the "..vehicleName.." using a fuel can.") -- Chat output
							
							-- Set the itemValue to 0 but keep the item. The player can then refill it at a gas station.
							
							showInventory(source)
						else
							outputChatBox("Wait for the fuel to decrease some more before refilling.", source, 255, 194, 14)
						end
					else
						outputChatBox("The fuel can is empty. /fillcan at a gas station.", source, 255, 194, 14)
					end
				else
					outputChatBox("This vehicle does not have a fuel tank.", source, 255, 194, 14)
				end
			else
				outputChatBox("You must be in a vehicle to use this item.", source, 255, 194, 14) 
			end

-------------------------------
-- Client side shop resource --
-------------------------------
-- Adds an empty fuel can item to the general shop GUI
function getItemsForSale(shop_type, race)
	if(shop_type == 1) then
		-- General Items
		item[21] = {"Fuel Can", "An empty fuel can.", "10", 26, 0, 1, false,}

-------------------------------
-- Server side fuel resource --
-------------------------------
-- Allows players to refill the fuel can. Sets the cans value to 5 so that 5 units of fuel can be transfered to a vehicle.
function fillCan(thePlayer, commandName)
	if (isPedInVehicle(thePlayer)) then
		outputChatBox("You need to get out of the vehicle to fill a fuel can.", thePlayer, 255, 0, 0)
	else
		local colShape = nil
		
		for key, value in ipairs(getElementsByType("colshape")) do
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
		
		if (colShape) then
			-- loop through the inventory and find the first fuel can's value.
			-- if there are no fuel cans output a message "you need to buy a fuel can".
			-- if the first fuel can's value is >=5 move on to find the next fuel can.
			-- if there are no more fuel cans output the message "All your fuel cans are full".
			-- If the player has another fuel can that has a value of less than 5 output global /me "PlayerName fills the fuels can" and "please wait while the can is filled" messages.
			-- after a delay check they are still in the colShape.
				-- if they are then set the fuel can's value to 5.
				-- price = fuel price * 5.
				-- remove price from player money.
				-- Output a message "fuel can filled at a cost of $".. price .."."
			-- if they have left the colShape output message "Don't you want any fuel?"
		end
	end
end
addCommandHandler("fillcan", fillCan)
