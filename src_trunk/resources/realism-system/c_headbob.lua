function bobHead()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	
	if (logged==1) then
		for key, value in ipairs(getElementsByType("player")) do
			local rot = getPedCameraRotation(value)
			local x, y, z = getElementPosition(value)
			local vx = x + math.sin(math.rad(rot)) * 10
			local vy = y + math.cos(math.rad(rot)) * 10
			setPedLookAt(value, vx, vy, 10, 3000)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), bobHead)