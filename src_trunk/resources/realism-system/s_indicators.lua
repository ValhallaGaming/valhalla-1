function resStart(res)
	if (res==getThisResource()) then
		for key, veh in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			setElementData(veh, "rightmarker1", nil)
			setElementData(veh, "rightobject1", nil)
			setElementData(veh, "rightmarker2", nil)
			setElementData(veh, "rightobject2", nil)
		end
	end
end
addEventHandler("onResourceStart", getRootElement(), resStart) 

function flashIndicator(marker1, marker2, vehicle, left)	
	if (left) then
		local leftmarker = getElementData(vehicle, "leftmarker1")
		if not (leftmarker) then
			marker1 = nil
			marker2 = nil
			
			local rightmarker = getElementData(vehicle, "rightmarker1")
			local disablingright = getElementData(vehicle, "disablingright")
			if (rightmarker) and not (disablingright) then
				local rightmarker = getElementData(vehicle, "rightmarker1")
				local rightobject = getElementData(vehicle, "rightobject1")
				local rightmarker2 = getElementData(vehicle, "rightmarker2")
				local rightobject2 = getElementData(vehicle, "rightobject2")
				destroyElement(rightmarker)
				destroyElement(rightobject)
				destroyElement(rightmarker2)
				destroyElement(rightobject2)
				setElementData(vehicle, "rightmarker1", nil)
				setElementData(vehicle, "rightobject1", nil)
				setElementData(vehicle, "rightmarker2", nil)
				setElementData(vehicle, "rightobject2", nil)
				setElementData(vehicle, "disablingleft", false)
				setElementData(vehicle, "disablingright", true)
			else
				setElementData(vehicle, "disablingright", false)
			end
		end
	else
		local rightmarker = getElementData(vehicle, "rightmarker1")
		if not (rightmarker) then
			marker1 = nil
			marker2 = nil
		end
		
		local leftmarker = getElementData(vehicle, "leftmarker1")
		local disablingleft = getElementData(vehicle, "disablingleft")
		if (leftmarker) and not (disablingleft) then
			local leftmarker = getElementData(vehicle, "leftmarker1")
			local leftobject = getElementData(vehicle, "leftobject1")
			local leftmarker2 = getElementData(vehicle, "leftmarker2")
			local leftobject2 = getElementData(vehicle, "leftobject2")
			destroyElement(leftmarker)
			destroyElement(leftobject)
			destroyElement(leftmarker2)
			destroyElement(leftobject2)
			setElementData(vehicle, "leftmarker1", nil)
			setElementData(vehicle, "leftobject1", nil)
			setElementData(vehicle, "leftmarker2", nil)
			setElementData(vehicle, "leftobject2", nil)
			setElementData(vehicle, "disablingright", false)
			setElementData(vehicle, "disablingleft", true)
		else
			setElementData(vehicle, "disablingleft", false)
		end
	end
	if (marker1) and (marker2) then
		if (isElementVisibleTo(marker1, getRootElement())) then
			setElementVisibleTo(marker1, getRootElement(), false)
			setElementVisibleTo(marker2, getRootElement(), false)
		else
			setElementVisibleTo(marker1, getRootElement(), true)
			setElementVisibleTo(marker2, getRootElement(), true)
		end
		
		for i = 0, 3 do
			local occupant = getVehicleOccupant(vehicle, i)
			if (occupant) then
				playSoundFrontEnd(occupant, 41)
			end
		end
		setTimer(flashIndicator, 500, 1, marker1, marker2, vehicle, left)
	end
end

function disableIndicatorsOnBlowup()
	local leftmarker = getElementData(source, "leftmarker1")
	local leftobject = getElementData(source, "leftobject1")
	local leftmarker2 = getElementData(source, "leftmarker2")
	local leftobject2 = getElementData(source, "leftobject2")
	
	if (leftmarker) then
		destroyElement(leftmarker)
	end
	
	if (leftobject) then
		destroyElement(leftobject)
	end
	
	if (leftmarker2) then
		destroyElement(leftmarker2)
	end
	
	if (leftobject2) then
		destroyElement(leftobject2)
	end
	
	setElementData(source, "leftmarker1", nil)
	setElementData(source, "leftobject1", nil)
	setElementData(source, "leftmarker2", nil)
	setElementData(source, "leftobject2", nil)
	
	local rightmarker = getElementData(source, "rightmarker1")
	local rightobject = getElementData(source, "rightobject1")
	local rightmarker2 = getElementData(source, "rightmarker2")
	local rightobject2 = getElementData(source, "rightobject2")
	
	if (rightmarker) then
		destroyElement(rightmarker)
	end
	
	if (rightobject) then
		destroyElement(rightobject)
	end
	
	if (rightmarker2) then
		destroyElement(rightmarker2)
	end
	
	if (rightobject2) then
		destroyElement(rightobject2)
	end
	
	setElementData(source, "rightmarker1", nil)
	setElementData(source, "rightobject1", nil)
	setElementData(source, "rightmarker2", nil)
	setElementData(source, "rightobject2", nil)
end
addEventHandler("onVehicleExplode", getRootElement(), disableIndicatorsOnBlowup)
addEventHandler("onVehicleStartExit", getRootElement(), disableIndicatorsOnBlowup)

function toggleLeftIndicator(x1, y1, z1, x2, y2, z2)
	local veh = getPedOccupiedVehicle(source)
	
	if (veh) then
		local leftmarker = getElementData(veh, "leftmarker1")
		
		if not (leftmarker) then
			
			object = createObject(1489, x1, y1, z1)
			exports.pool:allocateElement(object)
			marker = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
			exports.pool:allocateElement(marker)
			attachElements(object, veh, x1+0.1, y1+0.5, z1+0.7)
			attachElements(marker, object, 0, 0, 0)
			setElementAlpha(object, 0)
			
			object2 = createObject(1489, x1, y1, z1)
			exports.pool:allocateElement(object2)
			marker2 = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
			exports.pool:allocateElement(marker2)
			attachElements(object2, veh, x1+0.1, y2, z1+0.7)
			attachElements(marker2, object2, 0, 0, 0)
			setElementAlpha(object2, 0)
			
			
			setElementData(veh, "leftmarker1", marker)
			setElementData(veh, "leftobject1", object)
			setElementData(veh, "leftmarker2", marker2)
			setElementData(veh, "leftobject2", object2)
			
			setTimer(flashIndicator, 500, 1, marker, marker2, veh, true)
		else
			local leftmarker = getElementData(veh, "leftmarker1")
			local leftobject = getElementData(veh, "leftobject1")
			local leftmarker2 = getElementData(veh, "leftmarker2")
			local leftobject2 = getElementData(veh, "leftobject2")
			destroyElement(leftmarker)
			destroyElement(leftobject)
			destroyElement(leftmarker2)
			destroyElement(leftobject2)
			setElementData(veh, "leftmarker1", nil)
			setElementData(veh, "leftobject1", nil)
			setElementData(veh, "leftmarker2", nil)
			setElementData(veh, "leftobject2", nil)
		end
	end
end
addEvent("toggleLeftIndicators", true)
addEventHandler("toggleLeftIndicators", getRootElement(), toggleLeftIndicator)

function toggleRightIndicator(x1, y1, z1, x2, y2, z2)
	local veh = getPedOccupiedVehicle(source)
	
	if (veh) then
		local rightmarker = getElementData(veh, "rightmarker1")
		
		if not (rightmarker) then
			
			-- top right cornor
			object = createObject(1489, x1, y1, z1)
			exports.pool:allocateElement(object)
			marker = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
			exports.pool:allocateElement(marker)
			attachElements(object, veh, x2-0.3, y1+0.4, z1+0.7)
			attachElements(marker, object, 0, 0, 0)
			setElementAlpha(object, 0)
			
			-- top right cornor
			object2 = createObject(1489, x1, y1, z1)
			exports.pool:allocateElement(object2)
			marker2 = createMarker(x1, y1, z1, "corona", 1, 255, 194, 14, 200)
			exports.pool:allocateElement(marker2)
			attachElements(object2, veh, x2-0.3, y2-0.1, z1+0.7)
			attachElements(marker2, object2, 0, 0, 0)
			setElementAlpha(object2, 0)
			
			
			setElementData(veh, "rightmarker1", marker)
			setElementData(veh, "rightobject1", object)
			setElementData(veh, "rightmarker2", marker2)
			setElementData(veh, "rightobject2", object2)
			
			setTimer(flashIndicator, 500, 1, marker, marker2, veh, false)
		else
			local rightmarker = getElementData(veh, "rightmarker1")
			local rightobject = getElementData(veh, "rightobject1")
			local rightmarker2 = getElementData(veh, "rightmarker2")
			local rightobject2 = getElementData(veh, "rightobject2")
			destroyElement(rightmarker)
			destroyElement(rightobject)
			destroyElement(rightmarker2)
			destroyElement(rightobject2)
			setElementData(veh, "rightmarker1", nil)
			setElementData(veh, "rightobject1", nil)
			setElementData(veh, "rightmarker2", nil)
			setElementData(veh, "rightobject2", nil)
		end
	end
end
addEvent("toggleRightIndicators", true)
addEventHandler("toggleRightIndicators", getRootElement(), toggleRightIndicator)