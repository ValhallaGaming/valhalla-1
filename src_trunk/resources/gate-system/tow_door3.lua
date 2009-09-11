local objGatec = createObject(988, 1026.7662353516, -904.46270751953, 42.064300537109, 0, 0, 270)
exports.pool:allocateElement(objGatec)

local open = false

-- Gate code
function useImpoundDoorc(thePlayer)
	local team = getPlayerTeam(thePlayer)
	if (team==getTeamFromName("Best's Towing and Recovery")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(1026.7662353516, -904.46270751953, 42.064300537109, x, y, z)

		if (distance<=10) and (open==false) then
			open = true
			outputChatBox("The Front Gate is now open!", thePlayer, 0, 255, 0)
			moveObject(objGatec, 1000, 1026.7662353516, -898.46270751953, 42.064300537109, 0, 0, 0)
			setTimer(closeImpoundDoorc, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useImpoundDoorc)

function closeImpoundDoorc(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The Front Gate is now Closed!", thePlayer, 255, 0, 0)
	end

	moveObject(objGatec, 1000, 1026.7662353516, -904.46270751953, 42.064300537109, 0, 0, 0)

	setTimer(resetState1c, 1000, 1)
end


function resetState1c()
	open = false
end
