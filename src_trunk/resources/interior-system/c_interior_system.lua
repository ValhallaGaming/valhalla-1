gInteriorName, gOwnerName, gBuyMessage = nil

timer = nil

-- Message on enter
function showIntName(name, ownerName, inttype, cost)
	if (guiGetVisible(gInteriorName)) then
		killTimer(timer)
		destroyElement(gInteriorName)
		gInteriorName = nil
			
		destroyElement(gOwnerName)
		gOwnerName = nil
			
		if (gBuyMessage) then
			destroyElement(gBuyMessage)
			gBuyMessage = nil
		end
	end
		if (inttype==3) then -- Interior name and Owner for rented
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
		
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Rented by: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
		
		else -- Interior name and Owner for the rest
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
			
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Owner: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
		end
		if (ownerName=="None") and (inttype==3) then -- Unowned type 3 (rentable)
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to rent for $" .. tostring(cost) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		elseif (ownerName=="None") and (inttype<2) then -- Unowned any other type
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to buy for $" .. tostring(cost) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		else
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to enter.", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		end
		
		timer = setTimer(fadeMessage, 50, 20, true)
end

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gInteriorName)
	
	if (fadein) then
		local newalpha = alpha + 0.05
		guiSetAlpha(gInteriorName, newalpha)
		guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 4000, 1)
		end
	else
		local newalpha = alpha - 0.05
		guiSetAlpha(gInteriorName, newalpha)
		guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if(newalpha<=0.0) then
			destroyElement(gInteriorName)
			gInteriorName = nil
			
			destroyElement(gOwnerName)
			gOwnerName = nil
			
			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", getRootElement(), showIntName)