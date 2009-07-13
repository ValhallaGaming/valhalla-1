local localPlayer = getLocalPlayer()
local sounds = { }

function createSiren(thePlayer, seat)
	if (getVehicleSirensOn(source) and (seat==0)) then
		local x, y, z = getElementPosition(source)
		local sound = playSound3D("siren.wav", x, y, z, true)
		setSoundVolume(sound, 0.6)
		setElementData(source, "siren", sound)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), createSiren)

function createSiren(thePlayer, seat)
	if (getVehicleSirensOn(source) and (seat==0)) then
		local sound = getElementData(source, "siren")
		stopSound(sound)
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), createSiren)