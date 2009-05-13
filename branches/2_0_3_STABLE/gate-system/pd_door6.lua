objGatef = createObject(6400, 238.44337463379, 185.7231201172, 1002.5444946289, 0, 0, 90)
exports.pool:allocateElement(objGatef)
setElementInterior(objGatef, 3)
setElementDimension(objGatef, 1)

objGatef2 = createObject(6400, 238.44337463379, 185.731201172, 1004.5444946289, 0, 0, 90)
exports.pool:allocateElement(objGatef2)
setElementInterior(objGatef2, 3)
setElementDimension(objGatef2, 1)

objGatef3 = createObject(6400, 238.44337463379, 185.731201172, 1006.5444946289, 0, 0, 90)
setElementInterior(objGatef3, 3)
setElementDimension(objGatef3, 1)

open = false

-- Gate code
function usePDDoor6(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(238.44337463379, 185.7231201172, 1002.5444946289, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatef, 1000, 238.44337463379, 185.7231201172, 1010.5444946289)
			moveObject(objGatef2, 1000, 238.44337463379, 185.7231201172, 1010.5444946289)
			moveObject(objGatef3, 1000, 238.44337463379, 185.7231201172, 1010.5444946289)
			setTimer(closePDDoor6, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor6)

function closePDDoor6(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGatef, 1000, 238.44337463379, 185.7231201172, 1002.5444946289)
	moveObject(objGatef2, 1000, 238.44337463379, 185.7231201172, 1004.5444946289)
	moveObject(objGatef3, 1000, 238.44337463379, 185.7231201172, 1006.544494628)
end