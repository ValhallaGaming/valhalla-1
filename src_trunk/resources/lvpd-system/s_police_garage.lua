local marker1 = createMarker(2240.46484375, 2447.16796875, 3.2734375, "cylinder", 5, 255, 194, 14, 150)
exports.pool:allocateElement(marker1)
local marker2 = createMarker(2240.46484375, 2456.6247558594, 3.2734375, "cylinder", 5, 255, 181, 165, 213)
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