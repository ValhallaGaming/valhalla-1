local objGateh = createObject(3055, 2293.8805664063, 2498.833789063, 4.2734375, 0, 0, 90)
exports.pool:allocateElement(objGateh)

local open = false

-- Green door
local greendoor = createObject(1492, 2293.8684082031, 2494.5129394531, 2.3734375, 0, 0, 270)
exports.pool:allocateElement(greendoor)

-- Gate code
function usePDSideGarageGate(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2297.1805664063, 2509.133789063, 2.2734375, x, y, z)
		
		if (distance<=50) and (open==false) then
			open = true
			outputChatBox("LVMPD Side Garage Gate is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateh, 1000, 2293.8805664063, 2498.833789063, 6.95734375, 90, 0, 0)
			setTimer(closePDSideGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGarageGate)

function closePDSideGarageGate(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Side Garage Gate is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState7, 1000, 1)
	moveObject(objGateh, 1000, 2293.8805664063, 2498.833789063, 4.2734375, -90, 0, 0)
end

function resetState7()
	open = false
end