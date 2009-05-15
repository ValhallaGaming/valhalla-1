local pickup1 = createPickup(2075.4445800781, 1923.4255371094, 14, 3, 1276)
local pickup2 = createPickup(2690.6840820313, 866.61157226563, 9.6372062683105, 3, 1276)
local pickup3 = createPickup(1081.2023925781, -1697.4725341797, 13.246875, 3, 1276)
local pickup4 = createPickup(-71.808219909668, -1139.1987304688, 0.8, 3, 1276)
local pickup5 = createPickup(-1072.4919433594, -1170.0344238281, 129.3, 3, 1276)
local pickup6 = createPickup(2519.6125488281, -1272.7860107422, 34.881507873535, 3, 1276)
local pickup7 = createPickup(-1761.2625732422, 510.76193237305, 39.491255950928, 3, 1276)
local pickup8 = createPickup(-2548.6770019531, 194.68118286133, 6, 3, 1276)
local pickup9 = createPickup(1742.9956054688, -1862.8803710938, 13.275754165649, 3, 1276)
local pickup10 = createPickup(1098.4052734375, 1677.9473876953, 6.3328125, 3, 1276)

-- CODE is 94160296105
function onPickupWasHit(player, matchingDimension)
	if (getElementType(player)=="player") and not (isPedInVehicle(player)) then
		cancelEvent()
		
		if (source==pickup1) then
			exports.global:givePlayerAchievement(player, 33)
			outputChatBox("Hint #2: They've been building this damn thing for months, and I still have no idea what it's meant to be.", player)
			outputChatBox("The value of this hint is 4, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup2) then
			outputChatBox("Hint #3: I really do hate papercuts =[", player)
			outputChatBox("The value of this hint is 1, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup3) then
			outputChatBox("Hint #4: I only wanted a trucker job, but it seems they have upped-sticks and moved to Las Venturas.", player)
			outputChatBox("The value of this hint is 6, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup4) then
			outputChatBox("Hint #5: Fill in the blanks -      T _ _        _ _ R _", player)
			outputChatBox("The value of this hint is 0, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup5) then
			outputChatBox("Hint #6: Damn, SWAT stole my wall...", player)
			outputChatBox("The value of this hint is 2, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup6) then
			outputChatBox("Hint #7: Half a highway.", player)
			outputChatBox("The value of this hint is 9, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup7) then
			outputChatBox("Hint #8: I heard after Sergeant Adam Suzuko retired, he spent a lot of his time here, He also met Elton John here a lot.", player)
			outputChatBox("The value of this hint is 6, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup8) then
			outputChatBox("Hint #9: Back in the day of Don Corleone, Clowns performed their favorite activity of deathmatch here many a time.", player)
			outputChatBox("The value of this hint is 1, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup9) then
			outputChatBox("Hint #10: I only wanted to see Joe Calzaghe, but Chamberlain put a perspex wall infront of me.", player)
			outputChatBox("The value of this hint is 0, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		elseif (source==pickup10) then
			exports.global:givePlayerAchievement(player, 34)
			outputChatBox("Congratulations! You have completed the hunt, Please /report saying You have completed it and include the Code.", player)
			outputChatBox("The value of this hint is 5, Please take note of this as you will be asked to provide it at the end of the hunt.", player)
		end
	end
end
addEventHandler("onPickupHit", getRootElement(), onPickupWasHit)

function firstHint(thePlayer)
	outputChatBox("Hint #1: I'm not quite sure what palm trees and waterfalls have to do with Las Venturas, But they look nice anyway.", thePlayer)
	outputChatBox("The value of this hint is 9, Please take note of this as you will be asked to provide it at the end of the hunt.", thePlayer)
end
addCommandHandler("hint", firstHint)