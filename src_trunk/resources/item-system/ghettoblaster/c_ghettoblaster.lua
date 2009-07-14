blasters = { }
local localPlayer = getLocalPlayer()

function elementStreamIn()
	if (getElementType(source)=="object") then
		local model = getElementModel(source)
		if (model==2226) then
			local x, y, z = getElementPosition(source)
			local px, py, pz = getElementPosition(localPlayer)
			
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz)<300) then
				local sound = playSound3D("ghettoblaster/loop.mp3", x, y, z, true)
				blasters[source] = sound
				setSoundMaxDistance(sound, 20)
				
				if (isPedInVehicle(getLocalPlayer())) then
					setSoundVolume(sound, 0.5)
				end
			end
		end
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), elementStreamIn)

function elementStreamOut()
	if (blasters[source]~=nil) then
		local sound = blasters[source]
		stopSound(sound)
		blasters[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), elementStreamOut)
addEventHandler("onClientElementDestroy", getRootElement(), elementStreamOut)

function dampenSound(thePlayer)
	for key, value in pairs(blasters) do
		setSoundVolume(value, 0.5)
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), dampenSound)

function boostSound(thePlayer)
	for key, value in pairs(blasters) do
		setSoundVolume(value, 1.0)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), boostSound)