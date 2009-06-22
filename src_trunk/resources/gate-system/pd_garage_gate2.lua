local objGateg = createObject(3055, 2335.5135253906, 2443.5122070313, 6.9781973838806, 0, 0, 240)
exports.pool:allocateElement(objGateg)

local open = false

-- Gate code
function usePDFrontGarageGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2331.6135253906, 2444.0122070313, 4.6781973838806, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD Front Garage Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateg, 1000, 2335.5135253906, 2443.5122070313, 9.8781973838806, 90, 0, 0)
			setTimer(closePDFrontGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDFrontGarageGate)

function closePDFrontGarageGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Front Garage Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGateg, 1000, 2335.5135253906, 2443.5122070313, 6.9781973838806, -90, 0, 0)
end