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
		local logged = getElementData(theChosenOne, "loggedin")
		if not (logged) then
			if (count<10) then
				selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				outputDebugString("Player not logged in")
			else
				local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
				selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
				outputDebugString("no players found")
				count = 0
			end
		else
			local query = mysql_query(handler, "SELECT hunter FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(theChosenOne)) .."'")
			local huntersFriend = tonumber(mysql_result(query, 1, 1))
			mysql_free_result(query)
			
			if (huntersFriend == 0) then  -- are they a friend of hunter?
				if (count<10) then -- check 10 players before resetting the timer.
					selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				else
					local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
					selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
					count = 0
				end
			else
				if (getElementData(theChosenOne,"missionModel")) then -- player is already on car jacking mission.
					if (count<10) then
						selectPlayer() -- if this player is already on a car jacking mission go back and select another player.
					else
						local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
						selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1)
						count = 0
					end
				else				
					count = 0
					if(exports.global:doesPlayerHaveItem(theChosenOne,2))then
						exports.global:sendLocalMeAction(theChosenOne,"receives a text message.")
						triggerClientEvent(theChosenOne, "createHunterMarkers", theChosenOne)
					end	
					local selectionTime = math.random(1200000,3600000) -- random time between 20 and 60 minutes
					selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1) -- start the selectPlayerTimer again for the next person.
				end
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
				for i, player in ipairs( targetPlayers ) do
					outputChatBox("Hunter says: Thanks, man. Here's $" .. profit .. " for the car. I'll call you again soon.", player, 255, 255, 255)
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
