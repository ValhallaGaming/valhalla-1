local anim = false

function onRender()
	local forcedanimation = getElementData(getLocalPlayer(), "forcedanimation")

	if (getPedAnimation(getLocalPlayer())) and not (forcedanimation) then
		local screenWidth, screenHeight = guiGetScreenSize()
		anim = true
		dxDrawText("Press Spacebar to Cancel Animation", screenWidth-420, screenHeight-91, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
		dxDrawText("Press Spacebar to Cancel Animation", screenWidth-422, screenHeight-93, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	end
	
	if not (getPedAnimation(getLocalPlayer())) and (anim) then
		anim = false
		toggleAllControls(true, true, false)
	end
end
addEventHandler("onClientRender", getRootElement(), onRender)