
function bobHead()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	
	if (logged==1) then
        local scrWidth, scrHeight = guiGetScreenSize()
        local sx = scrWidth/2
        local sy = scrHeight/2
        local x, y, z = getWorldFromScreenPosition(sx, sy, 10)
        setPedLookAt(getLocalPlayer(), x, y, z, 3000)
	end
end
addEventHandler("onClientRender", getRootElement(), bobHead)

function resetCam()
	setCameraTarget(getLocalPlayer())
end
addCommandHandler("resetcam", resetCam)