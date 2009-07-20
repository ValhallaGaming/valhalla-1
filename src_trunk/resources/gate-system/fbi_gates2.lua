local objGatefbi1 = createObject(976, 2525.62109375, 2423.92421875, 9.91203125, 0, 0, 180)
exports.pool:allocateElement(objGatefbi1)

local objGatefbi2 = createObject(976, 2534.62109375, 2423.92421875, 9.91203125, 0, 0, 180)
exports.pool:allocateElement(objGatefbi2)

local open = false

-- Gate code
function useFBISideGate2(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Federal Bureau of Investigation")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2525.62109375, 2423.92421875, 9.91203125, x, y, z)
	
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("FBI Side Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatefbi1, 1000, 2517.62109375, 2423.92421875, 9.91203125, 0, 0, 0)
			moveObject(objGatefbi2, 1000, 2544.12109375, 2423.92421875, 9.91203125, 0, 0, 0)
			setTimer(closeFBISideGate2, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useFBISideGate2)

function closeFBISideGate2(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("FBI Side Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	open = false
	moveObject(objGatefbi1, 1000, 2525.62109375, 2423.92421875, 9.91203125, 0, 0, 0)
	moveObject(objGatefbi2, 1000, 2534.62109375, 2423.92421875, 9.91203125, 0, 0, 0)
end