wFriends, bClose, imgSelf, lName, imgFlag, paneFriends, tMessage, bSendMessage, tFriends = nil
paneFriend = { }


local width, height = 300, 500
local scrWidth, scrHeight = guiGetScreenSize()
x = scrWidth/2 - (width/2)
y = scrHeight/2 - (height/2)
	
	
local tableFriends = nil
local fadeTimer = nil
local fadeTimerTB = nil
local localPlayer = getLocalPlayer()
local message = nil
local cachievements = nil

local panels = { }
local names = { }
local onlineimages = { }
local chars = { }
local flags = { }
local messages = { }
local tachievements = { }
local removes = { }
local buttonUpdate = nil
local textMessage = nil

function isPlayerOnline(id)
	for key, value in ipairs(getElementsByType("player")) do
		local pid = getElementData(value, "gameaccountid")

		if (id==pid) then
			return true, getPlayerName(value)
		end
	end
	return false
end

function enableMessageEdit(button)
	outputDebugString("HIT")
	if (button=="left") then
		local x, y = guiGetPosition(messages[1], true)

		buttonUpdate = guiCreateButton(x+0.15, y, 0.046, 0.03, "Update", true)
		guiSetFont(buttonUpdate, "default-bold-small")
		guiSetAlpha(buttonUpdate, 0.0)
		
		textMessage = guiCreateEdit(x, y, 0.15, 0.03, tostring(message), true)
		guiSetFont(textMessage, "default-bold-small")
		guiSetAlpha(textMessage, 0.0)
		guiEditSetMaxLength(textMessage, 33)
		fadeTimerTB = setTimer(fadeInTextBox, 100, 0)
	end
end

function fadeInTextBox()
	local alpha = guiGetAlpha(textMessage)
	local alpha2 = guiGetAlpha(messages[1])
	
	guiSetAlpha(textMessage, alpha+0.1)
	guiSetAlpha(buttonUpdate, alpha+0.1)
	guiSetAlpha(messages[1], alpha2-0.1)
	
	if (alpha+0.1>=0.7) then
		guiSetVisible(message[1], false)
		guiBringToFront(textMessage)
		addEventHandler("onClientGUIClick", buttonUpdate, sendMessage, false)
		guiSetInputEnabled(true)
		killTimer(fadeTimerTB)
	end
end

function fadeOutTextBox()
	local alpha = guiGetAlpha(textMessage)
	local alpha2 = guiGetAlpha(messages[1])
	
	guiSetAlpha(textMessage, alpha-0.1)
	guiSetAlpha(buttonUpdate, alpha-0.1)
	guiSetAlpha(messages[1], alpha2+0.1)
	
	if (alpha-0.1<=0.0) then
		destroyElement(buttonUpdate)
		destroyElement(textMessage)
		guiSetInputEnabled(false)
		guiBringToFront(messages[1])
		killTimer(fadeTimerTB)
	end
end

function showFriendsUI(friends, fmess, myachievements)
	if (fadeTimer) then return end
	setElementData(getLocalPlayer(), "friends.visible", 1, true)
	
	local cx = 0.015
	local cy = 0.025
	local count = 1
	
	tableFriends = friends
	message = fmess
	cachievements = myachievements
	
	-- SELF
	panels[1] = guiCreateTabPanel(cx, cy, 0.24, 0.15, true)
	guiSetAlpha(panels[1], 0.0)
	
	local myname = getElementData(localPlayer, "gameaccountusername")
	
	names[1] = guiCreateLabel(cx+0.02, cy+0.02, 0.9, 0.1, tostring(myname), true)
	guiSetFont(names[1], "default-bold-small")
	guiSetAlpha(names[1], 0.0)
	
	onlineimages[1] = guiCreateStaticImage(cx+0.0075, cy+0.027, 0.0075, 0.0075, "images/grn.png", true)
	guiSetAlpha(onlineimages[1], 0.0)
	
	chars[1] = guiCreateLabel(cx+0.02, cy+0.04, 0.9, 0.1, "You are playing as " .. string.gsub(getPlayerName(localPlayer), "_", " "), true)
	guiSetFont(chars[1], "default-bold-small")
	guiSetAlpha(chars[1], 0.0)
	
	local country = tostring(getElementData(getLocalPlayer(), "country"))
	if (country==nil) then country = "zz" end
	flags[1] = guiCreateStaticImage(cx+0.213, cy+0.117, 0.02, 0.0175, "images/flags/" .. country .. ".png", true)
	guiSetAlpha(flags[1], 0.0)
	
	tachievements[1] = guiCreateLabel(cx+0.02, cy+0.08, 0.9, 0.1, "You have " .. myachievements .. " achievements.", true)
	guiSetFont(tachievements[1], "default-bold-small")
	guiSetAlpha(tachievements[1], 0.0)
	
	if (string.len(fmess)>33) then
		fmess = string.sub(fmess, 1, 33) .. "..."
	end
	messages[1] = guiCreateLabel(cx+0.02, cy+0.1, 0.15, 0.03, "'" .. tostring(fmess) .. "'", true)
	guiSetFont(messages[1], "default-bold-small")
	guiSetAlpha(messages[1], 0.0)
	addEventHandler("onClientGUIClick", messages[1], enableMessageEdit, false)
	
	showCursor(true)
	
	cy = cy + 0.16
	
	addEventHandler("onClientClick", getRootElement(), resetState)
	
	-- OTHERS
	for key, value in ipairs(friends) do
		local id, username, message, country, achievements, timeoffline = unpack( value )
		
		panels[key+1] = guiCreateTabPanel(cx, cy, 0.24, 0.15, true) -- 0.25, 0.15
		guiSetAlpha(panels[key+1], 0.0)
		
		local found, name = isPlayerOnline(id)
		local pid = nil
		
		-- Name
		if not found then
			names[key+1] = guiCreateLabel(cx+0.02, cy+0.02, 0.9, 0.1, tostring(username), true)
		else
			pid = getElementData(getPlayerFromNick(name), "playerid")
			names[key+1] = guiCreateLabel(cx+0.02, cy+0.02, 0.9, 0.1, tostring(username) .. "  (ID: " .. pid .. ")" , true)
		end
		guiSetFont(names[key+1], "default-bold-small")
		guiSetAlpha(names[key+1], 0.0)
		
		-- Online status
		local image = "images/red.png"
		if (isPlayerOnline(id)) then image = "images/grn.png" end
		onlineimages[key+1] = guiCreateStaticImage(cx+0.0075, cy+0.027, 0.0075, 0.0075, image, true)
		guiSetAlpha(onlineimages[key+1], 0.0)
		
		-- Current Character
		
		if (found) then
			chars[key+1] = guiCreateLabel(cx+0.02, cy+0.04, 0.9, 0.2, "Currently Playing as " .. string.gsub(name, "_", " ") , true)
		else
			if (timeoffline) then
				if (timeoffline==0) then
					chars[key+1] = guiCreateLabel(cx+0.02, cy+0.04, 0.9, 0.1, "Last Seen Today.", true)
				else
					chars[key+1] = guiCreateLabel(cx+0.02, cy+0.04, 0.9, 0.1, "Last Seen " .. timeoffline .. " days ago.", true)
				end
			else
				chars[key+1] = guiCreateLabel(cx+0.02, cy+0.04, 0.9, 0.1, "Last Seen Never.", true)
			end
		end
		guiSetFont(chars[key+1], "default-bold-small")
		guiSetAlpha(chars[key+1], 0.0)
		
		-- FLAG
		if (country==nil) then country = "zz" end
		flags[key+1] = guiCreateStaticImage(cx+0.213, cy+0.117, 0.02, 0.0175, "images/flags/" .. country .. ".png", true)
		guiSetAlpha(flags[key+1], 0.0)
		
		-- ACHIEVEMENTS
		tachievements[key+1] = guiCreateLabel(cx+0.02, cy+0.08, 0.9, 0.1, achievements .. " Achievements.", true)
		guiSetFont(tachievements[key+1], "default-bold-small")
		guiSetAlpha(tachievements[key+1], 0.0)
		
		-- MESSAGE
		if (string.len(message)>33) then
			message = string.sub(message, 1, 33) .. "..."
		end
		messages[key+1] = guiCreateLabel(cx+0.02, cy+0.1, 0.95, 0.1, "'" .. message .. "'", true)
		guiSetFont(messages[key+1], "default-bold-small")
		guiSetAlpha(messages[key+1], 0.0)
		
		-- REMOVE
		removes[key] = guiCreateLabel(cx+0.226, cy+0.01, 0.01, 0.02, "X", true)
		guiSetFont(removes[key], "default-bold-small")
		guiSetAlpha(removes[key], 0.0)
		addEventHandler("onClientGUIClick", removes[key], removeFriend, false)
		
		cy = cy + 0.16
		count = count + 1
		
		if (count >= 6) then
			cx = cx + 0.245
			cy = 0.025
			count = 0
		end
	end
	fadeTimer = setTimer(doFadeInEffect, 50, 0)
end
addEvent("showFriendsList", true)
addEventHandler("showFriendsList", getRootElement(), showFriendsUI)

function resetState()
	for key, value in pairs(panels) do
		guiMoveToBack(value)
	end
end

function sendMessage(button)
	if (button=="left") then
		message = guiGetText(textMessage)
		
		guiSetVisible(message[1], true)
		guiSetText(messages[1], "'" .. tostring(message) .. "'")
		
		if (isTimer(fadeTimerTB)) then killTimer(fadeTimerTB) end
		fadeTimerTB = setTimer(fadeOutTextBox, 100, 0)
		triggerServerEvent("updateFriendsMessage", getLocalPlayer(), message)

	end
end

function doFadeInEffect()
	local alpha = nil
	for key, value in pairs(panels) do
		alpha = guiGetAlpha(value)
		guiSetAlpha(value, alpha+0.1)
	end
	
	if (alpha+0.1 >= 0.7) and isTimer(fadeTimer) then
		killTimer(fadeTimer)
		fadeTimer = setTimer(doFadeInContent, 50, 0)
	end
end

function doFadeInContent()
	local alpha = nil
	for key, value in pairs(names) do
		alpha = guiGetAlpha(value)
		guiSetAlpha(value, alpha+0.1)
		
		guiSetAlpha(onlineimages[key], alpha+0.1)
		guiSetAlpha(chars[key], alpha+0.1)
		guiSetAlpha(flags[key], alpha+0.1)
		guiSetAlpha(tachievements[key], alpha+0.1)
		guiSetAlpha(messages[key], alpha+0.1)
		guiSetAlpha(removes[key], alpha+0.1)
	end
	
	if (alpha+0.1 >= 0.7) and isTimer(fadeTimer) then
		killTimer(fadeTimer)
		fadeTimer = nil
	end
end

function doFadeOutEffect(fadeBackIn)
	local alpha = nil
	for key, value in pairs(panels) do
		alpha = guiGetAlpha(value)
		guiSetAlpha(value, alpha-0.1)
		
		if (alpha-0.1 <= 0.0) then
			destroyElement(value)
		end
	end
	
	if (alpha-0.1 <= 0.0) and isTimer(fadeTimer) then
		killTimer(fadeTimer)
		removeEventHandler("onClientClick", getRootElement(), resetState)
		
		panels = { }
		names = { }
		onlineimages = { }
		chars = { }
		flags = { }
		tachievements = { }
		messages = { }
		removes = { }
		
		if (fadeBackIn) then
			fadeTimer = nil
			showFriendsUI(tableFriends, message, cachievements)
		else
			tableFriends = nil
			fadeTimer = nil
			
			tableFriends = nil
			buttonUpdate = nil
			textMessage = nil
			cachievements = nil
		end
		
	end
end

function doFadeOutContent(fadeBackIn)
	local alpha = nil
	if (isTimer(fadeTimerTB)) then killTimer(fadeTimerTB) end
	
	for key, value in pairs(names) do
		alpha = guiGetAlpha(value)
		guiSetAlpha(value, alpha-0.1)
		
		guiSetAlpha(onlineimages[key], alpha-0.1)
		guiSetAlpha(chars[key], alpha-0.1)
		guiSetAlpha(flags[key], alpha-0.1)
		guiSetAlpha(tachievements[key], alpha-0.1)
		guiSetAlpha(messages[key], alpha-0.1)
		guiSetAlpha(removes[key], alpha-0.1)
		
		if (isElement(textMessage) and (guiGetAlpha(textMessage)>0.0)) then guiSetAlpha(textMessage, alpha-0.1) end
		if (isElement(buttonUpdate)  and (guiGetAlpha(textMessage)>0.0)) then guiSetAlpha(buttonUpdate, alpha-0.1) end
		
		if (alpha-0.1 <= 0.0) then
			destroyElement(value)
			
			if (isElement(onlineimages[key])) then
				destroyElement(onlineimages[key])
			end
			
			if (isElement(chars[key])) then
				destroyElement(chars[key])
			end
			
			if (isElement(flags[key])) then
				destroyElement(flags[key])
			end
			
			if (isElement(tachievements[key])) then
				destroyElement(tachievements[key])
			end
			
			if (isElement(messages[key])) then
				destroyElement(messages[key])
			end
			
			if (isElement(removes[key])) then
				destroyElement(removes[key])
			end
			
			if (isElement(buttonUpdate)) then
				destroyElement(buttonUpdate)
			end
			
			if (isElement(textMessage)) then
				destroyElement(textMessage)
			end
		end
	end
	
	if (alpha-0.1 <= 0.0) and isTimer(fadeTimer) then
		killTimer(fadeTimer)
		fadeTimer = setTimer(doFadeOutEffect, 50, 0, fadeBackIn)
	end
end

function hideFriendsUI(informServer, fadeBackIn)
	if (fadeTimer) then return end
	fadeTimer = setTimer(doFadeOutContent, 50, 0, fadeBackIn)
	guiSetInputEnabled(false)
	showCursor(false)
	
	if (informServer or informServer==nil) then
		setElementData(getLocalPlayer(), "friends.visible", 0, true)
	end
end
addEvent("hideFriendsList", true)
addEventHandler("hideFriendsList", getRootElement(), hideFriendsUI)

local clicked = false
function removeFriend(button)
	if (button=="left") and (clicked == false) then
		local targetvalue = nil
		for key, value in pairs(removes) do
			if (tostring(value)==tostring(source)) then
				targetvalue = key
			end
		end
		
		if (targetvalue) then
			clicked = true
			local id, username, message, country, achievements, timeoffline = unpack(tableFriends[targetvalue])

			fadeTimerTB = setTimer(fadeOutFriend, 100, 0, targetvalue+1)
			triggerServerEvent("removeFriend", getLocalPlayer(), id, username, false)
		end
	end
end

function fadeOutFriend(key)
	local alpha = guiGetAlpha(messages[key])
	
	guiSetAlpha(panels[key], alpha-0.1)
	guiSetAlpha(onlineimages[key], alpha-0.1)
	guiSetAlpha(chars[key], alpha-0.1)
	guiSetAlpha(flags[key], alpha-0.1)
	guiSetAlpha(names[key], alpha-0.1)
	guiSetAlpha(tachievements[key], alpha-0.1)
	guiSetAlpha(messages[key], alpha-0.1)
	guiSetAlpha(removes[key-1], alpha-0.1)
	
	if (alpha-0.1<=0.0) then
		clicked = false
		killTimer(fadeTimerTB)
		table.remove(panels, key)
		table.remove(onlineimages, key)
		table.remove(chars, key)
		table.remove(flags, key)
		table.remove(names, key)
		table.remove(tachievements, key)
		table.remove(messages, key)
		table.remove(removes, key-1)
		table.remove(tableFriends, key-1)
		hideFriendsUI(false, true)
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
