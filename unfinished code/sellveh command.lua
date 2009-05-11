-- /sellveh [car ID] [Player Name] [Amount]
function sellVehOffer ( thePlayer, commandName, vehID, targetPlayer , amount )

	if not (vehID) or not (targetPlayer) or not (amount) then -- is the command complete?
		outputChatBox("SYNTAX: /" .. commandName .. " [vehicle ID = the car key items value][Partial Player Name / ID][Amount]", thePlayer, 255, 194, 14) -- error message
	else
		local owner = mysql_query( handler, "SELECT owner FROM vehicles WHERE id='".. vehID .. ) -- get the vehicles owner from the sql.
		local vehModel = mysql_query( handler, "SELECT model FROM vehicles WHERE id='".. vehID .. ) -- get the vehicles owner from the sql.
		if not (tonumber(owner) == getElementData(thePlayer, (tonumber("dbid")) -- does the player doing the command own the car?
			outputChatBox("You don't own car ID ".. vehID..".", thePlayer, 255, 0, 0) -- Not owner error message.
		else
			local x, y, z = getElementPosition(thePlayer)
			local tx, ty, tz = getElementPosition(targetPlayer)
			if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are the buyer and seller standing next to each other?
				outputChatBox("You are too far away from this player to sell them a car.", thePlayer, 255, 0, 0) -- distance error message.
			else
				for i = 1, 128 do -- Storing the offers. Similar to report system.
					if (offerNumber[i]==nil) and not (slot) then
						slot = i
					end
				end
				local slot = nil
				offerNumber[slot] = { } -- store the offer information
				offerNumber[slot][1] = owner -- The seller
				offerNumber[slot][2] = targetPlayer -- The buyer
				offerNumber[slot][3] = vehID -- The ID of the vehicle on offer
				offerNumber[slot][4] = vehModel -- The model of the vehicle on offer
				offerNumber[slot][5] = amount -- The model of the vehicle on offer

				setElementData(owner, "offerNumber", slot) -- ?? (taken from report function)
				
				local buyer = getPlayerName(targetPlayer)
				local vehName = getVehicleNameFromModel ( vehModel ) -- Getting the vehicle model name for output.
				local plate = = mysql_query( handler, "SELECT plate FROM vehicles WHERE id='".. vehID .. )-- get the license plate so the owner is sure it's the same car.
				
				outputChatBox("You have offered to sell a ".. vehName ..", license plate number: ".. plate .." to ".. targetPlayer .." for $".. amount ..".", thePlayer, 255, 0, 0) -- Sellers output
				outputChatBox(owner.. "has offered to sell you a ".. vehName ..", license plate number: ".. plate ..", for $".. amount ..".", thePlayer, 255, 0, 0) -- Buyers outputs
				outputChatBox("/acceptveh "..offerNumber.." to accept the deal. /declineveh "..offerNumber.." to decline the deal.", thePlayer, 255, 0, 0) -- Buyers output
			end
		end
	end
end
addCommandHandler("sellveh", sellVehOffer, false, false)

function sellVehAccept ( thePlayer, commandName, offerNumber )
	local id = tonumber( offerNumber )
		if not (offerNumber[id]) then -- Is it a valid offer number?
			outputChatBox("Invalid offer ID.", thePlayer, 255, 0, 0)
		else
			local x, y, z = getElementPosition(thePlayer)
			local tx, ty, tz = getElementPosition(targetPlayer)
			if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
				outputChatBox("You are too far away from this player to buy their car.", thePlayer, 255, 0, 0)
			else
				local money = getElementData(targetPlayer, "money")
				if (cost>money) then -- the buyer afford the offer?
					outputChatBox("This player can't afford the vehicle.", thePlayer, 255, 0, 0)		
					outputChatBox("You can't afford this vehicle.", targetPyayer, 255, 0, 0)
				else
					-- Set the new vehicle owner in the sql.
					-- Remove the key from the old owner.
					-- Place a blip on the radar showing the location of the car to the new owner.
					-- Remove the money from the buyers fund
					-- Add the money to the sellers funds
					
addCommandHandler("acceptveh", sellVehAccept, false, false)

function sellVehDecline ( buyer, commandName, offerNumber )
	local id = tonumber( offerNumber )
		if not (offerNumber[id]) then -- Is it a valid offer number?
			outputChatBox("Invalid offer ID.", buyer, 255, 0, 0)
		else
			if () then -- is the buyer the same buyer that received the original offer.
				-- Delete the offer.
				-- Output comfirmation to buyer and seller.

addCommandHandler("declineveh", sellVehDecline, false, false)