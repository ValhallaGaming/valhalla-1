function showLaser()
	for key, value in ipairs(getElementsByType("player")) do
		local weapon = getPedWeapon(value)
		
		if (weapon==24 or weapon==29 or weapon==31 or weapon==34) then
			local laser = getElementData(value, "laser")
			
			if (laser==1) then
				local sx, sy, sz = getPedTargetStart(value)
				local ex, ey, ez = getPedTargetEnd(value)
				local task = getPedTask(value, "secondary", 0)

				if (task=="TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(value)) then
					local collision, cx, cy, cz, element = processLineOfSight(sx, sy, sz, ex, ey, ez, true, true, true, true, true, false, false, false)
					
					if not (collision) then
						cx = ex
						cy = ey
						cz = ez
					end
					
					if (isPedDucked(value)) then
						if (value==getLocalPlayer()) then
							local sx, sy, sz = getPedBonePosition(value, 35)
							dxDrawLine3D(sx, sy, sz, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
						else
							dxDrawLine3D(sx, sy, sz-0.4, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
						end
					else
						if (value==getLocalPlayer()) then
							local sx, sy, sz = getPedBonePosition(value, 35)
							dxDrawLine3D(sx, sy, sz, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
						else
							dxDrawLine3D(sx, sy, sz-0.1, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showLaser)

setElementData(getLocalPlayer(), "laser", true, 1)

function toggleLaser()
	local laser = getElementData(getLocalPlayer(), "laser")
	
	if (laser==0) then
		setElementData(getLocalPlayer(), "laser", true, 1)
		outputChatBox("Your weapon laser is now ON.", 0, 255, 0)
	else
		setElementData(getLocalPlayer(), "laser", true, 0)
		outputChatBox("Your weapon laser is now OFF.", 255, 0, 0)
	end
end
addCommandHandler("toglaser", toggleLaser, false)
addCommandHandler("togglelaster", toggleLaser, false)