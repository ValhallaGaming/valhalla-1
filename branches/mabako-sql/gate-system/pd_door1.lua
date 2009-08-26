local objGatea = createObject(3089, 244.90234375, 72.533984375, 1003.640625, 0, 0, 0)
exports.pool:allocateElement(objGatea)
setElementInterior(objGatea, 6)
setElementDimension(objGatea, 1)

local objGatea2 = createObject(3089, 247.80234375, 72.533984375, 1003.640625, 0, 0, 180)
exports.pool:allocateElement(objGatea2)
setElementInterior(objGatea2, 6)
setElementDimension(objGatea2, 1)

local open = false

-- Gate code
function usePDDoor(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Los Santos Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(244.90234375, 72.533984375, 1003.640625, x, y, z)

		if (distance<=5) and (open==false) then
			open = true
			outputChatBox("LSPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatea, 1000, 244.90234375, 72.533984375, 1003.640625, 0, 0, 90)
			moveObject(objGatea2, 1000, 247.80234375, 72.533984375, 1003.640625, 0, 0, -90)
			setTimer(closePDDoor, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor)

function closePDDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LSPD Door is now Closed!", thePlayer, 255, 0, 0)
	end

	moveObject(objGatea, 1000, 244.90234375, 72.533984375, 1003.640625, 0, 0, -90)
	moveObject(objGatea2, 1000, 247.80234375, 72.533984375, 1003.640625, 0, 0, 90)

	setTimer(resetState1, 1000, 1)
end


function resetState1()
	open = false
end