-- { x, y, z, isStop, stop number}
busRoute = {
	{ 1718, -1855, 12, false, 0}, -- Depot start point
	{ 1740, -1857, 12, true, 1}, -- Unity
	{ 1890, -1755, 12, false, 0},
	{ 2036, -1755, 12, true, 2}, -- Idlewood gas
	{ 2190.9443359375, -1681.8193359375, 14, false, 0},
	{ 2314, -1661, 13, true, 3}, -- TGB
	{ 2344, -1541, 23, true, 4}, -- Basketball courts
	{ 2344, -1399, 23, false, 0},
	{ 2306, -1320, 23, false, 0},
	{ 2421, -1259, 23, true, 5}, -- Pig Pen
	{ 2388.171875, -1170.88671875, 27, false, 0},
	{ 2248.2109375, -1139.3955078125, 25, true, 6}, -- Jefferson Motel
	{ 2050.04296875, -1077.345703125, 24, false, 0},
	{ 1863.666015625, -1139.748046875, 23, true, 7}, -- Glen Park
	{ 1844.55078125, -1380.4072265625, 12, true, 8}, -- Skate Park
	{ 1824.796875, -1561.2734375, 12, false, 0},
	{ 1704.4501953125, -1590.40820312, 12, false, 0},
	{ 1550.5732421875, -1589.23046875, 12, false, 0},
	{ 1526.478515625, -1677.846679687, 12, false, 0},
	{ 1476.1435546875, -1729.3798828125, 12, true, 9}, -- City Hall 
	{ 1337.837890625, -1729.9736328125, 12, false, 0},
	{ 1327.7568359375, -1518.5810546875, 12, false, 0},
	{ 1360.515625, -1300.849609375, 12, true, 10}, -- Main Street
	{ 1234.5322265625, -1277.625, 13, true, 11}, -- Hospital
	{ 1218.44140625, -1200.3681640625, 20, false, 0},
	{ 1165.2587890625, -1041.2666015625, 31, false, 0},
	{ 1123.9111328125, -942.4951171875, 42, true, 12}, -- Impound
	{ 917.763671875, -969.4033203125, 37, false, 0},
	{ 730.96875, -1066.8232421875, 22, false, 0},
	{ 568.6435546875, -1225.041015625, 16, true, 13}, -- Bank
	{ 273.05859375, -1410.1787109375, 13, false, 0},
	{ 111.1884765625, -1662.326171875, 10, false, 0},
	{ 404.9365234375, -1775.779296875, 5, true, 14}, -- Beach
	{ 678.1484375, -1761.373046875, 12, true, 15}, -- Anchor
	{ 1212.0234375, -1854.94921875, 12, false, 0},
	{ 1654.560546875, -1875.05859375, 12, false, 0},
	{ 1759.783203125, -1826.096679687, 12, false, 0},
	{ 1736.9365234375, -1851.8310546875, 12, true, 16}, -- Depot
}

local busMarker, busNextMarker = nil, nil
local busBlip, busNextBlip = nil, nil

local bus = { [431]=true, [437]=true }

local blip

function resetBusJob()
	if (isElement(blip)) then
		destroyElement(blip)
		removeEventHandler("onClientVehicleEnter", getRootElement(), startBusJob)
		blip = nil
	end
	
	if isElement(busMarker) then
		destroyElement(busMarker)
		busMarker = nil
	end
	
	if isElement(busBlip) then
		destroyElement(busBlip)
		busBlip = nil
	end
	
	if isElement(busNextMarker) then
		destroyElement(busNextMarker)
		busNextMarker = nil
	end
	
	if isElement(busNextBlip) then
		destroyElement(busNextBlip)
		busNextBlip = nil
	end
end

function displayBusJob()
	blip = createBlip(1711.29296875, -1881.2841796875, 13.110404968262, 0, 4, 255, 127, 255)
	outputChatBox("#FF9933Approach the #FF66CCblip#FF9933 on your radar and enter the bus/coach.", 255, 194, 15, true)
end

function startBusJob()
	local job = getElementData(getLocalPlayer(), "job")
	if (job == 3)then
		if (blip) then
			destroyElement(blip)
			blip = nil
		end
		if(busMarker)then
			outputChatBox("#FF9933You have already started a bus route.", 255, 194, 14, true)
		else		
			local vehicle = getPedOccupiedVehicle(getLocalPlayer())
			if vehicle and getVehicleController(vehicle) == getLocalPlayer() and bus[getElementModel(vehicle)] then
				local x, y, z = busRoute[1][1], busRoute[1][2], busRoute[1][3]
				busBlip = createBlip(x, y, z, 0, 2, 255, 200, 0, 255)
				busMarker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- start marker.
				addEventHandler("onClientMarkerHit", busMarker, updateBusCheckpoint)
				
				setElementData(getLocalPlayer(), "busRoute.marker", 1)
				setElementData(getLocalPlayer(), "busRoute.totalmarkers", #busRoute)
				
				outputChatBox("#FF9933Drive around the bus #FFCC00route #FF9933stopping at the #A00101stops #FF9933along the way.", 255, 194, 14, true)
				outputChatBox("#FF9933You will be paid for each stop you make and for people you pick up.", 255, 194, 14, true)
			else
				outputChatBox("#FF9933You must be in a bus or coach to start the bus route.", 255, 194, 14, true)
			end
		end
	else
		outputChatBox("You are not a bus driver.", 255, 194, 14)
	end
end
addCommandHandler("startbus", startBusJob, false, false)

function updateBusCheckpoint(thePlayer)
	if not thePlayer or thePlayer == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (bus[id]) then
			outputChatBox("#FF9933You must be in a bus or coach to drive the bus route.", 255, 0, 0, true ) -- Wrong car type.
		else
			
			-- Find out which marker is next.
			local m_number = getElementData(getLocalPlayer(), "busRoute.marker")
			local max_number = getElementData(getLocalPlayer(), "busRoute.totalmarkers")
			local newnumber = m_number+1
			local nextnumber = m_number+2
			local x, y, z = nil
			if (busBlip) then
				-- Remove the old marker.
				destroyElement(busBlip)
				destroyElement(busMarker)
				busBlip = nil
				busMarker = nil
			end
			
			if busNextBlip then
				destroyElement(busNextBlip)
				destroyElement(busNextMarker)
				busNextBlip = nil
				busNextMarker = nil
			end
			
			x = busRoute[newnumber][1]
			y = busRoute[newnumber][2]
			z = busRoute[newnumber][3]
			
			if nextnumber <= tonumber(max_number) then
				nx = busRoute[nextnumber][1]
				ny = busRoute[nextnumber][2]
				nz = busRoute[nextnumber][3]
			end
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 0, 0, 150) -- Red marker
				busBlip = createBlip( x, y, z, 0, 2, 255, 0, 0, 255) -- Red blip
				
				addEventHandler("onClientMarkerHit", busMarker, endOfTheLine)
				setMarkerIcon(busMarker, "finish")
				
			elseif (busRoute[newnumber][4]==true) then -- If it is a stop.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 0, 0, 150) -- Red marker
				busBlip = createBlip( x, y, z, 0, 2, 255, 0, 0, 255) -- Red blip
				if (busRoute[nextnumber][4]==true) then
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
					busNextBlip = createBlip( nx, ny, nz, 0, 1.5, 255, 0, 0, 255) -- small red blip
				else
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
					busNextBlip = createBlip( nx, ny, nz, 0, 1.5, 255, 200, 0, 255) --small  yellow blip
				end
				
				addEventHandler("onClientMarkerHit", busMarker, waitAtStop)
				addEventHandler("onClientMarkerLeave", busMarker, checkWaitAtStop)
				
			else -- it is just a route.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- yellow marker
				busBlip = createBlip( x, y, z, 0, 2, 255, 200, 0, 255) -- yellow blip
				if (busRoute[nextnumber][4]==true) then
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
					busNextBlip = createBlip( nx, ny, nz, 0, 1.5, 255, 0, 0, 255) -- small red blip
				else
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
					busNextBlip = createBlip( nx, ny, nz, 0, 1.5, 255, 200, 0, 255) -- small yellow blip
				end
				
				setElementData(getLocalPlayer(), "busRoute.marker", newnumber)
				
				addEventHandler("onClientMarkerHit", busMarker, updateBusCheckpoint)
			end
			
			if busNextMarker and nextnumber == tonumber(max_number) then
				setMarkerIcon(busNextMarker, "finish")
			end
			
			setElementData(getLocalPlayer(), "busRoute.marker", newnumber)
			
		end
	end
end

function waitAtStop(thePlayer)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if thePlayer == getLocalPlayer() and vehicle and bus[getElementModel(vehicle)] then
		busStopTimer = setTimer(updateBusCheckpointAfterStop, 5000, 1)
		outputChatBox("#FF9933Wait at the bus stop for a moment.", 255, 0, 0, true )
	end
end

function checkWaitAtStop(thePlayer)
	if thePlayer == getLocalPlayer() then
		outputChatBox("You didn't wait at the bus stop.", 255, 0, 0)
		if busStopTimer then
			killTimer(busStopTimer)
			busStopTimer = nil
		end
	end
end

function updateBusCheckpointAfterStop()
	-- Remove the old marker.
	destroyElement(busBlip)
	destroyElement(busMarker)
	busBlip = nil
	busMarker = nil
	
	local m_number = getElementData(getLocalPlayer(), "busRoute.marker")
	local stopNumber = busRoute[m_number][5]
	triggerServerEvent("payBusDriver", getLocalPlayer(), stopNumber)
	
	updateBusCheckpoint()
end

function endOfTheLine()
	-- Remove the old marker.
	destroyElement(busBlip)
	destroyElement(busMarker)
	busBlip = nil
	busMarker = nil
	outputChatBox("#FF9933End of the Line. Use /startbus to begin the route again.", 0, 255, 0, true )
end

function enterBus ( thePlayer, seat, jacked )
	if(thePlayer == getLocalPlayer())then
		local vehID = getElementModel (source)
		if(bus[vehID])then
			if(seat~=0)then
				local money = getElementData(getLocalPlayer(),"money")
				if(money<5)then
					triggerServerEvent("removePlayerFromBus", getLocalPlayer(), thePlayer)
					outputChatBox("You can't afford the $5 bus fare.", 255, 0, 0)
				else
					triggerServerEvent("payBusFare", getLocalPlayer(), thePlayer)
					outputChatBox("You have paid $5 to ride the bus", 0, 255, 0)
				end
			elseif not busMarker then
				outputChatBox("#FF9933Use /startbus to begin the bus route.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), enterBus)