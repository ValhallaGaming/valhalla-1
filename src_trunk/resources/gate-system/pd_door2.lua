objGateb = createObject(1557, 228.25027770996, 159.77064819336, 1002.0234375, 0, 0, 90)
exports.pool:allocateElement(objGateb)
setElementInterior(objGateb, 3)
setElementDimension(objGateb, 1)

objGateb2 = createObject(1557, 228.25027770996, 162.77064819336, 1002.0234375, 0, 0, 270)
exports.pool:allocateElement(objGateb2)
setElementInterior(objGateb2, 3)
setElementDimension(objGateb2, 1)

open = false

-- Gate code
function usePDDoor2(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(228.25027770996, 159.77064819336, 1002.0234375, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateb, 1000, 228.25027770996, 159.77064819336, 1002.0234375, 0, 0, 90)
			moveObject(objGateb2, 1000, 228.25027770996, 162.77064819336, 1002.0234375, 0, 0, -90)
			setTimer(closePDDoor2, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor2)

function closePDDoor2(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGateb, 1000, 228.25027770996, 159.77064819336, 1002.0234375, 0, 0, -90)
	moveObject(objGateb2, 1000, 228.25027770996, 162.77064819336, 1002.0234375, 0, 0, 90)
	setTimer(resetState, 1000, 1)
end


function resetState()
	open = false
end