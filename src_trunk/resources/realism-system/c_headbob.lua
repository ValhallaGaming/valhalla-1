function bobHead()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	
	if (logged==1) then
		for key, value in ipairs(getElementsByType("player")) do
            if value == getLocalPlayer() then
                local scrWidth, scrHeight = guiGetScreenSize()
        		local sx = scrWidth/2
        		local sy = scrHeight/2
        		local x, y, z = getWorldFromScreenPosition(sx, sy, 10)
        		setPedLookAt(value, x, y, z, 3000)
            else
                local rot = getPedCameraRotation(value)
    			local x, y, z = getElementPosition(value)
    			local vx = x + math.sin(math.rad(rot)) * 10
    			local vy = y + math.cos(math.rad(rot)) * 10
    			setPedLookAt(value, vx, vy, z, 3000)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), bobHead)