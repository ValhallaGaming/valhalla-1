local line, route, m_number = nil

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
	
	m_number = 0
	triggerServerEvent("payBusDriver", getLocalPlayer(), line, -1)
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
				line = math.random( 1, #g_bus_routes )
				route = g_bus_routes[line]
				local x, y, z = route.points[1][1], route.points[1][2], route.points[1][3]
				busBlip = createBlip(x, y, z, 0, 2, 255, 200, 0, 255)
				busMarker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- start marker.
				addEventHandler("onClientMarkerHit", busMarker, updateBusCheckpoint)
				
				m_number = 1
				triggerServerEvent("payBusDriver", getLocalPlayer(), line, 0)
				
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
			local max_number = #route.points
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
			
			x = route.points[newnumber][1]
			y = route.points[newnumber][2]
			z = route.points[newnumber][3]
			
			if nextnumber <= tonumber(max_number) then
				nx = route.points[nextnumber][1]
				ny = route.points[nextnumber][2]
				nz = route.points[nextnumber][3]
			end
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 0, 0, 150) -- Red marker
				busBlip = createBlip( x, y, z, 0, 3, 255, 0, 0, 255) -- Red blip
				
				addEventHandler("onClientMarkerHit", busMarker, endOfTheLine)
				setMarkerIcon(busMarker, "finish")
				
			elseif (route.points[newnumber][4]==true) then -- If it is a stop.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 0, 0, 150) -- Red marker
				busBlip = createBlip( x, y, z, 0, 3, 255, 0, 0, 255) -- Red blip
				if (route.points[nextnumber][4]==true) then
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
					busNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 0, 0, 255) -- small red blip
				else
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
					busNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 200, 0, 255) --small  yellow blip
				end
				
				addEventHandler("onClientMarkerHit", busMarker, waitAtStop)
				addEventHandler("onClientMarkerLeave", busMarker, checkWaitAtStop)
				
			else -- it is just a route.
				
				busMarker = createMarker( x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- yellow marker
				busBlip = createBlip( x, y, z, 0, 3, 255, 200, 0, 255) -- yellow blip
				if (route.points[nextnumber][4]==true) then
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
					busNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 0, 0, 255) -- small red blip
				else
					busNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
					busNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 200, 0, 255) -- small yellow blip
				end
								
				addEventHandler("onClientMarkerHit", busMarker, updateBusCheckpoint)
			end
			
			if busNextMarker and nextnumber == tonumber(max_number) then
				setMarkerIcon(busNextMarker, "finish")
			end
			
			m_number = m_number + 1
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
		if busStopTimer then
			outputChatBox("You didn't wait at the bus stop.", 255, 0, 0)
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
	
	local stopNumber = route.points[m_number][5]
	triggerServerEvent("payBusDriver", getLocalPlayer(), line, stopNumber)
	
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
				local driver = getVehicleOccupant(source)
				if driver then -- you can only pay the driver if the bus has a driver
					local money = getElementData(getLocalPlayer(),"money")
					if(money<5)then
						triggerServerEvent("removePlayerFromBus", getLocalPlayer())
						outputChatBox("You can't afford the $5 bus fare.", 255, 0, 0)
					else
						triggerServerEvent("payBusFare", getLocalPlayer(), driver)
						outputChatBox("You have paid $5 to ride the bus", 0, 255, 0)
					end
				end
			elseif not busMarker then
				outputChatBox("#FF9933Use /startbus to begin the bus route.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), enterBus)