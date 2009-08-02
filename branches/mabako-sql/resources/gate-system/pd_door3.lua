local objGatec = createObject(3089, 229.92783508301, 169.94030761719, 1003.3234375, 0, 0, 0)
exports.pool:allocateElement(objGatec)
setElementInterior(objGatec, 3)
setElementDimension(objGatec, 1)

local objGatec2 = createObject(3089, 232.82783508301, 169.94030761719, 1003.3234375, 0, 0, 180)
exports.pool:allocateElement(objGatec2)
setElementInterior(objGatec2, 3)
setElementDimension(objGatec2, 1)

local open = false

-- Gate code
function usePDDoor3(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(229.92783508301, 169.94030761719, 1002.0234375, x, y, z)

		if (distance<=5) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatec, 1000, 229.92783508301, 169.94030761719, 1003.3234375, 0, 0, -90)
			moveObject(objGatec2, 1000, 232.82783508301, 169.94030761719, 1003.3234375, 0, 0, 90)
			setTimer(closePDDoor3, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor3)

function closePDDoor3(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatec, 1000, 229.92783508301, 169.94030761719, 1003.3234375, 0, 0, 90)
	moveObject(objGatec2, 1000, 232.82783508301, 169.94030761719, 1003.3234375, 0, 0, -90)
	setTimer(resetState3, 1000, 1)
end


function resetState3()
	open = false
end