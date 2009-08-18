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
			setTimer(endPaintjobPreview, 15000, 1, veh)
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