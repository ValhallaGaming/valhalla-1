objGated = createObject(1557, 295.12623901367, 189.35, 1006.171875, 0, 0, 0)
exports.pool:allocateElement(objGated)
setElementInterior(objGated, 3)
setElementDimension(objGated, 1)

objGated2 = createObject(1557, 298.12623901367, 189.35, 1006.171875, 0, 0, 180)
exports.pool:allocateElement(objGated2)
setElementInterior(objGated2, 3)
setElementDimension(objGated2, 1)

open = false

-- Gate code
function usePDDoor4(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(295.12623901367, 189.35, 1006.171875, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGated, 1000, 295.12623901367, 189.35, 1006.171875, 0, 0, -90)
			moveObject(objGated2, 1000, 298.12623901367, 189.35, 1006.171875, 0, 0, 90)
			setTimer(closePDDoor4, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor4)

function closePDDoor4(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGated, 1000, 295.12623901367, 189.35, 1006.171875, 0, 0, 90)
	moveObject(objGated2, 1000, 298.12623901367, 189.35, 1006.171875, 0, 0, -90)
	setTimer(resetState, 1000, 1)
end


function resetState()
	open = false
end