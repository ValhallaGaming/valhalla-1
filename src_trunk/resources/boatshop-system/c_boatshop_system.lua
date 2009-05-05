car, wCars, bClose, bBuy, gCars, lCost, lColors, sCol1, sCol2 = nil

vehicleIDs = { }
vehicleCosts = { }
vehicles = { "Dinghy", "Reefer", "Speeder", "Tropic", "Jetmax", "Squalo", "Marquis" }

vehicleIDs["Dinghy"] = 473
vehicleCosts["Dinghy"] = 5000

vehicleIDs["Reefer"] = 453
vehicleCosts["Reefer"] = 450000

vehicleIDs["Speeder"] = 452
vehicleCosts["Speeder"] = 500000

vehicleIDs["Tropic"] = 454
vehicleCosts["Tropic"] = 550000

vehicleIDs["Jetmax"] = 493
vehicleCosts["Jetmax"] = 580000

vehicleIDs["Squalo"] = 446
vehicleCosts["Squalo"] = 800000

vehicleIDs["Marquis"] = 484
vehicleCosts["Marquis"] = 1200000

function showCarshopUI()
	local width, height = 400, 200
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth - width
	local y = scrHeight/10
	
	wCars = guiCreateWindow(x, y, width, height, "The Rusted Anchor: Purchase a Boat", false)
	guiWindowSetSizable(wCars, false)
	
	bClose = guiCreateButton(0.6, 0.85, 0.2, 0.1, "Close", true, wCars)
	bBuy = guiCreateButton(0.825, 0.85, 0.2, 0.1, "Buy", true, wCars)
	addEventHandler("onClientGUIClick", bClose, hideCarshopUI, false)
	addEventHandler("onClientGUIClick", bBuy, buyCar, false)
	
	car = createVehicle(473, -2412.396484375, 2235.3625488281, -0.55000001192093, 0, 0, 270)
	setVehicleColor(car, 0, 0, 0, 0)
	setVehicleEngineState(car, true)
	
	gCars = guiCreateGridList(0.05, 0.1, 0.5, 0.75, true, wCars)
	addEventHandler("onClientGUIClick", gCars, updateCar, false)
	local col = guiGridListAddColumn(gCars, "Boat Model", 0.9)
	for key, value in ipairs(vehicles) do
		local row = guiGridListAddRow(gCars)
		guiGridListSetItemText(gCars, row, col, tostring(value), false, false)
	end
	guiGridListSetSelectedItem(gCars, 0, 1)
	
	lCost = guiCreateLabel(0.3, 0.85, 0.2, 0.1, "Cost: " .. vehicleCosts["Dinghy"] .. "$", true, wCars)
	guiSetFont(lCost, "default-bold-small")
	
	updateCar()
	
	lColors = guiCreateLabel(0.6, 0.15, 0.2, 0.1, "Colors:", true, wCars)
	guiSetFont(lColors, "default-bold-small")
	
	sCol1 = guiCreateScrollBar(0.6, 0.25, 0.35, 0.1, true, true, wCars)
	sCol2 = guiCreateScrollBar(0.6, 0.35, 0.35, 0.1, true, true, wCars)
	
	addEventHandler("onClientGUIScroll", sCol1, updateColors)
	addEventHandler("onClientGUIScroll", sCol2, updateColors)
	
	setCameraMatrix(-2412.396484375, 2260.0166015625, 8.55000001192093, -2412.396484375, 2235.3625488281, -0.55000001192093)
	
	guiSetInputEnabled(true)
	
	outputChatBox("Welcome to The Rusted Anchor.")
end
addEvent("showBoatshopUI", true)
addEventHandler("showBoatshopUI", getRootElement(), showCarshopUI)

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
	
	--removeEventHandler("onClientRender", getRootElement(), rotateCar)
	
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
		triggerServerEvent("buyBoat", getLocalPlayer(), car, cost, id, col1, col2)
	end
end