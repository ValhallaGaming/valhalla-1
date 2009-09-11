local objGatea = createObject(3089, 222.18794250488, 119.52620697021, 1010.358215332, 0, 0, 0)
exports.pool:allocateElement(objGatea)
setElementInterior(objGatea, 10)
setElementDimension(objGatea, 9001)

local open = false

-- Gate code
function useImpoundDoora(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Best's Towing and Recovery")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(222.18794250488, 119.52620697021, 1010.358215332, x, y, z)

		if (distance<=3) and (open==false) then
			open = true
			outputChatBox("The Briefing Room Door is now open!", thePlayer, 0, 255, 0)
			moveObject(objGatea, 1000, 222.18794250488, 119.52620697021, 1010.358215332, 0, 0, 90)
			setTimer(closeImpoundDoora, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useImpoundDoora)

function closeImpoundDoora(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The Briefing Room Door is now Closed!", thePlayer, 255, 0, 0)
	end

	moveObject(objGatea, 1000, 222.18794250488, 119.52620697021, 1010.358215332, 0, 0, -90)

	setTimer(resetState1a, 1000, 1)
end


function resetState1a()
	open = false
end
