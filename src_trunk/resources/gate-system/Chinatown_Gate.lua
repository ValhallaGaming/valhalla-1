local objChinaGate = createObject(969, 2562.5, 1822, 10, 0, 0, 0)
exports.pool:allocateElement(objChinaGate)

local objChinaFence = createObject( 983, 2543.97, 1839.34, 10.5, 0, 0, 0)
exports.pool:allocateElement(objChinaFence)

open = false

-- Gate code
function useChinaGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Yamaguchi-Gumi")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D( 2565.1757, 1820.6582, 10.8203, x, y, z )

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("Yakuza gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objChinaGate, 3000, 2568, 1822, 10, 0, 0, 0)
			setTimer(closeChinaGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useChinaGate)

function closeChinaGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Yakuza gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objChinaGate, 3000, 2562.5, 1822, 10, 0, 0, 0)
	setTimer(resetChinaGateState, 1000, 1)
end


function resetChinaGateState()
	open = false
end