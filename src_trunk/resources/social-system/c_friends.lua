wFriends, bClose, imgSelf, lName, imgFlag, paneFriends, tMessage, bSendMessage, tFriends = nil
paneFriend = { }


local width, height = 300, 500
local scrWidth, scrHeight = guiGetScreenSize()
x = scrWidth/2 - (width/2)
y = scrHeight/2 - (height/2)
	
function showFriendsUI(friends, fmess)
	wFriends = guiCreateWindow(x, y, width, height, "Friends List", false)
	guiWindowSetSizable(wFriends, false)
	addEventHandler("onClientGUIMove", wFriends, storeCoords)
	
	tFriends = friends
	
	-- SELF
	imgSelf = guiCreateStaticImage(0.05, 0.075, 0.9, 0.1, "images/friendsme.png", true, wFriends)
	
	bClose = guiCreateButton(0.825, 0.0375, 0.15, 0.04, "Close", true, wFriends)
	addEventHandler("onClientGUIClick", bClose, hideFriendsUI, false)
	
	local uname = getElementData(getLocalPlayer(), "gameaccountusername")
	local charname = string.gsub(getPlayerName(getLocalPlayer()), "_", " ")
	lName = guiCreateLabel(0.17, 0.084, 0.6, 0.2, uname .. " (" .. charname .. ")", true, wFriends)
	guiSetFont(lName, "default-bold-small")
	
	local country = tostring(getElementData(getLocalPlayer(), "country"))
	if (country==nil) then country = "ru" end
	imgFlag = guiCreateStaticImage(0.0875, 0.0875, 0.025806*3, 0.021154, "images/flags/" .. string.lower(country) .. ".png", true, wFriends)
	
	tMessage = guiCreateEdit(0.08, 0.12, 0.6, 0.04, tostring(fmess), true, wFriends)
	
	bSendMessage = guiCreateButton(0.68, 0.12, 0.25, 0.04, "Update", true, wFriends)
	addEventHandler("onClientGUIClick", bSendMessage, sendMessage, false)
	
	paneFriends = guiCreateScrollPane(0.05, 0.2, 0.9, 0.85, true, wFriends)
	
	local dy = 0.0
	local dheight = 0.2
	local online = 0
	for key, value in ipairs(friends) do
		local id, username, message, country, status, operatingsystem, achievements = unpack( value )
		
		-- Fix for blank messages
		if not message then
			message = "No Message"
		else
			message = "'" .. message .. "'"
		end
		
		-- STANDARD UI
		paneFriend[key] = {}
		paneFriend[key][7] = guiCreateScrollPane(0.05, dy, 1.0, 0.35, true, paneFriends)
		paneFriend[key][1] = guiCreateStaticImage(0.0, 0.1, 0.9, 0.5, ":account-system/img/charbg0.png", true, paneFriend[key][7])
		
		
		paneFriend[key][2] = guiCreateLabel(0.12, 0.1, 0.8, 0.2, username, true, paneFriend[key][7])
		guiSetFont(paneFriend[key][2], "default-bold-small")
		
		paneFriend[key][3] = guiCreateStaticImage(0.0175, 0.125, 0.09, 0.08, "images/flags/" .. string.lower(country or "ru") .. ".png", true, paneFriend[key][7])
		
		if isElement( status ) then
			status = "Online as (" .. getElementData( status, "playerid" ) .. ") " .. getPlayerName( status ):gsub("_", " ")
			online = online + 1
		end
		paneFriend[key][4] = guiCreateLabel(0.12, 0.2, 0.8, 0.2, tostring(status), true, paneFriend[key][7])
		guiSetFont(paneFriend[key][4], "default-bold-small")
		
		paneFriend[key][5] = guiCreateLabel(0.12, 0.3, 0.8, 0.2, tostring(message), true, paneFriend[key][7])
		guiSetFont(paneFriend[key][5], "default-bold-small")
		
		paneFriend[key][6] = guiCreateStaticImage(0.08, 0.42, 0.1, 0.16, "images/" .. operatingsystem .. ".png", true, paneFriend[key][7])
		
		paneFriend[key][10] = guiCreateLabel(0.22, 0.45, 0.5, 0.2, tostring(achievements) .. " Achievements", true, paneFriend[key][7])
		guiSetFont(paneFriend[key][10], "default-bold-small")
		
		paneFriend[key][8] = guiCreateButton(0.63, 0.43, 0.25, 0.15, "Remove", true, paneFriend[key][7])
		addEventHandler("onClientGUIClick", paneFriend[key][8], removeFriend, false)
		
		--paneFriend[key][9] = guiCreateButton(0.72, 0.43, 0.25, 0.15, "Compare", true, paneFriend[key][7])
		--addEventHandler("onClientGUIClick", paneFriend[key][8], removeFriend, false)
		
		dy = dy + 0.205
	end
	guiSetText(wFriends, "Friends List - " .. online .. "/" .. #friends .. " online")
	
	addEventHandler("onClientGUIClick", wFriends,
		function( button, state )
			if button == "left" and state == "up" then
				if source == tMessage then
					guiSetInputEnabled(true)
				else
					guiSetInputEnabled(false)
				end
			end
		end
	)
end
addEvent("showFriendsList", true)
addEventHandler("showFriendsList", getRootElement(), showFriendsUI)

function unload()
	guiSetInputEnabled(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), unload)

function sendMessage()
	local message = guiGetText(tMessage)
	hideFriendsUI()
	triggerServerEvent("updateFriendsMessage", getLocalPlayer(), message)
end

function storeCoords()
	if (wFriends~=nil) then
		x, y = guiGetPosition(wFriends, false)
	end
end

function hideFriendsUI()
	destroyElement(wFriends)
	guiSetInputEnabled(false)
	setElementData(getLocalPlayer(), "friends.visible", 0, true)
	tFriends = nil
end
addEvent("hideFriendsList", true)
addEventHandler("hideFriendsList", getRootElement(), hideFriendsUI)

function removeFriend(button)
	if (button=="left") then
		local targetvalue = nil
		for key, value in ipairs(paneFriend) do
			if (tostring(paneFriend[key][8])==tostring(source)) then
				targetvalue = key
			end
		end
		
		if (targetvalue) then
			local id = tFriends[targetvalue][1]
			local username = tFriends[targetvalue][2]
			hideFriendsUI()
			triggerServerEvent("removeFriend", getLocalPlayer(), id, username, false)
		end
	end
end

function toggleCursor()
	if (isCursorShowing()) then
		showCursor(false)
	else
		showCursor(true)
	end
end
addCommandHandler("togglecursor", toggleCursor)
bindKey("m", "down", "togglecursor")

function cursorHide()
	showCursor(false)
end
addEvent("cursorHide", false)
addEventHandler("cursorHide", getRootElement(), cursorHide)

function cursorShow()
	showCursor(true)
end
addEvent("cursorShow", false)
addEventHandler("cursorShow", getRootElement(), cursorShow)
