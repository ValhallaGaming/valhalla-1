car, wCars, bClose, bBuy, gCars, lCost, lColors, sCol1, sCol2 = nil

vehicleIDs = { }
vehicleCosts = { }
vehicles = {"Mountain Bike", "Bike", "BMX", "Pizza Boy", "Sanchez", "Quad", "Wayfarer", "Faggio", "BF-400", "FCR-900", "PCJ-600", "Manana", "Perenniel", "Moonbeam", "Clover", "Tampa", "NRG-500", "Greenwood", "Walton", "Glendale", "Primo", "Club", "Blista Compact", "Freeway", "Voodoo", "Stallion", "Bravura", "Intruder", "Previon", "Solair", "Oceanic", "Willard", "Picador", "Rancher", "Savanna", "Sabre", "Flash", "Pony", "Rumpo", "Majestic", "Bobcat", "Euros", "Hustler", "Regina", "Burrito", "Sadler", "Admiral", "Merit", "Stratum", "Nebula", "Sunrise", "Esperanto", "Yosemite", "Mesa", "Tahoma", "Cadrona", "Premier", "Hermes", "Uranus", "Buffalo", "Emperor", "Fortune", "Blade", "Sentinel", "Jester", "Virgo", "Tornado", "Buccaneer", "Remington", "Elegy", "Vincent", "Landstalker", "Alpha", "Elegant", "Stretch", "Washington", "Broadway", "Slamvan", "Sultan", "Phoenix", "Windsor", "Huntley", "Comet", "ZR-350", "Feltzer", "Banshee", "Super GT", "Turismo", "Bullet", "Cheetah", "Infernus", "Stafford" }

vehicleIDs["Mountain Bike"] = 510
vehicleCosts["Mountain Bike"] = 300

vehicleIDs["Bike"] = 509
vehicleCosts["Bike"] = 300

vehicleIDs["BMX"] = 481
vehicleCosts["BMX"] = 500

vehicleIDs["Pizza Boy"] = 448
vehicleCosts["Pizza Boy"] = 2700

vehicleIDs["Sanchez"] = 468
vehicleCosts["Sanchez"] = 3200

vehicleIDs["Quad"] = 471
vehicleCosts["Quad"] = 4000

vehicleIDs["Wayfarer"] = 586
vehicleCosts["Wayfarer"] = 4500

vehicleIDs["Faggio"] = 462
vehicleCosts["Faggio"] = 4600

vehicleIDs["BF-400"] = 581
vehicleCosts["BF-400"] = 4600

vehicleIDs["FCR-900"] = 521
vehicleCosts["FCR-900"] = 7300

vehicleIDs["PCJ-600"] = 461
vehicleCosts["PCJ-600"] = 9300

vehicleIDs["Manana"] = 410
vehicleCosts["Manana"] = 10000

vehicleIDs["Perenniel"] = 404
vehicleCosts["Perenniel"] = 10000

vehicleIDs["Moonbeam"] = 418
vehicleCosts["Moonbeam"] = 10000

vehicleIDs["Clover"] = 542
vehicleCosts["Clover"] = 12000

vehicleIDs["Tampa"] = 549
vehicleCosts["Tampa"] = 12000

vehicleIDs["NRG-500"] = 522
vehicleCosts["NRG-500"] = 13000

vehicleIDs["Greenwood"] = 492
vehicleCosts["Greenwood"] = 15000

vehicleIDs["Walton"] = 478
vehicleCosts["Walton"] = 15000

vehicleIDs["Glendale"] = 466
vehicleCosts["Glendale"] = 15000

vehicleIDs["Primo"] = 547
vehicleCosts["Primo"] = 16350

vehicleIDs["Club"] = 589
vehicleCosts["Club"] = 17340

vehicleIDs["Blista Compact"] = 496
vehicleCosts["Blista Compact"] = 17500

vehicleIDs["Freeway"] = 463
vehicleCosts["Freeway"] = 17500

vehicleIDs["Voodoo"] = 412
vehicleCosts["Voodoo"] = 18000

vehicleIDs["Stallion"] = 439
vehicleCosts["Stallion"] = 19995

vehicleIDs["Bravura"] = 401
vehicleCosts["Bravura"] = 21000

vehicleIDs["Intruder"] = 546
vehicleCosts["Intruder"] = 22000

vehicleIDs["Previon"] = 436
vehicleCosts["Previon"] = 22500

vehicleIDs["Solair"] = 458
vehicleCosts["Solair"] = 23000

vehicleIDs["Oceanic"] = 467
vehicleCosts["Oceanic"] = 23000

vehicleIDs["Willard"] = 529
vehicleCosts["Willard"] = 23000

vehicleIDs["Picador"] = 600
vehicleCosts["Picador"] = 23000

vehicleIDs["Rancher"] = 489
vehicleCosts["Rancher"] = 23500

vehicleIDs["Savanna"] = 567
vehicleCosts["Savanna"] = 24000

vehicleIDs["Sabre"] = 475
vehicleCosts["Sabre"] = 25000

vehicleIDs["Flash"] = 565
vehicleCosts["Flash"] = 25090

vehicleIDs["Pony"] = 413
vehicleCosts["Pony"] = 26000

vehicleIDs["Rumpo"] = 440
vehicleCosts["Rumpo"] = 27000

vehicleIDs["Majestic"] = 517
vehicleCosts["Majestic"] = 27500

vehicleIDs["Bobcat"] = 422
vehicleCosts["Bobcat"] = 28000

vehicleIDs["Euros"] = 587
vehicleCosts["Euros"] = 28510

vehicleIDs["Hustler"] = 545
vehicleCosts["Hustler"] = 30000

vehicleIDs["Regina"] = 479
vehicleCosts["Regina"] = 30000

vehicleIDs["Burrito"] = 482
vehicleCosts["Burrito"] = 30000

vehicleIDs["Sadler"] = 543
vehicleCosts["Sadler"] = 30500

vehicleIDs["Admiral"] = 445
vehicleCosts["Admiral"] = 31000

vehicleIDs["Merit"] = 551
vehicleCosts["Merit"] = 31275

vehicleIDs["Stratum"] = 561
vehicleCosts["Stratum"] = 32000

vehicleIDs["Nebula"] = 516
vehicleCosts["Nebula"] = 32000

vehicleIDs["Sunrise"] = 550
vehicleCosts["Sunrise"] = 32000

vehicleIDs["Esperanto"] = 419
vehicleCosts["Esperanto"] = 32000

vehicleIDs["Yosemite"] = 554
vehicleCosts["Yosemite"] = 35000

vehicleIDs["Mesa"] = 500
vehicleCosts["Mesa"] = 36000

vehicleIDs["Tahoma"] = 566
vehicleCosts["Tahoma"] = 38200

vehicleIDs["Cadrona"] = 527
vehicleCosts["Cadrona"] = 39800

vehicleIDs["Premier"] = 426
vehicleCosts["Premier"] = 40000

vehicleIDs["Hermes"] = 474
vehicleCosts["Hermes"] = 41995

vehicleIDs["Uranus"] = 558
vehicleCosts["Uranus"] = 42000

vehicleIDs["Buffalo"] = 402
vehicleCosts["Buffalo"] = 42685

vehicleIDs["Emperor"] = 585
vehicleCosts["Emperor"] = 42950

vehicleIDs["Fortune"] = 526
vehicleCosts["Fortune"] = 43250

vehicleIDs["Blade"] = 536
vehicleCosts["Blade"] = 44250

vehicleIDs["Sentinel"] = 405
vehicleCosts["Sentinel"] = 44600

vehicleIDs["Jester"] = 559
vehicleCosts["Jester"] = 45000

vehicleIDs["Virgo"] = 491
vehicleCosts["Virgo"] = 45295

vehicleIDs["Tornado"] = 576
vehicleCosts["Tornado"] = 47000

vehicleIDs["Buccaneer"] = 518
vehicleCosts["Buccaneer"] = 50000

vehicleIDs["Remington"] = 534
vehicleCosts["Remington"] = 50000

vehicleIDs["Elegy"] = 562
vehicleCosts["Elegy"] = 52000

vehicleIDs["Vincent"] = 540
vehicleCosts["Vincent"] = 53200

vehicleIDs["Landstalker"] = 400
vehicleCosts["Landstalker"] = 54000

vehicleIDs["Alpha"] = 602
vehicleCosts["Alpha"] = 55000

vehicleIDs["Elegant"] = 507
vehicleCosts["Elegant"] = 58000

vehicleIDs["Stretch"] = 409
vehicleCosts["Stretch"] = 59885

vehicleIDs["Washington"] = 421
vehicleCosts["Washington"] = 60000

vehicleIDs["Broadway"] = 575
vehicleCosts["Broadway"] = 62000

vehicleIDs["Slamvan"] = 535
vehicleCosts["Slamvan"] = 67400

vehicleIDs["Sultan"] = 560
vehicleCosts["Sultan"] = 72000

vehicleIDs["Phoenix"] = 603
vehicleCosts["Phoenix"] = 75000

vehicleIDs["Windsor"] = 555
vehicleCosts["Windsor"] = 77200

vehicleIDs["Huntley"] = 579
vehicleCosts["Huntley"] = 78450

vehicleIDs["Comet"] = 480
vehicleCosts["Comet"] = 83800

vehicleIDs["ZR-350"] = 477
vehicleCosts["ZR-350"] = 84000

vehicleIDs["Feltzer"] = 533
vehicleCosts["Feltzer"] = 98500

vehicleIDs["Banshee"] = 429
vehicleCosts["Banshee"] = 120000

vehicleIDs["Super GT"] = 506
vehicleCosts["Super GT"] = 173079

vehicleIDs["Turismo"] = 451
vehicleCosts["Turismo"] = 190600

vehicleIDs["Bullet"] = 541
vehicleCosts["Bullet"] = 250000

vehicleIDs["Cheetah"] = 415
vehicleCosts["Cheetah"] = 318538

vehicleIDs["Infernus"] = 411
vehicleCosts["Infernus"] = 339400

vehicleIDs["Stafford"] = 580
vehicleCosts["Stafford"] = 340000




function showCarshopUI()
	local width, height = 400, 200
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth - width
	local y = scrHeight/10
	
	wCars = guiCreateWindow(x, y, width, height, "Daker Autos: Purchase a Vehicle", false)
	guiWindowSetSizable(wCars, false)
	
	bClose = guiCreateButton(0.6, 0.85, 0.2, 0.1, "Close", true, wCars)
	bBuy = guiCreateButton(0.825, 0.85, 0.2, 0.1, "Buy", true, wCars)
	addEventHandler("onClientGUIClick", bClose, hideCarshopUI, false)
	addEventHandler("onClientGUIClick", bBuy, buyCar, false)
	
	car = createVehicle(451, 1986.1385498047, 2050.2172851563, 10.8203125)
	setVehicleColor(car, 0, 0, 0, 0)
	setVehicleEngineState(car, true)
	setVehicleOverrideLights(car, 2)
	addEventHandler("onClientRender", getRootElement(), rotateCar)
	
	gCars = guiCreateGridList(0.05, 0.1, 0.5, 0.75, true, wCars)
	addEventHandler("onClientGUIClick", gCars, updateCar, false)
	local col = guiGridListAddColumn(gCars, "Vehicle Model", 0.9)
	for key, value in ipairs(vehicles) do
		local row = guiGridListAddRow(gCars)
		guiGridListSetItemText(gCars, row, col, tostring(value), false, false)
	end
	guiGridListSetSelectedItem(gCars, 0, 1)
	
	lCost = guiCreateLabel(0.3, 0.85, 0.2, 0.1, "Cost: " .. vehicleCosts["Turismo"] .. "$", true, wCars)
	guiSetFont(lCost, "default-bold-small")
	
	updateCar()
	
	lColors = guiCreateLabel(0.6, 0.15, 0.2, 0.1, "Colors:", true, wCars)
	guiSetFont(lColors, "default-bold-small")
	
	sCol1 = guiCreateScrollBar(0.6, 0.25, 0.35, 0.1, true, true, wCars)
	sCol2 = guiCreateScrollBar(0.6, 0.35, 0.35, 0.1, true, true, wCars)
	
	addEventHandler("onClientGUIScroll", sCol1, updateColors)
	addEventHandler("onClientGUIScroll", sCol2, updateColors)
	
	setCameraMatrix(1976.9145507813, 2037.1280517578, 15.8129882812, 1986.1385498047, 2050.2172851563, 10.8203125)
	
	guiSetInputEnabled(true)
	
	outputChatBox("Welcome to Daker Auto's.")
end
addEvent("showCarshopUI", true)
addEventHandler("showCarshopUI", getRootElement(), showCarshopUI)

function updateCar()
	local row, col = guiGridListGetSelectedItem(gCars)
	
	if (row~=-1) and (col~=-1) then
		setElementModel(car, tonumber(vehicleIDs[tostring(guiGridListGetItemText(gCars, row, col))]))
		guiSetText(lCost, "Cost: " .. tostring(tonumber(vehicleCosts[tostring(guiGridListGetItemText(gCars, row, col))])) .. "$")
		
		local money = getElementData(getLocalPlayer(), "money")
		if (tonumber(vehicleCosts[tostring(guiGridListGetItemText(gCars, row, col))])>money) then
			guiLabelSetColor(lCost, 255, 0, 0)
			guiSetEnabled(bBuy, false)
		else
			guiLabelSetColor(lCost, 0, 255, 0)
			guiSetEnabled(bBuy, true)
		end
	else
		guiSetEnabled(bBuy, false)
	end
end

function updateColors()
	local col1 = guiScrollBarGetScrollPosition(sCol1)
	local col2 = guiScrollBarGetScrollPosition(sCol2)
	setVehicleColor(car, col1, col2, col1, col2)
end

function rotateCar()
	local rx, ry, rz = getElementRotation(car)
	setElementRotation(car, rx, ry, rz+1)
end

function hideCarshopUI()
	destroyElement(bClose)
	bClose = nil
	
	destroyElement(bBuy)
	bBuy = nil
	
	destroyElement(car)
	car = nil
	
	destroyElement(gCars)
	gCars = nil
	
	destroyElement(lCost)
	lCost = nil
	
	destroyElement(lColors)
	lColors = nil
	
	destroyElement(sCol1)
	sCol1 = nil
	
	destroyElement(sCol2)
	sCol2 = nil
	
	destroyElement(wCars)
	wCars = nil
	
	removeEventHandler("onClientRender", getRootElement(), rotateCar)
	
	setCameraTarget(getLocalPlayer())
	guiSetInputEnabled(false)
end

function buyCar(button)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(gCars)
		local car = tostring(guiGridListGetItemText(gCars, row, col))
		local cost = tostring(tonumber(vehicleCosts[car]))
		local id = vehicleIDs[car]
		local col1 = guiScrollBarGetScrollPosition(sCol1)
		local col2 = guiScrollBarGetScrollPosition(sCol2)

		hideCarshopUI()
		triggerServerEvent("buyCar", getLocalPlayer(), car, cost, id, col1, col2)
	end
end