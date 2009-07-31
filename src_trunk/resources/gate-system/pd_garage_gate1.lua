local objGateh = createObject(968, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 90)
exports.pool:allocateElement(objGateh)

createObject(970, 1544.318359375, -1621.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1619.5888671875, 13, 0, 0, 90)

createObject(970, 1544.318359375, -1634.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1637.5888671875, 13, 0, 0, 90)

local open = false

-- Gate code
function usePDSideGarageGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Los Santos Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(1544.6875, -1630.785546875, 13.1828125, x, y, z)
		
		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LSPD Barrier is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateh, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, -90, 0)
			setTimer(closePDSideGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGarageGate)

function closePDSideGarageGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LSPD Barrier is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState7, 1000, 1)
	moveObject(objGateh, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 0)
end

function resetState7()
	open = false
end