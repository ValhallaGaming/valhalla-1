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

enginelessVehicle = { [510]=true, [509]=true, [481]=true }
lightlessVehicle = { [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [497]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true }
locklessVehicle = { [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true }
armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car

-- Events
addEvent("onVehicleSpawn", false)

-- /makeveh
function createPermVehicle(thePlayer, commandName, id, col1, col2, userName, factionVehicle, cost)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) or not (col1) or not (col2) or not (userName) or not (factionVehicle) or not (cost) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id] [color1 (-1 for random)] [color2 (-1 for random)] [Owner Partial Username] [Faction Vehicle (1/0)] [Cost] [Tinted Windows] ", thePlayer, 255, 194, 14)
			outputChatBox("NOTE: If it is a faction vehicle, Username is the owner of the faction.", thePlayer, 255, 194, 14)
			outputChatBox("NOTE: If it is a faction vehicle, The cost is taken from the faction fund, rather than the player.", thePlayer, 255, 194, 14)
		else
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			if (tonumber(col1)==-1) then
				col1 = math.random(0, 126)
			end
			
			if (tonumber(col2)==-1) then
				col2 = math.random(0, 126)
			end
			
			local targetPlayer = exports.global:findPlayerByPartialNick(userName)
			
			if not (targetPlayer) then
				outputChatBox("No such player found.", thePlayer, 255, 0, 0)
			else
				local username = getPlayerName(targetPlayer)
				local dbid = getElementData(targetPlayer, "dbid")
				cost = tonumber(cost)
				
				if (tonumber(factionVehicle)==1) then
					factionVehicle = tonumber(getElementData(targetPlayer, "faction"))
					local theTeam = getPlayerTeam(targetPlayer)
					local money = getElementData(theTeam, "money")
					
					if (cost>money) then
						outputChatBox("This faction cannot afford this vehicle.", thePlayer, 255, 0, 0)
					else
						setElementData(theTeam, "money", money-tonumber(cost))
						mysql_query(handler, "UPDATE factions SET money='" .. money-tonumber(cost) .. "' WHERE id='" .. factionVehicle .. "'")
					end
				else
					factionVehicle = -1
					local money = getElementData(targetPlayer, "money")
					if (cost>money) then
						outputChatBox("This player cannot afford this vehicle.", thePlayer, 255, 0, 0)
					else
						exports.global:takePlayerSafeMoney(targetPlayer, cost)
					end
				end
				
				local letter1 = exports.global:randChar()
				local letter2 = exports.global:randChar()
				local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
				
				local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
				exports.pool:allocateElement(veh)
					
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
				else
					setElementData(veh, "fuel", 100)
						
					local rx, ry, rz = getVehicleRotation(veh)
					setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
					setVehicleLocked(veh, true)
					local locked = 1
							
					setVehicleColor(veh, col1, col2, col1, col2)
						
					setVehicleOverrideLights(veh, 1)
					setVehicleEngineState(veh, false)
					setVehicleFuelTankExplodable(veh, false)
					
					-- faction vehicles are unlocked
					if (factionVehicle~=-1) then
						locked = 0
						setVehicleLocked(veh, false)
					end
					
					-- Set the vehicle armored if it is armored
					if (armoredCars[tonumber(id)]) then
						setVehicleDamageProof(veh, true)
					end
						
					local query = mysql_query(handler, "INSERT INTO vehicles SET model='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', faction='" .. factionVehicle .. "', owner='" .. dbid .. "', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. r .. "', locked='" .. locked .. "'")

					if (query) then
						mysql_free_result(query)
						local id = mysql_insert_id(handler)
							
						if (factionVehicle==-1) then
							exports.global:givePlayerItem(targetPlayer, 3, tonumber(id))
						end
						
						setElementData(veh, "dbid", tonumber(id))
						setElementData(veh, "fuel", 100)
						setElementData(veh, "engine", 0)
						setElementData(veh, "oldx", x)
						setElementData(veh, "oldy", y)
						setElementData(veh, "oldz", z)
						setElementData(veh, "faction", factionVehicle)
						setElementData(veh, "owner", dbid)
						setElementData(veh, "job", 0)
						outputChatBox(getVehicleName(veh) .. " spawned with ID #" .. id .. ".", thePlayer, 255, 194, 14)
						triggerEvent("onVehicleSpawn", veh)
					end
				end
			end
		end
	end
end
addCommandHandler("makeveh", createPermVehicle, false, false)

-- /makecivveh
function createCivilianPermVehicle(thePlayer, commandName, id, col1, col2, userName, factionVehicle, cost)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) or not (col1) or not (col2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id] [color1 (-1 for random)] [color2 (-1 for random)]", thePlayer, 255, 194, 14)
		else
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			if (tonumber(col1)==-1) then
				col1 = math.random(0, 126)
			end
			
			if (tonumber(col2)==-1) then
				col2 = math.random(0, 126)
			end
			
			local letter1 = exports.global:randChar()
			local letter2 = exports.global:randChar()
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
			
			local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
			exports.pool:allocateElement(veh)
				
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				setElementData(veh, "fuel", 100)
					
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				setVehicleLocked(veh, false)
					
				setVehicleColor(veh, col1, col2, col1, col2)
					
				setVehicleOverrideLights(veh, 1)
				setVehicleEngineState(veh, false)
				setVehicleFuelTankExplodable(veh, false)
				
				-- Set the vehicle armored if it is armored
				if (armoredCars[tonumber(id)]) then
					setVehicleDamageProof(veh, true)
				end
					
				local query = mysql_query(handler, "INSERT INTO vehicles SET model='" .. id .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', color1='" .. col1 .. "', color2='" .. col2 .. "', faction='-1', owner='-2', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. r .. "'")
				
				if (query) then
					mysql_free_result(query)
					local id = mysql_insert_id(handler)
					
					setElementData(veh, "dbid", tonumber(id))
					setElementData(veh, "fuel", 100)
					setElementData(veh, "engine", 0)
					setElementData(veh, "oldx", x)
					setElementData(veh, "oldy", y)
					setElementData(veh, "oldz", z)
					setElementData(veh, "faction", -1)
					setElementData(veh, "owner", -2)
					setElementData(veh, "job", 0)
					outputChatBox(getVehicleName(veh) .. " (Civilian) spawned with ID #" .. id .. ".", thePlayer, 255, 194, 14)
					triggerEvent("onVehicleSpawn", veh)
				end
			end
		end
	end
end
addCommandHandler("makecivveh", createCivilianPermVehicle, false, false)

function loadAllVehicles(res)
	if (res==getThisResource()) then
		
		-- Reset player in vehicle states
		local players = exports.pool:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			setElementData(value, "realinvehicle", 0)
		end
		
		local result = mysql_query(handler, "SELECT currx, curry, currz, currrx, currry, currrz, x, y, z, rotx, roty, rotz, id, model, upgrade0, upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6, upgrade7, upgrade8, upgrade9, upgrade10, upgrade11, upgrade12, upgrade13, upgrade14, upgrade15, upgrade16 FROM vehicles")
		local resultext = mysql_query(handler, "SELECT fuel, engine, locked, lights, sirens, paintjob, wheel1, wheel2, wheel3, wheel4, panel0, panel1, panel2, panel3, panel4, panel5, panel6, door1, door2, door3, door4, door5, door6, hp, color1, color2, plate, faction, owner, job FROM vehicles")
		
		local counter = 0
		local rowc = 1
		
		if (result) then
			for result, row in mysql_rows(result) do
				local x = tonumber(row[1])
				local y = tonumber(row[2])
				local z = tonumber(row[3])
				
				local rx = tonumber(row[4])
				local ry = tonumber(row[5])
				local rz = tonumber(row[6])
				

				local respawnx = tonumber(row[7])
				local respawny = tonumber(row[8])
				local respawnz = tonumber(row[9])
				
				local respawnrx = tonumber(row[10])
				local respawnry = tonumber(row[11])
				local respawnrz = tonumber(row[12])
				
				local id = tonumber(row[13])
				local vehid = tonumber(row[14])
				
				local upgrade0 = row[15]
				local upgrade1 = row[16]
				local upgrade2 = row[17]
				local upgrade3 = row[18]
				local upgrade4 = row[19]
				local upgrade5 = row[20]
				local upgrade6 = row[21]
				local upgrade7 = row[22]
				local upgrade8 = row[23]
				local upgrade9 = row[24]
				local upgrade10 = row[25]
				local upgrade11 = row[26]
				local upgrade12 = row[27]
				local upgrade13 = row[28]
				local upgrade14 = row[29]
				local upgrade15 = row[30]
				local upgrade16 = row[31]
				
				local fuel = tonumber(mysql_result(resultext, rowc, 1))
				local engine = tonumber(mysql_result(resultext, rowc, 2))
				local locked = tonumber(mysql_result(resultext, rowc, 3))
				local lights = tonumber(mysql_result(resultext, rowc, 4))
				local sirens = tonumber(mysql_result(resultext, rowc, 5))
				local paintjob = tonumber(mysql_result(resultext, rowc, 6))
				
				local wheel1 = mysql_result(resultext, rowc, 7)
				local wheel2 = mysql_result(resultext, rowc, 8)
				local wheel3 = mysql_result(resultext, rowc, 9)
				local wheel4 = mysql_result(resultext, rowc, 10)
				
				local panel0 = mysql_result(resultext, rowc, 11)
				local panel1 = mysql_result(resultext, rowc, 12)
				local panel2 = mysql_result(resultext, rowc, 13)
				local panel3 = mysql_result(resultext, rowc, 14)
				local panel4 = mysql_result(resultext, rowc, 15)
				local panel5 = mysql_result(resultext, rowc, 16)
				local panel6 = mysql_result(resultext, rowc, 17)
				
				local door1 = mysql_result(resultext, rowc, 18)
				local door2 = mysql_result(resultext, rowc, 19)
				local door3 = mysql_result(resultext, rowc, 20)
				local door4 = mysql_result(resultext, rowc, 21)
				local door5 = mysql_result(resultext, rowc, 22)
				local door6 = mysql_result(resultext, rowc, 23)
				
				local hp = mysql_result(resultext, rowc, 24)
				
				local col1 = mysql_result(resultext, rowc, 25)
				local col2 = mysql_result(resultext, rowc, 26)
				
				local plate = mysql_result(resultext, rowc, 27)
				
				local faction = tonumber(mysql_result(resultext, rowc, 28))
				local owner = tonumber(mysql_result(resultext, rowc, 29))
				
				if (faction~=-1) then
					locked = 0
				end
				
				local job = mysql_result(resultext, rowc, 30)
				
				-- Spawn the vehicle
				local veh = createVehicle(vehid, x, y, z, rx, ry, rz, plate)
				exports.pool:allocateElement(veh)
				
				-- Set the vehicle armored if it is armored
				if (armoredCars[tonumber(vehid)]) then
					setVehicleDamageProof(veh, true)
				end
				
				-- Set the lights to undamaged, currently we cannot load light states as the MTA function is bugged
				setVehicleLightState(veh, 0, 0)
				setVehicleLightState(veh, 1, 0)
				setVehicleLightState(veh, 2, 0)
				setVehicleLightState(veh, 3, 0)
				
				-- Add the vehicle upgrades
				addVehicleUpgrade(veh, upgrade0)
				addVehicleUpgrade(veh, upgrade1)
				addVehicleUpgrade(veh, upgrade2)
				addVehicleUpgrade(veh, upgrade3)
				addVehicleUpgrade(veh, upgrade4)
				addVehicleUpgrade(veh, upgrade5)
				addVehicleUpgrade(veh, upgrade6)
				addVehicleUpgrade(veh, upgrade7)
				addVehicleUpgrade(veh, upgrade8)
				addVehicleUpgrade(veh, upgrade9)
				addVehicleUpgrade(veh, upgrade10)
				addVehicleUpgrade(veh, upgrade11)
				addVehicleUpgrade(veh, upgrade12)
				addVehicleUpgrade(veh, upgrade13)
				addVehicleUpgrade(veh, upgrade14)
				addVehicleUpgrade(veh, upgrade15)
				addVehicleUpgrade(veh, upgrade16)
				
				-- Paint job
				setVehiclePaintjob(veh, paintjob)
				
				-- Vehicle wheel states
				setVehicleWheelStates(veh, wheel1, wheel2, wheel3, wheel4)
				
				-- Vehicle panel states
				setVehiclePanelState(veh, 0, panel0)
				setVehiclePanelState(veh, 1, panel1)
				setVehiclePanelState(veh, 2, panel2)
				setVehiclePanelState(veh, 3, panel3)
				setVehiclePanelState(veh, 4, panel4)
				setVehiclePanelState(veh, 5, panel5)
				setVehiclePanelState(veh, 6, panel6)
				
				-- Door states
				setVehicleDoorState(veh, 0, door1)
				setVehicleDoorState(veh, 1, door2)
				setVehicleDoorState(veh, 2, door3)
				setVehicleDoorState(veh, 3, door4)
				setVehicleDoorState(veh, 4, door5)
				setVehicleDoorState(veh, 5, door6)
				
				-- Car HP
				setElementHealth(veh, hp)
				
				-- Lock the vehicle if locked
				if (locked==1) then
					setVehicleLocked(veh, true)
				else
					setVehicleLocked(veh, false)
				end
				
				-- Set the siren status
				if (sirens==1) then
					setVehicleSirensOn(veh, true)
				else
					setVehicleSirensOn(veh, false)
				end
				
				-- Set the vehicles color
				setVehicleColor(veh, col1, col2, col1, col2)
				
				-- Fix rz
				rz = -rz
				--respawnrz = -respawnrz
				respawnry = 0
				
				-- Where the vehicle will respawn on explode/idle
				setVehicleRespawnPosition(veh, respawnx, respawny, respawnz, respawnrx, respawnry, respawnrz)
				
				-- Vehicles element data
				setElementData(veh, "dbid", id)
				setElementData(veh, "fuel", fuel)
				setElementData(veh, "engine", engine)
				setElementData(veh, "oldx", x)
				setElementData(veh, "oldy", y)
				setElementData(veh, "oldz", z)
				setElementData(veh, "faction", faction)
				setElementData(veh, "owner", owner)
				setElementData(veh, "job", tonumber(job))
				
				-- Set the lights
				if (lights==0 or lights==1) then
					setVehicleOverrideLights(veh, 1)
				else
					setVehicleOverrideLights(veh, 2)
				end
				
				-- Set the sirens
				setVehicleSirensOn(veh, false)
				
				-- Set the engine
				if (engine==0) then
					setVehicleEngineState(veh, false)
				else
					setVehicleEngineState(veh, true)
				end
				
				-- Set the fuel tank non explodable
				setVehicleFuelTankExplodable(veh, false)
				
				triggerEvent("onVehicleSpawn", veh)
				counter = counter + 1
				rowc = rowc + 1
			end
		end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " vehicles.")
	end
end
addEventHandler("onResourceStart", getRootElement(), loadAllVehicles)

function vehicleExploded()
	setTimer(respawnVehicle, 180000, 1, source)
end
addEventHandler("onVehicleExplode", getRootElement(), vehicleExploded)

function vehicleRespawn(exploded)
	local id = getElementData(source, "dbid")
	local faction = getElementData(source, "faction")
	local owner = getElementData(source, "owner")
		
	-- Set the vehicle armored if it is armored
	local vehid = getElementModel(source)
	if (armoredCars[tonumber(vehid)]) then
		setVehicleDamageProof(source, true)
	end
		
	setVehicleFuelTankExplodable(source, false)
	setVehicleEngineState(source, false)
	setVehicleLandingGearDown(source, true)
	
	setElementData(source, "dbid", id)
	setElementData(source, "fuel", 100)
	setElementData(source, "engine", 0)
	
	local x, y, z = getElementPosition(source)
	setElementData(source, "oldx", x)
	setElementData(source, "oldy", y)
	setElementData(source, "oldz", z)
	
	setElementData(source, "faction", faction)
	setElementData(source, "owner", owner)
	
	setVehicleOverrideLights(source, 1)
	setVehicleFrozen(source, false)
	
	-- Set the sirens off
	setVehicleSirensOn(source, false)
	
	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)
	
	if (faction==-1) then
		setVehicleLocked(source, true)
	end
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleRespawn)

function setEngineStatusOnEnter(thePlayer, seat, jacked)
	local engine = getElementData(source, "engine")
	
	if (seat==0) then
		local model = getElementModel(source)
		if not (enginelessVehicle[model]) then
			if (engine==0) then
				toggleControl(thePlayer, "accelerate", false)
				toggleControl(thePlayer, "brake_reverse", false)
				toggleControl(thePlayer, "vehicle_fire", false)
				setVehicleEngineState(source, false)
			else
				setVehicleEngineState(source, true)
			end
		else
			toggleControl(thePlayer, "accelerate", true)
			toggleControl(thePlayer, "brake_reverse", true)
			toggleControl(thePlayer, "vehicle_fire", true)
					
			setVehicleEngineState(source, true)
			setElementData(source, "engine", 1)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), setEngineStatusOnEnter)

function vehicleExit(thePlayer, seat)
	toggleControl(thePlayer, "accelerate", true)
	toggleControl(thePlayer, "brake_reverse", true)
	toggleControl(thePlayer, "vehicle_fire", true)
	
	-- For oldcar
	local vehid = getElementData(source, "dbid")
	setElementData(thePlayer, "lastvehid", vehid)
end
addEventHandler("onVehicleExit", getRootElement(), vehicleExit)

function destroyTyre(veh, tyre)
	if (tyre==1) then
		setVehicleWheelStates(veh, 2, -1, -1, -1)
	elseif (tyre==2) then
		setVehicleWheelStates(veh, -1, 2, -1, -1)
	elseif (tyre==3) then
		setVehicleWheelStates(veh, -1, -1, 2, -1)
	elseif (tyre==4) then
		setVehicleWheelStates(veh, -1, -1, -1, 2)
	end
end

function damageTyres()
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(source)
	
	if (tyre1==1) then
		local randTime = math.random(10, 30)
		randTime = randTime * 1000
		setTimer(destroyTyre, randTime, 1, source, 1)
	end
	
	if (tyre2==1) then
		local randTime2 = math.random(10, 30)
		randTime2 = randTime2 * 1000
		setTimer(destroyTyre, randTime2, 1, source, 2)
	end
	
	if (tyre3==1) then
		local randTime3 = math.random(10, 30)
		randTime3 = randTime3 * 1000
		setTimer(destroyTyre, randTime3, 1, source, 3)
	end
	
	if (tyre4==1) then
		local randTime4 = math.random(10, 30)
		randTime4 = randTime4 * 1000
		setTimer(destroyTyre, randTime4, 1, source, 4)
	end
end
addEventHandler("onVehicleDamage", getRootElement(), damageTyres)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "j", "down", toggleEngine)) then
			bindKey(arrayPlayer, "j", "down", toggleEngine)
		end
		
		if not(isKeyBound(arrayPlayer, "l", "down", toggleLights)) then
			bindKey(arrayPlayer, "l", "down", toggleLights)
		end
		
		if not(isKeyBound(arrayPlayer, "k", "down", toggleLock)) then
			bindKey(arrayPlayer, "k", "down", toggleLock)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleEngine)
	bindKey(source, "l", "down", toggleLights)
	bindKey(source, "k", "down", toggleLock)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleEngine(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")
	
	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (enginelessVehicle[model]) then
			local engine = getElementData(veh, "engine")
			local fuel = getElementData(veh, "fuel")
			local seat = getPedOccupiedVehicleSeat(source)
			
			if (seat==0) then
				if (engine==0) and (fuel>0) then
					-- Bike fix
					toggleControl(source, "accelerate", true)
					toggleControl(source, "brake_reverse", true)
					toggleControl(source, "vehicle_fire", true)
					
					setVehicleEngineState(veh, true)
					setElementData(veh, "engine", 1)
				elseif (engine==0) and (fuel<1) then
					-- Bike fix
					toggleControl(source, "accelerate", false)
					toggleControl(source, "brake_reverse", false)
					toggleControl(source, "vehicle_fire", false)
					
					exports.global:sendLocalMeAction(source, "attempts to turn the engine on and fails.")
					outputChatBox("This vehicle has no fuel.", source)
				else
					-- Bike fix
					toggleControl(source, "accelerate", false)
					toggleControl(source, "brake_reverse", false)
					toggleControl(source, "vehicle_fire", false)
					
					setVehicleEngineState(veh, false)
					setElementData(veh, "engine", 0)
				end
			end
		end
	end
end

function toggleLock(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")
	
	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		--if not (locklessVehicle[model]) then
			local locked = isVehicleLocked(veh)
			local seat = getPedOccupiedVehicleSeat(source)
			if (seat==0) then
				if (locked) then
					setVehicleLocked(veh, false)
					exports.global:sendLocalMeAction(source, "unlocks the vehicle doors.")
				else
					setVehicleLocked(veh, true)
					exports.global:sendLocalMeAction(source, "locks the vehicle doors.")
				end
			end
		--end
	end
end

function checkLock(thePlayer)
	local locked = isVehicleLocked(source)
	
	if (locked) then
		cancelEvent()
		outputChatBox("The door is locked.", thePlayer)
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), checkLock)

function toggleLights(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (lightlessVehicle[model]) then
			local lights = getVehicleOverrideLights(veh)
			local seat = getPedOccupiedVehicleSeat(source)

			if (seat==0) then
				if (lights~=2) then
					setVehicleOverrideLights(veh, 2)
					setElementData(veh, "lights", 1)
				elseif (lights~=1) then
					setVehicleOverrideLights(veh, 1)
					setElementData(veh, "lights", 0)
				end
			end
		end
	end
end

--/////////////////////////////////////////////////////////
--Fix for spamming keys to unlock etc on entering
--/////////////////////////////////////////////////////////

-- bike lock fix
function checkBikeLock(thePlayer)
	if (isVehicleLocked(source)) then
		outputChatBox("That bike is locked.", source, 255, 194, 15)
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkBikeLock)

function setRealInVehicle(thePlayer)
	setElementData(thePlayer, "realinvehicle", 1)
end
addEventHandler("onVehicleEnter", getRootElement(), setRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)
	
	if not (locked) then
		setElementData(thePlayer, "realinvehicle", 0)
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), setRealNotInVehicle)

-- Faction vehicles removal script
function removeFromFactionVehicle(thePlayer)
	local faction = getElementData(thePlayer, "faction")
	local vfaction = tonumber(getElementData(source, "faction"))
	
	if (vfaction~=-1) then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		if (faction~=vfaction) and (seat==0) then
			local factionName = "this faction"
			for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
				local id = tonumber(getElementData(value, "id"))
				if (id==vfaction) then
					factionName = getTeamName(value)
					break
				end
			end
			outputChatBox("You are not a member of '" .. factionName .. "'.", thePlayer, 255, 194, 14)
			removePedFromVehicle(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			setElementPosition(thePlayer, x, y, z)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), removeFromFactionVehicle)