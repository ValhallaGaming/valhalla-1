function payBusDriver(line, stop)
	exports.global:givePlayerSafeMoney(source, 18)
	
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
				outputChatBox(" -- This stop: [".. g_bus_routes[line].stops[stop] .. "] --", nearbyPlayer, 255, 51, 102)
				if(stop<#g_bus_routes[line].stops)then
					outputChatBox(" -- Next stop: [".. g_bus_routes[line].stops[stop+1] .. "] --", nearbyPlayer, 255, 51, 102)
				end
			end
		end
	end	
end
addEvent("payBusDriver",true)
addEventHandler("payBusDriver", getRootElement(), payBusDriver)

function takeBusFare(thePlayer)
	exports.global:takePlayerSafeMoney(source, 5)
	exports.global:givePlayerSafeMoney(thePlayer, 5)
end
addEvent("payBusFare", true)
addEventHandler("payBusFare", getRootElement(), takeBusFare)

function ejectPlayerFromBus()
	removePedFromVehicle(source)
end
addEvent("removePlayerFromBus", true)
addEventHandler("removePlayerFromBus", getRootElement(), ejectPlayerFromBus)