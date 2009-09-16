armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car

-- Bodywork repair
function bodyworkRepair(veh)
	if (veh) then
		if not exports.global:takeMoney(source, 50) then
			outputChatBox("You can't afford the parts to repair this vehicle's bodywork.", source, 255, 0, 0)
		else
			local health = getElementHealth(veh)
			fixVehicle(veh)
			setElementHealth(veh, health)
			exports.global:sendLocalMeAction(source, "repairs the vehicle's body work.")
		end
	else
		outputChatBox("You need to be in the vehicle you want to repair.", source, 255, 0, 0)
	end
end
addEvent("repairBody", true)
addEventHandler("repairBody", getRootElement(), bodyworkRepair)

-- Full Service
function serviceVehicle(veh)
	if (veh) then
		if not exports.global:takeMoney(source, 100) then
			outputChatBox("You can't afford the parts to service this vehicle.", source, 255, 0, 0)
		else
			fixVehicle(veh)
			if not getElementData(veh, "Impounded") or getElementData(veh, "Impounded") == 0 then
				setElementData(veh, "enginebroke", 0, false)
				if armoredCars[ getElementModel( veh ) ] then
					setVehicleDamageProof(veh, true)
				else
					setVehicleDamageProof(veh, false)
				end
			end
			exports.global:sendLocalMeAction(source, "services the vehicle.")
		end
	else
		outputChatBox("You must be in the vehicle you want to service.", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function changeTyre( veh, wheelNumber )
	if (veh) then
		if not exports.global:takeMoney(source, 10) then
			outputChatBox("You can't afford the parts to change this vehicle's tyres.", source, 255, 0, 0)
		else
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates( veh )

			if (wheelNumber==1) then -- front left
				outputDebugString("Tyre 1 changed.")
				setVehicleWheelStates ( veh, 0, wheel2, wheel3, wheel4 )
			elseif (wheelNumber==2) then -- back left
				outputDebugString("Tyre 2 changed.")
				setVehicleWheelStates ( veh, wheel1, wheel2, 0, wheel4 )
			elseif (wheelNumber==3) then -- front right
				outputDebugString("Tyre 3 changed.")
				setVehicleWheelStates ( veh, wheel1, 0, wheel2, wheel4 )
			elseif (wheelNumber==4) then -- back right
				outputDebugString("Tyre 4 changed.")
				setVehicleWheelStates ( veh, wheel1, wheel2, wheel3, 0 )			
			end
			exports.global:sendLocalMeAction(source, "replaces the vehicle's tyre.")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changePaintjob( veh, paintjob )
	if (veh) then
		if not exports.global:takeMoney(source, 7500) then
			outputChatBox("You can't afford to repaint this vehicle.", source, 255, 0, 0)
		else
			triggerEvent( "paintjobEndPreview", source, veh )
			if setVehiclePaintjob( veh, paintjob ) then
				local col1, col2 = getVehicleColor( veh )
				if col1 == 0 or col2 == 0 then
					setVehicleColor( veh, 1, 1, 1, 1 )
				end
				exports.global:sendLocalMeAction(source, "repaints the vehicle.")
			else
				outputChatBox("This car already has this paintjob.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("paintjobChange", true)
addEventHandler("paintjobChange", getRootElement(), changePaintjob)

function changeVehicleUpgrade( veh, upgrade, name, cost )
	if (veh) then
		if not exports.global:hasMoney( source, cost ) then
			outputChatBox("You can't afford to add " .. name .. " to this vehicle.", source, 255, 0, 0)
		else
			for i = 0, 16 do
				if upgrade == getVehicleUpgradeOnSlot( veh, i ) then
					outputChatBox("This car already has this upgrade.", source, 255, 0, 0)
					return
				end
			end
			if addVehicleUpgrade( veh, upgrade ) then
				exports.global:takeMoney(source, cost)
				exports.global:sendLocalMeAction(source, "added " .. name .. " to the vehicle.")
			else
				outputChatBox("Failed to apply the car upgrade.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("changeVehicleUpgrade", true)
addEventHandler("changeVehicleUpgrade", getRootElement(), changeVehicleUpgrade)

function changeVehicleColour(veh, col1, col2, col3, col4)
	if (veh) then
		if not exports.global:takeMoney(source, 100) then
			outputChatBox("You can't afford to repaint this vehicle.", source, 255, 0, 0)
		else			
			exCol1, exCol2, exCol3, exCol4 = getVehicleColor ( veh )
			
			if not col1 then col1 = exCol1 end
			if not col2 then col2 = exCol2 end
			if not col3 then col3 = exCol3 end
			if not col4 then col4 = exCol4 end
			
			setVehicleColor ( veh, col1, col2, col3, col4 )
			
			exports.global:sendLocalMeAction(source, "repaints the vehicle.")
		end
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)