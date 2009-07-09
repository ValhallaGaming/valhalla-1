local localPlayer = getLocalPlayer()
local show = true

function startRes(res)
	if (res==getThisResource()) then
		for key, value in ipairs(getElementsByType("player")) do
			setPlayerNametagShowing(value, false)
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), startRes)

function setNametagOnJoin()
	setPlayerNametagShowing(source, false)
end
addEventHandler("onClientPlayerJoin", getRootElement(), setNametagOnJoin)

function renderNametags()
	if (show) then
		for key, player in ipairs(getElementsByType("player")) do
			local lx, ly, lz = getElementPosition(localPlayer)
			local rx, ry, rz = getElementPosition(player)
			local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
			local limitdistance = 20
			local reconx = getElementData(localPlayer, "reconx")
			
			
			if (player~=localPlayer) and (isElementOnScreen(player)) and ((distance<limitdistance) or reconx) then
				local rreconx = getElementData(player, "reconx")

				if not (rreconx) then
					local lx, ly, lz = getPedBonePosition(localPlayer, 7)
					local vehicle = getPedOccupiedVehicle(player)
					local collision = processLineOfSight(lx, ly, lz+1, rx, ry, rz, true, true, false, true, false, false, true, false, vehicle)

					if not (collision) or (reconx) then
						local x, y, z = getPedBonePosition(player, 7)
						local sx, sy = getScreenFromWorldPosition(x, y, z+0.45, 100, false)
						
						-- HP
						if (sx) and (sy) then
							local health = getElementHealth(player)
							
							if (health>0) then
								distance = distance / 5
								
								if (distance<1) then distance = 1 end
								if (distance>2) then distance = 2 end
								if (reconx) then distance = 1 end
								
								local offset = 65 / distance
								
								-- DRAW BG
								dxDrawRectangle(sx-offset-5, sy, 150 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
								
								-- DRAW HEALTH
								local width = 140
								local hpsize = (width / 100) * health
								local barsize = (width / 100) * (100-health)
								
								local color
								if (health>70) then
									color = tocolor(0, 255, 0, 130)
								elseif (health>35 and health<=70) then
									color = tocolor(255, 255, 0, 130)
								else
									color = tocolor(255, 0, 0, 130)
								end
								
								if (distance<1.2) then
									dxDrawRectangle(sx-offset, sy+5, hpsize/distance, 10 / distance, color, false)
									dxDrawRectangle((sx-offset)+(hpsize/distance), sy+5, barsize/distance, 10 / distance, tocolor(162, 162, 162, 100), false)
								else
									dxDrawRectangle(sx-offset, sy+5, hpsize/distance-5, 10 / distance-3, tocolor(0, 255, 0, 130), false)
									dxDrawRectangle((sx-offset)+(hpsize/distance-5), sy+5, barsize/distance-5, 10 / distance-3, tocolor(162, 162, 162, 100), false)
								end
							end
						end
						
						-- ARMOR
						sx, sy = getScreenFromWorldPosition(x, y, z+0.25, 100, false)
						if (sx) and (sy) then
							local armor = getPedArmor(player)
							
							if (armor>0) then
								local offset = 65 / distance
								
								-- DRAW BG
								dxDrawRectangle(sx-offset-5, sy, 150 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
								
								-- DRAW HEALTH
								local width = 140
								local armorsize = (width / 100) * armor
								local barsize = (width / 100) * (100-armor)
								
								
								if (distance<1.2) then
									dxDrawRectangle(sx-offset, sy+5, armorsize/distance, 10 / distance, tocolor(197, 197, 197, 130), false)
									dxDrawRectangle((sx-offset)+(armorsize/distance), sy+5, barsize/distance, 10 / distance, tocolor(162, 162, 162, 100), false)
								else
									dxDrawRectangle(sx-offset, sy+5, armorsize/distance-5, 10 / distance-3, tocolor(197, 197, 197, 130), false)
									dxDrawRectangle((sx-offset)+(armorsize/distance-5), sy+5, barsize/distance-5, 10 / distance-3, tocolor(162, 162, 162, 100), false)
								end
							end
						end
						
						-- NAME
						sx, sy = getScreenFromWorldPosition(x, y, z+0.6, 100, false)
						
						if (sx) and (sy) then
							local offset = 65 / distance
							local scale = 0.6 / distance
							local font = "bankgothic"
							dxDrawText(getPlayerNametagText(player), sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "middle", false, false, false)
							dxDrawText(getPlayerNametagText(player), sx-offset, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "middle", false, false, false)
							
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderNametags)

function hideNametags()
	show = false
end
addEvent("hidenametags", true)
addEventHandler("hidenametags", getRootElement(), hideNametags)

function showNametags()
	show = true
end
addEvent("shownametags", true)
addEventHandler("shownametags", getRootElement(), showNametags)
