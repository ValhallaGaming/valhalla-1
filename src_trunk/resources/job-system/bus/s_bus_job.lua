stopNumber = {}
stopNumber[1] = "Unity Station, Washington Road, Idlewood (START OF SERVICE)"
stopNumber[2] = "Idlewood Gas, Idlewood"
stopNumber[3] = "Ten Green Bottles & Grove St, Ganton"
stopNumber[4] = "Atlantic Avenue, Jefferson"
stopNumber[5] = "Pig Pen, Caesar Road, East Los Santos"
stopNumber[6] = "Jefferson Motel, E. Vinewood, Jefferson"
stopNumber[7] = "Glen Park"
stopNumber[8] = "Skate Park"
stopNumber[9] = "City Hall, Pershing Sq."
stopNumber[10] = "Main Street, Central LS"
stopNumber[11] = "All Saints General Hospital, Pawn Street, Market."
stopNumber[12] = "Impound Lot, Burger Shot"
stopNumber[13] = "W. Broadway, Rodeo"
stopNumber[14] = "Santa Maria Beach"
stopNumber[15] = "The Rusted Anchor"
stopNumber[16] = "Unity Station, Washington Road, Idlewood (END OF SERVICE)"

function payBusDriver(stop)
	exports.global:givePlayerSafeMoney(source, 18)
	local nextStopNumber = stop+1
	local thisStop = tostring(stopNumber[stop])
	
	if(stop<#stopNumber)then
		nextStop = tostring(stopNumber[nextStopNumber])
	end
	
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
				outputChatBox(" -- This stop: [".. thisStop .. "] --", nearbyPlayer, 255, 51, 102)
				if(stop<#stopNumber)then
					outputChatBox(" -- Next stop: [".. nextStop .. "] --", nearbyPlayer, 255, 51, 102)
				end
			end
		end
	end	
end
addEvent("payBusDriver",true)
addEventHandler("payBusDriver", getRootElement(), payBusDriver)

function takeBusFare(thePlayer)
	exports.global:takePlayerSafeMoney(thePlayer, 5)
	exports.global:givePlayerSafeMoney(source, 5)
end
addEvent("payBusFare", true)
addEventHandler("payBusFare", getRootElement(), takeBusFare)

function ejectPlayerFromBus(thePlayer)
	removePedFromVehicle(thePlayer)
end
addEvent("removePlayerFromBus", true)
addEventHandler("removePlayerFromBus", getRootElement(), ejectPlayerFromBus)