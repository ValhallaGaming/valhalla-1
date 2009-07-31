-- waves
function setInitialWaves(res)
	if (res==getThisResource()) then
		local hour, mins = getTime()
		createSewerFlood()
		if (hour%2==0) then -- even hour
			
			setWaveHeight(1)
		else
			setWaveHeight(0)
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), setInitialWaves)

function updateWaves()
	local hour, mins = getTime()

	if (hour%2==0) then -- even hour
		setWaveHeight(1)
	else
		setWaveHeight(0)
	end
end
addEvent("updateWaves", false)
addEventHandler("updateWaves", getRootElement(), updateWaves)

function createSewerFlood()
	 -- Dams
	createObject(16339, 1579.72265625, -1751.748046875, 1.3512325286865, 0, 0, 180)
	createObject(16339, 1410.2568359375, -1714.7568359375, 1.3512325286865, 0, 0, 355)
	createObject(16339, 2017.158203125, -1906.9755859375, 1.3512325286865, 0, 0, 315)
	createObject(16339, 2127.3828125, -2015.9189453125, 1.3512325286865, 0, 0, 135)
	createObject(16339, 2581.9560546875, -2110.491210937, 0, 0, 0, 270)
	createObject(16339, 2581.673828125, -2120.3525390625, 0, 0, 0, 90)
	
	-- Water #1
	local x1, y1, z1 = 1329.0009765625, -1733.38671875, 11.8 -- SW
	local x2, y2, z2 = 1466.4970703125, -1729.9609375, 11.8 -- SE
	local x3, y3, z3 = 1403.7509765625, -1298.647460937, 11.8 -- NW
	local x4, y4, z4 =  1420.6875, -1296.216796875, 11.8 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #2
	local x1, y1, z1 = 1349, -1725, 11.8 -- SW
	local x2, y2, z2 = 1382, -1726, 11.8-- SE
	local x3, y3, z3 = 1405, -1300, 11.8 -- NW
	local x4, y4, z4 = 1420, -1300, 11.8 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #3
	local x1, y1, z1 =  1377.1025390625, -1722.6787109375, 11.8 -- SW
	local x2, y2, z2 = 1425.798828125, -1721.890625, 11.8 -- SE
	local x3, y3, z3 = 1381.0849609375, -1706.6318359375, 11.8 -- NW
	local x4, y4, z4 = 1426.0390625, -1710.375, 11.8 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #4
	local x1, y1, z1 = 1357.7431640625, -1868.1962890625, 7 -- SW
	local x2, y2, z2 = 1527.5556640625, -1873.0205078125, 7 -- SE
	local x3, y3, z3 = 1349.453125, -1701.9990234375, 7 -- NW
	local x4, y4, z4 = 1527.1181640625, -1709.41015625, 7 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #5
	local x1, y1, z1 = 1574.828125, -1877.42578125, 7 -- SW
	local x2, y2, z2 = 2534.6591796875, -1917.185546875, 7 -- SE
	local x3, y3, z3 = 1576.982421875, -1729.087890625, 7 -- NW
	local x4, y4, z4 = 2537.37890625, -1775.4609375, 7 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #6
	local x1, y1, z1 = 2527.25, -2115.4765625, 7 -- SW
	local x2, y2, z2 = 2628.8037109375, -2207.7392578125, 7 -- SE
	local x3, y3, z3 = 2523.50390625, -1468.19140625, 7 -- NW
	local x4, y4, z4 =  2623.529296875, -1452.0751953125, 7 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	
	-- Water #7
	local x1, y1, z1 = 1613.341796875, -1750.46289062, 7 -- SW
	local x2, y2, z2 = 1630.85546875, -1750.1044921875, 7 -- SE
	local x3, y3, z3 = 1609.0078125, -1670.2392578125, 7 -- NW
	local x4, y4, z4 = 1628.3701171875, -1672.7763671875, 7 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	-- Water #8
	local x1, y1, z1 = 1966.9541015625, -1942.3779296875, 7 -- SW
	local x2, y2, z2 = 2076.99609375, -1927.4052734375, 7 -- SE
	local x3, y3, z3 = 1960.7197265625, -1872.1435546875, 7 -- NW
	local x4, y4, z4 = 2075.8251953125, -1866.0732421875, 7 -- NE
	local water = createWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
end