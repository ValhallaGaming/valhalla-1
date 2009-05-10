objGatea = createObject(1557, 228.25027770996, 149.77064819336, 1002.0234375, 0, 0, 90)
exports.pool:allocateElement(objGatea)
setElementInterior(objGatea, 3)
setElementDimension(objGatea, 1)

objGatea2 = createObject(1557, 228.25027770996, 152.77064819336, 1002.0234375, 0, 0, 270)
exports.pool:allocateElement(objGatea2)
setElementInterior(objGatea2, 3)
setElementDimension(objGatea2, 1)

open = false

-- Gate code
function usePDDoor(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(228.25027770996, 149.77064819336, 1002.0234375, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatea, 1000, 228.25027770996, 149.77064819336, 1002.0234375, 0, 0, 90)
			moveObject(objGatea2, 1000, 228.25027770996, 152.77064819336, 1002.0234375, 0, 0, -90)
			setTimer(closePDDoor, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor)

function closePDDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatea, 1000, 228.25027770996, 149.77064819336, 1002.0234375, 0, 0, -90)
	moveObject(objGatea2, 1000, 228.25027770996, 152.77064819336, 1002.0234375, 0, 0, 90)
	setTimer(resetState, 1000, 1)
end


function resetState()
	open = false
end