function checkForChat()
	local chatting = getElementData(getLocalPlayer(), "chatting")
	
	if (isChatBoxInputActive() and chatting==0) then
		setElementData(getLocalPlayer(), "chatting", 1, true)
	elseif (not isChatBoxInputActive() and chatting==1) then
		setElementData(getLocalPlayer(), "chatting", 0, true)
	end
end
setTimer(checkForChat, 50, 0)
setElementData(getLocalPlayer(), "chatting", 0, true)

function render()
	local x, y, z = getElementPosition(getLocalPlayer())
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) and (isElementStreamedIn(value)) then
			if (value~=getLocalPlayer()) then
				local chatting = getElementData(value, "chatting")
				
				if (chatting==1) then
					local px, py, pz = getPedBonePosition(value, 6)
					
					local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
					if (dist < 25) then
						local reconning = getElementData(value, "reconx")
						if (isLineOfSightClear(x, y, z, px, py, pz, true, false, false, false ) and isElementOnScreen(value)) and not (reconning) then
							local screenX, screenY = getScreenFromWorldPosition(px, py, pz+0.5)
							if (screenX and screenY) then
								dist = dist / 5
									
								if (dist<1) then dist = 1 end
								--if (dist>2) then dist = 2 end
								local offset = 70 / dist
								
								local draw = dxDrawImage(screenX, screenY, 60 / dist, 60 / dist, "chat.png")
							end
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