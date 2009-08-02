local objGatefbi1 = createObject(976, 2478.5185546875, 2513.1103515625, 9.911926841736, 0, 0, 90)
exports.pool:allocateElement(objGatefbi1)

local objGatefbi2 = createObject(976, 2478.5185546875, 2504.3103515625, 9.911926841736, 0, 0, 90)
exports.pool:allocateElement(objGatefbi2)

local open = false

-- Gate code
function useFBISideGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Federal Bureau of Investigation")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2478.5185546875, 2513.1103515625, 9.911926841736, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("FBI Side Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatefbi1, 1000, 2478.5185546875, 2519.1103515625, 9.911926841736, 0, 0, 0)
			moveObject(objGatefbi2, 1000, 2478.5185546875, 2497.1103515625, 9.911926841736, 0, 0, 0)
			setTimer(closeFBISideGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useFBISideGate)

function closeFBISideGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("FBI Side Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGatefbi1, 1000, 2478.5185546875, 2513.1103515625, 9.911926841736, 0, 0, 0)
	moveObject(objGatefbi2, 1000, 2478.5185546875, 2504.3103515625, 9.911926841736, 0, 0, 0)
end