stopNumber={}
stopNumber[1]={ "Lost Hill Drive, Redsands East" } -- Car dealership
stopNumber[2]={ "Earl Watts Projects, 112th Street, Redsands West" } -- Earl Watts Projects
stopNumber[3]={ "Las Venturas General Hospital, Tularosa Lane, Redsands West" } -- Hospital
stopNumber[4]={ "Las Venturas International Airport" } -- Airport
stopNumber[5]={ "Blackfield Stadium, Trinity Peak Street, Blackfield" } -- Prison
stopNumber[6]={ "Yellow Bell Station, Shermcrest Street, Pricke Pine" } -- Yellow Bell Station
stopNumber[7]={ "San Andreas Network Tower, Old Castle Drive, Roca Escalante" } -- PD / Bank / SAN
stopNumber[8]={ "Tatum Street, Creek" } -- Tatum
stopNumber[9]={ "City Hall, Fairpoint Drive, Hampton" } -- City Hall 
stopNumber[10]={ "Harbour, Sea Cliff Way, Rockshore West" } -- PD / harbour 
stopNumber[11]={ "Caligulas, The Strip" } -- Caligulas 
stopNumber[12]={ "Gray Dawn Drive, Roca Escalante" } -- Gray Dawn Drive
stopNumber[13]={ "LV Transport Depot, Lost Hill Drive, Redsands East [END OF SERVICE]" } -- Depot End Point

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
				if(stop<13)then
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