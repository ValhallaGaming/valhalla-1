local objGateg = createObject(3055, 1588.5490234375, -1637.95546875, 13.846516990662, 0, 0, 180)
exports.pool:allocateElement(objGateg)

createObject(3055, 1580.5490234375, -1637.95546875, 13.446516990662, 0, 0, 180)

local open = false

-- Gate code
function usePDFrontGarageGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Los Santos Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(1588.5490234375, -1637.95546875, 13.446516990662, x, y, z)
		
		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LSPD Garage is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateg, 1000, 1588.5490234375, -1637.95546875, 16.446516990662, -90, 0, 0)
			setTimer(closePDFrontGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDFrontGarageGate)

function closePDFrontGarageGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LSPD Garage is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState8, 1000, 1)
	moveObject(objGateg, 1000, 1588.5490234375, -1637.95546875, 13.846516990662, 90, 0, 0)
end

function resetState8()
	open = false
end