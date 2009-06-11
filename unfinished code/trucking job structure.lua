RSHaulTruck = {[]=true, []=true, []=true, []=true, []=true} -- need to /makecivveh. The trucks and trailers are permanently spawned.

-- Trucking Delivery Points
local point1 = ( , , )
local point2 = ( , , )
local point3 = ( , , )
local point4 = ( , , )
local point5 = ( , , )
local point6 = ( , , )
local point7 = ( , , )
local point8 = ( , , )
local point9 = ( , , )
local point10 = ( , , )

-- variables
local lastDeliveryPoint = 0
local revenue = 0

-- Phase 1: Initiate the job.
function truckJob (commandName, thePlayer)

	if not (isPedInVehicle(thePlayer)) and (getPedOccupiedVehicle(RSHaulTruck) then -- Is the player in a RS Haul vehicle
		outputChatBox("You must be in an RS Haul truck to begin deliveries.", thePlayer, 255, 0, 0)
	else
		local jobID = -- get the players job ID.
		if not (jobID == 1) then -- If they aren't a trucker.
			outputChatBox("Only RS Haul employees can do deliveries.", thePlayer, 255, 0, 0)
			outputChatBox("Visit City Hall to get the intercity trucker job.", thePlayer, 255, 0, 0)
		else
			triggerServerEvent("createDeliveryPoint")
		end
	end
end
addCommandHandler ("truckjob", truckJob)

-- Phase 2: Select a delivery point.
function createDeliveryPointHandler(thePlayer)

	local deliveryPoint = math.random(1,10) -- select a random point
	
	if (deliveryPoint) == (lastDeliveryPoint) then
		triggerServerEvent ("createDeliveryPoint")
	else
		local lastDeliveryPoint = deliveryPoint
		
		local blip = createBlip() -- create radar blip at delivery point.
		local marker = createMarker() -- create marker at delivery point.
		local colsphere = createColSphere(284.39205932617, 1411.373046875, 10.4046459198, 4) -- Create colision sphere where marker is.
		attachElements(marker, blip)
		exports.pool:allocateElement(blip)
		exports.pool:allocateElement(marker)

		setElementVisibleTo(marker, getRootElement(), false)
		setElementVisibleTo(marker, thePlayer, true)
		setElementVisibleTo(blip, getRootElement(), false)
		setElementVisibleTo(blip, thePlayer, true)
		
		setElementData(marker, "owner", getElementData(thePlayer, "gameaccountid"))
		setElementData(marker, "type", "job")
		setElementData(blip, "owner", getElementData(thePlayer, "gameaccountid"))
		setElementData(blip, "type", "job")
		
		addEventHandler("onColShapeHit", colsphere, dropOff) -- when the player enters the marker trigger the next stage.
		
	end
end
addEvent ("createDeliveryPoint")
addEventHandler ("createDeliveryPoint", getRootElement, createDeliveryPointHandler )

-- Phase 3: Drop off point.
function dropOff(thePlayer)
	
	-- Check the truck is a RS Haul trucj and a trailer is attacthed.
	local vehicle = getPedOccupiedVehicle(thePlayer) 
	local trailer = getVehicleTowedByVehicle(vehicle)
	
	if not (vehicle(RSHualTrucks) and not (trailer) then
		outputChatBox("Depot says: You lost the trailer!", thePlayer, 255, 255, 255) -- You forgot the trailer
	else
	
		setElementData (thePlayer, "revenue", (getElementData(thePlayer, "revenue") + 50)
		outputChatBox("Depot says: Better late than never. Your next delivery is now shown on your GPS.", thePlayer, 255, 255, 255)
		outputChatBox("You can return to the truck depot in LV to collect your earnings or do another delivery.", thePlayer, 255, 0, 0)
	
		-- add a "finish" marker at the depot.
		local depotBlip = createBlip() -- create radar blip at LV depot.
		local depotMarker = createMarker() -- create marker at LV depot.
		local depotColsphere = createColSphere(284.39205932617, 1411.373046875, 10.4046459198, 4) -- Create colision sphere where marker is.
		attachElements(depotMarker, depotBlip)
		exports.pool:allocateElement(depotBlip)
		exports.pool:allocateElement(depotMarker)	
		
		addEventHandler("onColShapeHit", depotColsphere, dropOff) -- when the player enters the marker trigger the next stage.
		
		triggerServerEvent("createDeliveryPoint") -- create a new delivery destination.
		
	end
end

-- Phase 4: Return to depot.
function finishTruckJob (thePlayer) -- When the player enters the marker back at the truck depot.
	
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local trailer = getVehicleTowedByVehicle(vehicle)
	removePedFromVehicle(thePlayer) -- Remove the player from the vehicle
	respawnVehicle(vehicle) -- Respawn the vehicle.
	respawnVehicle(trailer)
	destroyElement(blip) -- clear all blips and markers.
	destroyElement(marker)
	destroyElement(colsphere)
	destroyElement(depotBlip) -- clear all blips and markers.
	destroyElement(depotMarker)
	destroyElement(depotColsphere)
	
	local earnings = getElementData(thePlayer, "revenue")
	exports.global:givePlayerSafeMoney(thePlayer, tonumber(earnings)) -- Pay the player the "revenue".
	
end
