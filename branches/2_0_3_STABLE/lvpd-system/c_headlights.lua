-- Bind Keys required
function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("p", "down", toggleFlashers)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function toggleFlashers()
	local veh = getPedOccupiedVehicle(getLocalPlayer())

	if (veh) then
		local modelid = getElementModel(veh)
		
		if (governmentVehicle[modelid]) then
			local lights = getVehicleOverrideLights(veh)
			local state = getElementData(veh, "flashers")

			if (lights==2) then
				if not (state) then
					setElementData(veh, "flashers", true, true)
					setVehicleLightState(veh, 0, 1)
					setVehicleLightState(veh, 1, 0)
				else
					setElementData(veh, "flashers", nil, true)
					setVehicleLightState(veh, 0, 0)
					setVehicleLightState(veh, 1, 0)
				end
			end
		end
	end
end

governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

policevehicles = { }
policevehicleids = { }

function streamIn()
	if (getElementType(source)=="vehicle") then
		local modelid = getElementModel(source)
		
		if (governmentVehicle[modelid]) then
			for i = 1, #policevehicles+1 do
				if (policevehicles[i]==nil) then
					policevehicles[i] = source
					policevehicleids[source] = i
					break
				end
			end
		end
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if (getElementType(source)=="vehicle") then
		if (policevehicleids[source]~=nil) then
			local id = policevehicleids[source]
			policevehicleids[source] = nil
			policevehicles[id] = nil
		end
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function doFlashes()
	if (#policevehicles==0) then return end

	for key, veh in ipairs(policevehicles) do
		if not (getElementType(veh)) then
			local id = policevehicleids[veh]
			policevehicleids[veh] = nil
			policevehicles[id] = nil
		elseif (getElementData(veh, "flashers")) then
			local state1 = getVehicleLightState(veh, 0)
			local state2 = getVehicleLightState(veh, 1)
			
			setVehicleLightState(veh, 0, state2)
			setVehicleLightState(veh, 1, state1)
		end
	end
end
setTimer(doFlashes, 250, 0)

function vehicleBlown()
	setElementData(source, "flashers", nil, true)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)