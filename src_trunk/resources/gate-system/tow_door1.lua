local objGateb = createObject(3089, 228.2837677002, 115.20336151123, 1010.5583496094, 0, 0, 90)
exports.pool:allocateElement(objGateb)
setElementInterior(objGateb, 10)
setElementDimension(objGateb, 9001)

local open = false

-- Gate code
function useImpoundDoorb(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Best's Towing and Recovery")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(228.2837677002, 115.20336151123, 1010.5583496094, x, y, z)

		if (distance<=3) and (open==false) then
			open = true
			outputChatBox("The Main Impound Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateb, 1000, 228.2837677002, 115.20336151123, 1010.5583496094, 0, 0, -90)
			setTimer(closeImpoundDoorb, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useImpoundDoorb)

function closeImpoundDoorb(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The Main Impound Door is now Closed!", thePlayer, 255, 0, 0)
	end

	moveObject(objGateb, 1000, 228.2837677002, 115.20336151123, 1010.5583496094, 0, 0, 90)

	setTimer(resetState1b, 1000, 1)
end


function resetState1b()
	open = false
end
