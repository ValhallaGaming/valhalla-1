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

function createGeneralshop(thePlayer, commandName, shoptype)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if(tonumber(shoptype)) then
			if((tonumber(shoptype) >= 1) and (tonumber(shoptype) < 7)) then
			
				local x, y, z = getElementPosition(thePlayer)
				local dimension = getElementDimension(thePlayer)
				local interior = getElementInterior(thePlayer)
				
				local query = mysql_query(handler, "INSERT INTO shops SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', shoptype='" .. shoptype .. "'")
				
				if (query) then
					local id = mysql_insert_id(handler)
					mysql_free_result(query)
					
					local colCircle = createColCircle(x, y, 3)
					setElementDimension(colCircle, dimension)
					setElementInterior(colCircle, interior)
					
					setElementData(colCircle, "dbid", id)
					setElementData(colCircle, "type", "shop")
					setElementData(colCircle, "shoptype", tonumber(shoptype))
					
					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " created shop #" .. id .. " - type "..shoptype..".")
					outputChatBox("General shop created with ID #" .. id .. " and type "..shoptype..".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Error creating shop.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Type must be between 1 and 6.", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [shop type]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1 = General Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2 = Gun + Ammo Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3 = Food Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 4 = Sex Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 5 = Clothes Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 6 = Gym Store", thePlayer, 255, 194, 14)
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
		
		for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local colshapeType = getElementData(theColshape, "type")
			if (colshapeType) then
				if (colshapeType=="shop") then
					local x, y = getElementPosition(theColshape)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(theColshape)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(theColshape, "dbid")
						local shoptype = getElementData(theColshape, "shoptype")
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
			
			for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
				local colshapeType = getElementData(theColshape, "type")
				if (colshapeType) then
					if (colshapeType=="shop") then
						local dbid = getElementData(theColshape, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(theColshape)
							mysql_query(handler, "DELETE FROM shops WHERE id='" .. dbid .. "' LIMIT 1")
							
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
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT id, x, y, z, dimension, interior, shoptype FROM shops")
		
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
				
				local colCircle = createColCircle(x, y, 3)
				setElementDimension(colCircle, dimension)
				setElementInterior(colCircle, interior)
				
				setElementData(colCircle, "dbid", id)
				setElementData(colCircle, "type", "shop")
				setElementData(colCircle, "shoptype", tonumber(shoptype))
				counter = counter + 1
			end
			mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " general shops.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllGeneralshops)

function hitCollisionShape(hitElement, matchingDimension)
	if (matchingDimension) then -- Same dimension
		local elementType = getElementType(hitElement)
		if (elementType=="player") then
			local colshapeType = getElementData(source, "type")
			if (colshapeType=="shop") then
				local shoptype = getElementData(source, "shoptype")
				
				local race = 1
				
				if(shoptype == 5) then -- if its a clothes shop, we also need the players race
					local username = getPlayerName(hitElement)
					local result = mysql_query(handler, "SELECT skincolor FROM characters WHERE charactername='" .. username .. "' LIMIT 1")
					local race = tonumber(mysql_result(result, 1, 1))
					
					mysql_free_result(result)
				end
				triggerClientEvent(hitElement, "showGeneralshopUI", hitElement, shoptype, race)
			end
		end
	end
end
addEventHandler("onColShapeHit", getRootElement(), hitCollisionShape)



function givePlayerBoughtItem(itemID, itemValue, theCost, isWeapon, name, supplyCost)
	local interior = getElementDimension(source)
	local money = tonumber(getElementData(source, "money"))
	
	local thePickup = nil
	local inttype = nil
	local supplies = nil
	for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
		local pickupType = getElementData(value, "type")
		if (pickupType=="interior") then
			local id = getElementData(value, "dbid")
			if (tonumber(id)==tonumber(interior)) then
				thePickup = value
				inttype = getElementData(value, "inttype")
				break
			end
		end
	end
	
	if (inttype==1) then
		local result = mysql_query(handler, "SELECT supplies FROM interiors WHERE id='" .. interior .. "' LIMIT 1")
		supplies = tonumber(mysql_result(result, 1, 1))
		mysql_free_result(result)
	end
	
	if (money<tonumber(theCost)) then
		outputChatBox("You cannot afford this item.", source, 255, 0, 0)
	else
		if (inttype==2) or not (inttype) then
			if (isWeapon==nil) then
				exports.global:takePlayerSafeMoney(source, tonumber(theCost))
				exports.global:givePlayerItem(source, 16, tonumber(itemValue))
				setPedSkin(source, tonumber(itemValue))
				setElementData(source, "casualskin", tonumber(itemValue))
				exports.global:givePlayerAchievement(source, 21)
			elseif (isWeapon==false) then
				if(exports.global:givePlayerItem(source, itemID, itemValue)) then
					exports.global:takePlayerSafeMoney(source, tonumber(theCost))
					outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
					outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
				end
			elseif (isWeapon) and (itemValue==-1) then -- fighting styles!
				exports.global:takePlayerSafeMoney(source, tonumber(theCost))
				outputChatBox("You learnt " .. name .. ".", source, 255, 194, 14)
				outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
				setPedFightingStyle(source, tonumber(itemID))
				exports.global:givePlayerAchievement(source, 20)
			else
				if (itemID==28) or (itemID==30) or (itemID==32) then
					-- licensing check
					local gunlicense = getElementData(source, "license.gun")
					if (gunlicense==1) then
						exports.global:takePlayerSafeMoney(source, tonumber(theCost))
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $".. getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
						giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
					else
						outputChatBox("You do not have a gun license - You can buy this license at City Hall.", source, 255, 194, 14)
					end
				else
					exports.global:takePlayerSafeMoney(source, tonumber(theCost))
					outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
					outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
					giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
					exports.global:givePlayerAchievement(source, 22)
				end
			end
		elseif (inttype==1) then
			if (supplies<supplyCost) then
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
					exports.global:takePlayerSafeMoney(source, tonumber(theCost))
					exports.global:givePlayerItem(source, 16, tonumber(itemValue))
					setPedSkin(source, tonumber(itemValue))
					setElementData(source, "casualskin", tonumber(itemValue))
					exports.global:givePlayerAchievement(source, 21)
				elseif (isWeapon==false) then
					if(exports.global:givePlayerItem(source, itemID, itemValue)) then
						exports.global:takePlayerSafeMoney(source, tonumber(theCost))
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
					end
				elseif (isWeapon) and (itemValue==-1) then -- fighting styles!
					exports.global:takePlayerSafeMoney(source, tonumber(theCost))
					outputChatBox("You learnt " .. name .. ".", source, 255, 194, 14)
					outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
					setPedFightingStyle(source, tonumber(itemID))
					exports.global:givePlayerAchievement(source, 20)
				else
					if (itemID==28) or (itemID==30) or (itemID==32) then
						-- licensing check
						local gunlicense = getElementData(source, "license.gun")
						if (gunlicense==1) then
							exports.global:takePlayerSafeMoney(source, tonumber(theCost))
							outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
							outputChatBox("You have $".. getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
							giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
						else
							outputChatBox("You do not have a gun license - You can buy this license at City Hall.", source, 255, 194, 14)
						end
					else
						exports.global:takePlayerSafeMoney(source, tonumber(theCost))
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..getElementData(source, "money").." left in your wallet.", source, 255, 194, 14)
						giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
						exports.global:givePlayerAchievement(source, 22)
					end
				end
				mysql_query(handler, "UPDATE interiors SET supplies = supplies-1 WHERE id='" .. interior .. "'")
				
				-- give the money to the shop owner
				local owner = getElementData(thePickup, "owner")
				local theOwner = nil
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local id = getElementData(value, "dbid")
					if (id==owner) then
						theOwner = value
					end
				end
				
				mysql_query(handler, "UPDATE characters SET money=money + " .. tonumber(theCost) .. " WHERE id='" .. owner .. "' LIMIT 1")
				if (theOwner) then
					exports.global:givePlayerSafeMoney(theOwner, theCost)
					local profits = getElementData(theOwner, "businessprofit")
					setElementData(theOwner, "businessprofit", profits+theCost)
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
	mysql_query(handler, "UPDATE settings SET value='" .. globalSupplies .. "' WHERE name='globalsupplies'")
end
addEvent("updateGlobalSupplies", false)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

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
					local money = getElementData(thePlayer, "money")
					
					if (cost>money) then
						outputChatBox("You cannot afford that many supplies. (Cost is 2$ per supply).", thePlayer, 255, 0, 0)
					else
						exports.global:takePlayerSafeMoney(thePlayer, cost)
						globalSupplies = globalSupplies - amount
						mysql_query(handler, "UPDATE settings SET value='" .. globalSupplies .. "' where name='globalsupplies'")
						mysql_query(handler, "UPDATE interiors SET supplies= supplies + " .. amount .. " where id='" .. dbid .. "'")
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

function resStart(res)
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
		globalSupplies = tonumber(mysql_result(result, 1, 1))

		mysql_free_result(result)
	end
end
addEventHandler("onResourceStart", getRootElement(), resStart)