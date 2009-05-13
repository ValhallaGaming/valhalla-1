function syncHeadBob(x, y, z)
	local px, py, pz = getElementPosition(source)

	
	local colshape = createColSphere(px, py, pz, 20)
	exports.pool:allocateElement(colshape)
	local players = getElementsWithinColShape(colshape, "player")
	for key, value in ipairs(players) do
		if (value~=source) then
			--triggerClientEvent(value, "cSyncHead", value, source, x, y, z)
		end
	end
	destroyElement(colshape)
end
addEvent("syncHead", true)
addEventHandler("syncHead", getRootElement(), syncHeadBob)