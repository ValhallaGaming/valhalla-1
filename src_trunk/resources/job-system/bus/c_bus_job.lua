-- { x, y, z, isStop, stop number}
busRoute = {}
busRoute[1]={ 1718, -1855, 12, false, 0} -- Depot start point
busRoute[2]={ 1740, -1857, 12, true, 1} -- Unity
busRoute[3]={ 1890, -1755, 12, false, 0}
busRoute[4]={ 2036, -1755, 12, true, 2} -- Idlewood gas
busRoute[5]={ 2314, -1661, 13, true, 3} -- TGB
busRoute[6]={ 2344, -1541, 23, true, 4} -- Basketball courts
busRoute[7]={ 2344, -1399, 23, false, 0}
busRoute[8]={ 2306, -1320, 23, false, 0}
busRoute[9]={ 2421, -1259, 23, true, 5} -- Pig Pen
busRoute[10]={ 2388.171875, -1170.88671875, 27, false, 0}
busRoute[11]={  2248.2109375, -1139.3955078125, 25, true, 6} -- Jefferson Motel
busRoute[12]={ 2050.04296875, -1077.345703125, 24, false, 0}
busRoute[13]={ 1863.666015625, -1139.748046875, 23, true, 7} -- Glen Park
busRoute[14]={ 1844.55078125, -1380.4072265625, 12, true, 8} -- Skate Park
busRoute[15]={ 1824.796875, -1561.2734375, 12, false, 0}
busRoute[16]={ 1704.4501953125, -1590.40820312, 12, false, 0}
busRoute[17]={ 1550.5732421875, -1589.23046875, 12, false, 0}
busRoute[18]={ 1526.478515625, -1677.846679687, 12, false, 0} 
busRoute[19]={ 1476.1435546875, -1729.3798828125, 12, true, 9} -- City Hall 
busRoute[20]={  1337.837890625, -1729.9736328125, 12, false, 0} 
busRoute[21]={1327.7568359375, -1518.5810546875, 12, false, 0} 
busRoute[22]={ 1360.515625, -1300.849609375, 12, true, 10} -- Main Street
busRoute[23]={1180.7734375, -1278.5087890625, 12, true, 11} -- Hospital
busRoute[24]={ 1061.4228515625, -1239.0751953125, 15, false, 0}
busRoute[25]={ 1085.6611328125, -1105.21289062, 23, false, 0} 
busRoute[26]={ 1089.0087890625, -972.9365234375, 40, false, 0} 
busRoute[27]={ 917.763671875, -969.4033203125, 37, false, 0} 
busRoute[28]={  568.6435546875, -1225.041015625, 16, true, 12} -- Bank
busRoute[29]={ 678.1484375, -1761.373046875, 12, false, 0}
busRoute[30]={ 1212.0234375, -1854.94921875, 12, false, 0}
busRoute[31]={ 1654.560546875, -1875.05859375, 12, false, 0}
busRoute[32]={ 1759.783203125, -1826.096679687, 12, false, 0}
busRoute[33]={ 1736.9365234375, -1851.8310546875, 12, true, 13} -- Depot

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
end

function displayBusJob()
	blip = createBlip(1711.29296875, -1881.2841796875, 13.110404968262, 0, 4, 255, 127, 255)
	outputChatBox("#FF9933Approach the #FF66CCblip#FF9933 on your radar and enter the bus/coach.", 255, 194, 15, true)
end

function startBusJob(thePlayer)
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