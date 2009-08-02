stopNumber={}
stopNumber[1]={ "Unity Station, Washington Road, Idlewood (START OF SERVICE)" }
stopNumber[2]={ "Idlewood Gas, Idlewood" }
stopNumber[3]={ "Ten Green Bottles & Grove St, Ganton" }
stopNumber[4]={ "Atlantic Avenue, Jefferson" }
stopNumber[5]={ "Pig Pen, Caesar Road, East Los Santos" }
stopNumber[6]={ "Jefferson Motel, E. Vinewood, Jefferson" }
stopNumber[7]={ "Glen Park"  }
stopNumber[8]={ "City Hall, Pershing Sq." }
stopNumber[9]={ "Main Street, Central LS" }
stopNumber[10]={ "All Saints General Hospital, Pawn Street, Market." }
stopNumber[11]={ "W. Broadway, Rodeo" }
stopNumber[12]={ "Unity Station, Washington Road, Idlewood (END OF SERVICE)" }

function payBusDriver(stop)

	exports.global:givePlayerSafeMoney(source, 18)
	local nextStopNumber = stop+1
	local thisStop = tostring(stopNumber[stop][1])
	
	if(stop<13)then
		nextStop = tostring(stopNumber[nextStopNumber][1])
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
				if(stop<12)then
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
	local driver = getVehicleController(getPedOccupiedVehicle(thePlayer))
	if driver then
		exports.global:givePlayerSafeMoney(driver, 5)
	end
end
addEvent("payBusFare", true)
addEventHandler("payBusFare", getRootElement(), takeBusFare)

function ejectPlayerFromBus(thePlayer)
	removePedFromVehicle(thePlayer)
end
addEvent("removePlayerFromBus", true)
addEventHandler("removePlayerFromBus", getRootElement(), ejectPlayerFromBus)