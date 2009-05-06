function initiateTruckerJob(thePlayer)
	local blip = createBlip(2609.6213378906, 1435.2698974609, 10.8203125, 0, 2, 255, 0, 255, 255, 200)
	local marker = createMarker(2609.6213378906, 1435.2698974609, 10.8203125, "cylinder", 2, 0, 255, 0, 150)
	attachElements(marker, blip)
	exports.pool:allocateBlip(blip)
	exports.pool:allocateMarker(marker)

	setElementVisibleTo(marker, getRootElement(), false)
	setElementVisibleTo(marker, thePlayer, true)
	setElementVisibleTo(blip, getRootElement(), false)
	setElementVisibleTo(blip, thePlayer, true)
	
	setElementData(marker, "owner", getElementData(thePlayer, "gameaccountid"))
	setElementData(marker, "type", "job")
	setElementData(blip, "owner", getElementData(thePlayer, "gameaccountid"))
	setElementData(blip, "type", "job")
	
	outputChatBox("Welcome to the team, you can pick up your truck and trailer from the Depot. ", thePlayer, 255, 194, 14)
	outputChatBox("((A pink blip has been added to your map - Press F11))", thePlayer, 255, 194, 14)
	addEventHandler("onMarkerHit", marker, startTruckingMission, false)
	setElementData(thePlayer, "job.marker", marker)
end

function job(thePlayer)
	initiateTruckerJob(thePlayer)
end
addCommandHandler("job", job)

function startTruckingMission(thePlayer, matchingDimension)
	local jobmarker = getElementData(thePlayer, "jobmarker")
	if (matchingDimension) and not (jobmarker)then
		setElementData(thePlayer, "jobmarker", true)
		local vehicle = createVehicle(514, 2608.9780273438, 1417.2369384766, 10.8203125, 0, 0, 180, "-RSHAUL-")
		local trailer = createVehicle(584, 2608.9780273438, 1417.2369384766, 10.8203125, 0, 0, 180, "-RSHAUL-")
		exports.pool:allocateVehicle(vehicle)
		exports.pool:allocateVehicle(trailer)
		
		if (isPedInVehicle(thePlayer)) then
			removePedFromVehicle(thePlayer)
		end
		
		setElementData(vehicle, "fuel", 100)
		setElementData(vehicle, "owner", -2)
		setElementData(vehicle, "faction", -1)
		setElementData(vehicle, "locked", 0)
		setElementData(vehicle, "dbid", -999999)
		setElementData(vehicle, "oldx", 1503.5179443359)
		setElementData(vehicle, "oldy", 369.0305175781)
		setElementData(vehicle, "oldz", 10.8203125)
		warpPedIntoVehicle(thePlayer, vehicle)
		attachTrailerToVehicle(vehicle, trailer)
		
		outputChatBox("Drive the truck to the fuel refinery in the desert.", thePlayer, 255, 194, 14)
		outputChatBox("Drive carefully! This trailer is highly explosive!", thePlayer, 255, 194, 14)
		
		local marker = getElementData(thePlayer, "job.marker")
		local blip = getElementAttachedTo(marker)
		destroyElement(blip)
		destroyElement(marker)
		
		local marker = createMarker(284.39205932617, 1411.373046875, 10.4046459198, "cylinder", 4, 0, 255, 0, 150)
		local blip = createBlip(284.39205932617, 1411.373046875, 10.4046459198, 0, 2, 255, 0, 255, 255, 200)
		attachElements(marker, blip)
		exports.pool:allocateBlip(blip)
		exports.pool:allocateMarker(marker)
		
		setElementData(marker, "owner", getElementData(thePlayer, "gameaccountid"))
		setElementData(marker, "type", "job")
		setElementData(blip, "owner", getElementData(thePlayer, "gameaccountid"))
		setElementData(blip, "type", "job")
		
		setElementVisibleTo(marker, getRootElement(), false)
		setElementVisibleTo(marker, thePlayer, true)
		setElementVisibleTo(blip, getRootElement(), false)
		setElementVisibleTo(blip, thePlayer, true)
		local colsphere = createColSphere(284.39205932617, 1411.373046875, 10.4046459198, 4)
		exports.pool:allocateColshape(colsphere)
		addEventHandler("onColShapeHit", colsphere, truckingMissionPart2)
		setElementData(thePlayer, "job.marker", marker)
		setElementData(thePlayer, "job.colshape", colsphere)
		setElementData(thePlayer, "jobmarker", nil)
	end
end

function truckingMissionPart2(thePlayer, matchingDimension)
	if (matchingDimension) and (getElementType(thePlayer)=="player") then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		local trailer = getVehicleTowedByVehicle(vehicle)
		
		if not (trailer) or not (vehicle) then
			outputChatBox("Hey, Where's the trailer we gave you? ((Mission Failed))", thePlayer, 255, 194, 14)
			local marker = getElementData(thePlayer, "job.marker")
			local blip = getElementAttachedTo(marker)
			destroyElement(blip)
			destroyElement(marker)
			removePedFromVehicle(thePlayer, vehicle)
			destroyElement(vehicle)
			destroyElement(trailer)
		else
			local marker = getElementData(thePlayer, "job.marker")
			local colsphere = getElementData(thePlayer, "job.colshape")
			local blip = getElementAttachedTo(marker)
			destroyElement(blip)
			destroyElement(marker)
			destroyElement(colsphere)
		
			blip = createBlip(2638.9558105469, 1069.9577636719, 10.8203125, 0, 2, 255, 0, 255, 255, 200)
			marker = createMarker(2638.9558105469, 1069.9577636719, 10.8203125, "cylinder", 4, 0, 255, 0, 150)
			attachElements(marker, blip)
			exports.pool:allocateBlip(blip)
			exports.pool:allocateMarker(marker)
			
			setElementData(marker, "owner", getElementData(thePlayer, "gameaccountid"))
			setElementData(marker, "type", "job")
			setElementData(blip, "owner", getElementData(thePlayer, "gameaccountid"))
			setElementData(blip, "type", "job")

			setElementVisibleTo(marker, getRootElement(), false)
			setElementVisibleTo(marker, thePlayer, true)
			setElementVisibleTo(blip, getRootElement(), false)
			setElementVisibleTo(blip, thePlayer, true)
		
			setElementData(thePlayer, "job.marker", marker)
			local colsphere = createColSphere(2638.9558105469, 1069.9577636719, 10.8203125, 4)
			exports.pool:allocateColshape(colsphere)
			addEventHandler("onColShapeHit", colsphere, truckingMissionPart3)
			setElementData(thePlayer, "job.colshape", colsphere)
			outputChatBox("Your next destination is the fuel station.", thePlayer, 255, 194, 14)
			outputChatBox("((A pink blip has been added to your map - Press F11))", thePlayer, 255, 194, 14)
		end
	end
end

function truckingMissionPart3(thePlayer, matchingDimension)
	if (matchingDimension) and (getElementType(thePlayer)=="player") then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		local trailer = getVehicleTowedByVehicle(vehicle)
		
		if not (trailer) or not (vehicle) then
			outputChatBox("Hey, Where's the trailer we gave you? ((Mission Failed))", thePlayer, 255, 194, 14)
			local marker = getElementData(thePlayer, "job.marker")
			local blip = getElementAttachedTo(marker)
			destroyElement(blip)
			destroyElement(marker)
			removePedFromVehicle(thePlayer, vehicle)
			destroyElement(vehicle)
			destroyElement(trailer)
		else
			outputChatBox("Hey, Good Work! Here's your 60$ ((Mission Completed!))", thePlayer, 255, 194, 14)
			triggerEvent("updateGlobalSupplies", thePlayer, 50)
			exports.global:givePlayerSafeMoney(thePlayer, 60)
			local marker = getElementData(thePlayer, "job.marker")
			local colsphere = getElementData(thePlayer, "job.colshape")
			local blip = getElementAttachedTo(marker)
			destroyElement(blip)
			destroyElement(marker)
			destroyElement(colsphere)
			removePedFromVehicle(thePlayer, vehicle)
			destroyElement(vehicle)
			destroyElement(trailer)
		end
	end
end