function giveTruckingMoney(wage)
	exports.global:givePlayerSafeMoney(source, wage)
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)

function respawnTruck(vehicle)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setElementData(vehicle, "locked", 0, false)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
end
addEvent("respawnTruck", true)
addEventHandler("respawnTruck", getRootElement(), respawnTruck)