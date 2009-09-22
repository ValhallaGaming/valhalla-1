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
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then -- Check it's a permanently spawned vehicle and not a job vehicle
		local tick = getTickCount()
		local model = getElementModel(source)
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getVehicleRotation(source)
		
		local owner = getElementData(source, "owner")
		
		if (owner~=-1) then
			local col1, col2, col3, col4 = getVehicleColor(source)
			if getElementData(source, "oldcolors") then
				col1, col2, col3, col4 = unpack(getElementData(source, "oldcolors"))
			end
			
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
				
			local query = mysql_query(handler, "UPDATE vehicles SET model='" .. model .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', fuel='" .. fuel .. "', engine='" .. engine .. "', locked='" .. locked .. "', lights='" .. lights .. "', wheel1='" .. wheel1 .. "', wheel2='" .. wheel2 .. "', wheel3='" .. wheel3 .. "', wheel4='" .. wheel4 .. "' WHERE id='" .. dbid .. "'")
			mysql_free_result(query)
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
			
			local upgrade0 = getElementData( source, "oldupgrade" .. 0 ) or getVehicleUpgradeOnSlot(source, 0)
			local upgrade1 = getElementData( source, "oldupgrade" .. 1 ) or getVehicleUpgradeOnSlot(source, 1)
			local upgrade2 = getElementData( source, "oldupgrade" .. 2 ) or getVehicleUpgradeOnSlot(source, 2)
			local upgrade3 = getElementData( source, "oldupgrade" .. 3 ) or getVehicleUpgradeOnSlot(source, 3)
			local upgrade4 = getElementData( source, "oldupgrade" .. 4 ) or getVehicleUpgradeOnSlot(source, 4)
			local upgrade5 = getElementData( source, "oldupgrade" .. 5 ) or getVehicleUpgradeOnSlot(source, 5)
			local upgrade6 = getElementData( source, "oldupgrade" .. 6 ) or getVehicleUpgradeOnSlot(source, 6)
			local upgrade7 = getElementData( source, "oldupgrade" .. 7 ) or getVehicleUpgradeOnSlot(source, 7)
			local upgrade8 = getElementData( source, "oldupgrade" .. 8 ) or getVehicleUpgradeOnSlot(source, 8)
			local upgrade9 = getElementData( source, "oldupgrade" .. 9 ) or getVehicleUpgradeOnSlot(source, 9)
			local upgrade10 = getElementData( source, "oldupgrade" .. 10 ) or getVehicleUpgradeOnSlot(source, 10)
			local upgrade11 = getElementData( source, "oldupgrade" .. 11 ) or getVehicleUpgradeOnSlot(source, 11)
			local upgrade12 = getElementData( source, "oldupgrade" .. 12 ) or getVehicleUpgradeOnSlot(source, 12)
			local upgrade13 = getElementData( source, "oldupgrade" .. 13 ) or getVehicleUpgradeOnSlot(source, 13)
			local upgrade14 = getElementData( source, "oldupgrade" .. 14 ) or getVehicleUpgradeOnSlot(source, 14)
			local upgrade15 = getElementData( source, "oldupgrade" .. 15 ) or getVehicleUpgradeOnSlot(source, 15)
			local upgrade16 = getElementData( source, "oldupgrade" .. 16 ) or getVehicleUpgradeOnSlot(source, 16)

			local Impounded = getElementData(source, "Impounded")

			
			local health = getElementHealth(source)
			
			local paintjob = getVehiclePaintjob(source)
			if getElementData(source, "oldpaintjob") then
				paintjob = getElementData(source, "oldpaintjob")
			end
			
			local dimension = getElementDimension(source)
			local interior = getElementInterior(source)
			
			local update = mysql_query(handler, "UPDATE vehicles SET panel0='" .. panel0 .. "', panel1='" .. panel1 .. "', panel2='" .. panel2 .. "', panel3='" .. panel3 .. "', panel4='" .. panel4 .. "', panel5='" .. panel5 .. "', panel6='" .. panel6 .. "', door1='" .. door1 .. "', door2='" .. door2 .. "', door3='" .. door3 .. "', door4='" .. door4 .. "', door5='" .. door5 .. "', door6='" .. door6 .. "', hp='" .. health .. "', sirens='" .. sirens .. "', paintjob='" .. paintjob .. "', currdimension='" .. dimension .. "', currinterior='" .. interior .. "' WHERE id='" .. dbid .. "'")
			local update2 = mysql_query(handler, "UPDATE vehicles SET upgrade0='" .. upgrade0 .. "', upgrade1='" .. upgrade1 .. "', upgrade2='" .. upgrade2 .. "', upgrade3='" .. upgrade3 .. "', upgrade4='" .. upgrade4 .. "', upgrade5='" .. upgrade5 .. "', upgrade6='" .. upgrade6 .. "', upgrade7='" .. upgrade7 .. "', upgrade8='" .. upgrade8 .. "', upgrade9='" .. upgrade9 .. "', upgrade10='" .. upgrade10 .. "', upgrade11='" .. upgrade11 .. "', upgrade12='" .. upgrade12 .. "', upgrade13='" .. upgrade13 .. "', upgrade14='" .. upgrade14 .. "', upgrade15='" .. upgrade15 .. "', upgrade16='" .. upgrade16 .. "', Impounded='" .. tonumber(Impounded) .. "' WHERE id='" .. dbid .. "'")
			
			mysql_free_result(update)
			mysql_free_result(update2)
			
			local timeTaken = (getTickCount() - tick)/1000
			exports.irc:sendMessage("[SCRIPT] Saving Vehicle ID #" .. dbid .. " [Exit/Respawn] [" .. timeTaken .. " Seconds].")
		end
	end
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)