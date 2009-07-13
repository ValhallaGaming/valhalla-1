wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function clickPed(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") and (sent==false) and (element~=getLocalPlayer()) then
		local gatekeeper = getElementData(element, "talk")
		if (gatekeeper) then
			local x, y, z = getElementPosition(getLocalPlayer())
		
			if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
				if (wPedRightClick) then
					hidePlayerMenu()
				end
				
				showCursor(true)
				ax = absX
				ay = absY
				player = element
				closing = false
				
				wPedRightClick = guiCreateWindow(ax, ay, 150, 200, getElementData(element, "name"), false)
				
				local convoState = getElementData(element, "activeConvo")
				if (convoState == 0) then
				
					bTalkToPed = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Talk", true, wPedRightClick)
					addEventHandler("onClientGUIClick", bTalkToPed,  function (button, state)
						if(button == "left" and state == "up") then
					
							hidePedMenu()
							
							local ped = getElementData(element, "name")
							if (ped=="Steven Pullman") then
								triggerServerEvent( "startStevieConvo", getLocalPlayer())
								if not(getElementData(getLocalPlayer(),"stevieCooldown")) then
									triggerEvent ( "stevieIntroEvent", getLocalPlayer()) -- Trigger Client side function to create GUI.
								end
							elseif (ped=="Hunter") then
									triggerServerEvent( "startHunterConvo", getLocalPlayer())
								if not (getElementData(getLocalPlayer(),"hunterCoolDown")) then
									triggerEvent ( "hunterIntroEvent", getLocalPlayer()) -- Trigger Client side function to create GUI.
								end
							else
								outputChatBox("Error: Unknown ped.", 255, 0, 0)
							end
						end	
					end, false)
				end
				
				bClosePedMenu = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Close Menu", true, wPedRightClick)
				addEventHandler("onClientGUIClick", bClosePedMenu, hidePedMenu, false)
				sent=true
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPed, true)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil
	
	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil
	
	ax = nil
	ay = nil
	sent=false
	showCursor(false)
	
end