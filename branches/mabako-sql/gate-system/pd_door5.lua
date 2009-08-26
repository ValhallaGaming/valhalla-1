local objGatee = createObject(3089, 274.12623901367, 189.35, 1007.471875, 0, 0, 0)
exports.pool:allocateElement(objGate3)
setElementInterior(objGatee, 3)
setElementDimension(objGatee, 1)

local objGatee2 = createObject(3089, 277.02623901367, 189.35, 1007.471875, 0, 0, 180)
exports.pool:allocateElement(objGatee2)
setElementInterior(objGatee2, 3)
setElementDimension(objGatee2, 1)

local open = false

-- Gate code
function usePDDoor5(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(274.12623901367, 189.35, 1006.171875, x, y, z)

		if (distance<=5) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatee, 1000, 274.12623901367, 189.35, 1007.471875, 0, 0, -90)
			moveObject(objGatee2, 1000, 277.02623901367, 189.35, 1007.471875, 0, 0, 90)
			setTimer(closePDDoor5, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor5)

function closePDDoor5(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatee, 1000, 274.12623901367, 189.35, 1007.471875, 0, 0, 90)
	moveObject(objGatee2, 1000, 277.02623901367, 189.35, 1007.471875, 0, 0, -90)
	setTimer(resetState5, 1000, 1)
end


function resetState5()
	open = false
end