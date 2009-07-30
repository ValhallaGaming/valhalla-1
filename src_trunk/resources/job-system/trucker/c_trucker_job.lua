local blip, endblip
local jobstate = 0
local route = 0
local oldroute = -1
local marker, endmarker
local routescompleted = 0
local deliveryStopTimer = nil

routes = { }
routes[1] = { 1615.5283203125, -1614.431640625, 12.10223865509 }
routes[2] = { 1476.5732421875, -1735.2548828125, 11.943592071533 }
routes[3] = { 1360.8798828125, -1284.318359375, 11.949401855469 }
routes[4] = { 1192.7392578125, -1333.7568359375, 12.945232391357 }
routes[5] = { 1004.5302734375, -905.8271484375, 41.759048461914 }
routes[6] = { 1027, -1364.4248046875, 12.138906478882 }
routes[7] = { 649.2734375, -1467.0302734375, 13.317453384399 }
routes[8] = { 1144.14453125, 1368.0986328125, 10.434799194336 }
routes[9] = { 786.884765625, -1612.86328125, 11.937650680542 }
routes[10] = { 815.9462890625, -1392.9716796875, 12.95408821106 }

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
		blip = createBlip(-69.087890625, -1111.1103515625, 0.64266717433929, 51, 2, 255, 127, 255)
		
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
	if thePlayer == getLocalPlayer() and vehicle and getVehicleController(vehicle) == getLocalPlayer() and truck[getElementModel(vehicle)] then
		deliveryStopTimer = setTimer(nextDeliveryCheckpoint, 5000, 1)
		outputChatBox("#FF9933Wait a moment while your truck is processed.", 255, 0, 0, true )
	end
end

function checkWaitAtDelivery(thePlayer)
	if thePlayer == getLocalPlayer() and getVehicleController(getPedOccupiedVehicle(getLocalPlayer())) == getLocalPlayer()  then
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
				endblip = createBlip(-69.087890625, -1111.1103515625, 0.64266717433929, 0, 2, 255, 0, 0)
				endmarker = createMarker(-69.087890625, -1111.1103515625, 0.64266717433929, "checkpoint", 4, 255, 0, 0, 150)
				setMarkerIcon(endmarker, "finish")
				addEventHandler("onClientMarkerHit", endmarker, endDelivery)
			end
			jobstate = 3
		else
			outputChatBox("#FF9933You must be in a van to complete deliverys.", 255, 0, 0, true ) -- Wrong car type.
		end
	end
end

function endDelivery(thePlayer)
	if thePlayer == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle) or 0
		if not vehicle or getVehicleController(vehicle) ~= getLocalPlayer() or not (truck[id]) then
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
end

addEvent("restoreTruckerJob", true)
addEventHandler("restoreTruckerJob", getRootElement(),function() displayTruckerJob(true) end)

addEvent("startTruckJob", true)
addEventHandler("startTruckJob", getRootElement(), startTruckerJob)
