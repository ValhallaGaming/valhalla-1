-- Bind Keys required
function bindKeys(res)
	if (res==getThisResource()) then
		bindKey("p", "down", toggleFlashers)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function toggleFlashers()
	local veh = getPedOccupiedVehicle(getLocalPlayer())

	if (veh) then
		local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
		triggerServerEvent("toggleFlashers", getLocalPlayer(), x1, y1, z1, x2, y2, z2)
	end
end