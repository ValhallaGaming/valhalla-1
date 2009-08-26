-- BARRIER
local objDivision1 = createObject(968, 2303.1500078125, 623.0060546875, 10.704789924622, 0, 90, 0)
exports.pool:allocateElement(objDivision1)

local open = false

-- Gate code
function usePDBarrier(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2303.1500078125, 623.0060546875, 10.704789924622, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD South-East Division Barrier is now Open!", thePlayer, 0, 255, 0)
			moveObject(objDivision1, 1000, 2303.1500078125, 623.0060546875, 10.704789924622, 0, -90, 0)
			setTimer(closePDBarrier, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDBarrier)

function closePDBarrier(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD South-East Division Barrier is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState10, 1000, 1)
	moveObject(objDivision1, 1000,2303.1500078125, 623.0060546875, 10.704789924622, 0, 90, 0)
end

function resetState10()
	open = false
end