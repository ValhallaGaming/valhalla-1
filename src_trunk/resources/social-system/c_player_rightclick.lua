wRightClick = nil
bAddAsFriend, bCloseMenu = nil
sent = false
ax, ay = nil
player = nil

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if (element) then
		if (getElementType(element)=="player") and (button=="right") and (sent==false) and (element~=getLocalPlayer()) then
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
	
	bAddAsFriend = guiCreateButton(0.05, 0.25, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bAddAsFriend, hidePlayerMenu, false)
	sent = false
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

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