vehicles = {}
vehicles [1] = {602}
vehicles [2] = {496}	
vehicles [3] = {517}
vehicles [4] = {401}	
vehicles [5] = {410}
vehicles [6] = {518}	
vehicles [7] = {600}
vehicles [8] = {527}	
vehicles [9] = {436}
vehicles [10] = {589}	
vehicles [11] = {419}	
vehicles [12] = {549}
vehicles [13] = {526}	
vehicles [14] = {445}	 
vehicles [15] = {507}	
vehicles [16] = {585}
vehicles [17] = {587}	
vehicles [18] = {409}
vehicles [19] = {466}	
vehicles [20] = {550}
vehicles [21] = {492}	
vehicles [22] = {566}
vehicles [23] = {540}
vehicles [24] = {551}	
vehicles [25] = {421}
vehicles [26] = {529}
vehicles [27] = {536}
vehicles [28] = {534}
vehicles [29] = {567}
vehicles [30] = {535}
vehicles [31] = {576}
vehicles [32] = {412}
vehicles [33] = {402}
vehicles [34] = {475}
vehicles [35] = {429}	
vehicles [36] = {411}
vehicles [37] = {541}	
vehicles [38] = {559}
vehicles [39] = {560}
vehicles [40] = {562}	
vehicles [41] = {506}
vehicles [42] = {565}	
vehicles [43] = {451}
vehicles [44] = {558}
vehicles [45] = {477}
vehicles [46] = {579}
vehicles [47] = {400}

parts = {}
parts [1] = {"a transmission"}
parts [2] = {"a cooling system"}
parts [3] = {"front and rear dampers"}
parts [4] = {"a sports clutch"}
parts [5] = {"an induction kit"}

local count = 0

function createTimer(res)
	if (res==getThisResource()) then
		local selectionTime = math.random(300000, 1200000) -- random time between 5 and 20 minutes
		local selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
	end
end
addEventHandler("onResourceStart", getRootElement(), createTimer)

function selectPlayer()
	-- get a random player
	local theChosenOne = getRandomPlayer()
	count = count+1

	if (isElement(theChosenOne)) then
		local huntersFriend = tonumber(mysql_query(handler, "SELECT hunter FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(theChosenOne)) .."'"))
		if (huntersFriend == 0) then  -- are they a friend of hunter?
			if (count<10) then -- check 10 players before resetting the timer.
				selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
			else
				local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
				selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
			end
		else
			if (getElementData(theChosenOne,"missionModel")) then -- player is already on car jacking mission.
				if (count<10) then
					selectPlayer() -- if this player is already on a car jacking mission go back and select another player.
				else
					local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
					selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
				end
			else				
				checkcount = 0
				-- selecting a random car model (and car part just for fun).
				local modelID = math.random(1, 47) -- random vehicle ID from the list above.
				local vehicleID = vehicles[modelID][1]
				local vehicleName = getVehicleNameFromModel (vehicleID)
				setElementData(theChosenOne, "missionModel", vehicleID) -- set the players element data to the car requested car model.
				local rand = math.random(1, 5) -- random car part from the list above.
				local carPart = parts[rand][1]
				outputChatBox("SMS From: Hunter - Hey, man. I need ".. carPart .." from a ".. vehicleName ..". Can you help me out?", theChosenOne)
				outputChatBox("#FF9933((Steal a ".. vehicleName .." and deliver the car to Hunter's #FF66CCgarage#FF9933.))", theChosenOne, 255, 104, 91, true )
				
				triggerClientEvent(theChosenOne, "createHunterMarkers", theChosenOne)
				
				-- start the selectPlayerTimer again for the next person.
				local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
				selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
			end
		end
	end
end
addCommandHandler("starthunter", selectPlayer)

function dropOffCar()
	local thePlayer = source
	if(getElementData(thePlayer, "missionModel")) then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		if not(vehicle) then
			outputChatBox("You were supposed to deliver a car.", thePlayer, 255, 0, 0)
		else
			local requestedModel = getElementData(thePlayer,"missionModel")
			local requestedName = getVehicleNameFromModel(requestedModel)
			local deliveredName = getVehicleName(vehicle)
			local deliveredModel = getVehicleModelFromName(deliveredName)
			if (requestedModel~=deliveredModel) then
				outputChatBox("Hunter says: I wanted you to bring a ".. requestedName .. ", what am I supposed to do with a " .. deliveredName .. "?", thePlayer, 255, 255, 255)
			else
				local health = getElementHealth(vehicle)
				local profit = math.floor(health*2.5)
				exports.global:givePlayerSafeMoney(thePlayer, profit)
				local pedX, pedY, pedZ = getElementPosition( thePlayer )
				local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
				exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players.
				local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
				local name = string.gsub(getPlayerName(thePlayer), "_", " ")
				for i, key in ipairs( targetPlayers ) do
					outputChatBox("Hunter says: Thanks, man. Here's $" .. profit .. " for the car. I'll call you again soon.", thePlayer, 255, 255, 255)
				end
				destroyElement(chatSphere)
				
				-- cleanup
				removePedFromVehicle(thePlayer, vehicle)
				
				
				local dbid = tonumber(getElementData(vehicle, "dbid"))
				
				if (dbid>0) then
					respawnVehicle (vehicle)
					setElementData(vehicle, "locked", 0)
					setVehicleLocked(vehicle, false)
				else
					destroyElement(vehicle)
				end
				setElementData(thePlayer, "missionModel", nil)
				triggerClientEvent(thePlayer, "jackerCleanup", thePlayer)
			end
		end
	end
end
addEvent("dropOffCar", true)
addEventHandler("dropOffCar", getRootElement(), dropOffCar)
