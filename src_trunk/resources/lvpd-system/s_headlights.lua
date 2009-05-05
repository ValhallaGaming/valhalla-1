governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

-- EVENTS
addEvent("onVehicleToggleStrobes", false)

function toggleFlashers(x1, y1, z1, x2, y2, z2)
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
				exports.global:sendLocalMeAction(source, "turns the light strobes on.")
				triggerEvent("onVehicleToggleStrobes", veh, true)
				
				
				-- new flashing lights
				
				local object1 = createObject(1489, x1, y1, z1)
				attachElements(object1, veh, x1+0.9, y2+0.6, z1+0.7)
				
				local object2 = createObject(1489, x1, y1, z1)
				attachElements(object2, veh, x2-0.9, y2+0.6, z1+0.7)

				setElementData(veh, "flashobject1", object1)
				setElementData(veh, "flashobject2", object2)
			else
				setElementData(veh, "flashstate", nil)
				setVehicleLightState(veh, 0, 0)
				setVehicleLightState(veh, 1, 0)
				
				local object1 = getElementData(veh, "flashobject1")
				local marker1 = getElementData(veh, "flashmarker1")
				local object2 = getElementData(veh, "flashobject2")
				local marker2 = getElementData(veh, "flashmarker2")
						
				if (marker1) then
					destroyElement(marker1)
					setElementData(veh, "flashmarker1", nil)
				end
				
				if (marker2) then
					destroyElement(marker2)
					setElementData(veh, "flashmarker2", nil)
				end
				
				destroyElement(object1)
				destroyElement(object2)
				setElementData(veh, "flashobject1", nil)
				setElementData(veh, "flashobject2", nil)
				
				exports.global:sendLocalMeAction(source, "turns the light strobes off.")
				triggerEvent("onVehicleToggleStrobes", veh, false)
			end
		end
	end
end
addEvent("toggleFlashers", true)
addEventHandler("toggleFlashers", getRootElement(), toggleFlashers)
		
function toggleFlashing(theVehicle)
	local lights = getVehicleOverrideLights(theVehicle)
	
	if (lights~=2) then
		setElementData(theVehicle, "flashstate", nil)
		setVehicleLightState(theVehicle, 0, 0)
		setVehicleLightState(theVehicle, 1, 0)
		
		local object1 = getElementData(theVehicle, "flashobject1")
		local marker1 = getElementData(theVehicle, "flashmarker1")
		local object2 = getElementData(theVehicle, "flashobject2")
		local marker2 = getElementData(theVehicle, "flashmarker2")
				
		if (marker1) then
			destroyElement(marker1)
			setElementData(theVehicle, "flashmarker1", nil)
		end
		
		if (marker2) then
			destroyElement(marker2)
			setElementData(theVehicle, "flashmarker2", nil)
		end
		
		destroyElement(object1)
		destroyElement(object2)
		setElementData(theVehicle, "flashobject1", nil)
		setElementData(theVehicle, "flashobject2", nil)
	else
		local state = getElementData(theVehicle, "flashstate")

		if (state==0) then
			setVehicleLightState(theVehicle, 0, 0)
			setVehicleLightState(theVehicle, 1, 1)
			
			setElementData(theVehicle, "flashstate", 1)
			
			-- new lights
			local object1 = getElementData(theVehicle, "flashobject1")
			local marker1 = getElementData(theVehicle, "flashmarker1")
			local object2 = getElementData(theVehicle, "flashobject2")
			local marker2 = getElementData(theVehicle, "flashmarker2")
			
			if (marker1) then
				destroyElement(marker1)
				setElementData(theVehicle, "flashmarker1", nil)
			end
			
			local marker = createMarker(0, 0, 0, "corona", 1, 255, 0, 0, 200)
			attachElements(marker, object2, 0, 0, 0)
			setElementData(theVehicle, "flashmarker2", marker)

			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==1) then
			setVehicleLightState(theVehicle, 0, 0)
			setVehicleLightState(theVehicle, 1, 1)
			setElementData(theVehicle, "flashstate", 2)
			
			-- new lights
			local object1 = getElementData(theVehicle, "flashobject1")
			local marker1 = getElementData(theVehicle, "flashmarker1")
			local object2 = getElementData(theVehicle, "flashobject2")
			local marker2 = getElementData(theVehicle, "flashmarker2")

			if (marker2) then
				destroyElement(marker2)
				setElementData(theVehicle, "flashmarker2", nil)
			end
			
			local marker = createMarker(0, 0, 0, "corona", 1, 0, 0, 255, 200)
			attachElements(marker, object1, 0, 0, 0)
			setElementData(theVehicle, "flashmarker1", marker)
			
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==2) then
			setVehicleLightState(theVehicle, 0, 1)
			setVehicleLightState(theVehicle, 1, 0)
			setElementData(theVehicle, "flashstate", 3)
			
			-- new lights
			local object1 = getElementData(theVehicle, "flashobject1")
			local marker1 = getElementData(theVehicle, "flashmarker1")
			local object2 = getElementData(theVehicle, "flashobject2")
			local marker2 = getElementData(theVehicle, "flashmarker2")
			
			if (marker1) then
				destroyElement(marker1)
				setElementData(theVehicle, "flashmarker1", nil)
			end
			
			local marker = createMarker(0, 0, 0, "corona", 1, 255, 0, 0, 200)
			attachElements(marker, object2, 0, 0, 0)
			setElementData(theVehicle, "flashmarker2", marker)
			
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		elseif (state==3) then
			setVehicleLightState(theVehicle, 0, 1)
			setVehicleLightState(theVehicle, 1, 0)
			setElementData(theVehicle, "flashstate", 0)
			
			-- new lights
			local object1 = getElementData(theVehicle, "flashobject1")
			local marker1 = getElementData(theVehicle, "flashmarker1")
			local object2 = getElementData(theVehicle, "flashobject2")
			local marker2 = getElementData(theVehicle, "flashmarker2")
			
			if (marker2) then
				destroyElement(marker2)
				setElementData(theVehicle, "flashmarker2", nil)
			end
			
			local marker = createMarker(0, 0, 0, "corona", 1, 0, 0, 255, 200)
			attachElements(marker, object1, 0, 0, 0)
			setElementData(theVehicle, "flashmarker1", marker)
			
			setTimer(disableLights, 50, 1, theVehicle)
			local timer = setTimer(toggleFlashing, 200, 1, theVehicle)
		end
	end
end

function disableLights(theVehicle)
	setVehicleLightState(theVehicle, 0, 1)
	setVehicleLightState(theVehicle, 1, 1)
	
	local object1 = getElementData(theVehicle, "flashobject1")
	local marker1 = getElementData(theVehicle, "flashmarker1")
	local object2 = getElementData(theVehicle, "flashobject2")
	local marker2 = getElementData(theVehicle, "flashmarker2")
			
	if (marker1) then
		destroyElement(marker1)
		setElementData(theVehicle, "flashmarker1", nil)
	end
	
	if (marker2) then
		destroyElement(marker2)
		setElementData(theVehicle, "flashmarker2", nil)
	end
end