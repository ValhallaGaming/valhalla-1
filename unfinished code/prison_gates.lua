function resetState()
	open = false
end

---------------------
-- Exterior gate 1 --
---------------------
objGatea = createObject(7657, 1071.1484, 1361.8896, 11.5154, 0, 0, 180)
exports.pool:allocateElement(objGatea)
setElementInterior(objGatea, 0)
setElementDimension(objGatea, 0)

-- Gate code
function usePrisonGate1(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D( , , , x, y, z) -- centre of gate.

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("Prison gate open!", thePlayer, 0, 255, 0)
			moveObject(objGatea, 5000, 1081.1586, 1361.8896, 11.5154, 0, 0, 180)
			setTimer(closePrisonGate1, 10000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor)

function closePrisonGate1(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Prison gate Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatea, 5000, 1071.1484, 1361.8896, 11.5154, 0, 0, 180)
	setTimer(resetState, 5000, 1)
end

-------------------------
-- Exterior gate 2 / 3 --
-------------------------
objGatea2 = createObject(969, 1068.267, 1338.885, 9.820, 0, 0, 180)
objGatea3 = createObject(969, 1068.288, 1039.103, 9.820, 0, 0, 0)
exports.pool:allocateElement(objGatea2)
exports.pool:allocateElement(objGatea3)
setElementInterior(objGatea2, 0)
setElementDimension(objGatea2, 0)
setElementInterior(objGatea3, 0)
setElementDimension(objGatea3, 0)

open = false

-- Gate code
function usePrisonGate2(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(, , , x, y, z) -- centre of gates

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("Prison gate now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatea2, 4000, 1063.087, 1338.885, 9.820, 0, 0, 180)
			moveObject(objGatea3, 4000, 1071.866, 1339.103, 9.820, 0, 0, 0)
			setTimer(closePrisonGate2, 10000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor)

function closePrisonGate2(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Prison gate now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatea2, 4000,  1068.267, 1338.885, 9.820, 0, 0, 180)
	moveObject(objGatea3, 4000, 1068.288, 1039.103, 9.820, 0, 0, 0)
	setTimer(resetState, 4000, 1)
end

-------------------
-- Interior Gate --
-------------------
objGatea4 = createObject(2930, 1049.3933, 1253.0361, 1480.2933, 0, 0, 90)
exports.pool:allocateElement(objGatea4)
setElementInterior(objGatea4, 0)
setElementDimension(objGatea4, 4)

-- Gate code
function usePrisonIntGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D( 1048.1711, 1253.6361, 1480.2933, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("Prison gate open!", thePlayer, 0, 255, 0)
			moveObject(objGatea4, 2000, 1048.1711, 1253.6361, 1480.2933, 0, 0, 180)
			setTimer(closePrisonIntGate, 50000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor)

function closePrisonIntGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Prison gate Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objGatea4, 2000, 1049.3933, 1253.0361, 1480.2933, 0, 0, 90)
	setTimer(resetState, 2000, 1)
end