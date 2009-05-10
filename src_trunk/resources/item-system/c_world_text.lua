function showWorldText()
	local x, y, z = getElementPosition(getLocalPlayer())
	local colsphere = createColSphere(x, y, z, 10)
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("object")) do
		local ox, oy, oz = getElementPosition(value)
		if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<20) then
			local objtype = getElementData(value, "type")
			if (objtype) then
				if (objtype=="worlditem") then
					local collision, cx, cy, cz = processLineOfSight(x, y, z, ox, oy, oz, true, false, false, false, false, false)
					
					if not (collision) then
						local sx, sy = getScreenFromWorldPosition(ox, oy, oz+1)
						local sx2, sy2 = getScreenFromWorldPosition(ox, oy, oz+0.1)
						local itemName = getElementData(value, "itemName")
						if (sx) and (sy) then
							dxDrawText(tostring(itemName) .. " -  Click to Pick up!", sx-150, sy, sx+150, sy, tocolor(255, 255, 255, 255), 1, "pricedown", "center", "top", false, false, false)
							dxDrawLine(sx-150, sy+35, sx+150, sy+35, tocolor(255, 255, 255, 255, 1, false))
						end
					end
				end
			end
		end
	end
end
--addEventHandler("onClientPreRender", getRootElement(), showWorldText)