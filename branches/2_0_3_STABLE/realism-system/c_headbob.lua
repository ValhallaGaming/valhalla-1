cooldown = false
tmrCooldown = nil

function bobHead()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	
	if (logged==1) then
		local scrWidth, scrHeight = guiGetScreenSize()
		local sx = scrWidth/2
		local sy = scrHeight/2
		local x, y, z = getWorldFromScreenPosition(sx, sy, 10)
		
		setPedLookAt(getLocalPlayer(), x, y, z, -1, 50)
		
		if not (cooldown) then
			--triggerServerEvent("syncHead", getLocalPlayer(), x, y, z)
			cooldown = true
			tmrCooldown = setTimer(resetCooldown, 1000, 1)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), bobHead)

function resetCooldown()
	cooldown = false
end

function csyncHeadBob(player, x, y, z)
	setPedLookAt(player, x, y, z, -1)
end
addEvent("cSyncHead", true)
addEventHandler("cSyncHead", getRootElement(), csyncHeadBob)