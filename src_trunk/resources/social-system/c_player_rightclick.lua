wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu = nil
sent = false
ax, ay = nil
player = nil

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if (element) then
		if (getElementType(element)=="player") and (sent==false) and (element==getLocalPlayer()) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			triggerServerEvent("sendPlayerInfo", getLocalPlayer(), element)
		elseif not (element) then
			hidePlayerMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, false)

function showPlayerMenu(targetPlayer, friends, description)
	wRightClick = guiCreateWindow(ax, ay, 150, 200, string.gsub(getPlayerName(targetPlayer), "_", " "), false)
	
	local targetid = tonumber(getElementData(targetPlayer, "gameaccountid"))
	local found = false
	for key, value in ipairs(friends) do
		if (friends[key]==targetid) then
			found = true
		end
	end
	
	if (found==false) then
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Add as friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Remove friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end
	
	bAddAsFriend = guiCreateButton(0.05, 0.45, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bAddAsFriend, hidePlayerMenu, false)
	sent = false
	
	-- FRISK
	--bFrisk = guiCreateButton(0.05, 0.25, 0.87, 0.1, "Frisk", true, wRightClick)
	--addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

--------------------
--    FRISKING    --
--------------------
wFriskItems, bFriskTakeItem, bFriskClose, gFriskItems, FriskColName = nil
function cfriskPlayer(button, state, x, y)
	if not (wFriskItems) then
		local width, height = 300, 200
		local scrWidth, scrHeight = guiGetScreenSize()
		
		wFriskItems = guiCreateWindow(x, y, width, height, "Frisk: " .. getPlayerName(player), false)
		guiWindowSetSizable(wFriskItems, false)
		
		gFriskItems = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, wFriskItems)
		FriskColName = guiGridListAddColumn(gFriskItems, "Name", 0.9)
		
		local items = getElementData(player, "items")
		
		for i = 1, 10 do
			local itemID = tonumber(gettok(items, i, string.byte(',')))
			if (itemID~=nil) then
				local itemName = exports.global:cgetItemName(itemID)
				outputChatBox(tostring(itemName))
				local row = guiGridListAddRow(gFriskItems)
				guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
			end
		end
		
		bFriskTakeItem = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Take Item", true, wFriskItems)
		bFriskClose = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Close", true, wFriskItems)
		addEventHandler("onClientGUIClick", bFrisk, hidePlayerMenu, false)
	else
		guiBringToFront(wFriskItems, true)
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
	destroyElement(wRightClick)
	wRightClick = nil
	
	destroyElement(bAddAsFriend)
	bAddAsFriend = nil
	
	ax = nil
	ay = nil
	player = nil
	
	showCursor(false)
end