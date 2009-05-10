-- STRIP CAMERA 1
stripCamera1 = nil
stripCamera1Col = nil
stripCamera1ColWarn = nil
stripCamera1Speed = nil


function resourceStart(res)
	if (res==getThisResource()) then
		-- STRIP CAMERA 1
		stripCamera1 = createObject(1293, 2057.3688964844, 1600.7856445313, 9.929556846619, 0, 0, 183.23063659668)
		exports.pool:allocateElement(stripCamera1)
		stripCamera1Col = createColSphere(2057.3688964844, 1600.7856445313, 9.929556846619, 80)
		exports.pool:allocateElement(stripCamera1Col)
		stripCamera1ColWarn = createColSphere(2057.3688964844, 1600.7856445313, 10.929556846619, 150)
		exports.pool:allocateElement(stripCamera1ColWarn)
		stripCamera1Speed = 60
		addEventHandler("onColShapeHit", stripCamera1ColWarn, sendWarning)
		addEventHandler("onColShapeHit", stripCamera1Col, monitorSpeed)
		addEventHandler("onColShapeLeave", stripCamera1Col, stopMonitorSpeed)
	end
end
addEventHandler("onResourceStart", getRootElement(), resourceStart)

-- dynamic stuff
function monitorSpeed(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle")then
		local thePlayer = getVehicleOccupant(element)
		local timer = setTimer(checkSpeed, 200, 40, element, thePlayer, source)
		setElementData(thePlayer, "cameratimer", timer)
	end
end

function stopMonitorSpeed(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle") then
		local thePlayer = getVehicleOccupant(element)
		local timer = getElementData(thePlayer, "cameratimer")
	end
end

function checkSpeed(vehicle, player, colshape)
	speedx, speedy, speedz = getElementVelocity(vehicle)
	if (speedx) and (speedy) and (speedz) then
		speed = ((speedx^2 + speedy^2 + speedz^2)^(0.5)*100)
		
		if (colshape==stripCamera1Col) then -- strip camera 1
			if (speed>stripCamera1Speed) then
				local x, y, z = getElementPosition(player)
				if (z<14) then
					local timer = getElementData(player, "cameratimer")
					killTimer(timer)
					setTimer(sendWarningToCops, 1000, 1, vehicle, player, colshape, x, y, z, speed)
				end
			end
		end
	end
end

lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

function sendWarningToCops(vehicle, player, colshape, x, y, z, speed)
	local direction = "in an unknown direction"
	local areaname = getZoneName(x, y, z)
	local nx, ny, nz = getElementPosition(player)
	local vehname = getVehicleName(vehicle)
	local vehid = getElementModel(vehicle)
	
	if not (lawVehicles[vehid]) then
		if (ny>y) then -- north
			direction = "northbound"
		elseif (ny<y) then -- south
			direction = "southbound"
		elseif (nx>x) then -- east
			direction = "eastbound"
		elseif (nx<x) then -- west
			direction = "westbound"
		end
		
		exports.global:givePlayerAchievement(player, 13)
		triggerClientEvent(player, "cameraEffect", player)
		
		local theTeam = getTeamFromName("Las Venturas Metropolitan Police Department")
		local teamPlayers = getPlayersInTeam(theTeam)
		for key, value in ipairs(teamPlayers) do
			outputChatBox("DISPATCH: All units we have a traffic violation at " .. areaname .. ". ((" .. getPlayerName(player) .. "))", value, 255, 194, 14)
			outputChatBox("DISPATCH: Vehicle was a " .. vehname .. " travelling at " .. tostring(math.ceil(speed))+15 .. " Mph.", value, 255, 194, 14)
			outputChatBox("DISPATCH: Vehicle was last seen heading " .. direction .. ".", value, 255, 194, 14)
		end
	end
end

function sendWarning(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle")then
		local thePlayer = getVehicleOccupant(element)
		
		if (getElementType(thePlayer) and isElement(thePlayer)) then
			outputChatBox("You are entering a speed control area. The speed limit is 80Mph (120Kph). Watch your speed.", thePlayer)
			outputChatBox("Courtesy of the Las Venturas Metropolitan Police Department.", thePlayer)
		end
	end
end

function showspeed(thePlayer)
	local veh = getPedOccupiedVehicle(thePlayer)
	speedx, speedy, speedz = getElementVelocity (veh)
	actualspeed = ((speedx^2 + speedy^2 + speedz^2)^(0.5)*100)
	outputChatBox("SPEED: " .. actualspeed .. "(" .. getTrainSpeed(veh) .. ")")
	setVehicleEngineState(veh, true)
end