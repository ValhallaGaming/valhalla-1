wFriends, bClose, imgSelf, lName, imgFlag, paneFriends, tMessage, bSendMessage, tFriends = nil
paneFriend = { }


local width, height = 300, 500
local scrWidth, scrHeight = guiGetScreenSize()
x = scrWidth/2 - (width/2)
y = scrHeight/2 - (height/2)
	
function showFriendsUI(friends)
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
	imgFlag = guiCreateStaticImage(0.0875, 0.0875, 0.025806*3, 0.021154, "images/flags/" .. string.lower(country) .. ".png", true, wFriends)
	
	local fmess = getElementData(getLocalPlayer(), "friends.message")
	
	tMessage = guiCreateEdit(0.08, 0.12, 0.6, 0.04, tostring(fmess), true, wFriends)
	
	bSendMessage = guiCreateButton(0.68, 0.12, 0.25, 0.04, "Update", true, wFriends)
	addEventHandler("onClientGUIClick", bSendMessage, sendMessage, false)
	
	paneFriends = guiCreateScrollPane(0.05, 0.2, 0.9, 0.85, true, wFriends)
	
	local dy = 0.0
	local dheight = 0.2
	for key, value in ipairs(friends) do
		local id = friends[key][1]
		local username = friends[key][2]
		local message = friends[key][3]
		local country = friends[key][4]
		local status = friends[key][5]
		local operatingsystem = friends[key][7]
		local name = nil
		
		-- Fix for blank messages
		if (tostring(message)=="nil") then
			message = "No Message"
		else
			message = "'" .. message .. "'"
		end
		
		if (status=="Online") then
			name = string.gsub(friends[key][6], "_", " ")
		end
	
		-- STANDARD UI
		paneFriend[key] = {}
		paneFriend[key][7] = guiCreateScrollPane(0.05, dy, 1.0, 0.35, true, paneFriends)
		paneFriend[key][1] = guiCreateStaticImage(0.0, 0.1, 0.9, 0.5, "img/charbg0.png", true, paneFriend[key][7], getResourceFromName("account-system"))
		
		if (name~=nil) then
			paneFriend[key][2] = guiCreateLabel(0.12, 0.1, 0.8, 0.2, username .. " as " .. name, true, paneFriend[key][7])
		else
			paneFriend[key][2] = guiCreateLabel(0.12, 0.1, 0.8, 0.2, username, true, paneFriend[key][7])
		end
		guiSetFont(paneFriend[key][2], "default-bold-small")

		paneFriend[key][3] = guiCreateStaticImage(0.0175, 0.125, 0.09, 0.08, "images/flags/" .. string.lower(country) .. ".png", true, paneFriend[key][7])
		
		paneFriend[key][4] = guiCreateLabel(0.12, 0.2, 0.8, 0.2, tostring(status), true, paneFriend[key][7])
		guiSetFont(paneFriend[key][4], "default-bold-small")
		
		paneFriend[key][5] = guiCreateLabel(0.12, 0.3, 0.8, 0.2, tostring(message), true, paneFriend[key][7])
		guiSetFont(paneFriend[key][5], "default-bold-small")
		
		paneFriend[key][6] = guiCreateStaticImage(0.08, 0.42, 0.1, 0.16, "images/" .. operatingsystem .. ".png", true, paneFriend[key][7])
		
		paneFriend[key][10] = guiCreateLabel(0.22, 0.45, 0.5, 0.2, tostring(friends[key][8]) .. " Achievements", true, paneFriend[key][7])
		guiSetFont(paneFriend[key][10], "default-bold-small")
		
		paneFriend[key][8] = guiCreateButton(0.63, 0.43, 0.25, 0.15, "Remove", true, paneFriend[key][7])
		addEventHandler("onClientGUIClick", paneFriend[key][8], removeFriend, false)
		
		--paneFriend[key][9] = guiCreateButton(0.72, 0.43, 0.25, 0.15, "Compare", true, paneFriend[key][7])
		--addEventHandler("onClientGUIClick", paneFriend[key][8], removeFriend, false)
		
		dy = dy + 0.205
	end
	
	guiSetInputEnabled(true)
end
addEvent("showFriendsList", true)
addEventHandler("showFriendsList", getRootElement(), showFriendsUI)

function unload(res)
	if (res==getThisResource()) then
		guiSetInputEnabled(false)
	end
end
addEventHandler("onClientResourceStop", getRootElement(), unload)

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
			triggerServerEvent("removeFriend", getLocalPlayer(), id, username)
		end
	end
end