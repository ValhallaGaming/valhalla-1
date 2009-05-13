function createATM(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
			
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		local x, y, z  = getElementPosition(thePlayer)
		local rotation = getPedRotation(thePlayer)
		
		z = z - 0.3
		
		local query = mysql_query(handler, "INSERT INTO atms SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', rotation='" .. rotation .. "'")
				
		if (query) then
			local id = mysql_insert_id(handler)
			mysql_free_result(query)
			
			local object = createObject(2942, x, y, z, 0, 0, rotation-180)
			exports.pool:allocateElement(object)
			setElementDimension(object, dimension)
			setElementInterior(object, interior)
			
			local px = x + math.sin(math.rad(-rotation)) * 0.8
				local py = y + math.cos(math.rad(-rotation)) * 0.8
				local pz = z
			
			local pickup = createPickup(px, py, pz, 3, 1274)
			exports.pool:allocateElement(pickup)
			setElementDimension(pickup, dimension)
			setElementInterior(pickup, interior)
			
			setElementData(object, "dbid", id)
			setElementData(object, "type", "atm")
			
			setElementData(pickup, "dbid", id)
			setElementData(pickup, "type", "atm")
			addEventHandler("onPickupHit", pickup, showATMInterface)
			
			x = x + ((math.cos(math.rad(rotation)))*5)
			y = y + ((math.sin(math.rad(rotation)))*5)
			setElementPosition(thePlayer, x, y, z)
			
			outputChatBox("ATM created with ID #" .. id .. "!", thePlayer, 0, 255, 0)
		else
			outputChatBox("There was an error while creating an ATM. Try again.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addatm", createATM, false, false)

function loadAllATMs(res)
	if (res==getThisResource()) then
		local result = mysql_query(handler, "SELECT id, x, y, z, rotation, dimension, interior FROM atms")
		local counter = 0
		
		if (result) then
			for result, row in mysql_rows(result) do
				local id = tonumber(row[1])
				local x = tonumber(row[2])
				local y = tonumber(row[3])
				local z = tonumber(row[4])

				local rotation = tonumber(row[5])
				local dimension = tonumber(row[6])
				local interior = tonumber(row[7])
				
				local object = createObject(2942, x, y, z, 0, 0, rotation-180)
				exports.pool:allocateElement(object)
				setElementDimension(object, dimension)
				setElementInterior(object, interior)
				
				local px = x + math.sin(math.rad(-rotation)) * 0.8
				local py = y + math.cos(math.rad(-rotation)) * 0.8
				local pz = z
				
				local pickup = createPickup(px, py, pz, 3, 1274)
				exports.pool:allocateElement(pickup)
				setElementDimension(pickup, dimension)
				setElementInterior(pickup, interior)
				
				setElementData(object, "dbid", id)
				setElementData(object, "pickup", pickup)
				setElementData(object, "type", "atm")
				
				setElementData(pickup, "dbid", id)
				setElementData(pickup, "type", "atm")
				addEventHandler("onPickupHit", pickup, showATMInterface)
				counter = counter + 1
			end
			mysql_free_result(result)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " ATMs.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllATMs)

function deleteATM(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
				
			local counter = 0
			local objects = exports.pool:getPoolElementsByType("object")
			for k, theObject in ipairs(objects) do
				local objectType = getElementData(theObject, "type")
					
				if (objectType=="atm") then
					local objectID = getElementData(theObject, "dbid")
					if (objectID==id) then
						destroyElement(theObject)
						counter = counter + 1
					end
				end
			end
			
			local pickups = exports.pool:getPoolElementsByType("pickup")
			for k, thePickup in ipairs(pickups) do
				local pickupType = getElementData(thePickup, "type")
					
				if (pickupType=="atm") then
					local pickupID = getElementData(thePickup, "dbid")
					if (pickupID==id) then
						destroyElement(thePickup)
					end
				end
			end
			
			if (counter>0) then -- ID Exists
				local query = mysql_query(handler, "DELETE FROM atms WHERE id='" .. id .. "'")
				
				if (query) then
					mysql_free_result(query)
				end
				
				outputChatBox("ATM #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted ATM #" .. id .. ".")
			else
				outputChatBox("ATM ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delatm", deleteATM, false, false)

function getNearbyATMs(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby ATMs:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(exports.pool:getPoolElementsByType("object")) do
			local objecttype = getElementData(theObject, "type")
			if (objecttype=="atm") then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					local dbid = getElementData(theObject, "dbid")
					outputChatBox("   ATM with ID " .. dbid .. ".", thePlayer)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyatms", getNearbyATMs, false, false)

function showATMInterface(thePlayer)
	local result = mysql_query(handler, "SELECT faction_id, faction_leader FROM characters WHERE charactername='" .. getPlayerName(thePlayer) .. "' LIMIT 1")
	
	if (result) then
		local faction_id = tonumber(mysql_result(result, 1, 1))
		local faction_leader = tonumber(mysql_result(result, 1, 2))
		mysql_free_result(result)
		
		local isInFaction = false
		local isFactionLeader = false
		
		if (faction_id>0) then
			isInFaction = true
		end
		
		if (faction_leader==1) then
			isFactionLeader = true
		end
		
		local faction = getPlayerTeam(thePlayer)
		local money = getElementData(faction, "money")
		triggerClientEvent(thePlayer, "showBankUI", thePlayer, isInFaction, isFactionLeader, money)
	end
end