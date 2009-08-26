local objDivGate1 = createObject(3089, 244.9, 72.4765625, 1003.940625, 0, 0, 0)
exports.pool:allocateElement(objDivGate1)
setElementInterior(objDivGate1, 6)
setElementDimension(objDivGate1, 681)

local objDivGate2 = createObject(3089, 247.9, 72.4765625, 1003.940625, 0, 0, 180)
exports.pool:allocateElement(objDivGate2)
setElementInterior(objDivGate2, 6)
setElementDimension(objDivGate2, 681) -- 1557

local open = false

-- Gate code
function usePDDivDoor1(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(247.9, 72.4765625, 1002.640625, x, y, z)

		if (distance<=5) and (open==false) then
			open = true
			outputChatBox("LVMPD South-East Division Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objDivGate1, 1000, 244.9, 72.4765625, 1003.940625, 0, 0, 90)
			moveObject(objDivGate2, 1000, 247.9, 72.4765625, 1003.940625, 0, 0, -90)
			setTimer(closePDDivDoor1, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDivDoor1)

function closePDDivDoor1(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD South-East Division Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objDivGate1, 1000, 244.9, 72.4765625, 1003.940625, 0, 0, -90)
	moveObject(objDivGate2, 1000, 247.9, 72.4765625, 1003.940625, 0, 0, 90)
	setTimer(resetState11, 1000, 1)
end


function resetState11()
	open = false
end