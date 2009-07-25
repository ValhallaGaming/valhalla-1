function unsitInHelicopter(vehicle)
	local seat = getElementData(source, "seat")
	
	if (isElement(vehicle)) then
		if not (getElementType(vehicle)=="vehicle") then
			local vehicles = exports.pool:getPoolElementsByType("vehicle")
			local helicopters = { }
			for key, value in ipairs(vehicles) do
				if (getElementModel(value)==497) then
					table.insert(helicopters, value)
				end
			end
			
			for key, value in ipairs(helicopters) do
				local players = getElementData(value, "players")
				
				if (players) then				
					local removed = false
					for key, value in ipairs(players) do
						if (value==source) then
							removed = true
							table.remove(players, key)
						end
					end
					
					if (removed) then
						setElementData(value, "players", players, false)
					end
				end
			end
			
			removeElementData(source, "seat")
			detachElements(source, vehicle)
			exports.global:removeAnimation(source)
		elseif (seat) and (seat>0) then
			local players = getElementData(vehicle, "players")
			
			for key, value in ipairs(players) do
				if (value==source) then
					table.remove(players, key)
				end
			end
			setElementData(vehicle, "players", players, false)
			removeElementData(source, "seat")
			detachElements(source, vehicle)
			exports.global:removeAnimation(source)
		end
	end
end
addEvent("unsitInHelicopter", true)
addEventHandler("unsitInHelicopter", getRootElement(), unsitInHelicopter)
addEventHandler("onPlayerSpawn", getRootElement(), unsitInHelicopter)
addEventHandler("onPlayerQuit", getRootElement(), unsitInHelicopter)


function sitInHelicopter(vehicle)
	local players = getElementData(vehicle, "players")
	
	if (not players) or (#players<2) then
		local seat = 0
		if not (players) then
			players = { }
			seat = 1
		end
		
		-- determine their seat...
		local s1 = false
		local s2 = false
		
		for key, value in ipairs(players) do
			local seat = getElementData(value, "seat")
			
			if (seat==1) then
				s1 = true
			elseif (seat==2) then
				s2 = true
			end
		end
		
		if (s1) then
			seat = 1
			
			local x, y, z = getElementPosition(vehicle)
			local rx, ry, rz = getVehicleRotation(vehicle)
			x = x - math.sin(math.rad(rz))*1.01
			y = y - math.cos(math.rad(rz))*1.01
			
			attachElements(source, vehicle, -1.3, 0, 0)
			setPedRotation(source, rz+90)
			exports.global:applyAnimation(source, "FOOD", "FF_Sit_Look", 999999, true, true, false)
			setPedWeaponSlot(source, 5)
		elseif not (s2) then
			seat = 1
			
			local x, y, z = getElementPosition(vehicle)
			local rx, ry, rz = getVehicleRotation(vehicle)
			x = x + math.sin(math.rad(rz))*1.01
			y = y + math.cos(math.rad(rz))*1.01
			
			attachElements(source, vehicle, 1.3, 0, 0)
			setPedRotation(source, rz-90)
			exports.global:applyAnimation(source, "FOOD", "FF_Sit_Look", 999999, true, true, false)
			setPedWeaponSlot(source, 5)
		end
		
		table.insert(players, source)
		setElementData(source, "seat", seat, false)
		
		setElementData(vehicle, "players", players, false)
	else
		outputChatBox("This helicopter is full.", source, 255, 0, 0)
	end
end
addEvent("sitInHelicopter", true)
addEventHandler("sitInHelicopter", getRootElement(), sitInHelicopter)