function AdminLoungeTeleport(sourcePlayer)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		setElementPosition ( sourcePlayer, 275.761475, -2052.245605, 3085.291962 )
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)