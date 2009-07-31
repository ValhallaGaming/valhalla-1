local marker1 = createMarker(1545.55859375, -1659.109375, 4.890625, "cylinder", 5, 255, 194, 14, 150)
exports.pool:allocateElement(marker1)
local marker2 = createMarker(1545.580078125, -1663.462890625, 4.890625, "cylinder", 5, 255, 181, 165, 213)
exports.pool:allocateElement(marker2)

-- Nice little guard ped
guard = createPed(280, 1544.1591796875, -1632, 13.3828125)
exports.pool:allocateElement(guard)
setPedRotation(guard, 90)
setTimer(giveWeapon, 50, 1, guard, 29, 15000, true)

function killMeByPed(element)
	killPed(source, element, 29, 9)
	setPedHeadless(source, true)
end
addEvent("killmebyped", true)
addEventHandler("killmebyped", getRootElement(), killMeByPed)