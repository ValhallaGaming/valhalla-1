arrestColShape = createColSphere(1513.50, -1538.44, -8.97, 4)
setElementInterior(arrestColShape, 0)
setElementDimension(arrestColShape, 0)

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
		
		if (factionType==2) then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>60) then
				outputChatBox("SYNTAX: /arrest [Player Partial Nick / ID] [Fine] [Jail Time (Minutes 1->60)] [Crimes Committed]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = call(getResourceFromName("CJRPglobal-functions"), "findPlayerByPartialNick", targetPlayerNick)
				
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
						outputChatBox("The player is not within range of the cell.", thePlayer, 255, 0, 0)
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
								local query = executeSQLUpdate("characters", "pdjail='1', pdjail_time='" .. jailtime .. "'", "charactername='" .. targetPlayerNick .. "'")
								outputChatBox("You jailed " .. targetPlayerNick .. " for " .. jailtime .. " Minutes.", thePlayer, 255, 0, 0)
								setElementPosition(targetPlayer, 1513.5769042969, -1537.7105712891, -7.9730205535889)
								setPedRotation(targetPlayer, 181.2902221679)
								
								setElementData(targetPlayer, "money", money-amount)
								
								-- Trigger the event
								triggerEvent("onPlayerArrest", thePlayer, targetPlayer, fine, jailtime, reason)
								
								-- Show the message to the faction
								local theTeam = getTeamFromName("Los Santos Police Department")
								local teamPlayers = getPlayersInTeam(theTeam)
								
								local query = executeSQLSelect("characters", "faction_id, faction_rank", "charactername='" .. username .. "'", 1)
								
								local factionID = query[1][1]
								local factionRank = query[1][2]
								
								local factionRankTitle = executeSQLSelect("factions", "rank_" .. factionRank, "id='" .. factionID .. "'", 1)[1][1]
								
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
			local query = executeSQLUpdate("characters", "pdjail_time='0', pdjail='0'", "charactername='" .. username .. "'")
			setElementData(jailedPlayer, "jailtimer", nil)
			setElementDimension(jailedPlayer, 0)
			setElementInterior(jailedPlayer, 0)
			setElementPosition(jailedPlayer, 1506.1640625, -1523.1450195313, -5.3714542388916)
			setPedRotation(jailedPlayer, 82.29931640625)
			setElementData(jailedPlayer, "pd.jailserved", 0)
			setElementData(jailedPlayer, "pd.jailtime", 0)
			setElementData(jailedPlayer, "pd.jailtimer", nil)
			fadeCamera(jailedPlayer, true)
			outputChatBox("Your time has been served.", jailedPlayer, 0, 255, 0)
		else
			local query = executeSQLUpdate("characters", "pdjail_time='" .. timeLeft .. "'", "charactername='" .. username .. "'")
		end
	else
		local theTimer = getElementData(jailedPlayer, "jailtimer")
		killTimer(theTimer)
	end
end