function updateNametagColor(thePlayer)
	if isPlayerAdmin(thePlayer) and getElementData(thePlayer, "adminduty") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then -- Admin duty
		setPlayerNametagColor(thePlayer, 255, 194, 14)
	elseif (getElementData(thePlayer,"PDbadge")==1) then -- PD Badge
		setPlayerNametagColor(thePlayer, 0, 100, 255)
	elseif (getElementData(thePlayer,"ESbadge")==1) then -- ES Badge
		setPlayerNametagColor(thePlayer, 175, 50, 50)
	elseif isPlayerBronzeDonator(thePlayer) then -- Donor
		setPlayerNametagColor(thePlayer, 167, 133, 63)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end
