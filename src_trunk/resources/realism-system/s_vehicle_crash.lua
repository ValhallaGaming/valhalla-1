function throwPlayerThroughWindow(x, y, z)
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source, vehicle)
	setElementPosition(source, x, y, z)
	setPedAnimation(source, "CRACK", "crckdeth2", 10000, true, false, false)
	setTimer(setPedAnimation, 10005, 1, source)
end
addEvent("crashThrowPlayerFromVehicle", true)
addEventHandler("crashThrowPlayerFromVehicle", getRootElement(), throwPlayerThroughWindow)