local blip
local jobstate = 0
local route = 0
local marker
local colshape
local routescompleted = 0

routes = { }
routes[1] = { 2648.64453125, 846.005859375, 6.1870636940002 }
routes[2] = { 2119.5634765625, 950.6748046875, 10.519774436951 }
routes[3] = { 2372.2021484375, 2548.2451171875, 10.526019096375 }
routes[4] = { 2288.5732421875, 2418.6533203125, 10.458553314209 }
routes[5] = { 2090.205078125, 2086.9130859375, 10.526629447937 }
routes[6] = { 1946.015625, 2054.931640625, 10.527263641357 }
routes[7] = { 1630.2587890625, 1797.3447265625, 10.526601791382 }
routes[8] = { 1144.14453125, 1368.0986328125, 10.434799194336 }
routes[9] = { 635.9775390625, 1252.9892578125, 11.357774734497 }
routes[10] = { 261.623046875, 1412.3564453125, 10.20871925354 }

function displayTruckerJob()
	if (jobstate==0) then
		jobstate = 1
		blip = createBlip(2821.806640625, 954.4755859375, 10.75, 0, 4, 255, 127, 255)
		outputChatBox("#FF9933Approach the #FF66CCblip#FF9933 on your radar and enter the van to start your job.", 255, 194, 15, true)
		outputChatBox("#FF9933Type /startjob once you are in the van.", 255, 194, 15, true)
	end
end
addCommandHandler("job", displayTruckerJob)

function startTruckerJob()
	if (jobstate==1) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		
		if not (vehicle) then
			outputChatBox("You must be in a van.", 255, 0, 0)
		else
			local model = getElementModel(vehicle)
			if (model==414) then -- MULE
				routescompleted = 0
			
				outputChatBox("#FF9933Drive to the #FF66CCblip#FF9933 on the radar and use /dumpload.", 255, 194, 15, true)
				destroyElement(blip)
				
				local rand = math.random(1, 10)
				route = routes[rand]
				local x, y, z = routes[rand][1], routes[rand][2], routes[rand][3]
				blip = createBlip(x, y, z, 0, 4, 255, 127, 255)
				marker = createMarker(x, y, z, "cylinder", 4, 255, 127, 255, 150)
				colshape = createColCircle(x, y, z, 4)
				
				jobstate = 2
			else
				outputChatBox("You are not in a van.", 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startjob", startTruckerJob)

function dumpTruckLoad()
	if (jobstate==2 or jobstate==3) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		
		if not (vehicle) then
			outputChatBox("You are not in the van.", 255, 0, 0)
		else
			local model = getElementModel(vehicle)
			if (model==414) then -- MULE
				if (isElementWithinColShape(vehicle, colshape)) then
					destroyElement(colshape)
					destroyElement(marker)
					destroyElement(blip)
					outputChatBox("You completed your trucking run.", 0, 255, 0)
					routescompleted = routescompleted + 1
					outputChatBox("#FF9933You can now either return to the warehouse and obtain your wage using /quitjob", 0, 0, 0, true)
					outputChatBox("#FF9933or continue onto the next #FF66CCdrop off point#FF9933 and increase your wage.", 0, 0, 0, true)
					
					local rand = math.random(1, 10)
					route = routes[rand]
					local x, y, z = routes[rand][1], routes[rand][2], routes[rand][3]
					blip = createBlip(x, y, z, 0, 4, 255, 127, 255)
					marker = createMarker(x, y, z, "cylinder", 4, 255, 127, 255, 150)
					colshape = createColCircle(x, y, z, 4)
					
					jobstate = 3
				else
					outputChatBox("#FF0066You are not at your #FF66CCdrop off point#FF0066.", 255, 0, 0, true)
				end
			else
				outputChatBox("You are not in a van.", 255, 0, 0)
			end
		end
	end
end
addCommandHandler("dumpload", dumpTruckLoad)

function endTruckJob()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not (vehicle) then
		outputChatBox("You are not in the van.", 255, 0, 0)
	else
		local model = getElementModel(vehicle)
		if (model==414) then -- MULE
			if (jobstate==3) then
				local x, y, z = getElementPosition(vehicle)
				
				if (getDistanceBetweenPoints3D(2842.4677734375, 956.3330078125, 10.843829154968, x, y,z)<100) then
					local wage = 50*routescompleted
					outputChatBox("You earnt " .. wage .. "$ on your trucking runs.", 255, 194, 15)
					local vehicle = getPedOccupiedVehicle(localPlayer)
					triggerServerEvent("giveTruckingMoney", localPlayer, wage)
				end
			end
			
			triggerServerEvent("respawnTruck", localPlayer, vehicle)
			outputChatBox("Thank you for your services to RS Haul.", 0, 255, 0)
			destroyElement(colshape)
			destroyElement(marker)
			destroyElement(blip)
			routescompleted = 0
			setElementData(localPlayer, "job", true, 0)
		else
			outputChatBox("You are not in the van.", 255, 0, 0)
		end
	end
end