local drivers = {}
local blips = {}

function updateBusBlips(line)
	local driversonline = 0
	for k, v in ipairs(drivers[line]) do
		driversonline = driversonline + #v
	end
	
	if driversonline > 0 then
		for k, v in ipairs(drivers[line]) do
			-- check back if see if a driver is nearing that
			if #(drivers[line][k-1] or {}) + #v > 0 then
				setBlipColor( blips[line][k], 127, 255, 63, 127 )
			else
				setBlipColor( blips[line][k], 255, 255, 63, 127 )
			end
		end
	else -- no drivers online
		for k, v in ipairs(blips[line]) do
			setBlipColor( v, 255, 63, 63, 127 )
		end
	end
end

function removeDriver()
	for k, v in ipairs(drivers) do
		for key, value in ipairs(v) do
			for i, player in pairs(value) do
				if player == source then
					table.remove(value, i)
				end
			end
		end
	end
end

function removeDriverOnAllLines()
	removeDriver()
	for line, v in pairs(drivers) do
		updateBusBlips(line)
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeDriverOnAllLines )
addEventHandler("onCharacterLogin", getRootElement(), removeDriverOnAllLines )

function payBusDriver(line, stop)
	if stop == -2 then
		removeDriver()
		exports.global:giveMoney(source, 36)
	elseif stop == -1 then
		removeDriverOnAllLines()
		return
	elseif stop == 0 then
		table.insert( drivers[line][1], source )
	else
		exports.global:giveMoney(source, 18)
		
		local x, y, z = getElementPosition(source)
		local chatSphere = createColSphere(x, y, z, 20)
		
		exports.pool:allocateElement(chatSphere)
		
		local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
		
		destroyElement(chatSphere)
		
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		
		for index, nearbyPlayer in ipairs(nearbyPlayers) do
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
			
			if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
				
				local logged = getElementData(nearbyPlayer, "loggedin")
				if not(isPedDead(nearbyPlayer)) and (logged==1) then
					outputChatBox(" -- This stop: [".. g_bus_routes[line].stops[stop] .. "] --", nearbyPlayer, 255, 51, 102)
					if(stop<#g_bus_routes[line].stops)then
						outputChatBox(" -- Next stop: [".. g_bus_routes[line].stops[stop+1] .. "] --", nearbyPlayer, 255, 51, 102)
					end
				end
			end
		end
		
		-- "remove" driver from current blip
		if drivers[line][stop+1] then
			removeDriver()
			table.insert( drivers[line][stop+1], source )
		end
	end
	updateBusBlips(line)
end
addEvent("payBusDriver",true)
addEventHandler("payBusDriver", getRootElement(), payBusDriver)

function takeBusFare(thePlayer)
	exports.global:takeMoney(source, 5)
	exports.global:giveMoney(thePlayer, 5)
end
addEvent("payBusFare", true)
addEventHandler("payBusFare", getRootElement(), takeBusFare)

function ejectPlayerFromBus()
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
end
addEvent("removePlayerFromBus", true)
addEventHandler("removePlayerFromBus", getRootElement(), ejectPlayerFromBus)

-- BUS ROUTES BLIPS
function createBusBlips( )
	for routeID, route in ipairs( g_bus_routes ) do
		blips[routeID] = {}
		drivers[routeID] = {}
		for pointID, point in ipairs( route.points ) do
			if point[4] and #route.points ~= pointID then
				local stop = #blips[routeID]+1
				blips[routeID][stop] = createBlip( point[1], point[2], point[3], 0, 1, 255, 63, 63, 127, -5, 65 )
				drivers[routeID][stop] = {}
			end
		end
	end
end
addEventHandler( "onResourceStart", getResourceRootElement(), createBusBlips )