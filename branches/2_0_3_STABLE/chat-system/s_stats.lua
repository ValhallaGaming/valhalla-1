function showStats(thePlayer)
	local carlicense = getElementData(thePlayer, "license.car")
	local gunlicense = getElementData(thePlayer, "license.gun")
	
	if (carlicense==1) then
		carlicense = "Yes"
	else
		carlicense = "No"
	end
	
	if (gunlicense==1) then
		gunlicense = "Yes"
	else
		gunlicense = "No"
	end

	outputChatBox("~-~-~-~-~-~-~-~-~-~-~-~-~-~-~~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
	outputChatBox("Stats For: " .. getPlayerName(thePlayer) .. ".", thePlayer, 255, 194, 14)
	outputChatBox("Cell Number: " .. getElementData(thePlayer, "cellnumber"), thePlayer, 255, 194, 14)
	outputChatBox("Car Drivers License: " .. carlicense, thePlayer, 255, 194, 14)
	outputChatBox("Gun License: " .. gunlicense, thePlayer, 255, 194, 14)
	outputChatBox("~-~-~-~-~-~-~-~-~-~-~-~-~-~-~~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
end
addCommandHandler("stats", showStats, false, false)