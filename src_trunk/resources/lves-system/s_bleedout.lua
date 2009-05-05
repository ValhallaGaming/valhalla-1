function startBleeding(attacker, weapon, bodypart)
	local health = getElementHealth(source)
	local bleeding = getElementData(source, "bleeding")
	
	if (health<=20) and (health>0) and (bleeding~=1) then
		setElementData(source, "bleeding", 1)
		exports.global:sendLocalMeAction(source, "starts to bleed.")
		setTimer(bleedPlayer, 60000, 1, source, getPlayerName(source))
	end
end
addEventHandler("onPlayerDamage", getRootElement(), startBleeding)

function bleedPlayer(thePlayer, playerName)
	if (getElementType(thePlayer)) then -- still logged in & playing
		if (playerName==getPlayerName(thePlayer)) then -- make sure they havent changed character
			local health = getElementHealth(thePlayer)
			
			if (health<=20) and (health>0) then
				setElementHealth(thePlayer, health-2)
				setTimer(bleedPlayer, 60000, 1, thePlayer, playerName)
			else
				setElementData(source, "bleeding", 0)
			end
		end
	end
end