function syncRadio(station, name)
	local vehicle = getPedOccupiedVehicle(source)
	local seat = getPedOccupiedVehicleSeat(source)

	if (vehicle) then
		for i = 1, 4 do
			if (i~=seat) then
				local occupant = getVehicleOccupant(vehicle, i)
				if (occupant) then
					triggerClientEvent(occupant, "syncRadio", occupant, station)
				end
			end
		end
	end
end
addEvent("sendRadioSync", true)
addEventHandler("sendRadioSync", getRootElement(), syncRadio)