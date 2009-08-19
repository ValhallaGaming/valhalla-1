-- Bind Keys required
function bindKeys(res)
	bindKey("p", "down", toggleFlashers)
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		local modelid = getVehicleModel(value)
		if (isElementStreamedIn(value)) then
			if (governmentVehicle[modelid]) or exports.global:cdoesVehicleHaveItem(value, 61) then
				for i = 1, #policevehicles+1 do
					if (policevehicles[i]==nil) then
						policevehicles[i] = value
						policevehicleids[value] = i
						break
					end
				end
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleFlashers()
	local veh = getPedOccupiedVehicle(getLocalPlayer())

	if (veh) then
		local modelid = getElementModel(veh)
		if (governmentVehicle[modelid]) or exports.global:cdoesVehicleHaveItem(veh, 61) then -- Emergency Light Becon
			local lights = getVehicleOverrideLights(veh)
			local state = getElementData(veh, "flashers")

			if (lights==2) then
				if not (state) then
					setElementData(veh, "flashers", true, true)
					setVehicleHeadLightColor(veh, 0, 0, 255)
					setVehicleLightState(veh, 0, 1)
					setVehicleLightState(veh, 1, 0)
				else
					setElementData(veh, "flashers", nil, true)
					setVehicleLightState(veh, 0, 0)
					setVehicleLightState(veh, 1, 0)
					setVehicleHeadLightColor(veh, 255, 255, 255)
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
		if (governmentVehicle[modelid]) or exports.global:cdoesVehicleHaveItem(source, 61) then
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
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), streamIn)
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if (getElementType(source)=="vehicle") then
		local modelid = getElementModel(source)
		if (policevehicleids[source]~=nil) then
			local id = policevehicleids[source]
			setVehicleHeadLightColor(source, 255, 255, 255)
			policevehicleids[source] = nil
			policevehicles[id] = nil
		end
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

count = 0
function doFlashes()
	if (#policevehicles==0) then return end
	
	for key, veh in ipairs(policevehicles) do
		if not (isElement(veh)) then
			local id = policevehicleids[veh]
			policevehicleids[veh] = nil
			policevehicles[id] = nil
		elseif (getElementData(veh, "flashers")) then
			local state1 = getVehicleLightState(veh, 0)
			local state2 = getVehicleLightState(veh, 1)
			
			if (state1==0) then
				setVehicleHeadLightColor(veh, 0, 0, 255)
			else
				setVehicleHeadLightColor(veh, 255, 0, 0)
			end
			
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