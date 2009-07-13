local marker = nil
local blip = nil
function createHunterMarkers()
	blip = createBlip(1108.7441, 1903.98535, 9.52469, 0, 4, 255, 127, 255) -- No blip. The player should know where the garage is from when they met Hunter to get the job.
	marker = createMarker(1108.7441, 1903.98535, 9.52469, "cylinder", 4, 255, 127, 255, 150)
	addEventHandler("onClientMarkerHit", marker, dropOffCar, false)
end
addEvent("createHunterMarkers", true)
addEventHandler("createHunterMarkers", getRootElement(), createHunterMarkers)

function dropOffCar(player, dimension)
	if (dimension) and (player==getLocalPlayer()) then
		triggerServerEvent("dropOffCar", getLocalPlayer())
	end
end

function jackerCleanup()
	if (isElement(blip)) then destroyElement(blip) end
	if (isElement(marker)) then destroyElement(marker) end
end
addEvent("jackerCleanup", true)
addEventHandler("jackerCleanup", getRootElement(), jackerCleanup)