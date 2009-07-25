local objGatei = createObject(976, 2237.5334472656, 2448.87109375, 9.8203125, 0, 0, 90)
exports.pool:allocateElement(objGatei)
local objGatei2 = createObject(976, 2237.5334472656, 2448.87109375, 12.8203125, 0, 0, 90)
exports.pool:allocateElement(objGatei2)

local open = false

-- Gate code
function usePDSideGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2237.5334472656, 2448.87109375, 9.8203125, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD Side Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatei, 1000, 2237.5334472656, 2438.37109375, 9.9203125)
			moveObject(objGatei2, 1000, 2237.5334472656, 2438.37109375, 12.8203125)
			setTimer(closePDSideGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGate)

function closePDSideGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Side Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState9, 1000, 1)
	moveObject(objGatei, 1000, 2237.5334472656, 2448.87109375, 9.8203125)
	moveObject(objGatei2, 1000, 2237.5334472656, 2448.87109375, 12.8203125)
end

function resetState9()
	open = false
end