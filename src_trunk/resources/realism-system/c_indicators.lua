function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("vehicle_look_left", "down", "indicator_left")
		bindKey("vehicle_look_right", "down", "indicator_right")
	end
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

leftTimer = nil
rotation = 0
rightTimer = nil

function toggleLeftIndicators()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	if (veh) then
		local vehicleType = getVehicleType(veh)
		if (vehicleType~="Plane" and vehicleType~="Helicopter" and vehicleType~="Boat" and vehicleType~="Train" and vehicleType~="BMX" and vehicleType~="Quad") then
			
			local state = getElementData(veh, "leftindicator")
			
			if not (state) then
				setElementData(veh, "leftindicator", true, true)
				rx, ry, rotation = getVehicleRotation(veh)
				leftTimer = setTimer(checkLeftAngle, 1000, 0, veh)
			else
				removeElementData(veh, "leftindicator", true)
				local key = veh
				
				if (vehicles[key][2]) then
					destroyElement(vehicles[key][2])
					vehicles[key][2] = nil
				end
				
				if (vehicles[key][3]) then
					destroyElement(vehicles[key][3])
					vehicles[key][3] = nil
				end
				
				if (vehicles[key][4]) then
					destroyElement(vehicles[key][4])
					vehicles[key][4] = nil
				end
				
				if (vehicles[key][5]) then
					destroyElement(vehicles[key][5])
					vehicles[key][5] = nil
				end
			end
		end
	end
end

function checkLeftAngle(veh)
	rx, ry, rz = getVehicleRotation(veh)
	
	if (rz>=rotation+70) then
		killTimer(leftTimer)
		removeElementData(veh, "leftindicator")
		local key = veh
				
		if (vehicles[key][2]) then
			destroyElement(vehicles[key][2])
			vehicles[key][2] = nil
		end
				
		if (vehicles[key][3]) then
			destroyElement(vehicles[key][3])
			vehicles[key][3] = nil
		end
				
		if (vehicles[key][4]) then
			destroyElement(vehicles[key][4])
			vehicles[key][4] = nil
		end
				
		if (vehicles[key][5]) then
			destroyElement(vehicles[key][5])
			vehicles[key][5] = nil
		end
	end
end

function checkRightAngle(veh)
	rx, ry, rz = getVehicleRotation(veh)

	if (rz<=rotation-70) then
		killTimer(rightTimer)
		removeElementData(veh, "rightindicator")
		local key = veh
				
		if (vehicles[key][6]) then
			destroyElement(vehicles[key][6])
			vehicles[key][6] = nil
		end
				
		if (vehicles[key][7]) then
			destroyElement(vehicles[key][7])
			vehicles[key][7] = nil
		end
				
		if (vehicles[key][8]) then
			destroyElement(vehicles[key][8])
			vehicles[key][8] = nil
		end
				
		if (vehicles[key][9]) then
			destroyElement(vehicles[key][9])
			vehicles[key][9] = nil
		end
	end
end

function toggleRightIndicators()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	if (veh) then
		local vehicleType = getVehicleType(veh)
		if (vehicleType~="Plane" and vehicleType~="Helicopter" and vehicleType~="Boat" and vehicleType~="Train" and vehicleType~="BMX" and vehicleType~="Quad") then
			
			local state = getElementData(veh, "rightindicator")
			
			if not (state) then
				setElementData(veh, "rightindicator", true, true)
				rx, ry, rotation = getVehicleRotation(veh)
				rightTimer = setTimer(checkRightAngle, 1000, 0, veh)
			else
				removeElementData(veh, "rightindicator")
				local key = veh
				
				if (vehicles[key][6]) then
					destroyElement(vehicles[key][6])
					vehicles[key][6] = nil
				end
				
				if (vehicles[key][7]) then
					destroyElement(vehicles[key][7])
					vehicles[key][7] = nil
				end
				
				if (vehicles[key][8]) then
					destroyElement(vehicles[key][8])
					vehicles[key][8] = nil
				end
				
				if (vehicles[key][9]) then
					destroyElement(vehicles[key][9])
					vehicles[key][9] = nil
				end
			end
		end
	end
end

addCommandHandler ("indicator_left", toggleLeftIndicators)
addCommandHandler ("indicator_right", toggleRightIndicators)

vehicles = { }

function streamIn()
	if (getElementType(source)=="vehicle") then
        vehicles[source] = { }
    end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if (getElementType(source)=="vehicle") then
        cleanupVehicle(source)
		table.remove(vehicles, source)
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function cleanupVehicle(vehicle)
    if vehicle then
        for i = 2, 9 do
            destroyElement(vehicles[vehicle][i])
        end
    end
end

function doFlashes()
	if (#vehicles==0) then return end

	for key, value in pairs(vehicles) do
		local veh = key

		-- left indicator
		if (getElementData(veh, "leftindicator")) then
			if (vehicles[key][2]==nil) then
				local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
			
				vehicles[key][2] = createObject(1489, x1, y1, z1)
				vehicles[key][3] = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
				attachElements(vehicles[key][2], veh, x1+0.1, y1+0.5, z1+0.7)
				attachElements(vehicles[key][3], vehicles[key][2], 0, 0, 0)
				setElementAlpha(vehicles[key][2], 0)
			
				vehicles[key][4] = createObject(1489, x1, y1, z1)
				vehicles[key][5] = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
				attachElements(vehicles[key][4], veh, x1+0.1, y2, z1+0.7)
				attachElements(vehicles[key][5], vehicles[key][4], 0, 0, 0)
				setElementAlpha(vehicles[key][4], 0)
			else
				destroyElement(vehicles[key][2])
				destroyElement(vehicles[key][3])
				destroyElement(vehicles[key][4])
				destroyElement(vehicles[key][5])
				vehicles[key][2] = nil
				vehicles[key][3] = nil
				vehicles[key][4] = nil
				vehicles[key][5] = nil
			end
		end
		
		-- right indicator
		if (getElementData(veh, "rightindicator")) then
			if (vehicles[key][6]==nil) then
				local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
			
				vehicles[key][6] = createObject(1489, x1, y1, z1)
				vehicles[key][7] = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
				attachElements(vehicles[key][6], veh, x2-0.3, y1+0.4, z1+0.7)
				attachElements(vehicles[key][7], vehicles[key][6], 0, 0, 0)
				setElementAlpha(vehicles[key][6], 0)
			
				vehicles[key][8] = createObject(1489, x1, y1, z1)
				vehicles[key][9] = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
				attachElements(vehicles[key][8], veh, x2-0.3, y2-0.1, z1+0.7)
				attachElements(vehicles[key][9], vehicles[key][8], 0, 0, 0)
				setElementAlpha(vehicles[key][8], 0)
			else
				destroyElement(vehicles[key][6])
				destroyElement(vehicles[key][7])
				destroyElement(vehicles[key][8])
				destroyElement(vehicles[key][9])
				vehicles[key][6] = nil
				vehicles[key][7] = nil
				vehicles[key][8] = nil
				vehicles[key][9] = nil
			end
		end
	end
end
setTimer(doFlashes, 500, 0)