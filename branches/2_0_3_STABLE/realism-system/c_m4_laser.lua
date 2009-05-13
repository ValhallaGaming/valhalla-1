function showLaser(key, state)
	if (state=="down") then
		local weapon = getPedWeapon(getLocalPlayer())
		if (weapon==31) then
			addEventHandler("onClientRender", getRootElement(), drawLaser)
		end
	else
		setCameraTarget(getLocalPlayer(), getLocalPlayer())
		removeEventHandler("onClientRender", getRootElement(), drawLaser)
	end
end

function drawLaser()
	local width, height = guiGetScreenSize ()
	local x, y, z = getWorldFromScreenPosition(width/2, height/2, 1000)
	local px, py, pz = getPedBonePosition(getLocalPlayer(), 25)
	local rot = getPedRotation(getLocalPlayer())
	
	px, py, pz = getPedBonePosition(getLocalPlayer(), 25)
	rot = getPedRotation(getLocalPlayer())
	x = x - math.sin( math.rad( rot ) ) * 1.5
	y = y - math.cos( math.rad( rot ) ) * 1.5
	
	px = px - math.sin( math.rad( rot ) ) * 1.2
	py = py - math.cos( math.rad( rot ) ) * 1.2
	
	pz = pz + 0.25
	
	px = px - math.sin( math.rad( rot ) ) +0.28
	py = py - math.cos( math.rad( rot ) )
	dxDrawLine3D(px, py, pz, x, y, z, tocolor(255, 0, 0, 200))
end

function resourceStart(res)
	if (res==getThisResource()) then
		bindKey("aim_weapon", "down", showLaser)
		bindKey("aim_weapon", "up", showLaser)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resourceStart)

function resourceStop(res)
	if (res==getThisResource()) then
		unbindKey("aim_weapon", "down", showLaser)
		unbindKey("aim_weapon", "up", showLaser)
	end
end
addEventHandler("onClientResourceStop", getRootElement(), resourceStop)

