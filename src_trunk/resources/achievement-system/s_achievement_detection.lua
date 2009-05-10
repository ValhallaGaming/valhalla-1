-- /////////////// ACHIEVEMENT ID 2 - Donut King ///////////////////
function giveAchievementOnFactionJoin(theTeam)
	local id = tonumber(getElementData(theTeam, "id"))
	if (id) then
		if (id==1) then
			exports.global:givePlayerAchievement(source, 2)
		end
	end
end
addEventHandler("onPlayerJoinFaction", getRootElement(), giveAchievementOnFactionJoin)

-- /////////////// ACHIEVEMENT ID 3 - The Wheelman ///////////////////
function giveAchievementOnVehicleEnter(thePlayer)
	if (not exports.global:doesPlayerHaveAchievement(thePlayer, 3)) then
		outputChatBox("Vehicle Controls:", thePlayer, 255, 194, 14)
		outputChatBox("Engine: Press J", thePlayer, 255, 194, 14)
		outputChatBox("Locks: Press K", thePlayer, 255, 194, 14)
		outputChatBox("Headlights: Press L", thePlayer, 255, 194, 14)
		outputChatBox("Indicators: Press Q and E", thePlayer, 255, 194, 14)
	end
	exports.global:givePlayerAchievement(thePlayer, 3)
end
addEventHandler("onVehicleEnter", getRootElement(), giveAchievementOnVehicleEnter)

-- /////////////// ACHIEVEMENT ID 4 - The Newbie ///////////////////
function giveAchievementOnFirstCharacter()
	exports.global:givePlayerAchievement(source, 4)
end
addEventHandler("onPlayerCreateCharacter", getRootElement(), giveAchievementOnFirstCharacter)

-- /////////////// ACHIEVEMENT ID 5 - Trust me, I'm a doctor ///////////////////
function giveAchievementOnFactionJoinES(theTeam)
	local id = tonumber(getElementData(theTeam, "id"))
	if (id) then
		if (id==2) then
			exports.global:givePlayerAchievement(source, 5)
		end
	end
end
addEventHandler("onPlayerJoinFaction", getRootElement(), giveAchievementOnFactionJoinES)

-- /////////////// ACHIEVEMENT ID 6 - Politicians, All the same ///////////////////
function giveAchievementOnFactionJoinGov(theTeam)
	local id = tonumber(getElementData(theTeam, "id"))
	if (id) then
		if (id==3) then
			exports.global:givePlayerAchievement(source, 6)
		end
	end
end
addEventHandler("onPlayerJoinFaction", getRootElement(), giveAchievementOnFactionJoinGov)

-- /////////////// ACHIEVEMENT ID 7 - Cleaning the streets ///////////////////
function giveAchievementOnArrest(targetPlayer, fine, jailtime, reason)
	exports.global:givePlayerAchievement(source, 8)
end
addEventHandler("onPlayerArrest", getRootElement(), giveAchievementOnArrest)

-- /////////////// ACHIEVEMENT ID 8 - Banged Up ///////////////////
function giveAchievementOnArrested(targetPlayer, fine, jailtime, reason)
	exports.global:givePlayerAchievement(source, 9)
end
addEventHandler("onPlayerArrest", getRootElement(), giveAchievementOnArrested)

-- /////////////// ACHIEVEMENT ID 8 - Banged Up ///////////////////
mtaPickup = createPickup(1444.1369628906, 1903.8308105469, 10.8203125, 3, 1248)
exports.pool:allocateElement(mtaPickup)
function giveAchievementOnMTAPickup(thePlayer)
	cancelEvent()
	exports.global:givePlayerAchievement(thePlayer, 32)
end
addEventHandler("onPickupHit", mtaPickup, giveAchievementOnMTAPickup)