local marker1 = createMarker(2240.46484375, 2447.16796875, 3.2734375, "cylinder", 5, 255, 194, 14, 150)
exports.pool:allocateMarker(marker1)
local marker2 = createMarker(2240.46484375, 2456.6247558594, 3.2734375, "cylinder", 5, 255, 181, 165, 213)
exports.pool:allocateMarker(marker2)

-- Nice little guard ped
guard = createPed(282, 2238.9091796875, 2449.3188476563, 11.037217140198)
exports.pool:allocatePed(guard)
setPedRotation(guard, 90)