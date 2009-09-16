-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

-- respawn dead npcs after two minute
addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		setTimer(
			function( source )
				local x,y,z = getElementPosition(source)
				local rotation = getElementData(source, "rotation")
				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)
				local dbid = getElementData(source, "dbid")
				local shoptype = getElementData(source, "shoptype")
				local skin = getElementModel(source)
				
				destroyElement(source)
				createShopKeeper(x,y,z,interior,dimension,dbid,shoptype,rotation,skin)
			end,
			120000, 1, source
		)
	end
)

local skins = { { 211, 217 }, { 179 }, false, { 178 }, { 82 }, { 80, 81 }, { 28, 29 }, { 169 }, { 171, 172 } }

function createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation, skin)
	if not skin then
		skin = 0
		
		if shoptype == 3 then
			skin = 168
			-- needs differences for burgershot etc
			if interior == 5 then
				skin = 155
			elseif interior == 9 then
				skin = 167
			elseif interior == 10 then
				skin = 205
			elseif dimension == 1355 then
				skin = 171
			end
			-- interior 17 = donut shop
		elseif shoptype==10 then
			skin = 142
		else
			-- clothes, interior 5 = victim
			-- clothes, interior 15 = binco
			-- clothes, interior 18 = zip
			skin = skins[shoptype][math.random( 1, #skins[shoptype] )]
		end
	end
	
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementDimension(ped, dimension)
	setElementInterior(ped, interior)
	exports.pool:allocateElement(ped)
	setElementData(ped, "shopkeeper", true)
	setPedFrozen(ped, true)
	
	setElementData(ped, "dbid", id, false)
	setElementData(ped, "type", "shop", false)
	setElementData(ped, "shoptype", shoptype, false)
	setElementData(ped, "rotation", rotation, false)
end

function isGun(weaponID)
	if weaponID <= 15 or weaponID >= 42 then
		return false
	end
	return true
end

function createGeneralshop(thePlayer, commandName, shoptype)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if(tonumber(shoptype)) then
			if((tonumber(shoptype) >= 1) and (tonumber(shoptype) < 11)) then
			
				local x, y, z = getElementPosition(thePlayer)
				local dimension = getElementDimension(thePlayer)
				local interior = getElementInterior(thePlayer)
				local rotation = math.ceil(getPedRotation(thePlayer) / 30)*30
				
				local query = mysql_query(handler, "INSERT INTO shops SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', shoptype='" .. shoptype .. "', rotation='" .. rotation .. "'")
				
				if (query) then
					local id = mysql_insert_id(handler)
					mysql_free_result(query)
					
					createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation)

					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " created shop #" .. id .. " - type "..shoptype..".")
					outputChatBox("General shop created with ID #" .. id .. " and type "..shoptype..".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Error creating shop.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Type must be between 1 and 10.", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [shop type]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1 = General Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2 = Gun + Ammo Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3 = Food Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 4 = Sex Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 5 = Clothes Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 6 = Gym Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 7 = Drug Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 8 = Electronics Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 9 = Alcohol Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 10 = Book Store", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("makeshop", createGeneralshop, false, false)

function getNearbyGeneralshops(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby shops:", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
			local pedType = getElementData(thePed, "type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						outputChatBox("   Shop with ID " .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyshops", getNearbyGeneralshops, false, false)

function deleteGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			
			for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
				local pedType = getElementData(thePed, "type")
				if (pedType) then
					if (pedType=="shop") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							local query = mysql_query(handler, "DELETE FROM shops WHERE id='" .. dbid .. "' LIMIT 1")
							mysql_free_result(query)
							exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) ..  " deleted shop with ID #" .. id .. ".")
							outputChatBox("Deleted shop with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
						end
					end
				end
			end
			
			if (counter==0) then
				outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delshop", deleteGeneralShop, false, false)

function loadAllGeneralshops(res)
	local result = mysql_query(handler, "SELECT id, x, y, z, dimension, interior, shoptype, rotation FROM shops")
	
	local counter = 0
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
			local x = tonumber(row[2])
			local y = tonumber(row[3])
			local z = tonumber(row[4])
			
			local dimension = tonumber(row[5])
			local interior = tonumber(row[6])
			local shoptype = tonumber(row[7])
			
			local rotation = tonumber(row[8])
			
			createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation)
			counter = counter + 1
		end
		mysql_free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " general shops.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllGeneralshops)

function clickStoreKeeper(ped)
	local shoptype = getElementData(ped, "shoptype")

	local race = 1

	local race, gender = -1, -1
	if(shoptype == 5) then -- if its a clothes shop, we also need the players race
		local result = mysql_query(handler, "SELECT gender,skincolor FROM characters WHERE charactername='" .. getPlayerName(source) .. "' LIMIT 1")
		gender = tonumber(mysql_result(result,1,1))
		race = tonumber(mysql_result(result,1,2))
		mysql_free_result(result)
	end
	triggerClientEvent(source, "showGeneralshopUI", source, shoptype, race, gender)
end
addEvent("onClickStoreKeeper", true)
addEventHandler("onClickStoreKeeper", getRootElement(), clickStoreKeeper)



function givePlayerBoughtItem(itemID, itemValue, theCost, isWeapon, name, supplyCost)
	local interior = getElementDimension(source)
	
	if (itemID==48) then -- BACKPACK = UNIQUE
		if (exports.global:hasItem(source, itemID)) then
			outputChatBox("You already have one of this item, this item is unique.", source, 255, 0, 0)
			return
		end
	end
	
	local inttype = nil
	local supplies = nil
	local dbid, thePickup = call( getResourceFromName( "interior-system" ), "findProperty", source)
	if thePickup then
		inttype = getElementData(thePickup, "inttype")
	end
	
	if inttype == 1 then
		local result = mysql_query(handler, "SELECT supplies FROM interiors WHERE id='" .. interior .. "' LIMIT 1")
		supplies = tonumber(mysql_result(result, 1, 1))
		mysql_free_result(result)
	end
	
	if not exports.global:hasMoney(source, theCost) then
		outputChatBox("You cannot afford this item.", source, 255, 0, 0)
	else
		if inttype==1 and supplies<supplyCost then
			outputChatBox("This item is out of stock.", source, 255, 0, 0)
			local owner = getElementData(thePickup, "owner")
			local theOwner = nil
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local id = getElementData(value, "dbid")
				if (id==owner) then
					theOwner = value
				end
			end
			
			if (theOwner) then
				exports.global:givePlayerAchievement(theOwner, 28)
				outputChatBox("Supplies in your shop are empty!!! Be sure to fill them up, or you risk losing business.", theOwner, 255, 0, 0)
			end
		else
			if (isWeapon==nil) then
				if exports.global:takeMoney(source, theCost) then
					exports.global:giveItem(source, 16, tonumber(itemValue))
					setPedSkin(source, tonumber(itemValue))
					setElementData(source, "casualskin", tonumber(itemValue), false)
					exports.global:givePlayerAchievement(source, 21)
				end
			elseif (isWeapon==false) and (itemID==68) then
				local ticketNumber = exports.lottery:giveTicket(source)
				if ticketNumber ~= false then
					exports.global:takeMoney(source, tonumber(theCost))
					outputChatBox("You bought a " .. name .. ". The ticket number is: " .. ticketNumber .. ".", source, 255, 194, 14)
					outputChatBox("The money will be transfered to your account if you win.", source, 255, 194, 14)
					outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
				else
					outputChatBox("I'm sorry, the lottery is already closed. Wait for the next round.", source, 255, 194, 14)
				end
			elseif (isWeapon==false) then
				if(exports.global:giveItem(source, itemID, itemValue)) then
					if exports.global:takeMoney(source, theCost) then
						if (itemID~=30) and (itemID~=31) and (itemID~=32) and (itemID~=33) then
							outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
							outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
						else
							outputChatBox("You stole some " .. name .. ".", source, 255, 194, 14)
						end
					end
				else
					outputChatBox("You do not have enough space to purchase that item.", source, 255, 0, 0)
				end
			elseif (isWeapon) and (itemValue==-1) then -- fighting styles!
				if exports.global:takeMoney(source, theCost) then
					outputChatBox("You learnt " .. name .. ".", source, 255, 194, 14)
					outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
					
					itemID = tonumber(itemID)
					
					if (itemID==4) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 20, 1)
					elseif (itemID==5) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 21, 1)
					elseif (itemID==6) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 22, 1)
					elseif (itemID==7) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 23, 1)
					elseif (itemID==15) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 24, 1)
					elseif (itemID==16) then
						setPedFightingStyle(source, itemID)
						exports.global:giveItem(source, 25, 1)
					end
					
					exports.global:givePlayerAchievement(source, 20)
				end
			else
				if (itemID==999) then
					if exports.global:takeMoney(source, tonumber(theCost)) then
						setPedArmor(source, 50)
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
					end
				elseif isWeapon and isGun(tonumber(itemID)) then
					-- licensing check
					local gunlicense = getElementData(source, "license.gun")
					if (gunlicense==1) then
						if exports.global:takeMoney(source, theCost) then
							outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
							outputChatBox("You have $".. exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
							exports.global:giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
						end
					else
						outputChatBox("You do not have a weapons license - You can buy this license at City Hall.", source, 255, 194, 14)
					end
				else
					if exports.global:takeMoney(source, theCost) then
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
						exports.global:giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
						exports.global:givePlayerAchievement(source, 22)
					end
				end
			end
			
			if inttype == 1 then
				local query = mysql_query(handler, "UPDATE interiors SET supplies = supplies-1 WHERE id='" .. interior .. "'")
				mysql_free_result(query)
				-- give the money to the shop owner
				local owner = getElementData(thePickup, "owner")
				local theOwner = nil
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local id = getElementData(value, "dbid")
					if (id==owner) then
						theOwner = value
					end
				end
				
				query = mysql_query(handler, "UPDATE characters SET bankmoney=bankmoney + " .. tonumber(theCost) .. " WHERE id='" .. owner .. "' LIMIT 1")
				mysql_free_result(query)
				if (theOwner) then
					--exports.global:givePlayerSafeMoney(theOwner, theCost)
					local profits = getElementData(theOwner, "businessprofit")
					setElementData(theOwner, "businessprofit", profits+theCost, false)
				end
				
				if (supplies-1<10) then
					if (theOwner) then
						outputChatBox("Supplies in your shop are running low! (Less than 10). Be sure to fill them up, or you risk losing business.", theOwner, 255, 0, 0)
					end
				end
			end
		end
	end
end
addEvent("ItemBought", true )
addEventHandler("ItemBought", getRootElement(), givePlayerBoughtItem, itemID, ammoAmount, theCost)

globalSupplies = 0

function updateGlobalSupplies(value)
	globalSupplies = globalSupplies + value
	local query = mysql_query(handler, "UPDATE settings SET value='" .. globalSupplies .. "' WHERE name='globalsupplies'")
	mysql_free_result(query)
end
addEvent("updateGlobalSupplies", true)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

function checkSupplies(thePlayer)
	local interior = getElementInterior(thePlayer)
	
	if (interior==0) then
		outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
	else
		local dbid = getElementDimension(thePlayer)
			
		local owner = nil
		local inttype = nil
		local pickups = exports.pool:getPoolElementsByType("pickup")
		for k, thePickup in ipairs(pickups) do
			local pickupType = getElementData(thePickup, "type")
			
			if (pickupType=="interiorexit") then
				local pickupID = getElementData(thePickup, "dbid")
				if (pickupID==dbid) then
					owner = getElementData(thePickup, "owner")
					inttype = getElementData(thePickup, "inttype")
				end
			end
		end
			
		if (tonumber(owner)==getElementData(thePlayer, "dbid")) and (inttype==1) then
			local query = mysql_query(handler, "SELECT supplies FROM interiors WHERE id='" .. dbid .. "' LIMIT 1")
			local supplies = mysql_result(query, 1, 1)
			mysql_free_result(query)
			
			outputChatBox("This business has " .. supplies .. " supplies.", thePlayer, 255, 194, 14)
		else
			outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checksupplies", checkSupplies, false, false)

function orderSupplies(thePlayer, commandName, amount)
	if not (amount) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Amount of Supplies]", thePlayer, 255, 194, 14)
	else
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
				
			local owner = nil
			local inttype = nil
			local pickups = exports.pool:getPoolElementsByType("pickup")
			for k, thePickup in ipairs(pickups) do
				local pickupType = getElementData(thePickup, "type")
				
				if (pickupType=="interiorexit") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==dbid) then
						owner = getElementData(thePickup, "owner")
						inttype = getElementData(thePickup, "inttype")
					end
				end
			end
			
			if (tonumber(owner)==getElementData(thePlayer, "dbid")) and (inttype==1) then
				amount = tonumber(amount)
				
				if (amount>globalSupplies) then
					outputChatBox("Supplier: Sorry, we do not have that many supplies in stock currently.", thePlayer, 255, 194, 14)
				else
					local cost = amount*2
					
					if not exports.global:takeMoney(thePlayer, cost) then
						outputChatBox("You cannot afford that many supplies. (Cost is 2$ per supply).", thePlayer, 255, 0, 0)
					else
						globalSupplies = globalSupplies - amount
						local query = mysql_query(handler, "UPDATE settings SET value='" .. globalSupplies .. "' where name='globalsupplies'")
						mysql_free_result(query)
						query = mysql_query(handler, "UPDATE interiors SET supplies= supplies + " .. amount .. " where id='" .. dbid .. "'")
						mysql_free_result(query)
						outputChatBox("You bought " .. amount .. " supplies for your business.", thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("ordersupplies", orderSupplies, false, false)

function resStart()
	local result = mysql_query(handler, "SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
	globalSupplies = tonumber(mysql_result(result, 1, 1))

	mysql_free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)