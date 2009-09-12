wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation, bBlindfold, bStabilize = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false
description = nil
age = nil
weight = nil
height = nil
race = nil

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) and (element~=getLocalPlayer()) then
		local x, y, z = getElementPosition(getLocalPlayer())
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			closing = false
			triggerServerEvent("sendPlayerInfo", getLocalPlayer(), element)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, true)

function showPlayerMenu(targetPlayer, friend, sdescription, sage, sweight, sheight, srace)
	wRightClick = guiCreateWindow(ax, ay, 150, 200, string.gsub(getPlayerName(targetPlayer), "_", " "), false)
	
	age = sage
	weight = sweight
	description = sdescription
	height = sheight
	
	if (srace==0) then
		race = "Black"
	elseif (srace==1) then
		race = "White"
	elseif (srace==2) then
		race = "Asian"
	else
		race = "Alien"
	end

	
	if not friend then
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Add as friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Remove friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end
	
	-- FRISK
--[[	if getElementData(getLocalPlayer(), "hoursplayed") >= 12 then
		bFrisk = guiCreateButton(0.05, 0.25, 0.45, 0.1, "Frisk", true, wRightClick)
		addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	end]]
	
	-- RESTRAIN
	local cuffed = getElementData(player, "restrain")
	
	if cuffed == 0 then
		bRestrain = guiCreateButton(0.05, 0.25, 0.87, 0.1, "Restrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = guiCreateButton(0.05, 0.25, 0.87, 0.1, "Unrestrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
	end
	
	-- BLINDFOLD
	local blindfold = getElementData(player, "blindfold")
	
	if (blindfold) and (blindfold == 1) then
		bBlindfold = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Remove Blindfold", true, wRightClick)
		addEventHandler("onClientGUIClick", bBlindfold, cremoveBlindfold, false)
	else
		bBlindfold = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Blindfold", true, wRightClick)
		addEventHandler("onClientGUIClick", bBlindfold, cBlindfold, false)
	end
	
	-- STABILIZE
	y = 0.64
	if exports.global:hasItem(getLocalPlayer(), 70) and getElementData(player, "injuriedanimation") then
		bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Stabilize", true, wRightClick)
		addEventHandler("onClientGUIClick", bStabilize, cStabilize, false)
		y = y + 0.13
	end
	
	bCloseMenu = guiCreateButton(0.05, y, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hidePlayerMenu, false)
	sent = false
	
	bInformation = guiCreateButton(0.05, 0.38, 0.87, 0.1, "Information", true, wRightClick)
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function showPlayerInfo(button, state)
	if (button=="left") then
		outputChatBox("~~~~~~~~~~~~ " .. getPlayerName(player) .. " ~~~~~~~~~~~~", 255, 194, 14)
		outputChatBox("Race: " .. race, 255, 194, 14)
		outputChatBox("Age: " .. age .. " years old", 255, 194, 14)
		outputChatBox("Weight: " .. weight .. "kg", 255, 194, 14)
		outputChatBox("Height: " .. height .. "cm", 255, 194, 14)
		outputChatBox("Description: " .. description, 255, 194, 14)
	end
end


--------------------
--   STABILIZING  --
--------------------

function cStabilize(button, state)
	if button == "left" and state == "up" then
		if (exports.global:hasItem(getLocalPlayer(), 70)) then -- Has First Aid Kit?
			local knockedout = getElementData(player, "injuriedanimation")
			
			if not knockedout then
				outputChatBox("This player is not knocked out.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("stabilizePlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a First Aid Kit.", 255, 0, 0)
		end
	end
end

--------------------
--  BLINDFOLDING  --
-------------------
function cBlindfold(button, state, x, y)
	if (button=="left") then
		if (exports.global:hasItem(getLocalPlayer(), 66)) then -- Has blindfold?
			local blindfolded = getElementData(player, "blindfold")
			local restrained = getElementData(player, "restrain")
			
			if (blindfolded==1) then
				outputChatBox("This player is already blindfolded.", 255, 0, 0)
				hidePlayerMenu()
			elseif (restrained==0) then
				outputChatBox("This player must be restrained in order to blindfold them.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("blindfoldPlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a blindfold.", 255, 0, 0)
		end
	end
end

function cremoveBlindfold(button, state, x, y)
	if (button=="left") then
		local blindfolded = getElementData(player, "blindfold")
		if (blindfolded==1) then
			triggerServerEvent("removeBlindfold", getLocalPlayer(), player)
			hidePlayerMenu()
		else
			outputChatBox("This player is not blindfolded.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

--------------------
--  RESTRAINING   --
--------------------
function crestrainPlayer(button, state, x, y)
	if (button=="left") then
		if (exports.global:hasItem(getLocalPlayer(), 45) or exports.global:hasItem(getLocalPlayer(), 46)) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained==1) then
				outputChatBox("This player is already restrained.", 255, 0, 0)
				hidePlayerMenu()
			else
				local restrainedObj
				
				if (exports.global:hasItem(getLocalPlayer(), 45)) then
					restrainedObj = 45
				elseif (exports.global:hasItem(getLocalPlayer(), 46)) then
					restrainedObj = 46
				end
					
				triggerServerEvent("restrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			end
		else
			outputChatBox("You have no items to restrain with.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

function cunrestrainPlayer(button, state, x, y)
	if (button=="left") then
		local restrained = getElementData(player, "restrain")
		
		if (restrained==0) then
			outputChatBox("This player is not restrained.", 255, 0, 0)
			hidePlayerMenu()
		else
			local restrainedObj = getElementData(player, "restrainedObj")
			local dbid = getElementData(getLocalPlayer(), "dbid")
			
			if (exports.global:hasItem(getLocalPlayer(), 47, dbid)) or (restrainedObj==46) then -- has the keys, or its a rope
				triggerServerEvent("unrestrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			else
				outputChatBox("You do not have the keys to these handcuffs.", 255, 0, 0)
			end
		end
	end
end
--------------------
-- END RESTRAINING--
--------------------

--------------------
--    FRISKING    --
--------------------
--[[
wFriskItems, bFriskTakeItem, bFriskClose, gFriskItems, FriskColName = nil
function cfriskPlayer(button, state, x, y)
	if (button=="left") then
		destroyElement(wRightClick)
		wRightClick = nil
		
		if not (wFriskItems) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained~=1) then
				outputChatBox("This player is not restrained.", 255, 0, 0)
				hidePlayerMenu()
			elseif getElementHealth(getLocalPlayer()) < 50 then
				outputChatBox("You need at least half health to frisk someone.", 255, 0, 0)
				hidePlayerMenu()
			else
				addEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
				local playerName = string.gsub(getPlayerName(player), "_", " ")
				triggerServerEvent("sendLocalMeAction", getLocalPlayer(), getLocalPlayer(), "frisks " .. playerName .. ".")
				local width, height = 300, 200
				local scrWidth, scrHeight = guiGetScreenSize()
				
				wFriskItems = guiCreateWindow(x, y, width, height, "Frisk: " .. playerName, false)
				guiWindowSetSizable(wFriskItems, false)
				
				gFriskItems = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, wFriskItems)
				FriskColName = guiGridListAddColumn(gFriskItems, "Name", 0.9)
				
				local items = getElementData(player, "items")
				
				local slots = 10
				if (exports.global:hasItem(player, 48, -1)) then
					slots = 20
				end
				
				for i = 1, slots do
					local itemID = tonumber(gettok(items, i, string.byte(',')))
					if (itemID~=nil) then
						local itemName = exports.global:cgetItemName(itemID)
						local row = guiGridListAddRow(gFriskItems)
						guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
						guiGridListSetSortingEnabled(gFriskItems, false)
					end
				end
				
				-- WEAPONS
				for i = 1, 12 do
					if (getPedWeapon(player, i)>0) then
						local ammo = getPedTotalAmmo(player, i)
						
						if (ammo>0) then
							local itemName = getWeaponNameFromID(getPedWeapon(player, i))
							local row = guiGridListAddRow(gFriskItems)
							guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
							guiGridListSetSortingEnabled(gFriskItems, false)
						end
					end
				end
				
				bFriskTakeItem = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Take Item", true, wFriskItems)
				addEventHandler("onClientGUIClick", bFriskTakeItem, takePlayerItem, false)
				
				bFriskClose = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Close", true, wFriskItems)
				addEventHandler("onClientGUIClick", bFriskClose, hidePlayerMenu, false)
			end
		else
			guiBringToFront(wFriskItems, true)
		end
	end
end

function takePlayerItem(button, state, x, y)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gFriskItems)
		
		if getElementHealth(getLocalPlayer()) < 50 then
			outputChatBox("You need at least half health to frisk someone.", 255, 0, 0)
			hidePlayerMenu()
		elseif (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		else
			local items = getElementData(player, "items")
			local itemvalues = getElementData(player, "itemvalues")
			
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if itemID == 3 or itemID == 4 or itemID == 5 or itemID == 48 then -- KEYS or BACKPACK
				outputChatBox("You cannot take this item from the player.", 255, 0, 0)
				return
			end
			
			if (itemName) then -- ITEM
				if not (exports.global:hasSpaceForItem(getLocalPlayer())) then
					outputChatBox("You do not have space for this item.", 255, 0, 0)
				else
					guiGridListRemoveRow(gFriskItems, row)
					triggerServerEvent("friskTakePlayerItem", getLocalPlayer(), player, itemID, itemValue, itemName)
				end
			else -- WEAPON
				local weaponID = getWeaponIDFromName(guiGridListGetItemText(gFriskItems, row, col))
				
				if (getPedWeapon(getLocalPlayer(), getSlotFromWeapon(weaponID))==weaponID) then
					outputChatBox("You already have one of this item, this item is Unique.", 255, 0, 0)
				else
					local weaponAmmo = getPedAmmoInClip(player, getSlotFromWeapon(weaponID)) * 5

					guiGridListRemoveRow(gFriskItems, row)
					triggerServerEvent("friskTakePlayerWeapon", getLocalPlayer(), player, weaponID, weaponAmmo)
				end
			end
		end
	end
end]]
--------------------
--  END FRISKING  --
--------------------

function caddFriend()
	triggerServerEvent("addFriend", getLocalPlayer(), player)
	hidePlayerMenu()
end

function cremoveFriend()
	local id = tonumber(getElementData(player, "gameaccountid"))
	local username = getPlayerName(player)
	triggerServerEvent("removeFriend", getLocalPlayer(), id, username, true)
	hidePlayerMenu()
end

function hidePlayerMenu()
	if (isElement(bAddAsFriend)) then
		destroyElement(bAddAsFriend)
	end
	bAddAsFriend = nil
	
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if (isElement(wFriskItems)) then
		destroyElement(wFriskItems)
	end
	wFriskItems = nil
	
	ax = nil
	ay = nil
	
	description = nil
	age = nil
	weight = nil
	height = nil
	
	if player then
		removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	end
	
	sent = false
	player = nil
	
	showCursor(false)
end

function checkMenuWasted()
	if source == getLocalPlayer() or source == player then
		hidePlayerMenu()
	end
end

addEventHandler("onClientPlayerWasted", getRootElement(), checkMenuWasted)