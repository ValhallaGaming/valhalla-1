local backupBlip = nil
addEvent("createBackupBlip", true)
addEvent("destroyBackupBlip", true)
addEventHandler("createBackupBlip", getRootElement(), function ()
	if (backupBlip) then
		destroyElement(backupBlip)
		backupBlip = nil
	end
	local x, y, z = getElementPosition(source)
	backupBlip = createBlip(x, y, z, 0, 3, 255, 0, 0, 255, 255, 32767)
	attachElements(backupBlip, source)
end)
addEventHandler("destroyBackupBlip", getRootElement(), function ()
	if (backupBlip) then
		destroyElement(backupBlip)
		backupBlip = nil
	end
end)