sound = nil
blaster = nil

function elementStreamIn()
	if (getElementType(source)=="object") then
		local model = getElementModel(source)
		if (model==2226) then
			local x, y, z = getElementPosition(source)
			
			if (blaster==nil) then
				blaster = source
				sound = playSound3D("ghettoblaster/loop.mp3", x, y, z, true)
				
				if (isPedInVehicle(getLocalPlayer())) then
					setSoundVolume(sound, 0.5)
				end
			end
		end
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), elementStreamIn)

function elementStreamOut()
	if (blaster~=nil) then
		if (source==blaster) then
			blaster = nil
			stopSound(sound)
			sound = nil
		end
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), elementStreamOut)
addEventHandler("onClientElementDestroy", getRootElement(), elementStreamOut)

function dampenSound(thePlayer)
	if (thePlayer==getLocalPlayer()) and (isElement(sound)) then
		setSoundVolume(sound, 0.5)
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), dampenSound)

function boostSound(thePlayer)
	if (thePlayer==getLocalPlayer()) and (isElement(sound)) then
		setSoundVolume(sound, 1.0)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), boostSound)