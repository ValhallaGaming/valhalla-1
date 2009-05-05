-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

function saveVehicleOnExit(thePlayer, seat, vehicle)
	if (vehicle) then
		source = vehicle
	end
	
	
	local dbid = getElementData(source, "dbid")
	
	if (dbid>=0) then -- Check it's a permanently spawned vehicle
		local tick = getTickCount()
		local model = getElementModel(source)
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getVehicleRotation(source)
		
		local owner = getElementData(source, "owner")
		
		if (owner~=-1) then
			local col1, col2, col3, col4 = getVehicleColor(source)
			
			local fuel = getElementData(source, "fuel")
			
			local engine = getElementData(source, "engine")
			
			local locked = isVehicleLocked(source)
			
			if (locked) then
				locked = 1
			else
				locked = 0
			end
			
			local lights = getVehicleOverrideLights(source)
				
			local sirens = getVehicleSirensOn(source)
				
			if (sirens) then
				sirens = 1
			else
				sirens = 0
			end
				
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
				
			mysql_query(handler, "UPDATE vehicles SET model='" .. model .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', fuel='" .. fuel .. "', engine='" .. engine .. "', locked='" .. locked .. "', lights='" .. lights .. "', wheel1='" .. wheel1 .. "', wheel2='" .. wheel2 .. "', wheel3='" .. wheel3 .. "', wheel4='" .. wheel4 .. "' WHERE id='" .. dbid .. "'")
				
			local panel0 = getVehiclePanelState(source, 0)
			local panel1 = getVehiclePanelState(source, 1)
			local panel2 = getVehiclePanelState(source, 2)
			local panel3 = getVehiclePanelState(source, 3)
			local panel4 = getVehiclePanelState(source, 4)
			local panel5 = getVehiclePanelState(source, 5)
			local panel6 = getVehiclePanelState(source, 6)
				
			local door1 = getVehicleDoorState(source, 0)
			local door2 = getVehicleDoorState(source, 1)
			local door3 = getVehicleDoorState(source, 2)
			local door4 = getVehicleDoorState(source, 3)
			local door5 = getVehicleDoorState(source, 4)
			local door6 = getVehicleDoorState(source, 5)
			
			local health = getElementHealth(source)
			
			local paintjob = getVehiclePaintjob(source)
			
			local update = mysql_query(handler, "UPDATE vehicles SET panel0='" .. panel0 .. "', panel1='" .. panel1 .. "', panel2='" .. panel2 .. "', panel3='" .. panel3 .. "', panel4='" .. panel4 .. "', panel5='" .. panel5 .. "', panel6='" .. panel6 .. "', door1='" .. door1 .. "', door2='" .. door2 .. "', door3='" .. door3 .. "', door4='" .. door4 .. "', door5='" .. door5 .. "', door6='" .. door6 .. "', hp='" .. health .. "', sirens='" .. sirens .. "', paintjob='" .. paintjob .. "' WHERE id='" .. dbid .. "'")
			
			if (update) then
				mysql_free_result(update)
			end
			
			local timeTaken = (getTickCount() - tick)/1000
			exports.irc:sendMessage("[SCRIPT] Saving Vehicle ID #" .. dbid .. " [Exit/Respawn] [" .. timeTaken .. " Seconds].")
		end
	end
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)