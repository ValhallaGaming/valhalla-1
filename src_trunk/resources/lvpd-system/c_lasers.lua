function showLaser()
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) and (isElementStreamedIn(value)) then
			local weapon = getPedWeapon(value)
			
			if (weapon==24 or weapon==29 or weapon==31 or weapon==34) then
				local laser = getElementData(value, "laser")
				local deaglemode = getElementData(value, "deaglemode")

				if (laser == false) and (deaglemode==nil or deaglemode==0) then
					local sx, sy, sz = getPedWeaponMuzzlePosition(value)
					local ex, ey, ez = getPedTargetEnd(value)
					local task = getPedTask(value, "secondary", 0)

					if (task=="TASK_SIMPLE_USE_GUN") then --(task=="TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(value)) then
						local collision, cx, cy, cz, element = processLineOfSight(sx, sy, sz, ex, ey, ez, true, true, true, true, true, false, false, false)
						
						if not (collision) then
							cx = ex
							cy = ey
							cz = ez
						end
						
						dxDrawLine3D(sx, sy, sz-0.05, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showLaser)