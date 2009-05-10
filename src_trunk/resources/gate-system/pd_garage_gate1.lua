objGateh = createObject(972, 2297.1805664063, 2509.133789063, 2.2734375, 0, 0, 180)
exports.pool:allocateElement(objGateh)

open = false

-- Green door
createObject(1492, 2293.8684082031, 2494.5129394531, 2.3734375, 0, 0, 270)

-- Gate code
function usePDSideGarageGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2297.1805664063, 2509.133789063, 2.2734375, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD Side Garage Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateh, 1000, 2297.1805664063, 2521.8940429688, 2.2734375)
			setTimer(closePDSideGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGarageGate)

function closePDSideGarageGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Side Garage Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGateh, 1000, 2297.1805664063, 2509.133789063, 2.2734375)
end