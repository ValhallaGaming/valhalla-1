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
	if (itemID==1) then return "Haggis"
	elseif (itemID==2) then return "Cellphone"
	elseif (itemID==3) then return "Vehicle Key"
	elseif (itemID==4) then return "House Key"
	elseif (itemID==5) then return "Business Key"
	elseif (itemID==6) then return "Radio"
	elseif (itemID==7) then return "Phonebook"
	elseif (itemID==8) then return "Sandwich"
	elseif (itemID==9) then return "Softdrink"
	elseif (itemID==10) then return "Dice"
	elseif (itemID==11) then return "Taco"
	elseif (itemID==12) then return "Burger"
	elseif (itemID==13) then return "Donut"
	elseif (itemID==14) then return "Cookie"
	elseif (itemID==15) then return "Water"
	elseif (itemID==16) then return "Clothes"
	elseif (itemID==17) then return "Watch"
	elseif (itemID==18) then return "City Guide"
	elseif (itemID==19) then return "MP3 Player"
	elseif (itemID==20) then return "Standard Fighting for Dummies"
	elseif (itemID==21) then return "Boxing for Dummies"
	elseif (itemID==22) then return "Kung Fu for Dummies"
	elseif (itemID==23) then return "Knee Head Fighting for Dummies"
	elseif (itemID==24) then return "Grab Kick Fighting for Dummies"
	elseif (itemID==25) then return "Elbow Fighting for Dummies"
	elseif (itemID==26) then return "Gas Mask"
	elseif (itemID==27) then return "Flashbang"
	elseif (itemID==28) then return "Glowstick"
	elseif (itemID==29) then return "Door Ram"
	elseif (itemID==30) then return "Cannabis Sativa"
	elseif (itemID==31) then return "Cocaine Alkaloid"
	elseif (itemID==32) then return "Lysergic Acid"
	elseif (itemID==33) then return "Unprocessed PCP"
	elseif (itemID==34) then return "Cocaine"
	elseif (itemID==35) then return "Drug 2"
	elseif (itemID==36) then return "Drug 3"
	elseif (itemID==37) then return "Drug 4"
	elseif (itemID==38) then return "Marijuana"
	elseif (itemID==39) then return "Drug 6"
	elseif (itemID==40) then return "Angel Dust"
	elseif (itemID==41) then return "LSD"
	elseif (itemID==42) then return "Drug 9"
	elseif (itemID==43) then return "PCP Hydrochloride"
	elseif (itemID==44) then return "Chemistry Set"
	elseif (itemID==45) then return "Handcuffs"
	elseif (itemID==46) then return "Rope"
	elseif (itemID==47) then return "Handcuff Keys"
	elseif (itemID==48) then return "Backpack"
	elseif (itemID==49) then return "Fishing Rod"
	elseif (itemID==50) then return "Los Santos Highway Code"
	elseif (itemID==51) then return "Chemistry 101"
	elseif (itemID==52) then return "Police Officer's Manual"
	elseif (itemID==53) then return "Breathalizer"
	elseif (itemID==54) then return "Ghettoblaster"
	elseif (itemID==55) then return "Business Card"
	elseif (itemID==56) then return "Ski Mask/Balaclava"
	elseif (itemID==57) then return "Fuel Can"
	elseif (itemID==58) then return "Ziebrand Beer"
	elseif (itemID==59) then return "Mudkip"
	elseif (itemID==60) then return "Safe"
	else return false 
	end
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