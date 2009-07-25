-- Bodywork repair
function bodyworkRepair()
	local veh = getPedOccupiedVehicle(source)
	if (veh) then
		local money = getElementData(source, "money")
		if(money<50)then
			outputChatBox("You can't afford the parts to repair this vehicle's bodywork.", source, 255, 0, 0)
		else
			local health = getElementHealth(veh)
			fixVehicle(veh)
			setElementHealth(veh, health)
			exports.global:takePlayerSafeMoney(source, 50)
			exports.global:sendLocalMeAction(source, "repairs the vehicle's body work.")
		end
	else
		outputChatBox("You need to be in the vehicle you want to repair.", source, 255, 0, 0)
	end
end
addEvent("repairBody", true)
addEventHandler("repairBody", getRootElement(), bodyworkRepair)

-- Full Service
function serviceVehicle()
	local veh = getPedOccupiedVehicle(source)
	if (veh) then
		local money = getElementData(source, "money")
		if(money<100)then
			outputChatBox("You can't afford the parts to service this vehicle.", source, 255, 0, 0)
		else
			fixVehicle(veh)
			setElementData(veh, "enginebroke", 0, false)
			exports.global:takePlayerSafeMoney(source, 100)
			exports.global:sendLocalMeAction(source, "services the vehicle.")
		end
	else
		outputChatBox("You must be in the vehicle you want to service.", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function changeTyre( wheelNumber )
	local veh = getPedOccupiedVehicle(source)
	if (veh) then
		local money = getElementData(source, "money")
		if(money<10)then
			outputChatBox("You can't afford the parts to chnge this vehicle's tyres.", source, 255, 0, 0)
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
			exports.global:takePlayerSafeMoney(source, 10)
			exports.global:sendLocalMeAction(source, "replaces the vehicle's tyre.")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changeVehicleColour( col1, col2, col3, col4)
	local veh = getPedOccupiedVehicle(source)
	if (veh) then
		local money = getElementData(source, "money")
		if(money<100)then
			outputChatBox("You can't afford to repaint this vehicle.", source, 255, 0, 0)
		else			
			exCol1, exCol2, exCol3, exCol4 = getVehicleColor ( veh )
			
			if not col1 then col1 = exCol1 end
			if not col2 then col2 = exCol2 end
			if not col3 then col3 = exCol3 end
			if not col4 then col4 = exCol4 end
			
			setVehicleColor ( veh, col1, col2, col3, col4 )
			
			exports.global:takePlayerSafeMoney(source, 100)
			exports.global:sendLocalMeAction(source, "repaints the vehicle.")
		end
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)