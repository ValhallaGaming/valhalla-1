function deployFlashbang(thePlayer, commandName, targetPartialNick)
	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
		
		if (ftype~=2) then
			outputChatBox("You do not have a flashbang.", thePlayer, 255, 0, 0)
		else
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = z - 1
			
			exports.global:sendLocalMeAction(thePlayer, "throws a flashbang.")
			
			local obj = createObject(343, x, y, z)
			exports.pool:allocateElement(obj)
			setTimer(explodeFlash, math.random(500, 600), 3, obj, x, y, z)
		end
	end
end
--addCommandHandler("flashbang", deployFlashbang, false, false)

function explodeFlash(obj, x, y, z)
	local colsphere = createColSphere(x, y, z, 7)
	exports.pool:allocateElement(colsphere)
	local players = getElementsWithinColShape(colsphere, "player")
	
	destroyElement(obj)
	destroyElement(colsphere)
	for key, value in ipairs(players) do
		local gasmask = getElementData(value, "gasmask")
		
		if (not gasmask) or (gasmask==0) then
			playSoundFrontEnd(value, 47)
			fadeCamera(value, false, 0.5, 255, 255, 255)
			setTimer(cancelEffect, 5000, 1, value)
			setTimer(playSoundFrontEnd, 1000, 1, value, 48)
		end
	end
end

function cancelEffect(thePlayer)
	fadeCamera(thePlayer, true, 6.0)
end