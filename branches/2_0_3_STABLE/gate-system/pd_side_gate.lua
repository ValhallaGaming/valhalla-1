objGatei = createObject(976, 2237.5334472656, 2448.87109375, 9.8203125, 0, 0, 90)
exports.pool:allocateElement(objGatei)
objGatei2 = createObject(976, 2237.5334472656, 2448.87109375, 12.8203125, 0, 0, 90)
exports.pool:allocateElement(objGatei2)

-- these are just fences to stop people climbing
o1 = createObject(987, 2237.5334472656, 2442.37109375, 9.9203125, 0, 0, 270)
o2 = createObject(987, 2237.5334472656, 2448.37109375, 9.9203125, 0, 0, 270)
o3 = createObject(987, 2237.5334472656, 2430.87109375, 9.9203125, 0, 0, 0)

o4 = createObject(987, 2237.5334472656, 2469.77109375, 9.9203125, 0, 0, 270)
o5 = createObject(987, 2237.5334472656, 2475.77109375, 9.9203125, 0, 0, 270)
o6 = createObject(987, 2237.5334472656, 2487.77109375, 9.9203125, 0, 0, 270)
o7 = createObject(987, 2237.5334472656, 2499.77109375, 9.9203125, 0, 0, 270)
o8 = createObject(987, 2237.5334472656, 2502.77109375, 9.9203125, 0, 0, 270)
p9 = createObject(987, 2249.5334472656, 2502.77109375, 9.9203125, 0, 0, 180)
o10 = createObject(987, 2260.5334472656, 2502.77109375, 9.9203125, 0, 0, 180)
o11 = createObject(987, 2271.5334472656, 2502.77109375, 9.9203125, 0, 0, 180)
o12 = createObject(987, 2282.5334472656, 2502.77109375, 9.9203125, 0, 0, 180)
o13 = createObject(987, 2293.5334472656, 2502.77109375, 9.9203125, 0, 0, 180)

open = false

-- Gate code
function usePDSideGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2237.5334472656, 2448.87109375, 9.8203125, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD Side Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatei, 1000, 2237.5334472656, 2438.37109375, 9.9203125)
			moveObject(objGatei2, 1000, 2237.5334472656, 2438.37109375, 12.8203125)
			setTimer(closePDSideGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGate)

function closePDSideGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Side Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGatei, 1000, 2237.5334472656, 2448.87109375, 9.8203125)
	moveObject(objGatei2, 1000, 2237.5334472656, 2448.87109375, 12.8203125)
end