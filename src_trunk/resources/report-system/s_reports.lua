reports = { }

function resourceStart(res)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		removeElementData(value, "report")
		removeElementData(value, "reportadmin")
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function updateReportCount()
	local open = 0
	local handled = 0
	
	local unanswered = {}
	local byadmin = {}
	
	for key, value in pairs(reports) do
		open = open + 1
		if value[5] then
			handled = handled + 1
			if not byadmin[value[5]] then
				byadmin[value[5]] = { key }
			else
				table.insert(byadmin[value[5]], key)
			end
		else
			table.insert(unanswered, key) 
		end
	end
	
	for key, value in ipairs(exports.global:getAdmins()) do
		triggerClientEvent( value, "updateReportsCount", value, open, handled, unanswered, byadmin[value] )
	end
end

function showReports(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("~~~~~~~~~ Reports ~~~~~~~~~", thePlayer, 255, 194, 15)
		
		local count = 0
		for i = 1, 128 do
			local report = reports[i]
			if report then
				local reporter = report[1]
				local reported = report[2]
				local timestring = report[4]
				local admin = report[5]
				
				local handler = ""
				if (isElement(admin)) then
					handler = tostring(getPlayerName(admin))
				else
					handler = "None."
				end
				
				outputChatBox("Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. ".", thePlayer, 255, 195, 15)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("None.", thePlayer, 255, 194, 15)
		else
			outputChatBox("Type /ri [id] to obtain more information about the report.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("reports", showReports, false, false)

function reportInfo(thePlayer, commandName, id)	
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				
				local playerID = getElementData(reporter, "playerid")
				local reportedID = getElementData(reported, "playerid")
				
				
				outputChatBox(" [#" .. id .."] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " at " .. timestring .. ".", thePlayer, 0, 255, 255)
				
				local reason1 = reason:sub( 0, 70 )
				local reason2 = reason:sub( 71 )
				outputChatBox(" [#" .. id .."] Reason: " .. reason1, thePlayer, 0, 255, 255)
				if reason2 and #reason2 > 0 then
					outputChatBox(" [#" .. id .."] " .. reason2, thePlayer, 0, 255, 255)
				end
				
				local handler = ""
				if (isElement(admin)) then
					outputChatBox(" [#" .. id .."] This report is being handled by " .. getPlayerName(admin) .. ".", thePlayer, 0, 255, 255)
				else
					outputChatBox(" [#" .. id .."] Type /ar " .. id .. " to accept this report.", thePlayer, 0, 255, 255)
				end
			else
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function playerQuit()
	local report = getElementData(source, "report")
	local update = false
	
	if report and reports[report] then
		local theAdmin = reports[report][5]
		
		if (isElement(theAdmin)) then
			outputChatBox(" [#" .. report .."] Player " .. getPlayerName(source) .. " left the game.", theAdmin, 0, 255, 255)
		else
			for key, value in ipairs(exports.global:getAdmins()) do
				local adminduty = getElementData(value, "adminduty")
				if adminduty == 1 then
					outputChatBox(" [#" .. i .."] Player " .. getPlayerName(source) .. " left the game.", value, 0, 255, 255)
					update = true
				end
			end
		end
		
		local alertTimer = reports[report][6]
		local timeoutTimer = reports[report][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end
		
		reports[report] = nil -- Destroy any reports made by the player
		update = true
	end
	
	-- check for reports assigned to him, unassigned if neccessary	
	for i = 1, 128 do -- Support 128 reports at any one time, since each player can only have one report
		if reports[i] then
			if reports[i][5] == source then
				reports[i][5] = nil
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "adminduty")
					if adminduty == 1 then
						outputChatBox(" [#" .. i .."] Report is unassigned (" .. getPlayerName(source) .. " left the game)", value, 0, 255, 255)
						update = true
					end
				end
			end
			if reports[i][2] == source then
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "adminduty")
					if adminduty == 1 then
						outputChatBox(" [#" .. i .."] Reported Player " .. getPlayerName(source) .. " left the game.", value, 0, 255, 255)
						update = true
					end
				end
				
				local reporter = reports[i][1]
				if reporter ~= source then
					outputChatBox("Your report #" .. i .. " has been closed (" .. getPlayerName(source) .. " left the game)", reporter, 255, 194, 14)
				end
				
				local alertTimer = reports[i][6]
				local timeoutTimer = reports[i][7]

				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end

				if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end

				reports[i] = nil -- Destroy any reports made by the player
			end
		end
	end
	
	if update then
		updateReportCount()
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
	
function handleReport(reportedPlayer, reportedReason)
	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("The Player you're reporting is not logged in.", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil
	
	for i = 1, 128 do -- Support 128 reports at any one time, since each player can only have one report
		if not reports[i] then
			slot = i
			break
		end
	end
	
	local hours, minutes = getTime()
	
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
	
	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	
	setElementData(source, "report", slot)
	removeElementData(source, "reportadmin")
	
	local admins = exports.global:getAdmins()
	local count = 0
	-- Show to admins
	for key, value in ipairs(admins) do
		local adminduty = getElementData(value, "adminduty")
		if (adminduty==1) then
			outputChatBox(" [#" .. slot .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 0, 255, 255)
			local reason1 = reportedReason:sub( 0, 70 )
			local reason2 = reportedReason:sub( 71 )
			outputChatBox(" [#" .. slot .. "] Reason: " .. reason1, value, 0, 255, 255)
			if reason2 and #reason2 > 0 then
				outputChatBox(" [#" .. slot .. "] " .. reason2, value, 0, 255, 255)
			end
		end
		if getElementData(value, "hiddenadmin") ~= 1 then
			count = count + 1
		end
	end
	
	outputChatBox("[" .. timestring .. "] Thank you for submitting your admin report, Your report reference number is #" .. tostring(slot) .. ".", source, 255, 194, 14)
	outputChatBox("[" .. timestring .. "] An admin will respond to your report ASAP. Currently there are " .. count .. " admin(s) available.", source, 255, 194, 14)
	outputChatBox("[" .. timestring .. "] You can close this report at any time by typing /endreport.", source, 255, 194, 14)
	
	updateReportCount()
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
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")
		
		-- Show to admins
		for key, value in ipairs(admins) do
			local adminduty = getElementData(value, "adminduty")
			if (adminduty==1) then
				outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 0, 255, 255)
				outputChatBox(" [#" .. id .. "] " .. "Reason: " .. tostring(reportedReason), value, 0, 255, 255)
			end
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
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end
		
		reports[id] = nil -- Destroy any reports made by the player
		
		removeElementData(reportingPlayer, "report")
		removeElementData(reportingPlayer, "reportadmin")
		
		local hours, minutes = getTime()
		
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
			local adminduty = getElementData(value, "adminduty")
			if (adminduty==1) then
				outputChatBox(" [#" .. id .. "] - REPORT #" .. id .. " has expired! Be quicker next time!! -", value, 0, 255, 255)
			end
		end
		
		outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") has expired.", reportingPlayer, 255, 194, 14)
		outputChatBox("[" .. timestring .. "] If you still require assistance, please resubmit your report or visit our forums (http://forums.valhallagaming.net).", reportingPlayer, 255, 194, 14)

		updateReportCount()
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
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[id] = nil
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local timestring = hours .. ":" .. minutes
					
					removeElementData(reportingPlayer, "report")
					removeElementData(reportingPlayer, "reportadmin")
					outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") was marked as false by " .. getPlayerName(thePlayer) .. ".", reportingPlayer, 255, 194, 14)
					
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " has marked report #" .. id .. " as false. -", value, 0, 255, 255)
						end
					end
					
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

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
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end
					
					reports[id][5] = thePlayer -- Admin dealing with this report
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local adminreports = getElementData(thePlayer, "adminreports")
					setElementData(thePlayer, "adminreports", adminreports+1, false)
					setElementData(reportingPlayer, "reportadmin", thePlayer, false)
					
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					
					outputChatBox("[" .. timestring .. "] Administrator " .. getPlayerName(thePlayer) .. " has accepted your report (#" .. id .. "), Please wait for him/her to contact you.", reportingPlayer, 255, 194, 14)
					outputChatBox("You have accepted report #" .. id .. ". Please proceed to contact the player ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", thePlayer, 255, 194, 14)
					
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " has accepted report #" .. id .. " -", value, 0, 255, 255)
						end
					end
					
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function closeReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local alertTimer = reports[id][6]
				local timeoutTimer = reports[id][7]
				
				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end
				
				if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end
				
				reports[id] = nil

				if (isElement(reporter)) then
					removeElementData(reporter, "report")
					removeElementData(reporter, "reportadmin")
					outputChatBox(getPlayerName(thePlayer) .. " has closed your report. Please re-submit your report if you weren't happy that it was resolved.", reporter, 0, 255, 255)
				end
				
				local admins = exports.global:getAdmins()
				for key, value in ipairs(admins) do
					local adminduty = getElementData(value, "adminduty")
					if (adminduty==1) then
						outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " has closed the report #" .. id .. ". -", value, 0, 255, 255)
					end
				end
				
				updateReportCount()
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function endReport(thePlayer, commandName)
	local report = getElementData(thePlayer, "report")
	
	if not (report) then
		outputChatBox("You have no pending reports. Press F2 to create one.", thePlayer, 255, 0, 0)
	else
		local hours, minutes = getTime()
					
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
		local alertTimer = reports[report][6]
		local timeoutTimer = reports[report][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end

		reports[report] = nil
		removeElementData(thePlayer, "report")
		removeElementData(thePlayer, "reportadmin")
		
		outputChatBox("[" .. timestring .. "] You have closed your report (#" .. report .. ").", thePlayer, 255, 194, 14)
		
		if (isElement(reportHandler)) then
			outputChatBox(getPlayerName(thePlayer) .. " has closed the report (#" .. report .. "). Thank you for dealing with this report.", reportHandler, 0, 255, 255)
		end
		
		updateReportCount()
	end
end
addCommandHandler("endreport", endReport, false, false)