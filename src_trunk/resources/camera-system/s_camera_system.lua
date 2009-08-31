-- STRIP CAMERA 1
stripCamera1 = nil
stripCamera1Col = nil
stripCamera1ColWarn = nil
stripCamera1Speed = nil


function resourceStart(res)
	-- STRIP CAMERA 1
	stripCamera1 = createObject(1293, 1342.5859375, -1471.4306640625, 12.939081573486, 0, 0, 347.48364257813)
	exports.pool:allocateElement(stripCamera1)
	stripCamera1Col = createColTube(1342.5859375, -1471.4306640625, 5, 80, 9)
	exports.pool:allocateElement(stripCamera1Col)
	stripCamera1ColWarn = createColTube(1342.5859375, -1471.4306640625, 5, 150, 10)
	exports.pool:allocateElement(stripCamera1ColWarn)
	stripCamera1Speed = 65
	addEventHandler("onColShapeHit", stripCamera1ColWarn, sendWarning)
	addEventHandler("onColShapeHit", stripCamera1Col, monitorSpeed)
	addEventHandler("onColShapeLeave", stripCamera1Col, stopMonitorSpeed)
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

-- dynamic stuff
function monitorSpeed(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle")then
		local thePlayer = getVehicleOccupant(element)
		if thePlayer then
			local timer = setTimer(checkSpeed, 200, 40, element, thePlayer, source)
			setElementData(thePlayer, "cameratimer", timer, false)
		end
	end
end

function stopMonitorSpeed(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle") then
		local thePlayer = getVehicleOccupant(element)
		if thePlayer then
			local timer = getElementData(thePlayer, "cameratimer")
			if isTimer( timer ) then
				killTimer( timer )
			end
			removeElementData( thePlayer, "cameratimer" )
		end
	end
end

function checkSpeed(vehicle, player, colshape)
	speedx, speedy, speedz = getElementVelocity(vehicle)
	if (speedx) and (speedy) and (speedz) then
		speed = ((speedx^2 + speedy^2 + speedz^2)^(0.5)*100)
		
		if (colshape==stripCamera1Col) then -- strip camera 1
			if (speed>stripCamera1Speed) then
				local x, y, z = getElementPosition(player)
				local timer = getElementData(player, "cameratimer")
				if timer then
					killTimer(timer)
					removeElementData(player, "cameratimer")
				end
				setTimer(sendWarningToCops, 1000, 1, vehicle, player, colshape, x, y, z, speed)
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
		local dx = nx - x
		local dy = ny - y
		
		if dy > math.abs(dx) then
			direction = "northbound"
		elseif dy < -math.abs(dx) then
			direction = "southbound"
		elseif dx > math.abs(dy) then
			direction = "eastbound"
		elseif dx < -math.abs(dy) then
			direction = "westbound"
		end
		
		exports.global:givePlayerAchievement(player, 13)
		triggerClientEvent(player, "cameraEffect", player)
		
		local theTeam = getTeamFromName("Los Santos Police Department")
		local teamPlayers = getPlayersInTeam(theTeam)
		for key, value in ipairs(teamPlayers) do
			local duty = tonumber(getElementData(value, "duty"))
			if (duty>0) then
				outputChatBox("DISPATCH: All units we have a traffic violation at " .. areaname .. ". ((" .. getPlayerName(player) .. "))", value, 255, 194, 14)
				outputChatBox("DISPATCH: Vehicle was a " .. vehname .. " travelling at " .. tostring(math.ceil(speed)) .. " Mph.", value, 255, 194, 14)
				outputChatBox("DISPATCH: Vehicle was last seen heading " .. direction .. ".", value, 255, 194, 14)
			end
		end
	end
end

function sendWarning(element, matchingDimension)
	if (matchingDimension) and (getElementType(element)=="vehicle")then
		local thePlayer = getVehicleOccupant(element)
		
		if (isElement(thePlayer) and (thePlayer~=getRootElement())) then
			outputChatBox("You are entering a speed control area. The speed limit is 60Kph (40Mph). Watch your speed.", thePlayer)
			outputChatBox("Courtesy of the Los Santos Police Department.", thePlayer)
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