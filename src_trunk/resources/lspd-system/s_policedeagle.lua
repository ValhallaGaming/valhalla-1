function tazerFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<50) then
		local colshape = createColSphere(px, py, pz, 20)
		for key, value in ipairs(getElementsWithinColShape(colshape)) do
			if (value~=source) then
				outputChatBox("SYNC: Sending tazer effect to client: " .. tostring(getPlayerName(value)) .. " FROM: " .. tostring(getPlayerName(source)) .. ".")
				triggerClientEvent(value, "showTazerEffect", value, x, y, z) -- show the sparks
			end
		end
		
		if (target) then
			toggleAllControls(target, false, true, false)
			setPedAnimation(target, "CRACK", "crckidle1", 3000, false, false, false)
			setTimer(toggleAllControls, 3000, 1, target, true, true, true)
			setTimer(setPedAnimation, 3001, 1, target)
		end
		destroyElement(colshape)
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)

function tazer(thePlayer)
	giveWeapon(thePlayer, 24, 15000, true)
end
addCommandHandler("givedeagle", tazer)