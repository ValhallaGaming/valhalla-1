wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false
description = nil
age = nil
weight = nil
height = nil

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) and (element==getLocalPlayer()) then
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

function showPlayerMenu(targetPlayer, friends, sdescription, sage, sweight, sheight)
	wRightClick = guiCreateWindow(ax, ay, 150, 200, string.gsub(getPlayerName(targetPlayer), "_", " "), false)
	
	local targetid = tonumber(getElementData(targetPlayer, "gameaccountid"))
	local found = false
	for key, value in ipairs(friends) do
		if (friends[key]==targetid) then
			found = true
		end
	end
	
	age = sage
	weight = sweight
	description = sdescription
	height = sheight
	
	if (found==false) then
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Add as friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Remove friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end
	
	bCloseMenu = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hidePlayerMenu, false)
	sent = false
	
	-- FRISK
	bFrisk = guiCreateButton(0.05, 0.25, 0.45, 0.1, "Frisk", true, wRightClick)
	addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	
	-- RESTRAIN
	local cuffed = getElementData(player, "restrain")
	
	if (cuffed==0) then
		bRestrain = guiCreateButton(0.555, 0.25, 0.45, 0.1, "Restrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = guiCreateButton(0.555, 0.25, 0.45, 0.1, "Unrestrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
	end
	
	bInformation = guiCreateButton(0.05, 0.38, 0.87, 0.1, "Information", true, wRightClick)
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function showPlayerInfo(button, state)
	if (button=="left") then
		outputChatBox("~~~~~~~~~~~~ " .. getPlayerName(player) .. " ~~~~~~~~~~~~", 255, 194, 14)
		outputChatBox("Age: " .. age .. " years old", 255, 194, 14)
		outputChatBox("Weight: " .. weight .. "cm", 255, 194, 14)
		outputChatBox("Height: " .. height .. "cm", 255, 194, 14)
		outputChatBox("Description: " .. description, 255, 194, 14)
	end
end

--------------------
--  RESTRAINING   --
--------------------
function crestrainPlayer(button, state, x, y)
	if (button=="left") then
		if (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 45, -1) or exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 46, -1)) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained==1) then
				outputChatBox("This player is already restrained.", 255, 0, 0)
				hidePlayerMenu()
			else
				local restrainedObj
				
				if (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 45, -1)) then
					restrainedObj = 45
				elseif (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 46, -1)) then
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
			local restrainedBy = getElementData(player, "restrainedBy")
			local restrainedObj = getElementData(player, "restrainedObj")
			local dbid = getElementData(getLocalPlayer(), "dbid")
			
			if (exports.global:cdoesPlayerHaveItem(getLocalPlayer(), 47, dbid)) or (restrainedObj==46) then -- has the keys, or its a rope
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
				
				for i = 1, 10 do
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
						local itemName = getWeaponNameFromID(getPedWeapon(player, i))
						local row = guiGridListAddRow(gFriskItems)
						guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
						guiGridListSetSortingEnabled(gFriskItems, false)
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
		
		if (row<0) then
			outputChatBox("Please select an item first.", 255, 0, 0)
		else
			local items = getElementData(player, "items")
			local itemvalues = getElementData(player, "itemvalues")
			
			local itemID = tonumber(gettok(items, row+1, string.byte(',')))
			local itemValue = tonumber(gettok(itemvalues, row+1, string.byte(',')))
			local itemName = exports.global:cgetItemName(itemID)
			
			if (itemID==48) then -- BACKPACK
				outputChatBox("You cannot take this item from the player.", 255, 0, 0)
				return
			end
			
			if (itemName) then -- ITEM
				if not (exports.global:cdoesPlayerHaveSpaceForItem(getLocalPlayer())) then
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
					local weaponAmmo = getPedTotalAmmo(player, getSlotFromWeapon(weaponID))
					guiGridListRemoveRow(gFriskItems, row)
					triggerServerEvent("friskTakePlayerWeapon", getLocalPlayer(), player, weaponID, weaponAmmo)
				end
			end
		end
	end
end
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
	
	removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	
	sent = false
	player = nil
	
	showCursor(false)
end