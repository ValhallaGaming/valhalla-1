governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

-- EVENTS
addEvent("onVehicleToggleStrobes", false)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getAllPlayers()
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "p", "down", toggleFlashers)) then
			bindKey(arrayPlayer, "p", "down", toggleFlashers)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "p", "down", toggleFlashers)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleFlashers(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	
	if (veh) then
		local model = getElementModel(veh)
		local lights = getVehicleOverrideLights(veh)
		local seat = getPedOccupiedVehicleSeat(source)
		
		if (governmentVehicle[model]) and (lights==2) and (seat<2) then -- Must be a government vehicle and have the headlights on
			local state = getElementData(veh, "flashstate")
			
			if not (state) then
				local timer = setTimer(toggleFlashing, 200, 1, veh)
				setElementData(veh, "flashstate", 0)
				call(getResourceFromName("CJRPglobal-functions"), "sendLocalMeAction", source, "turns the light strobes on.")
				triggerEvent("onVehicleToggleStrobes", veh, true)
			else
				setElementData(veh, "flashstate", nil)
				setVehicleLightState(veh, 0, 0)
				setVehicleLightState(veh, 1, 0)
				call(getResourceFromName("CJRPglobal-functions"), "sendLocalMeAction", source, "turns the light strobes off.")
				triggerEvent("onVehicleToggleStrobes", veh, false)
			end
		end
	end
end

function toggleFlashing(theVehicle)
	local lights = getVehicleOverrideLights(theVehicle)
	
	if (lights~=2) then
		setElementData(theVehicle, "flashstate", nil)
		setVehicleLightState(theVehicle, 0, 0)
		setVehicleLightState(theVehicle, 1, 0)
	else
		local state = getElementData(theVehicle, "flashstate")

		
		if (state==0) then
			setVehicleLightState(theVehicle, 0, 0)
			setVehicleLightState(theVehicle, 1, 1)
			
			setElementData(theVehicle, "flashstate", 1)
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==1) then
			setVehicleLightState(theVehicle, 0, 0)
			setVehicleLightState(theVehicle, 1, 1)
			setElementData(theVehicle, "flashstate", 2)
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==2) then
			setVehicleLightState(theVehicle, 0, 1)
			setVehicleLightState(theVehicle, 1, 0)
			setElementData(theVehicle, "flashstate", 3)
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==3) then
			setVehicleLightState(theVehicle, 0, 1)
			setVehicleLightState(theVehicle, 1, 0)
			setElementData(theVehicle, "flashstate", 0)
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		end
	end
end

function disableLights(theVehicle)
	setVehicleLightState(theVehicle, 0, 1)
	setVehicleLightState(theVehicle, 1, 1)
end