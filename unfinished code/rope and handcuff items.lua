---------
-- SQL --
---------
INSERT INTO items SET id='23', item_name='Rope', item_description='A length of strong rope.';
INSERT INTO items SET id='24', item_name='Handcuffs', item_description='A pair of handcuffs.';
INSERT INTO items SET id='25', item_name='Handcuff Key', item_description='A key to a pair of handcuffs.';

-- needs a second "restrain" column in the characters sql called "tie" to record whether the player is currently tied by a rope. This way you can cuff and tie separately.
---------------------- ROPE ----------------------------------

-----------------
-- Server side --
-----------------

----------------------[Tie]--------------------
function tiePlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else			
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			
			if not( exports.global:doesPlayerHaveItem(thePlayer, 23) ) then
				outputChatBox("You need a rope to tie them with.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==1) then
						outputChatBox("Player is already restrained.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(targetPlayer)
						
						local colSphere = createColSphere(x, y, z, smallRadius)
						
						if (isElementWithinColShape(thePlayer, colSphere)) then
							outputChatBox("You have been tied by ".. username ..".", targetPlayer)
							outputChatBox("You have tied ".. targetPlayerName ..".", thePlayer)
							toggleControl(targetPlayer, "sprint", false)
							toggleControl(targetPlayer, "jump", false)
							toggleControl(targetPlayer, "next_weapon", false)
							toggleControl(targetPlayer, "previous_weapon", false)
							toggleControl(targetPlayer, "accelerate", false)
							toggleControl(targetPlayer, "brake_reverse", false)
							toggleControl(targetPlayer, "fire", false)
							toggleControl(targetPlayer, "aim_weapon", false)

							setPedWeaponSlot(targetPlayer, 0)
							setElementData(targetPlayer, "restrain", 1)
							
							exports.global:takePlayerItem(thePlayer, 23, 1) -- take the rope
						else
							outputChatBox("You are not close enough to ".. targetPlayerName .." to tie them.", thePlayer, 255, 0, 0)						
						end
						destroyElement(colSphere)
					end
				end
			end
		end
	end
end
addCommandHandler("tie", tiePlayer, false, false)

----------------------[Untie]--------------------
function untiePlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else
			local thePlayerRestrain = getElementData(thePlayer, "restrain") -- is the player trying to remove cuffs handcuffed?
			local thePlayerTied = getElementData(thePlayer, "tie") -- is the player trying to remove cuffs tied?
			
			if (thePlayerRestrain == 1) or (thePlayerTied == 1) then
				outputChatBox("You are restrained so can't free someone...", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local tied = getElementData(targetPlayer, "tie")
					
					if (tied == 0) then
						outputChatBox("The player is not tied.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(targetPlayer)
						
						local colSphere = createColSphere(x, y, z, smallRadius)
						
						if (isElementWithinColShape(thePlayer, colSphere)) then
							outputChatBox("You have been untied by " .. username ..".", targetPlayer)
							outputChatBox("You have untied" targetPlayerName ..".", thePlayer)
							toggleControl(targetPlayer, "sprint", true)
							toggleControl(targetPlayer, "fire", true)
							toggleControl(targetPlayer, "jump", true)
							toggleControl(targetPlayer, "next_weapon", true)
							toggleControl(targetPlayer, "previous_weapon", true)
							toggleControl(targetPlayer, "accelerate", true)
							toggleControl(targetPlayer, "brake_reverse", true)
							toggleControl(targetPlayer, "aim_weapon", true)
							setElementData(targetPlayer, "restrain", 0)
							setPedAnimation(targetPlayer)
							
							exports.global:givePlayerItem(thePlayer, 23, 1) -- give the player back the rope.
						else
							outputChatBox("You are not within range of ".. targetPlayerName ..".", thePlayer, 255, 0, 0)						
						end
						destroyElement(colSphere)
					end
				end
			end
		end
	end
end
addCommandHandler("untie", untiePlayer, false, false)
-------------------------------
-- Client side shop resource --
-------------------------------
-- Adds the sack item to the general shop GUI
function getItemsForSale(shop_type, race)
	if(shop_type == 1) then
		-- General Items
		item[21] = {"Rope", "A length of rope.", "10", 23, 0, 1, false, 2}

------------------------------------- HANDCUFFS ---------------------------------------
-----------------
-- Server side --
-----------------
----------------------[cuff]--------------------
function cuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else			
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			
			if not( exports.global:doesPlayerHaveItem(thePlayer, 24) ) then
				outputChatBox("You need handcuffs to handcuff someone.", thePlayer, 255, 0, 0)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
				if not (targetPlayer) then
					outputChatBox("Player not found.", thePlayer, 255, 0, 0)
				else
					local cuffed = getElementData(targetPlayer, "restrain")
					if (restrain==1) then
						outputChatBox("Player is already cuffed.", thePlayer, 255, 0, 0)
					
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(targetPlayer)
						
						local colSphere = createColSphere(x, y, z, smallRadius)
						
						if (isElementWithinColShape(thePlayer, colSphere)) then
							outputChatBox("You have been cuffed by ".. username ..".", targetPlayer)
							outputChatBox("You have cuffed ".. targetPlayerName ..".", thePlayer)
							toggleControl(targetPlayer, "sprint", false)
							toggleControl(targetPlayer, "jump", false)
							toggleControl(targetPlayer, "next_weapon", false)
							toggleControl(targetPlayer, "previous_weapon", false)
							toggleControl(targetPlayer, "accelerate", false)
							toggleControl(targetPlayer, "brake_reverse", false)
							toggleControl(targetPlayer, "fire", false)
							toggleControl(targetPlayer, "aim_weapon", false)

							setPedWeaponSlot(targetPlayer, 0)
							setElementData(targetPlayer, "restrain", 1)
							
							exports.global:takePlayerItem(thePlayer, 24, 1) -- take the rope
						else
							outputChatBox("You are not close enough to ".. targetPlayerName .." to handcuff them.", thePlayer, 255, 0, 0)						
						end
						destroyElement(colSphere)
					end
				end
			end
		end
	end
end
addCommandHandler("cuff", cuffPlayer, false, false)

----------------------[uncuff]--------------------
function uncuffPlayer(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPartialNick) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer)
		else
			local thePlayerRestrain = getElementData(thePlayer, "restrain") -- is the player trying to remove cuffs handcuffed?
			local thePlayerTied = getElementData(thePlayer, "tie") -- is the player trying to remove cuffs tied?
			
			if (thePlayerRestrain == 1) or (thePlayerTied == 1) then
				outputChatBox("You are restrained so can't free someone...", thePlayer, 255, 0, 0)
			else
				if not( exports.global:doesPlayerHaveItem(thePlayer, 25) ) then -- Does the player have a handcuff key.
					outputChatBox("You need to handcuff key to unlock the handcuffs.", thePlayer, 255, 0, 0)
				end
					local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
					if not (targetPlayer) then
						outputChatBox("Player not found.", thePlayer, 255, 0, 0)
					else
						
						local restrain = getElementData(targetPlayer, "restrain") 
						if (restrain==0) then-- is the target restained?
							outputChatBox("Player is not cuffed.", thePlayer, 255, 0, 0)
						else
							local targetPlayerName = getPlayerName(targetPlayer)
							local x, y, z = getElementPosition(targetPlayer)
							
							local colSphere = createColSphere(x, y, z, smallRadius)
							
							if (isElementWithinColShape(thePlayer, colSphere)) then
								outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
								outputChatBox("You have uncuffed targetPlayerName .. ".", thePlayer)
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "fire", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "next_weapon", true)
								toggleControl(targetPlayer, "previous_weapon", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								toggleControl(targetPlayer, "aim_weapon", true)
								setElementData(targetPlayer, "restrain", 0)
								setPedAnimation(targetPlayer)
								
								exports.global:givePlayerItem(thePlayer, 24, 1) -- give the player back the handcuffs.
							else
								outputChatBox("You are not within range of " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)						
							end
							destroyElement(colSphere)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("uncuff", uncuffPlayer, false, false)