--[[ Bind Keys required
function enterVehicle()
	toggleControl("vehicle_look_left", false)
	toggleControl("vehicle_look_right", false)
end
addEventHandler("onClientVehicleEnter", getRootElement(), enterVehicle)]]

function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("vehicle_look_left", "down", "indicator_left")
		bindKey("vehicle_look_right", "down", "indicator_right")
	end
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function toggleLeftIndicators()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	if (veh) then
		local vehicleType = getVehicleType(veh)
		if (vehicleType~="Plane" and vehicleType~="Helicopter" and vehicleType~="Boat" and vehicleType~="Train" and vehicleType~="BMX" and vehicleType~="Quad") then
			local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
			triggerServerEvent("toggleLeftIndicators", getLocalPlayer(), x1, y1, z1, x2, y2, z2)
		end
	end
end

function toggleRightIndicators()
	local veh = getPedOccupiedVehicle(getLocalPlayer())

	if (veh) then
		local vehicleType = getVehicleType(veh)
		if (vehicleType~="Plane" and vehicleType~="Helicopter" and vehicleType~="Boat" and vehicleType~="Train" and vehicleType~="BMX" and vehicleType~="Quad") then
			local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
			triggerServerEvent("toggleRightIndicators", getLocalPlayer(), x1, y1, z1, x2, y2, z2)
		end
	end
end

addCommandHandler ("indicator_left", toggleLeftIndicators)
addCommandHandler ("indicator_right", toggleRightIndicators)