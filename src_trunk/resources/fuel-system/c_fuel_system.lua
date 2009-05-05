fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

pFuel, lFuel = nil

function resourceStarted(res)
	if (res==getThisResource()) then
		pFuel = guiCreateProgressBar(0.425, 0.85, 0.2, 0.035, true)
		lFuel = guiCreateLabel(0.425, 0.85, 0.2, 0.035, "Fuel:", true)
		guiLabelSetColor(lFuel, 0, 0, 0)
		guiSetFont(lFuel, "default-bold-small")
		guiLabelSetHorizontalAlign(lFuel, "center")
		guiLabelSetVerticalAlign(lFuel, "center")
		guiSetVisible(pFuel, false)
		guiSetVisible(lFuel, false)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resourceStarted)

function vehicleEnter(thePlayer, seat)
	if (seat==0) and (thePlayer==getLocalPlayer()) then
		local model = getElementModel(source)
		if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
			local fuel = getElementData(source, "fuel")
			
			setPlayerFuel(fuel)
			--guiSetVisible(pFuel, true)
			--guiSetVisible(lFuel, true)
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), vehicleEnter)

function vehicleExit(thePlayer, seat)
	if (seat==0) and (thePlayer==getLocalPlayer()) then
		guiSetVisible(pFuel, false)
		guiSetVisible(lFuel, false)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), vehicleExit)

function playerDied()
	if(source==getLocalPlayer()) then
		guiSetVisible(pFuel, false)
		guiSetVisible(lFuel, false)
	end
end
addEventHandler("onClientPedWasted", getRootElement(), playerDied)

function setPlayerFuel(fuel)
	guiProgressBarSetProgress(pFuel, tonumber(fuel))
	
	if(math.floor(tonumber(fuel))<1) then 
		guiSetText(lFuel, "Fuel: Empty!")
	else
		guiSetText(lFuel, "Fuel: " .. math.floor(fuel) .. " Litres.")
	end
end

addEvent("setClientFuel", true )
addEventHandler("setClientFuel", getRootElement(), setPlayerFuel, fuel)

function removeFuelBar()
	if not (isPedInVehicle(getLocalPlayer())) and (guiGetVisible(pFuel)) then
		guiSetVisible(pFuel, false)
		guiSetVisible(lFuel, false)
	end
end
setTimer(removeFuelBar, 1000, 0)