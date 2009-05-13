-- objects to make the floor solid...
obj1 = createObject(3867, 195.93978881836, 175.52951049805, 1000.1234375)
exports.pool:allocateElement(obj1)
setElementDimension(obj1, 1)
setElementInterior(obj1, 3)
setObjectRotation(obj1, 270, 0, 180)

obj2 = createObject(3867, 195.93978881836, 157.52951049805, 1000.1234375)
exports.pool:allocateElement(obj2)
setElementDimension(obj2, 1)
setElementInterior(obj2, 3)
setObjectRotation(obj2, 270, 0, 180)

-- cells
cells = {}

-- cell 1
cells[1] = {}
cells[1][1] = 198.70074462891
cells[1][2] = 162.2671661377
cells[1][3] = 1003.0299682617
cells[1][4] = 198.70074462891

-- cell 2
cells[2] = {}
cells[2][1] = 197.43392944336
cells[2][2] = 174.46385192871
cells[2][3] = 1003.0234375
cells[2][4] = 3.4074401855469

-- cell 3
cells[3] = {}
cells[3][1] = 193.31275939941
cells[3][2] = 174.46385192871
cells[3][3] = 1003.0234375
cells[3][4] = 3.4074401855469

-- cell 4
cells[4] = {}
cells[4][1] = 188.91346740723
cells[4][2] = 174.46385192871
cells[4][3] = 1003.0234375
cells[4][4] = 3.4074401855469

arrestColShape = createColSphere(200.70149230957, 168.81527709961, 1003.0234375, 4)
exports.pool:allocateElement(arrestColShape)
setElementInterior(arrestColShape, 3)
setElementDimension(arrestColShape, 1)

-- EVENTS
addEvent("onPlayerArrest", false)

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (jailtime) then
			jailtime = tonumber(jailtime)
		end
		
		if (factionType==2) and (isElementWithinColShape(thePlayer, arrestColShape)) then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>60) then
				outputChatBox("SYNTAX: /arrest [Player Partial Nick / ID] [Fine] [Jail Time (Minutes 1->60)] [Crimes Committed]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick)
				
				if not (targetPlayer) then
					outputChatBox("Player is not online.", thePlayer, 255, 0, 0)
				else
					local elems = getElementsWithinColShape(arrestColShape, "player")
					local found = false
					for key, value in ipairs(elems) do
						if (value==targetPlayer) then
							found = true
						end
					end
					
					if not (found) then
						outputChatBox("The player is not within range of the booking desk.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
						local username  = getPlayerName(thePlayer)
						local targetPlayerNick  = getPlayerName(targetPlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("This player is already serving a jail sentance.", thePlayer, 255, 0, 0)
						else
							local amount = tonumber(fine)
							local money = getElementData(targetPlayer, "money")
							
							if (amount>money) then
								outputChatBox("The player cannot afford such a fine.", thePlayer, 255, 0, 0)
							else
								local theTimer = setTimer(timerPDUnjailPlayer, 60000, jailtime, targetPlayer)
								setElementData(targetPlayer, "pd.jailserved", 0)
								setElementData(targetPlayer, "pd.jailtime", jailtime)
								setElementData(targetPlayer, "pd.jailtimer", theTimer)
								mysql_query(handler, "UPDATE characters SET pdjail='1', pdjail_time='" .. jailtime .. "' WHERE charactername='" .. targetPlayerNick .. "'")
								outputChatBox("You jailed " .. targetPlayerNick .. " for " .. jailtime .. " Minutes.", thePlayer, 255, 0, 0)
								
								local cell = math.random(1, 4)
								
								setElementPosition(targetPlayer, cells[cell][1], cells[cell][2], cells[cell][3])
								setPedRotation(targetPlayer, cells[cell][4])
								
								exports.global:takePlayerSafeMoney(targetPlayer, tonumber(amount))
								
								-- Trigger the event
								triggerEvent("onPlayerArrest", thePlayer, targetPlayer, fine, jailtime, reason)
								
								-- Show the message to the faction
								local theTeam = getTeamFromName("Las Venturas Metropolitan Police Department")
								local teamPlayers = getPlayersInTeam(theTeam)
								
								local result = mysql_query(handler, "SELECT faction_id, faction_rank FROM characters WHERE charactername='" .. username .. "' LIMIT 1")
								
								local factionID = tonumber(mysql_result(result, 1, 1))
								local factionRank = tonumber(mysql_result(result, 1, 2))
								
								mysql_free_result(result)
								
								local titleresult = mysql_query(handler, "SELECT rank_" .. factionRank .. " FROM factions WHERE id='" .. factionID .. "' LIMIT 1")
								local factionRankTitle = tostring(mysql_result(titleresult, 1, 1))
								mysql_free_result(titleresult)
								
								outputChatBox("You were arrested by " .. username .. " for " .. jailtime .. " minute(s).", targetPlayer, 0, 102, 255)
								outputChatBox("Crimes Committed: " .. reason .. ".", targetPlayer, 0, 102, 255)
								
								for key, value in ipairs(teamPlayers) do
									outputChatBox(factionRankTitle .. " " .. username .. " arrested " .. targetPlayerNick .. " for " .. jailtime .. " minute(s).", value, 0, 102, 255)
									outputChatBox("Crimes Committed: " .. reason .. ".", value, 0, 102, 255)
								end
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("arrest", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "pd.jailserved")
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local username = getPlayerName(jailedPlayer)
		setElementData(jailedPlayer, "pd.jailserved", timeServed+1)
		local timeLeft = timeLeft - 1
		setElementData(jailedPlayer, "pd.jailtime", timeLeft)

		if (timeLeft<=0) then
			fadeCamera(jailedPlayer, false)
			mysql_query(handler, "UPDATE characters SET pdjail_time='0', pdjail='0' WHERE charactername='" .. username .. "'")
			setElementData(jailedPlayer, "jailtimer", nil)
			setElementDimension(jailedPlayer, 1)
			setElementInterior(jailedPlayer, 3)
			setCameraInterior(jailedPlayer, 3)
			setElementPosition(jailedPlayer, 233.42037963867, 157.07211303711, 1003.0234375)
			setPedRotation(jailedPlayer, 211.10571289063)
			setElementData(jailedPlayer, "pd.jailserved", 0)
			setElementData(jailedPlayer, "pd.jailtime", 0)
			setElementData(jailedPlayer, "pd.jailtimer", nil)
			fadeCamera(jailedPlayer, true)
			outputChatBox("Your time has been served.", jailedPlayer, 0, 255, 0)
		else
			mysql_query(handler, "UPDATE characters SET pdjail_time='" .. timeLeft .. "' WHERE charactername='" .. username .. "'")
		end
	else
		local theTimer = getElementData(jailedPlayer, "jailtimer")
		killTimer(theTimer)
	end
end