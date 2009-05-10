objGatee = createObject(1557, 274.12623901367, 189.35, 1006.171875, 0, 0, 0)
exports.pool:allocateElement(objGate3)
setElementInterior(objGatee, 3)
setElementDimension(objGatee, 1)

objGatee2 = createObject(1557, 277.12623901367, 189.35, 1006.171875, 0, 0, 180)
exports.pool:allocateElement(objGatee2)
setElementInterior(objGatee2, 3)
setElementDimension(objGatee2, 1)

open = false

-- Gate code
function usePDDoor5(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(274.12623901367, 189.35, 1006.171875, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatee, 1000, 274.12623901367, 189.35, 1006.171875, 0, 0, -90)
			moveObject(objGatee2, 1000, 277.12623901367, 189.35, 1006.171875, 0, 0, 90)
			setTimer(closePDDoor5, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor5)

function closePDDoor5(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatee, 1000, 274.12623901367, 189.35, 1006.171875, 0, 0, 90)
	moveObject(objGatee2, 1000, 277.12623901367, 189.35, 1006.171875, 0, 0, -90)
	setTimer(resetState, 1000, 1)
end


function resetState()
	open = false
end