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



--temp = createColPolygon(1116.8955078125, 2267.6962890625, 1156.8583984375, 2342.765625, 1119.6123046875, 2342.8837890625, 1102.9873046875, 2329.2900390625, 1066.1015625, 2243.8466796875, 1065.365234375, 2170.486328125, 1155.388671875, 2169.1767578125, 1156.9677734375, 2222.8740234375, 1139.1669921875, 2222.9130859375, 1138.9072265625, 2282.8603515625, 1156.9619140625, 2283.494140625)--, 10.8203125, 1156.96875, 2342.875, 10.8203125)
--function tempfunc(source, commandName)
--	outputConsole(tostring(isElementWithinColShape(source, temp)))
--end

--addCommandHandler("temp", tempfunc)


local towSphere = createColPolygon(1039.78515625, -914.3857421875, 1024.2607421875, -930.337890625, 1022.0048828125, -909.5869140625, 1027.4990234375, -909.4912109375, 1026.982421875, -896.4853515625, 1018.8779296875, -896.4501953125, 1019.9013671875, -887.54296875, 1034.6142578125, -882.556640625, 1054.9501953125, -866.4970703125, 1079.0576171875, -864.7861328125, 1106.0419921875, -857.8330078125, 1134.47265625, -852.9794921875, 1134.5341796875, -873.716796875, 1073.2001953125, -873.9072265625, 1073.3173828125, -922.0927734375)
local towSphere2 = createColPolygon(1592.8232421875, -1690.8232421875, 1611.7314453125, -1665.80859375, 1611.7275390625, -1721.408203125, 1556.486328125, -1721.513671875, 1546.5703125, -1719.9052734375, 1537.9248046875, -1715.505859375, 1530.921875, -1708.4306640625, 1526.8115234375, -1700.3681640625, 1524.9833984375, -1634.1396484375, 1555.84375, -1634.056640625, 1556.447265625, -1690.478515625, 1581.2490234375, -1690.4306640625, 1581.412109375, -1665.943359375, 1611.724609375, -1665.7958984375)

function cannotVehpos(thePlayer)
	return isElementWithinColShape(thePlayer, towSphere) and getTeamName(getPlayerTeam(thePlayer)) ~= "Best's Towing and Recovery"
end

-- generic function to check if a guy is in the col polygon and the right team
function CanTowTruckDriverVehPos(thePlayer, commandName)
	local ret = 0
	if (isElementWithinColShape(thePlayer, towSphere) or isElementWithinColShape(thePlayer,towSphere2)) then
		if (getTeamName(getPlayerTeam(thePlayer)) == "Best's Towing and Recovery") then
			ret = 2
		else
			ret = 1
		end
	end
	return ret
end
--Auto Pay for PD
function CanTowTruckDriverGetPaid(thePlayer, commandName)
	if (isElementWithinColShape(thePlayer,towSphere2)) then
		if (getTeamName(getPlayerTeam(thePlayer)) == "Best's Towing and Recovery") then
			return true
		end
	end
	return false
end
function UnlockVehicle(element, matchingdimension)
	if (getElementType(element) == "vehicle" and getVehicleOccupant(element) and getTeamName(getPlayerTeam(getVehicleOccupant(element))) == "Best's Towing and Recovery" and getElementModel(element) == 525 and getVehicleTowedByVehicle(element)) then
		--local towing = getVehicleTowedByVehicle(element)
		local temp = element
		while (getVehicleTowedByVehicle(temp)) do
			temp = getVehicleTowedByVehicle(temp)
			local owner = getElementData(temp, "owner")
			local faction = getElementData(temp, "faction")
			local dbid = getElementData(temp, "dbid")
			if (owner > 0) then
				if (faction > 3 or faction < 0) then
					if (source == towSphere2) then
						--PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
						setVehicleLocked(temp, false)
						setElementData(temp, "locked", false)
						setElementData(temp, "Impounded", 0)
						setElementData(temp, "enginebroke", 0, false)
						setVehicleDamageProof(temp, false)
						setVehicleEngineState(temp, false)
						outputChatBox("Please remember to vehpos your vehicle in our car park.", getVehicleOccupant(element), 255, 194, 14)
					else
						--if (getElementData(temp, "faction") ~= 30) then
							--unlock it and impound it
							setVehicleLocked(temp, false)
							setElementData(temp, "locked", false)
							setElementData(temp, "Impounded", getRealTime().yearday)
							setElementData(temp, "enginebroke", 1, false)
							setVehicleEngineState(temp, false)
							outputChatBox("Please remember to vehpos your vehicle in our car park.", getVehicleOccupant(element), 255, 194, 14)
						--end
					end
				else
					outputChatBox("This Faction's vehicle cannot be impounded.", getVehicleOccupant(element), 255, 194, 14)
				end
			end
		end
	end
end

addEventHandler("onColShapeHit", towSphere, UnlockVehicle)
addEventHandler("onColShapeHit", towSphere2, UnlockVehicle)
function payRelease(vehID)
	if exports.global:takeMoney(source, 75) then
		local towCompany = getTeamFromName("Best's Towing and Recovery")
		local dbid = getElementData(towCompany, "id")
		call(getResourceFromName("faction-system"), "addToFactionMoney", dbid, 75)
		setElementData(vehID, "Impounded", 0)
		setElementPosition(vehID, 1104.6435546875, -932.0029296875, 43.187454223633)
		setVehicleLocked(vehID, true)
		setElementData(vehID, "locked", true)
		setElementData(vehID, "enginebroke", 0, false)
		setVehicleDamageProof(vehID, false)
		setVehicleEngineState(vehID, false)
		updateVehPos(vehID)
		outputChatBox("Your vehicle has been released. Please remember to vehpos your vehicle so it does not respawn in our carpark.", source, 255, 194, 14)
	else
		outputChatBox("Insufficient Funds.", source, 255, 0, 0)
		--Should be impossible to get to here, but you never know.
	end
end
addEvent("releaseCar", true)
addEventHandler("releaseCar", getRootElement(), payRelease)

function disableEntryToTowedVehicles(thePlayer, seat, jacked, door) 
	if (getVehicleTowingVehicle(source)) then
		outputChatBox("You cannot enter a vehicle being towed!", thePlayer, 255, 0, 0)
		cancelEvent()
	end
end

addEventHandler("onVehicleStartEnter", getRootElement(), disableEntryToTowedVehicles)


local releaseColShape = createColSphere(223.42578125, 114.265625, 1010.21875, 1)
function triggerShowImpound(element)
	local vehElements = {}
	local count = 1
	for key, value in ipairs(getElementsByType("vehicle")) do
		local dbid = getElementData(value, "dbid")
		if (getElementData(value, "Impounded") and getElementData(value, "Impounded") > 0 and ((dbid > 0 and exports.global:hasItem(element, 3, dbid) or (getElementData(value, "faction") == getElementData(element, "faction") and getElementData(value, "owner") == getElementData(element, "dbid"))))) then
			vehElements[count] = value
			count = count + 1
		end
	end

	triggerClientEvent( element, "ShowImpound", element, vehElements)
end
addEventHandler("onColShapeHit", releaseColShape, triggerShowImpound)

function updateVehPos(veh)
	local x, y, z = getElementPosition(veh)
	local rx, ry, rz = getVehicleRotation(veh)
		
	local interior = getElementInterior(veh)
	local dimension = getElementDimension(veh)
	local dbid = getElementData(veh, "dbid")	
	local query = mysql_query(handler, "UPDATE vehicles SET x='" .. x .. "', y='" .. y .."', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "', interior='" .. interior .. "', currinterior='" .. interior .. "', dimension='" .. dimension .. "', currdimension='" .. dimension .. "' WHERE id='" .. dbid .. "'")
	mysql_free_result(query)	
	setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
	setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
end

function updateTowingVehicle(theTruck)
	local thePlayer = getVehicleOccupant(theTruck)
	if (getTeamName(getPlayerTeam(thePlayer)) == "Best's Towing and Recovery") then
		local owner = getElementData(source, "owner")
		local faction = getElementData(source, "faction")
		local carName = getVehicleName(source)
		
		if (owner<0) then
			outputChatBox("(( This " .. carName .. " is a civilian vehicle. ))", thePlayer, 255, 195, 14)
		elseif (faction==-1) and (owner>0) then
			local query = mysql_query(handler, "SELECT charactername FROM characters WHERE id='" .. owner .. "' LIMIT 1")
		
			if (mysql_num_rows(query)>0) then
				local ownerName = mysql_result(query, 1, 1)
				outputChatBox("(( This " .. carName .. " belongs to " .. ownerName .. ". ))", thePlayer, 255, 195, 14)
			end
			mysql_free_result(query)
		else
			local query = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. faction .. "' LIMIT 1")
		
			if (mysql_num_rows(query)>0) then
				local ownerName = mysql_result(query, 1, 1)
				outputChatBox("(( This " .. carName .. " belongs to the " .. ownerName .. " faction. ))", thePlayer, 255, 195, 14)
			end
			mysql_free_result(query)
		end
	end
end

addEventHandler("onTrailerAttach", getRootElement(), updateTowingVehicle)

function updateCivilianVehicles(theTruck)
	if (isElementWithinColShape(theTruck, towSphere)) then
		local owner = getElementData(source, "owner")
		local faction = getElementData(source, "faction")
		local dbid = getElementData(source, "dbid")

		if (dbid >= 0 and faction == -1 and owner < 0) then
			call(getResourceFromName("faction-system"), "addToFactionMoney", 30, 75)
			outputChatBox("The state has un-impounded the vehicle you where towing.", getVehicleOccupant(theTruck), 255, 194, 14)
			respawnVehicle(source)
		end
	end
end

addEventHandler("onTrailerDetach", getRootElement(), updateCivilianVehicles)