local blip, endblip
local jobstate = 0
local route = 0
local oldroute = -1
local marker, endmarker
local routescompleted = 0
local deliveryStopTimer = nil

routes = { }
routes[1] = { 2648.64453125, 846.005859375, 6.1870636940002 }
routes[2] = { 2119.5634765625, 950.6748046875, 10.519774436951 }
routes[3] = { 2372.2021484375, 2548.2451171875, 10.526019096375 }
routes[4] = { 2288.5732421875, 2418.6533203125, 10.458553314209 }
routes[5] = { 2090.205078125, 2086.9130859375, 10.526629447937 }
routes[6] = { 1946.015625, 2054.931640625, 10.527263641357 }
routes[7] = { 1630.2587890625, 1797.3447265625, 10.526601791382 }
routes[8] = { 1144.14453125, 1368.0986328125, 10.434799194336 }
routes[9] = { 635.9775390625, 1252.9892578125, 11.357774734497 }
routes[10] = { 261.623046875, 1412.3564453125, 10.20871925354 }

local truck = { [414] = true }

function resetTruckerJob()
	jobstate = 0
	routescompleted = 0
	oldroute = -1
	
	if (isElement(marker)) then
		destroyElement(marker)
		marker = nil
	end
	
	if (isElement(blip)) then
		destroyElement(blip)
		blip = nil
	end
    
    if (isElement(endmarker)) then
		destroyElement(endmarker)
		endmarker = nil
	end
	
	if (isElement(endcolshape)) then
		destroyElement(endcolshape)
		endcolshape = nil
	end
	
	if (isElement(endblip)) then
		destroyElement(endblip)
		endblip = nil
	end
	
	if deliveryStopTimer then
		killTimer(deliveryStopTimer)
		deliveryStopTimer = nil
	end
end

function displayTruckerJob(notext)
	if (jobstate==0) then
		jobstate = 1
		blip = createBlip(2821.806640625, 954.4755859375, 10.75, 51, 2, 255, 127, 255)
		setElementData(getLocalPlayer(),"job",1)
		
		if not notext then		
			outputChatBox("#FF9933Approach the #CCCCCCblip#FF9933 on your radar and enter the van to start your job.", 255, 194, 15, true)
		end
	end
end

function startTruckerJob()
	if (jobstate==1) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if vehicle and getVehicleController(vehicle) == getLocalPlayer() and truck[getElementModel(vehicle)] then
			routescompleted = 0
		
			outputChatBox("#FF9933Drive to the #FFC800blip#FF9933 to complete your first delivery.", 255, 194, 15, true)
			destroyElement(blip)
			
			local rand = math.random(1, #routes)
			route = routes[rand]
			local x, y, z = route[1], route[2], route[3]
			blip = createBlip(x, y, z, 0, 2, 255, 200, 0)
			marker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150)
			addEventHandler("onClientMarkerHit", marker, waitAtDelivery)
			addEventHandler("onClientMarkerLeave", marker, checkWaitAtDelivery)
							
			jobstate = 2
			oldroute = rand
		else
			outputChatBox("You must be in the van to start this job.", 255, 0, 0)
		end
	end
end

function waitAtDelivery(thePlayer)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if thePlayer == getLocalPlayer() and vehicle and truck[getElementModel(vehicle)] then
		deliveryStopTimer = setTimer(nextDeliveryCheckpoint, 5000, 1)
		outputChatBox("#FF9933Wait a moment while your truck is processed.", 255, 0, 0, true )
	end
end

function checkWaitAtDelivery(thePlayer)
	if thePlayer == getLocalPlayer() then
		outputChatBox("You didn't wait at the dropoff point.", 255, 0, 0)
		if deliveryStopTimer then
			killTimer(deliveryStopTimer)
			deliveryStopTimer = nil
		end
	end
end

function nextDeliveryCheckpoint()
	deliveryStopTimer = nil
	if jobstate == 2 or jobstate == 3 then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if vehicle and getVehicleController(vehicle) == getLocalPlayer() and truck[getElementModel(vehicle)] then
			destroyElement(marker)
			destroyElement(blip)
			
			routescompleted = routescompleted + 1
			outputChatBox("You completed your " .. routescompleted .. ". trucking run.", 0, 255, 0)
			outputChatBox("#FF9933You can now either return to the #CC0000warehouse #FF9933and obtain your wage", 0, 0, 0, true)
			outputChatBox("#FF9933or continue onto the next #FFC800drop off point#FF9933 and increase your wage.", 0, 0, 0, true)

			-- next drop off
			local rand = -1
			repeat
				rand = math.random(1, #routes)
			until oldroute ~= rand
			route = routes[rand]
			oldroute = rand
			local x, y, z = route[1], route[2], route[3]
			blip = createBlip(x, y, z, 0, 2, 255, 200, 0)
			marker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150)
			addEventHandler("onClientMarkerHit", marker, waitAtDelivery)
			addEventHandler("onClientMarkerLeave", marker, checkWaitAtDelivery)
			
			if jobstate == 2 then
				-- no final checkpoint set yet
				endblip = createBlip(2836, 975, 9.75, 0, 2, 255, 0, 0)
				endmarker = createMarker(2836, 975, 9.75, "checkpoint", 4, 255, 0, 0, 150)
				setMarkerIcon(endmarker, "finish")
				addEventHandler("onClientMarkerHit", endmarker, endDelivery)
			end
			jobstate = 3
		else
			outputChatBox("#FF9933You must be in a van to complete deliverys.", 255, 0, 0, true ) -- Wrong car type.
		end
	end
end

function endDelivery()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	local id = getElementModel(vehicle) or 0
	if not vehicle or not (truck[id]) then
		outputChatBox("#FF9933You must be in a van to complete deliverys.", 255, 0, 0, true ) -- Wrong car type.
	else
		local wage = 50 * routescompleted
		outputChatBox("You earned $" .. wage .. " on your trucking runs.", 255, 194, 15)
		triggerServerEvent("giveTruckingMoney", getLocalPlayer(), wage)
		
		triggerServerEvent("respawnTruck", getLocalPlayer(), vehicle)
		resetTruckerJob()
		displayTruckerJob(true)
	end
end

addEvent("restoreTruckerJob", true)
addEventHandler("restoreTruckerJob", getRootElement(),function() displayTruckerJob(true) end)

addEvent("startTruckJob", true)
addEventHandler("startTruckJob", getRootElement(), startTruckerJob)
