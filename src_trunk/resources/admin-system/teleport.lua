function AdminLoungeTeleport(sourcePlayer)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		setElementPosition ( sourcePlayer, 275.761475, -2052.245605, 3085.291962 )
		triggerClientEvent(sourcePlayer, "usedElevator", sourcePlayer)
		setPedFrozen(sourcePlayer, true)
		setPedGravity(sourcePlayer, 0)
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)