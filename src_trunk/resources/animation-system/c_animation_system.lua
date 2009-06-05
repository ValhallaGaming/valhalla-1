function onRender()
	if (getPedAnimation(getLocalPlayer())) then
		local screenWidth, screenHeight = guiGetScreenSize()
		dxDrawText("Press Spacebar to Cancel Animation", screenWidth-420, screenHeight-91, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
		dxDrawText("Press Spacebar to Cancel Animation", screenHeight-165, screenHeight-93, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	end
end
addEventHandler("onClientRender", getRootElement(), onRender)