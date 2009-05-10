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
function callSomeone(thePlayer, commandName, phoneNumber)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- 2 = Cell phone item
			if not (phoneNumber) then
				outputChatBox("SYNTAX: /call [Phone Number]", thePlayer, 255, 194, 14)
			else
				local calling = getElementData(thePlayer, "calling")
			
				if (calling) then -- Using phone already
					outputChatBox("You are already using your phone.", thePlayer, 255, 0, 0)
				else
					exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
					local found, foundElement = false
					
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
							if not (exports.global:doesPlayerHaveItem(foundElement, 2)) then -- Check the target has a phone, if not, they weren't found
								found, foundElement = false
							end
						end
					end
					
					local money = getElementData(thePlayer, "money")
					
					if (money<10) then
						outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
					elseif not (found) or (foundElement==thePlayer) then -- Player with this phone number isnt online...
						outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
					else
						local targetCalling = getElementData(foundElement, "calling")
						
						if (targetCalling) then
							outputChatBox("You get a busy tone.", thePlayer)
						else
							setElementData(thePlayer, "calling", foundElement)
							setElementData(thePlayer, "called", true)
							setElementData(foundElement, "calling", thePlayer)
							
							-- local player
							setPedAnimation(thePlayer, "ped", "phone_in", 100, false, true, false)
							setTimer(setPedAnimation, 2000, 1, thePlayer, "ped", "phone_talk", 100, false, true, false)
							
							-- target player
							exports.global:sendLocalMeAction(foundElement, "'s Phone start's to ring.")
							outputChatBox("Your phone is ringing. (( /pickup to answer ))", foundElement, 255, 194, 14)
							
							exports.global:givePlayerAchievement(thePlayer, 16) -- On the Blower
							
							-- Give the target 10 seconds to answer the call
							setTimer(cancelCall, 10000, 1, thePlayer)
							setTimer(cancelCall, 10000, 1, foundElement)
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

function cancelCall(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate")
	
	if (phoneState==0) then
		setElementData(thePlayer, "calling", nil)
		setElementData(thePlayer, "called", nil)
	end
end

function answerPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if (phoneState==0) then
					local target = calling
					outputChatBox("You picked up the phone.", thePlayer)
					outputChatBox("They picked up the phone.", target)
					exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
					setElementData(thePlayer, "phonestate", 1) -- Your in an actual call
					setElementData(calling, "phonestate", 1) -- Your in an actual call
					exports.global:sendLocalMeAction(thePlayer, "answers their cellphone.")
					setPedAnimation(thePlayer, "ped", "phone_in", 100, false, true, false)
					setTimer(setPedAnimation, 2000, 1, thePlayer, "ped", "phone_talk", 100, false, true, false)
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
		if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- 71 = Cell phone item
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				local target = calling
				local phoneState = getElementData(thePlayer, "phonestate")
				if (phoneState>=1) then -- lets charge the player
					if (getElementData(thePlayer, "called")) then
						exports.global:takePlayerSafeMoney(thePlayer, 10)
					else
						exports.global:takePlayerSafeMoney(calling, 10)
					end
				end
			
				outputChatBox("They hung up.", target)
				setElementData(thePlayer, "calling", nil)
				setElementData(calling, "calling", nil)
				setElementData(thePlayer, "caller", nil)
				setElementData(calling, "caller", nil)
				setElementData(thePlayer, "phonestate", 0)
				setElementData(calling, "phonestate", 0)
				exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
				
				setPedAnimation(thePlayer, "ped", "phone_out", 1300, false, true, false)
				setTimer(setPedAnimation, 1305, 1, thePlayer)
				
				setPedAnimation(calling, "ped", "phone_out", 1300, false, true, false)
				setTimer(setPedAnimation, 1305, 1, calling)
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
		if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			
			if (phoneState==1) then
				exports.global:sendLocalMeAction(thePlayer, "turns on loudspeaker on the cellphone.")
				outputChatBox("You flick your phone onto loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 2)
			elseif (phoneState==1) then
				exports.global:sendLocalMeAction(thePlayer, "turns off loudspeaker on the cellphone.")
				outputChatBox("You flick your phone off of loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 1)
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
		if (exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- 71 = Cell phone item
			if not (...) then
				outputChatBox("SYNTAX: /p [Message]", thePlayer, 255, 194, 14)
			else
				local phoneState = getElementData(thePlayer, "phonestate")
				
				if (phoneState>=1) then -- The player is in a call, not just dialing (2= loudspeaker)
					local message = table.concat({...}, " ")
					local username = getPlayerName(thePlayer)
					local phoneNumber = getElementData(thePlayer, "cellnumber")
					
					local target = getElementData(thePlayer, "calling")
					-- Send the message to the person on the other end of the line
					outputChatBox("((" .. username .. ")) #" .. phoneNumber .. " [Cellphone]: " .. message, target)
					outputChatBox("You [Cellphone]: " ..message, thePlayer)
					
					-- Send it to nearby players of the speaker
					local x, y, z = getElementPosition(thePlayer)
					local chatSphere = createColSphere(x, y, z, 10)
					exports.pool:allocateElement(chatSphere)
					local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
					
					destroyElement(chatSphere)
					
					for index, nearbyPlayer in ipairs(nearbyPlayers) do
						if (nearbyPlayer~=thePlayer) then
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
							if (nearbyPlayer~=target) then
								outputChatBox(username .. "'s Cellphone Loudspeaker: " .. message, nearbyPlayer)
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
		if (exports.global:doesPlayerHaveItem(thePlayer, 7)) then -- 7 = Phonebook item
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