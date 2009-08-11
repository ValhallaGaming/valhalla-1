local blip, endblip
local jobstate = 0
local route = 0
local oldroute = -1
local marker, endmarker
local routescompleted = 0
local deliveryStopTimer = nil
local wage = 0

routes = {
	{ 1615.5283203125, -1614.431640625, 12.10223865509 },
	{ 1476.5732421875, -1735.2548828125, 11.943592071533 },
	{ 1360.8798828125, -1284.318359375, 11.949401855469 },
	{ 1192.7392578125, -1333.7568359375, 12.945232391357 },
	{ 1019.5927734375, -928.279296875, 42.1796875 }, --northern gas station
	{ 1027, -1364.4248046875, 12.138906478882 },
	{ 649.2734375, -1467.0302734375, 13.317453384399 },
	{ 786.884765625, -1612.86328125, 11.937650680542 },
	{ 815.9462890625, -1392.9716796875, 12.95408821106 },
	{ 1826.69140625, -1845.1533203125, 13.578125 },
	{ 2400.4296875, -1486.8359375, 23.828125 },
	{ 2148.263671875, -1006.384765625, 61.870578765869 },
	{ 2857.71484375, -1536.0712890625, 10.576637268066 },
	{ 2197.541015625, -2657.6513671875, 13.118523597717 },
	{ 1751.4375, -2060.2880859375, 13.166693687439 }
}

--[[for k, v in pairs(routes) do
	createBlip(v[1], v[2], v[3], 51, 2, 255, 127, 255)
	createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 200, 0, 150)
end]]

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
	
	wage = 0
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
			outputChatBox("#FF9933Drive to the #FFFF00blip#FF9933 to complete your first delivery.", 255, 194, 15, true)
			outputChatBox("#FF9933Remember to #FFFF00follow the street rules#FF9933.", 255, 194, 15, true)
			outputChatBox("#FF9933If your truck is #FFFF00damaged#FF9933, the customers may pay less or refuse to accept the goods.", 255, 194, 15, true)
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
			triggerServerEvent("loadDeliveryProgress", getLocalPlayer(), 0, 0)
		else
			outputChatBox("You must be in the van to start this job.", 255, 0, 0)
		end
	end
end

function waitAtDelivery(thePlayer)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if thePlayer == getLocalPlayer() and vehicle and getVehicleController(vehicle) == getLocalPlayer() and truck[getElementModel(vehicle)] then
		if getElementHealth(vehicle) < 350 then
			outputChatBox("You need to get your truck repaired.", 255, 0, 0)
		else
			deliveryStopTimer = setTimer(nextDeliveryCheckpoint, 5000, 1)
			outputChatBox("#FF9933Wait a moment while your truck is processed.", 255, 0, 0, true )
		end
	end
end

function checkWaitAtDelivery(thePlayer)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if vehicle and thePlayer == getLocalPlayer() and getVehicleController(vehicle) == getLocalPlayer()  then
		if getElementHealth(vehicle) >= 350 then
			outputChatBox("You didn't wait at the dropoff point.", 255, 0, 0)
			if deliveryStopTimer then
				killTimer(deliveryStopTimer)
				deliveryStopTimer = nil
			end
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
			
			local health = getElementHealth(vehicle)
			if health >= 975 then
				pay = 60 -- bonus: $60
			elseif health >= 800 then
				pay = 50
			elseif health >= 350 then
				-- 350 (black smoke) to 800, round to $5
				pay = math.ceil( 10 * ( health - 300 ) / 500 ) * 5
			else
				outputDebugString("{TRUCKING} Should not happen")
				pay = 0
			end
			
			wage = wage + pay
			
			routescompleted = routescompleted + 1
			outputChatBox("You completed your " .. routescompleted .. ". trucking run and earned $" .. pay .. ".", 0, 255, 0)
			outputChatBox("#FF9933You can now either return to the #CC0000warehouse #FF9933and obtain your wage", 0, 0, 0, true)
			outputChatBox("#FF9933or continue onto the next #FFFF00drop off point#FF9933 and increase your wage.", 0, 0, 0, true)
			
			triggerServerEvent("saveDeliveryProgress", getLocalPlayer(), routescompleted, wage)
			
			-- next drop off
			local rand = -1
			repeat
				rand = math.random(1, #routes)
			until oldroute ~= rand and getDistanceBetweenPoints2D(routes[oldroute][1], routes[oldroute][2], routes[rand][1], routes[rand][2]) > 250
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
			
			-- increase global supplies by 3
			triggerServerEvent("updateGlobalSupplies", getRootElement(), 3)
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
			outputChatBox("You earned $" .. wage .. " on your trucking runs.", 255, 194, 15)
			triggerServerEvent("giveTruckingMoney", getLocalPlayer(), wage)
			triggerServerEvent("saveDeliveryProgress", getLocalPlayer(), 0, 0)
			
			triggerServerEvent("respawnTruck", getLocalPlayer(), vehicle)
			resetTruckerJob()
			displayTruckerJob(true)
		end
	end
end

addEvent("restoreTruckerJob", true)
addEventHandler("restoreTruckerJob", getRootElement(), function() displayTruckerJob(true) end )

addEvent("loadTruckerJob", true)
addEventHandler("loadTruckerJob", getRootElement(), function(r, w) routescompleted = r wage = w end )

addEvent("startTruckJob", true)
addEventHandler("startTruckJob", getRootElement(), startTruckerJob)