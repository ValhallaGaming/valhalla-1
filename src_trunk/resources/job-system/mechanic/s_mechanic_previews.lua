function previewColors( veh, color1, color2, color3, color4 )
	if veh then
		if not getElementData( veh, "oldcolors" ) then
			setElementData( veh, "oldcolors", { getVehicleColor( veh ) }, false )
		end
		local col = getElementData( veh, "oldcolors" )
		color1 = color1 or col[1]
		color2 = color2 or col[2]
		color3 = color3 or col[3]
		color4 = color4 or col[4]
		if setVehicleColor( veh, color1, color2, color3, color4 ) then
			setTimer(endColorPreview, 45000, 1, veh)
		end
	end
end
addEvent("colorPreview", true)
addEventHandler("colorPreview", getRootElement(), previewColors)

function endColorPreview( veh )
	if veh then
		local colors = getElementData( veh, "oldcolors" )
		if colors then
			setVehicleColor( veh, unpack( colors ) )
			removeElementData( veh, "oldcolors" )
		end
	end
end
addEvent("colorEndPreview", true)
addEventHandler("colorEndPreview", getRootElement(), endColorPreview)

function previewPaintjob( veh, paintjob )
	if veh then
		if not getElementData( veh, "oldpaintjob" ) then
			setElementData( veh, "oldpaintjob", getVehiclePaintjob( veh ), false )
		end
		if setVehiclePaintjob( veh, paintjob ) then
			local col1, col2 = getVehicleColor( veh )
			if col1 == 0 or col2 == 0 then
				if not getElementData( veh, "oldcolors" ) then
					setElementData( veh, "oldcolors", { getVehicleColor( veh ) }, false )
				end
				setVehicleColor( veh, 1, 1, 1, 1 )
			end
			setTimer(endPaintjobPreview, 45000, 1, veh)
		end
	end
end
addEvent("paintjobPreview", true)
addEventHandler("paintjobPreview", getRootElement(), previewPaintjob)

function endPaintjobPreview( veh )
	if veh then
		local paintjob = getElementData( veh, "oldpaintjob" )
		if paintjob then
			setVehiclePaintjob( veh, paintjob )
			removeElementData( veh, "oldpaintjob" )
		end
		local colors = getElementData( veh, "oldcolors" )
		if colors then
			setVehicleColor( veh, unpack( colors ) )
			removeElementData( veh, "oldcolors" )
		end
	end
end
addEvent("paintjobEndPreview", true)
addEventHandler("paintjobEndPreview", getRootElement(), endPaintjobPreview)

function previewUpgrade( veh, upgrade, slot )
	if veh then
		if not getElementData( veh, "oldupgrade" .. slot ) then
			setElementData( veh, "oldupgrade" .. slot, getVehicleUpgradeOnSlot( veh, slot ), false )
		end
		if addVehicleUpgrade( veh, upgrade ) then
			setTimer(endUpgradePreview, 45000, 1, veh, slot)
		end
	end
end
addEvent("upgradePreview", true)
addEventHandler("upgradePreview", getRootElement(), previewUpgrade)

function endUpgradePreview( veh, slot )
	if veh then
		local upgrade = getElementData( veh, "oldupgrade" .. slot )
		if upgrade then
			if upgrade == 0 then
				removeVehicleUpgrade( veh, getVehicleUpgradeOnSlot( veh, slot ) )
			else
				addVehicleUpgrade( veh, upgrade )
			end
			removeElementData( veh, "oldupgrade" .. slot )
		end
	end
end
addEvent("upgradeEndPreview", true)
addEventHandler("upgradeEndPreview", getRootElement(), endUpgradePreview)
