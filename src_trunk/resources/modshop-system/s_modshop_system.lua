local modShape = createColSphere(2386.2431640625, 1049.4853515625, 10.8203125, 10)

function startModding(element, matchingDimension)
	if (getElemenType(element)=="vehicle" and matchingDimension) then
		local upgrades = getVehicleCompatibleUpgrades(element)
		local thePlayer = getVehicleController(element)
		
		if (thePlayer) then
			if (#upgrades==0) then
				outputChatBox("This vehicle can not be modded.", 255, 0, 0)
			else
				triggerClientEvent(thePlayer, "startModding", thePlayer, upgrades)
			end
		end
	end
end