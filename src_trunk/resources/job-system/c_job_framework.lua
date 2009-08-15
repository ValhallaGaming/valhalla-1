job = 0
localPlayer = getLocalPlayer()

function playerSpawn()
	local logged = getElementData(source, "loggedin")

	if (logged==1) then
		job = tonumber(getElementData(source, "job"))
		if (job==1) then -- TRUCKER
			resetTruckerJob()
			setTimer(displayTruckerJob, 1000, 1)
		elseif (job==2) then -- TAXI
			resetTaxiJob()
			setTimer(displayTaxiJob, 1000, 1)
		elseif (job==3) then -- BUS
			resetBusJob()
			setTimer(displayBusJob, 1000, 1)
		end
	end
end
addEventHandler("onClientPlayerSpawn", localPlayer, playerSpawn)

function quitJob()
	local logged = getElementData(localPlayer, "loggedin")
	
	if (logged==1) then
		job = getElementData(localPlayer, "job")
		
		if (job==0) then
			outputChatBox("You are currently unemployed.", 255, 0, 0)
		elseif (job==1) then -- TRUCKER JOB
			resetTruckerJob()
			setElementData(localPlayer, "job", 0, true)
			outputChatBox("You have now quit your job as a delivery driver.", 0, 255, 0)
		elseif (job==2) then -- TAXI JOB
			resetTaxiJob()
			setElementData(localPlayer, "job", 0, true)
			outputChatBox("You have now quit your job as a taxi driver.", 0, 255, 0)
		elseif (job==3) then -- BUS JOB
			resetBusJob()
			setElementData(localPlayer, "job", 0, true)
			outputChatBox("You have now quit your job as a bus driver.", 0, 255, 0)
		elseif (job==4) then -- CITY MAINTENANCE
			outputChatBox("You have now quit your job as a city maintenance worker.", 0, 255, 0)
			setElementData(localPlayer, "tag", 1, true)
			setElementData(localPlayer, "job", 0, true)
			triggerServerEvent("cancelCityMaintenance", localPlayer)
		elseif (job==5) then -- MECHANIC
			setElementData(localPlayer, "job", 0, true)
			outputChatBox("You have now quit your job as a mechanic.", 0, 255, 0)
		elseif (job==6) then -- LOCKSMITH
			setElementData(localPlayer, "job", 0, true)
			outputChatBox("You have now quit your job as a locksmith.", 0, 255, 0)
		end
	end
end
addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)