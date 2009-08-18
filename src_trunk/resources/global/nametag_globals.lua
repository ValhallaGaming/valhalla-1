function updateNametagColor(thePlayer)
	if isPlayerAdmin(thePlayer) and getElementData(thePlayer, "adminduty") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then
		setPlayerNametagColor(thePlayer, 255, 194, 14)
	elseif isPlayerBronzeDonator(thePlayer) then
		setPlayerNametagColor(thePlayer, 167, 133, 63)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end
