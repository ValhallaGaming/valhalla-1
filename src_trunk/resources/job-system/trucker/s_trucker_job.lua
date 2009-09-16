local lockTimer = nil

function giveTruckingMoney(wage)
	exports.global:giveMoney(source, wage)
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)

function respawnTruck(vehicle)
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setElementData(vehicle, "locked", 0, false)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
end
addEvent("respawnTruck", true)
addEventHandler("respawnTruck", getRootElement(), respawnTruck)

local truck = { [414] = true }
function checkTruckingEnterVehicle(thePlayer, seat)
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and seat == 0 and truck[getElementModel(source)] and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
		triggerClientEvent(thePlayer, "startTruckJob", thePlayer)
	end
end
addEventHandler("onVehicleEnter", getRootElement(), checkTruckingEnterVehicle)

function startEnterTruck(thePlayer, seat, jacked)
	if seat == 0 and truck[getElementModel(source)] and getElementData(thePlayer,"job") == 1 and jacked then -- if someone try to jack the driver stop him
		if isTimer(lockTimer) then
			killTimer(lockTimer)
			lockTimer = nil
		end
		setVehicleLocked(source, true)
		lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterTruck)

function saveDeliveryProgress(runs, wage)
	mysql_free_result(mysql_query(handler, "UPDATE characters SET truckingruns=" .. tonumber(runs) .. ", truckingwage=" .. tonumber(wage) .. "  WHERE id=" .. getElementData(source, "dbid")))
end
addEvent("saveDeliveryProgress", true)
addEventHandler("saveDeliveryProgress", getRootElement(), saveDeliveryProgress)

function restoreTruckingJob()
	if getElementData(source, "job") == 1 then
		triggerClientEvent(source, "restoreTruckerJob", source)
	end
end
addEventHandler("restoreJob", getRootElement(), restoreTruckingJob)

function loadDeliveryProgress(runs, wage)
	local result = mysql_query(handler, "SELECT truckingruns, truckingwage FROM characters WHERE id=" .. getElementData(source, "dbid"))
	local runs = tonumber(mysql_result(result, 1, 1))
	local wage = tonumber(mysql_result(result, 1, 2))
	mysql_free_result(result)
	triggerClientEvent(source, "loadTruckerJob", source, runs, wage)
end
addEvent("loadDeliveryProgress", true)
addEventHandler("loadDeliveryProgress", getRootElement(), loadDeliveryProgress)
