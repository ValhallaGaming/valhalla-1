local objChinaGate = createObject(986, 2566.45, 1822, 11, 0, 0, 180)
exports.pool:allocateElement(objChinaGate)

local objChinaGate2 = createObject(986, 2566.45, 1826, 11, 0, 0, 180)
exports.pool:allocateElement(objChinaGate2)

local objChinaFence = createObject( 987, 2544.3037109375, 1845.4, 9.5, 0, 0, 270)
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
			moveObject(objChinaGate, 3000, 2571.8, 1822, 11)
            moveObject(objChinaGate2, 4000, 2571.8, 1826, 11)
			setTimer(closeChinaGate, 6000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useChinaGate)

function closeChinaGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("Yakuza gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	moveObject(objChinaGate, 3000, 2566.45, 1822, 11)
    moveObject(objChinaGate2, 4000, 2566.45, 1826, 11) 
	setTimer(resetChinaGateState, 1000, 1)
end


function resetChinaGateState()
	open = false
end