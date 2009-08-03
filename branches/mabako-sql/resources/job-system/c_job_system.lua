wEmployment, jobList, bAcceptJob, bCancel = nil

local ped = createPed(141, 359.7131652832, 173.87419128418, 1008.3893432617)
setPedRotation(ped, 260.3631)
setElementDimension(ped, 125)
setElementInterior(ped, 3)

function showEmploymentWindow()
	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wEmployment = guiCreateWindow(x, y, width, height, "Job Pinboard", false)
	
	jobList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wEmployment)
    local column = guiGridListAddColumn(jobList, "Job Title", 0.9)

	-- TRUCKER
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Delivery Driver", false, false)
	
	-- TAXI
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Taxi Driver", false, false)
	
	-- BUS
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Bus Driver", false, false)
	
	-- CITY MAINTENACE
	local team = getPlayerTeam(getLocalPlayer())
	local ftype = getElementData(team, "type")
	if ftype ~= 2 then
		local rowmaintenance = guiGridListAddRow(jobList)
		guiGridListSetItemText(jobList, rowmaintenance, column, "City Maintenance", false, false)
	end
	
	-- MECHANIC
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Mechanic", false, false)
	
	-- LOCKSMITH
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Locksmith", false, false)
	
	bAcceptJob = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Accept Job", true, wEmployment)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, wEmployment)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptJob, acceptJob)
	addEventHandler("onClientGUIDoubleClick", jobList, acceptJob)
	addEventHandler("onClientGUIClick", bCancel, cancelJob)
end
addEvent("onEmployment", true)
addEventHandler("onEmployment", getRootElement(), showEmploymentWindow)

function acceptJob(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		local job = getElementData(getLocalPlayer(), "job")
		
		if (row==-1) or (col==-1) then
			outputChatBox("Please select a job first!", 255, 0, 0)
		elseif (job>0) then
			outputChatBox("You are already employed, please quit your other job first (( /quitjob )).", 255, 0, 0)
		else
			local job = 0
			local jobtext = guiGridListGetItemText(jobList, guiGridListGetSelectedItem(jobList), 1)
			
			if (jobtext=="Delivery Driver") then
				displayTruckerJob()
				job = 1
			elseif (jobtext=="Taxi Driver") then
				job = 2
				displayTaxiJob()
			elseif  (jobtext=="Bus Driver") then
				job = 3
				displayBusJob()
			elseif (jobtext=="City Maintenance") then
				job = 4
			elseif (jobtext=="Mechanic") then
				displayMechanicJob()
				job = 5
			elseif (jobtext=="Locksmith") then
				displayLocksmithJob()
				job = 6
			end
			
			triggerServerEvent("acceptJob", getLocalPlayer(), job)
			
			destroyElement(jobList)
			destroyElement(bAcceptJob)
			destroyElement(bCancel)
			destroyElement(wEmployment)
			wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
			showCursor(false)
		end
	end
end

function cancelJob(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(jobList)
		destroyElement(bAcceptJob)
		destroyElement(bCancel)
		destroyElement(wEmployment)
		wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end