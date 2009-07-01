function checkForChat()
	local chatting = getElementData(getLocalPlayer(), "chatting")
	
	if (isChatBoxInputActive() and chatting==0) then
		setElementData(getLocalPlayer(), "chatting", true, 1)
	elseif (not isChatBoxInputActive() and chatting==1) then
		setElementData(getLocalPlayer(), "chatting", true, 0)
	end
end
setTimer(checkForChat, 50, 0)
setElementData(getLocalPlayer(), "chatting", true, 0)

function render()
	local x, y, z = getElementPosition(getLocalPlayer())
	for key, value in ipairs(getElementsByType("player")) do
		if (value==getLocalPlayer()) then
			local chatting = getElementData(value, "chatting")
			
			if (chatting==1) then
				--local px, py, pz = getElementPosition(value)
				local px, py, pz = getPedBonePosition(value, 6)
				
				local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
				if (dist < 300) then
					local reconning = getElementData(value, "reconx")
					if (isLineOfSightClear(x, y, z, px, py, pz, true, false, false, false ) and isElementOnScreen(value)) and not (reconning) then
						local screenX, screenY = getScreenFromWorldPosition(px, py, pz+0.5)
						if (screenX and screenY) then
							local draw = dxDrawImage(screenX, screenY, 70, 70, "chat.png")
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), render)

chaticon = true
function toggleChatIcon()
	if (chaticon) then
		outputChatBox("Chat icons are now disabled.", 255, 0, 0)
		chaticon = false
		removeEventHandler("onClientRender", getRootElement(), render)
	else
		outputChatBox("Chat icons are now enabled.", 0, 255, 0)
		chaticon = true
		addEventHandler("onClientRender", getRootElement(), render)
	end
end
addCommandHandler("togglechaticons", toggleChatIcon, false)
addCommandHandler("togchaticons", toggleChatIcon, false)