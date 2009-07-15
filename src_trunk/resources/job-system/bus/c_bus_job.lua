local blip

function resetBusJob()
	if (isElement(blip)) then
		destroyElement(blip)
	end
end

function displayBusJob()
	blip = createBlip(1902.5610351563, 2319.673828125, 11.024569511414, 0, 4, 255, 127, 255)
	outputChatBox("#FF9933Approach the #FF66CCblip#FF9933 on your radar and enter the bus/coach to start your job.", 255, 194, 15, true)
	addEventHandler("onClientVehicleEnter", getRootElement(), startBusJob)
end

function startBusJob(thePlayer)
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==431 or getElementModel(source)==437) then
			removeEventHandler("onClientVehicleEnter", getRootElement(), startBusJob)
			if (isElement(blip)) then
				destroyElement(blip)
			end
		end
	end
end