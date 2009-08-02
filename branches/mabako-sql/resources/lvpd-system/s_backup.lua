backupBlip = nil
backupPlayer = nil

function removeBackup(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if (backupPlayer~=nil) then
			destroyElement(backupBlip)
			removeEventHandler("onPlayerQuit", backupPlayer, destroyBlip)
			removeEventHandler("savePlayer", backupPlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = nil
			outputChatBox("Backup system reset!", thePlayer, 255, 194, 14)
		else
			outputChatBox("Backup system did not need reset.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("resetbackup", removeBackup, false, false)

function backup(thePlayer, commandName)
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	
	if (factionType==2) and (duty>0) then
		if (backupBlip) and (backupPlayer~=thePlayer) then -- in use
			outputChatBox("There is already a backup beacon in use.", thePlayer, 255, 194, 14)
		elseif not (backupBlip) then -- make backup blip
			backupPlayer = thePlayer
			local x, y, z = getElementPosition(thePlayer)
			backupBlip = createBlip(x, y, z, 0, 3, 255, 0, 0, 255, 255, 32767)
			exports.pool:allocateElement(backupBlip)
			attachElements(backupBlip, thePlayer)
			
			addEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			addEventHandler("savePlayer", thePlayer, destroyBlip)
			
			setElementVisibleTo(backupBlip, getRootElement(), false)
			
			for key, value in ipairs(getPlayersInTeam(theTeam)) do
				local duty = tonumber(getElementData(value, "duty"))
				
				if (duty>0) then
					outputChatBox("A unit needs urgent assistance! Please respond ASAP!", value, 255, 194, 14)
					setElementVisibleTo(backupBlip, value, true)
				end
			end
			
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local duty = getElementData(value, "duty")
				
				if (getPlayerTeam(value)~=theTeam) or (duty==0) then
					setElementVisibleTo(backupBlip, value, false)
				end
			end
		elseif (backupBlip) and (backupPlayer==thePlayer) then -- in use by this player
			for key, value in ipairs(getPlayersInTeam(theTeam)) do
			
				local duty = tonumber(getElementData(value, "duty"))
				
				if (duty>0) then
					outputChatBox("The unit no longer requires assistance. Resume normal patrol", value, 255, 194, 14)
				end
			end
			
			destroyElement(backupBlip)
			removeEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			removeEventHandler("savePlayer", thePlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = nil
		end
	end
end
addCommandHandler("backup", backup, false, false)
addEvent("savePlayer", false)

function destroyBlip()
	local theTeam = getPlayerTeam(source)
	for key, value in ipairs(getPlayersInTeam(theTeam)) do
		outputChatBox("The unit no longer requires assistance. Resume normal patrol", value, 255, 194, 14)
	end
	destroyElement(backupBlip)
	removeEventHandler("onPlayerQuit", thePlayer, destroyBlip)
	removeEventHandler("savePlayer", thePlayer, destroyBlip)
	backupPlayer = nil
	backupBlip = nil
end