local objChinaGate = createObject(986, 2562.5, 1822, 10, 0, 0, 0)
exports.pool:allocateElement(objChinaGate)

local objChinaGate2 = createObject(986, 2562.5, 1826, 10, 0, 0, 0)
exports.pool:allocateElement(objChinaGate2)

local objChinaFence = createObject( 987, 2544.3037109375, 1840.0390625, 10, 0, 0, 0)
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
            moveObject(objChinaGate2, 4000, 2568, 1826, 10, 0, 0, 0)
			setTimer(closeChinaGate, 6000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useChinaGate)

function closeChinaGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Yakuza gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objChinaGate, 3000, 2562.5, 1822, 10, 0, 0, 0)
    moveObject(objChinaGate2, 4000, 2562.5, 1826, 10, 0, 0, 0) 
	setTimer(resetChinaGateState, 1000, 1)
end


function resetChinaGateState()
	open = false
end