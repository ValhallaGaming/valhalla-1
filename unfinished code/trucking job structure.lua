RSHaulTrucks = {[]=true, []=true, []=true, []=true, []=true} -- need to /makecivveh. The trucks and trailers are permanently spawned.

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

function truckJob (commandName, thePlayer)

	if not (isPedInVehicle(thePlayer)) and (getPedOccupiedVehicle(RSHaulTrucks) then -- Is the player in a RS Haul vehicle
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

function createDeliveryPoint(thePlayer)

	local deliveryPoint = math.random(1,10) -- select a random point
	
	if (deliveryPoint) == (oldDeliveryPoint) then
		local deliveryPoint = math.random(1,10) -- select another random point
	else
		triggerServerEvent ("startTrucking")
end

function startTrucking (thePlayer)

	local lastDeliveryPoint = deliveryPoint
		
	local blip = createBlip() -- create radar blip at delivery point.
	local marker = createMarker() -- create marker at delivery point.
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


function dropOff(thePlayer)
	
	-- Check the truck has a trailer attacthed.
	local vehicle = getPedOccupiedVehicle(thePlayer) 
	local trailer = getVehicleTowedByVehicle(vehicle)
	
	if not (vehicle(RSHualTrucks) and not (trailer) then
		outputChatBox("Depot says: You lost the trailer!", thePlayer, 255, 255, 255) -- You forgot the trailer
	else
	
		local revenue = revenue + 50
		outputChatBox("Depot says: Your next delivery is now shown on your GPS.", thePlayer, 255, 255, 255)
		outputChatBox("You can return to the truck depot to collect your earnings or do another delievery.", thePlayer, 255, 0, 0)
	
		-- add a "finish" marker to the depot.
			
		triggerServerEvent("createDeliveryPoint") -- create a new delivery destination.
		
	end
end

function finishTruckJob (thePlayer) -- When the player enters the marker back at the truck depot.

	-- Remove the player from the vehicle
	-- Respawn the vehicle.
	-- clear all blips and markers.
	-- Pay the player the "revenue".
	
end
