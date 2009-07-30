local blip

function resetTaxiJob()
	if (isElement(blip)) then
		destroyElement(blip)
		removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
	end
end

function displayTaxiJob()
	blip = createBlip(1771.537109375, -1858.5126953125, 12, 0, 4, 255, 127, 255)
	outputChatBox("#FF9933Approach the #FF66CCblip#FF9933 on your radar and enter the taxi to start your job.", 255, 194, 15, true)
	addEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
end

function startTaxiJob(thePlayer)
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==438 or getElementModel(source)==420) then
			removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
			outputChatBox("You will be alerted when someone has ordered a taxi.", 255, 194, 15)
			if (isElement(blip)) then
				destroyElement(blip)
			end
		end
	end
end