local count = 0

function createTimer(res)
	local selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), createTimer)

function selectPlayer()
	-- get a random player
	local theChosenOne = getRandomPlayer()
	count = count+1

	if (isElement(theChosenOne)) then	
		local logged = getElementData(theChosenOne, "loggedin")
		if not (logged) then
			if (count<10) then
				selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				outputDebugString("Player not logged in")
			else
				selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
				outputDebugString("no players found")
				count = 0
			end
		elseif getElementData( theChosenOne, "phoneoff" ) == 1 then
			outputDebugString("Player " .. getPlayerName(theChosenOne) .. " has his phone off")
		else
			local query = mysql_query(handler, "SELECT hunter FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(theChosenOne)) .."'")
			local huntersFriend = tonumber(mysql_result(query, 1, 1))
			mysql_free_result(query)
			
			if (huntersFriend == 0) then  -- are they a friend of hunter?
				if (count<10) then -- check 10 players before resetting the timer.
					selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				else
					selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
					count = 0
				end
			else
				if (getElementData(theChosenOne,"missionModel")) then -- player is already on car jacking mission.
					if (count<10) then
						selectPlayer() -- if this player is already on a car jacking mission go back and select another player.
					else
						selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
						count = 0
					end
				else				
					count = 0
					if(exports.global:hasItem(theChosenOne,2))then
						exports.global:sendLocalMeAction(theChosenOne,"receives a text message.")
						triggerClientEvent(theChosenOne, "createHunterMarkers", theChosenOne)
					end	
					local selectionTime = math.random(1200000,2400000) -- random time between 20 and 40 minutes
					selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1) -- start the selectPlayerTimer again for the next person.
				end
			end
		end
	end
end
-- addCommandHandler("starthunter", selectPlayer)

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
				local profit = math.floor(health*1.5)
				exports.global:giveMoney(thePlayer, profit)
				local pedX, pedY, pedZ = getElementPosition( thePlayer )
				local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
				exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players.
				local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
				local name = string.gsub(getPlayerName(thePlayer), "_", " ")
				for i, player in ipairs( targetPlayers ) do
					outputChatBox("Hunter says: Thanks, man. Here's $" .. profit .. " for the car. I'll call you again soon.", player, 255, 255, 255)
				end
				destroyElement(chatSphere)
				
				-- cleanup
				setElementData(thePlayer, "realinvehicle", 0, false)
				removePedFromVehicle(thePlayer, vehicle)
				
				
				local dbid = tonumber(getElementData(vehicle, "dbid"))
				
				if (dbid>0) then
					respawnVehicle (vehicle)
					setElementData(vehicle, "locked", 0, false)
					setVehicleLocked(vehicle, false)
				else
					destroyElement(vehicle)
				end
				removeElementData(thePlayer, "missionModel")
				triggerClientEvent(thePlayer, "jackerCleanup", thePlayer)
			end
		end
	end
end
addEvent("dropOffCar", true)
addEventHandler("dropOffCar", getRootElement(), dropOffCar)
