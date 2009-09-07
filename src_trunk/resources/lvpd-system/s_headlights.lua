function vehicleBlown()
	setElementData(source, "flashers", nil, true)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)