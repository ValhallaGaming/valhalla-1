gInteriorName, gOwnerName, gBuyMessage = nil

timer = nil

-- Message on enter
function showIntName(name, ownerName, inttype, cost, fee)
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
	
	if name then
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
			local msg = "Press F to enter."
			if fee and fee > 0 then
				msg = "Entrance Fee: $" .. fee
				
				if exports.global:hasMoney( getLocalPlayer(), fee ) then
					msg = msg .. "\nPress F to enter."
				end
			end
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		end
		
		timer = setTimer(fadeMessage, 50, 20, true)
	end
end

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gInteriorName)
	
	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		guiSetAlpha(gInteriorName, newalpha)
		guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 4000, 1)
		end
	elseif (alpha) then
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

-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)
		
		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	for key, value in ipairs(interiors) do
		local inttype = interiors[key][1]
		local x = interiors[key][2]
		local y = interiors[key][3]
		
		createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", getRootElement(), createBlipsFromTable)

function createBlipAtXY(inttype, x, y)
	if inttype == 3 then inttype = 0 end
	createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", getRootElement(), createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= 'number' then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)
		
		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", getRootElement(), removeBlipAtXY)