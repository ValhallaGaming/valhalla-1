-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

-- CELL PHONES
function callSomeone(thePlayer, commandName, phoneNumber, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 2 = Cell phone item
			if not (phoneNumber) then
				outputChatBox("SYNTAX: /call [Phone Number]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "phoneoff") == 1 then
				outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
			else
				local calling = getElementData(thePlayer, "calling")
				
				if (calling) then -- Using phone already
					outputChatBox("You are already using your phone.", thePlayer, 255, 0, 0)
				else
					
					if phoneNumber == "911" then
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						outputChatBox("911 Operator says: 911 emergency. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 911)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						toggleAllControls(thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "8294" then
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						outputChatBox("Taxi Operator says: LS Cabs here. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 8294)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						toggleAllControls(thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "081016" then
						if not executeCommandHandler( "081016", thePlayer ) then
							outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
						end
					else
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						local found, foundElement, foundPhoneItemValue = false
						
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							local logged = getElementData(value, "loggedin")
							
							if (logged==1) then
								local number = getElementData(value, "cellnumber")
								if (number==tonumber(phoneNumber)) then
									found = true
									foundElement = value
								end
							end
							
							if (found) then
								local find = false
								find,_,foundPhoneItemValue = exports.global:hasItem(foundElement, 2)
								if not find then -- Check the target has a phone, if not, they weren't found
									found, foundElement = false
								end
							end
						end
						
						if not exports.global:isPlayerSilverDonator(thePlayer) and not exports.global:hasMoney(thePlayer, 10) then
							outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
						elseif not found or foundElement == thePlayer then -- Player with this phone number isnt online...
							outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
						elseif getElementData(foundElement, "phoneoff") == 1 then
							outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 194, 14)
						else
							local targetCalling = getElementData(foundElement, "calling")
							
							if (targetCalling) then
								outputChatBox("You get a busy tone.", thePlayer)
							else
								setElementData(thePlayer, "calling", foundElement, false)
								setElementData(thePlayer, "called", true, false)
								setElementData(foundElement, "calling", thePlayer, false)
								
								-- local player
								exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
								toggleAllControls(thePlayer, true, true, true)
								setTimer(startPhoneAnim, 3002, 1, thePlayer)
								setTimer(startPhoneAnim, 3050, 1, thePlayer)
								
								--player around target and target start ringing
								if foundPhoneItemValue ~= 0 then -- not vibrate mode
									local x, y, z = getElementPosition(foundElement)
									local phoneSphere = createColSphere(x, y, z, 10)
									for _,nearbyPlayer in ipairs(getElementsWithinColShape(phoneSphere)) do
										triggerClientEvent(nearbyPlayer, "startRinging", foundElement, 1, foundPhoneItemValue)
									end
									destroyElement(phoneSphere)
								end
								
								-- target player
								exports.global:sendLocalMeAction(foundElement, "'s Phone start's to ring.")
								outputChatBox("Your phone is ringing. (( /pickup to answer ))", foundElement, 255, 194, 14)
								
								exports.global:givePlayerAchievement(thePlayer, 16) -- On the Blower
								
								-- Give the target 30 seconds to answer the call
								setTimer(cancelCall, 30000, 1, thePlayer)
								setTimer(cancelCall, 30000, 1, foundElement)
							end
						end
					end
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to dial on a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("call", callSomeone)
addEvent("remoteCall", true)
addEventHandler("remoteCall", getRootElement(), callSomeone)

function startPhoneAnim(thePlayer)
	exports.global:applyAnimation(thePlayer, "ped", "phone_talk", -1, true, true, true)
	toggleAllControls(thePlayer, true, true, true)
end
	

function cancelCall(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate")
	
	if (phoneState==0) then
		setElementData(thePlayer, "calling", nil, false)
		setElementData(thePlayer, "called", nil, false)
	end
end

function answerPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if (phoneState==0) then
					local target = calling
					outputChatBox("You picked up the phone. (( /p to talk ))", thePlayer)
					outputChatBox("They picked up the phone.", target)
					exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
					setElementData(thePlayer, "phonestate", 1, false) -- Your in an actual call
					setElementData(calling, "phonestate", 1, false) -- Your in an actual call
					exports.global:sendLocalMeAction(thePlayer, "answers their cellphone.")
					
					local x, y, z = getElementPosition(target)
					local phoneSphere = createColSphere(x, y, z, 10)
					for _,nearbyPlayer in ipairs(getElementsWithinColShape(phoneSphere)) do
						triggerClientEvent(nearbyPlayer, "stopRinging", thePlayer)
					end
					destroyElement(phoneSphere)
					
					exports.global:applyAnimation(calling, "ped", "phone_in", 3000, false)
					toggleAllControls(calling, true, true, true)
					setTimer(startPhoneAnim, 3002, 1, thePlayer)
					setTimer(startPhoneAnim, 3050, 1, thePlayer)
				end
			elseif not (calling) then
				outputChatBox("Your phone is not ringing.", thePlayer, 255, 0, 0)
			elseif (phoneState==1) or (phoneState==2) then
				outputChatBox("Your phone is already in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("pickup", answerPhone)

function hangupPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 2 = Cell phone item
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if (type(calling)~="number") then
					local target = calling
					local phoneState = getElementData(thePlayer, "phonestate")
					if phoneState >= 1 then -- lets charge the player
						if (getElementData(thePlayer, "called")) then
							if not exports.global:isPlayerSilverDonator(thePlayer) then
								exports.global:takeMoney(thePlayer, 10, true)
							end
						else
							if not exports.global:isPlayerSilverDonator(calling) then
								exports.global:takeMoney(calling, 10, true)
							end
						end
					end
					removeElementData(calling, "calling")
					outputChatBox("They hung up.", target)
					removeElementData(calling, "caller")
					setElementData(calling, "phonestate", 0, false)
					exports.global:applyAnimation(calling, "ped", "phone_out", 1300, false)
					toggleAllControls(calling, true, true, true)
				end
				
				removeElementData(thePlayer, "calling")
				removeElementData(thePlayer, "caller")
				removeElementData(thePlayer, "callprogress")
				removeElementData(thePlayer, "call.situation")
				removeElementData(thePlayer, "call.location")
				setElementData(thePlayer, "phonestate", 0, false)
				exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
				
				exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1300, false)
				toggleAllControls(thePlayer, true, true, true)
			else
				outputChatBox("Your phone is not in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("hangup", hangupPhone)

function loudSpeaker(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			
			if (phoneState==1) then
				exports.global:sendLocalMeAction(thePlayer, "turns on loudspeaker on the cellphone.")
				outputChatBox("You flick your phone onto loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 2, false)
			elseif (phoneState==2) then
				exports.global:sendLocalMeAction(thePlayer, "turns off loudspeaker on the cellphone.")
				outputChatBox("You flick your phone off of loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 1, false)
			else
				outputChatBox("You are not in a call.", thePlayer, 255, 0 ,0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("loudspeaker", loudSpeaker)

function talkPhone(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 71 = Cell phone item
			if not (...) then
				outputChatBox("SYNTAX: /p [Message]", thePlayer, 255, 194, 14)
			else
				local phoneState = getElementData(thePlayer, "phonestate")
				
				if (phoneState>=1) then -- The player is in a call, not just dialing (2= loudspeaker)
					local message = table.concat({...}, " ")
					local username = getPlayerName(thePlayer)
					local phoneNumber = getElementData(thePlayer, "cellnumber")
					
					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					
					local target = getElementData(thePlayer, "calling")
					
					local callprogress = getElementData(thePlayer, "callprogress")
					if (callprogress) then
						outputChatBox("You [Cellphone]: " ..message, thePlayer)
						-- Send it to nearby players of the speaker
						local x, y, z = getElementPosition(thePlayer)
						local chatSphere = createColSphere(x, y, z, 10)
						exports.pool:allocateElement(chatSphere)
						local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
						
						destroyElement(chatSphere)
						
						for index, nearbyPlayer in ipairs(nearbyPlayers) do
							if nearbyPlayer ~= thePlayer and getElementDimension(nearbyPlayer) == getElementDimension(thePlayer) then
								outputChatBox(username .. " [Cellphone]: " .. message, nearbyPlayer)
							end
						end
					
						if (tonumber(target)==911) then -- EMERGENCY SERVICES
							if (callprogress==1) then -- Requesting the location
								setElementData(thePlayer, "call.location", message)
								setElementData(thePlayer, "callprogress", 2)
								outputChatBox("911 Operator says: Can you describe your emergency please?", thePlayer)
								return
							elseif (callprogress==2) then -- Requesting the situation
								outputChatBox("911 Operator says: Thanks for your call, we've dispatched a unit to your location.", thePlayer)
																
								local location = getElementData(thePlayer, "call.location")
								local theTeam = getTeamFromName("Los Santos Police Department")
								local theTeamES = getTeamFromName("Los Santos Emergency Services")
								local teamMembers = getPlayersInTeam(theTeam)
								local teamMembersES = getPlayersInTeam(theTeamES)
								
								for key, value in ipairs(teamMembers) do
									outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
								end
								
								for key, value in ipairs(teamMembersES) do
									outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer) .. "))", value, 0, 183, 239)
								end
								
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						elseif (tonumber(target)==8294) then -- TAXI
							if (callprogress==1) then
								outputChatBox("Taxi Operator says: Thanks for your call, a taxi will be with you shortly.", thePlayer)
								
								local playerNumber = getElementData(thePlayer, "cellnumber")
				
								for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
									local job = getElementData(value, "job")
									
									if (job==2) then
										outputChatBox("[New Fare] " .. getPlayerName(thePlayer) .." Ph:" .. playerNumber .. " Location: " .. message .."." , value, 0, 183, 239)
									end
								end
							
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						end
					end
					
					message = call( getResourceFromName( "chat-system" ), "trunklateText", thePlayer, call( getResourceFromName( "chat-system" ), "trunklateText", target, message ) )
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, target, message, language)
					
					-- Send the message to the person on the other end of the line
					outputChatBox("[" .. languagename .. "] ((" .. username .. ")) #" .. phoneNumber .. " [Cellphone]: " .. message2, target)
					outputChatBox("[" .. languagename .. "] You [Cellphone]: " ..message, thePlayer)
					
					-- Send it to nearby players of the speaker
					local x, y, z = getElementPosition(thePlayer)
					local chatSphere = createColSphere(x, y, z, 10)
					exports.pool:allocateElement(chatSphere)
					local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
					
					destroyElement(chatSphere)
					
					for index, nearbyPlayer in ipairs(nearbyPlayers) do
						if nearbyPlayer ~= thePlayer and getElementDimension(nearbyPlayer) == getElementDimension(thePlayer) then
							outputChatBox(username .. " [Cellphone]: " .. message, nearbyPlayer)
						end
					end
					
					local phoneState = getElementData(target, "phonestate")
					-- Send it to the listener, if they have loud speaker
					if (phoneState==2) then -- Loudspeaker
						local x, y, z = getElementPosition(target)
						local chatSphere = createColSphere(x, y, z, 40)
						exports.pool:allocateElement(chatSphere)
						local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
						local username = getPlayerName(target)
						
						destroyElement(chatSphere)
						
						for index, nearbyPlayer in ipairs(nearbyPlayers) do
							if nearbyPlayer ~= target and getElementDimension(nearbyPlayer) == getElementDimension(target) then
								local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
								outputChatBox("[" .. languagename .. "] " .. username .. "'s Cellphone Loudspeaker: " .. message2, nearbyPlayer)
							end
						end
					end
				else
					outputChatBox("You are not on a call.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("p", talkPhone)

function phoneBook(thePlayer, commandName, partialNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 7)) then -- 7 = Phonebook item
			if not (partialNick) then
				outputChatBox("SYNTAX: /phonebook [Partial Name]", thePlayer, 255, 194, 14)
			else
				exports.global:sendLocalMeAction(thePlayer, "looks into their phonebook.")
				local result = mysql_query(handler, "SELECT cellnumber, charactername FROM characters WHERE charactername LIKE '%" .. partialNick .. "%'")
				
				if (mysql_num_rows(result)>0) then
					for result, row in mysql_rows(result) do
						local phoneNumber = tonumber(row[1])
						local username = tostring(row[2])
						username = string.gsub(username, "_", " ")
						
						outputChatBox(username .. " - #" .. phoneNumber .. ".", thePlayer)
					end
				else
					outputChatBox("You find no one with that name.", thePlayer, 255, 194, 14)
				end
				mysql_free_result(result)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a phonebook you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("phonebook", phoneBook)

function togglePhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if logged == 1 and ( exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerBronzeDonator(thePlayer) ) then
		if getElementData( thePlayer, "calling" ) then
			outputChatBox("You are using your phone!", thePlayer, 255, 0, 0)
		else
			local phoneoff = getElementData( thePlayer, "phoneoff" )
			
			if phoneoff == 1 then
				outputChatBox("You switched your phone on.", thePlayer, 0, 255, 0)
			else
				outputChatBox("You switched your phone off.", thePlayer, 255, 0, 0)
			end
			setElementData(thePlayer, "phoneoff", 1 - phoneoff, false)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET phoneoff=" .. ( 1 - phoneoff ) .. " WHERE id = " .. getElementData(thePlayer, "dbid") ) )
		end
	end
end
addCommandHandler("togglephone", togglePhone)

function saveCurrentRingtone(itemValue)
	if itemValue then
		exports.global:takeItem(source, 2)
		exports.global:giveItem(source, 2, itemValue)
	end
end
addEvent("saveRingtone", true)
addEventHandler("saveRingtone", getRootElement(), saveCurrentRingtone)