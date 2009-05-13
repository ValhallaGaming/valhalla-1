reports = { }

function playerJoin()
	setElementData(source, "report", nil)
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function resourceStart(res)
	if (res==getThisResource()) then
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			setElementData(value, "report", nil)
		end
	end
end
addEventHandler("onResourceStart", getRootElement(), resourceStart)

function playerQuit()
	local report = getElementData(source, "report")
	
	if (report) then
		local theAdmin = reports[report][5]
		
		if (theAdmin) then
			outputChatBox("Player " .. getPlayerName(source) .. " left the game. Report #" .. report .. " has been closed.", theAdmin, 0, 255, 255)
		end
		
		local alertTimer = reports[report][6]
		local timeoutTimer = reports[report][7]
		
		if (alertTimer) then
			killTimer(alertTimer)
		end
		
		if (timeoutTimer) then
			killTimer(timeoutTimer)
		end
		
		reports[report] = nil -- Destroy any reports made by the player
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
	
function handleReport(reportedPlayer, reportedReason)
	-- Find a free report slot
	local slot = nil
	
	for i = 1, 128 do -- Support 128 reports at any one time, since each player can only have one report
		if (reports[i]==nil) and not (slot) then
			slot = i
		end
	end
	
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	
	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end
	
	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end
	
	local timestring = hours .. ":" .. minutes
	

	local alertTimer = setTimer(alertPendingReport, 120000, 2, slot)
	local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, slot)
	
	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][7] = timeoutTimer -- Timeout timer of the report
	
	setElementData(source, "report", slot)
	
	local admins = exports.global:getAdmins()
	-- Show to admins
	for key, value in ipairs(admins) do
		outputChatBox(" [-ADMIN REPORT-] " .. tostring(getPlayerName(source)) .. " reported " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 0, 255, 255)
		outputChatBox(" [-ADMIN REPORT-] " .. "Reason: " .. tostring(reportedReason), value, 0, 255, 255)
		outputChatBox(" [-ADMIN REPORT-] Type /ar " .. slot .. " to accept this report.", value, 0, 255, 255)
	end
	
	outputChatBox("[" .. timestring .. "] Thank you for submitting your admin report, Your report reference number is #" .. tostring(slot) .. ".", source, 255, 194, 14)
	outputChatBox("[" .. timestring .. "] An admin will respond to your report ASAP. Currently there are " .. #admins .. " admin(s) available.", source, 255, 194, 14)
	outputChatBox("[" .. timestring .. "] You can close this report at any time by typing /endreport.", source, 255, 194, 14)
end

addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)

function alertPendingReport(id)
	if (reports[id]) then
		local admins = exports.global:getAdmins()
		
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		
		-- Show to admins
		for key, value in ipairs(admins) do
			outputChatBox(" [-ADMIN REPORT-] - REPORT #" .. id .. " has still not been answered! -", value, 0, 255, 255)
			outputChatBox(" [-ADMIN REPORT-] " .. tostring(getPlayerName(reportingPlayer)) .. " reported " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 0, 255, 255)
			outputChatBox(" [-ADMIN REPORT-] " .. "Reason: " .. tostring(reportedReason), value, 0, 255, 255)
			outputChatBox(" [-ADMIN REPORT-] Type /ar " .. id .. " to accept this report.", value, 0, 255, 255)
		end
	end
end

function pendingReportTimeout(id)
	if (reports[id]) then
		local admins = exports.global:getAdmins()
		
		local reportingPlayer = reports[id][1]
		
		-- Destroy the report
		local alertTimer = reports[id][6]
		local timeoutTimer = reports[id][7]
		
		killTimer(alertTimer)
		killTimer(timeoutTimer)
		
		reports[id] = nil -- Destroy any reports made by the player
		
		setElementData(reportingPlayer, "report", nil)
		
		local time = getRealTime()
		local hours = time.hour
		local minutes = time.minute
		
		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end
		
		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end
		
		local timestring = hours .. ":" .. minutes
		
		-- Show to admins
		for key, value in ipairs(admins) do
			outputChatBox(" [-ADMIN REPORT-] - REPORT #" .. id .. " has expired! Be quicker next time!! -", value, 0, 255, 255)
		end
		
		outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") has expired.", reportingPlayer, 255, 194, 14)
		outputChatBox("[" .. timestring .. "] If you still require assistance, please resubmit your report or visit our forums (http://forums.concretegaming.net).", reportingPlayer, 255, 194, 14)
	end
end

function falseReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					
					reports[id] = nil
					
					local time = getRealTime()
					local hours = time.hour
					local minutes = time.minute
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local timestring = hours .. ":" .. minutes
					
					setElementData(reportingPlayer, "report", nil)
					outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") was marked as false by " .. getPlayerName(thePlayer) .. ".", reportingPlayer, 255, 194, 14)
					
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						outputChatBox(" [-ADMIN REPORT-] - " .. getPlayerName(thePlayer) .. " has marked report #" .. id .. " as false. -", value, 0, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport)
addCommandHandler("fr", falseReport)

function acceptReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					
					killTimer(alertTimer)
					killTimer(timeoutTimer)
					
					reports[id][5] = thePlayer -- Admin dealing with this report
					
					local time = getRealTime()
					local hours = time.hour
					local minutes = time.minute
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local adminreports = getElementData(thePlayer, "adminreports")
					setElementData(thePlayer, "adminreports", adminreports+1)
					
					local timestring = hours .. ":" .. minutes
					
					outputChatBox("[" .. timestring .. "] Administrator " .. getPlayerName(thePlayer) .. " has accepted your report (#" .. id .. "), Please wait for him/her to contact you.", reportingPlayer, 255, 194, 14)
					outputChatBox("You have accepted report #" .. id .. ". Please proceed to contact the player (" .. getPlayerName(reportingPlayer) .. ").", thePlayer, 255, 194, 14)
					
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						outputChatBox(" [-ADMIN REPORT-] - " .. getPlayerName(thePlayer) .. " has accepted report #" .. id .. " -", value, 0, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport)
addCommandHandler("ar", acceptReport)

function endReport(thePlayer, commandName)
	local report = getElementData(thePlayer, "report")
	
	if not (report) then
		outputChatBox("You have no pending reports. Press F2 to create one.", thePlayer, 255, 0, 0)
	else
		local time = getRealTime()
		local hours = time.hour
		local minutes = time.minute
					
		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end
					
		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end
					
		local timestring = hours .. ":" .. minutes
		local reportHandler = reports[report][5]
		
		reports[report] = nil
		setElementData(thePlayer, "report", nil)
		
		outputChatBox("[" .. timestring .. "] You have closed your report (#" .. report .. ").", thePlayer, 255, 194, 14)
		
		if (reportHandler) then
			outputChatBox(getPlayerName(thePlayer) .. " has closed the report (#" .. report .. "). Thank you for dealing with this report.", reportHandler, 0, 255, 255)
		end
	end
end
addCommandHandler("endreport", endReport)