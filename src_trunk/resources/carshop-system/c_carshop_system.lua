car, wCars, bClose, bBuy, gCars, lCost, lColors, sCol1, sCol2 = nil
activeShop, shopID = nil

local function countVehicles( )
	vehiclecount = {}
	for key, value in pairs( getElementsByType( "vehicle" ) ) do
		if isElement( value ) then
			local model = getElementModel( value )
			if vehiclecount[ model ] then
				vehiclecount[ model ] = vehiclecount[ model ] + 1
			else
				vehiclecount[ model ] = 1
			end
		end
	end
end

local function copy( t )
	if type(t) == 'table' then
		local r = {}
		for k, v in pairs( t ) do
			r[k] = copy( v )
		end
		return r
	else
		return t
	end
end

local function sort( a, b )
	return a[2] < b[2]
end

function showCarshopUI(id)
	shopID = id
	
	countVehicles()
	activeShop = copy( g_shops[id] )
	
	local width, height = 400, 200
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth - width
	local y = scrHeight/10
	
	wCars = guiCreateWindow(x, y, width, height, activeShop.name .. ": Purchase a Vehicle", false)
	guiWindowSetSizable(wCars, false)
	
	bClose = guiCreateButton(0.6, 0.85, 0.2, 0.1, "Close", true, wCars)
	bBuy = guiCreateButton(0.825, 0.85, 0.2, 0.1, "Buy", true, wCars)
	addEventHandler("onClientGUIClick", bClose, hideCarshopUI, false)
	addEventHandler("onClientGUIClick", bBuy, buyCar, false)
	
	car = createVehicle(451, unpack(activeShop.previewpos))
	setVehicleColor(car, 0, 0, 0, 0)
	setVehicleEngineState(car, true)
	setVehicleOverrideLights(car, 2)
	
	if activeShop.rotate then
		addEventHandler("onClientRender", getRootElement(), rotateCar)
	end
	
	-- sort by price
	for key, value in ipairs( activeShop ) do
		if value[1] and value[2] and vehiclecount[ value[1] ] then
			value[2] = value[2] + ( vehiclecount[ value[1] ] or 0 ) * 600
		end
	end
	table.sort( activeShop, sort )
	
	gCars = guiCreateGridList(0.05, 0.1, 0.5, 0.75, true, wCars)
	addEventHandler("onClientGUIClick", gCars, updateCar, false)
	local col = guiGridListAddColumn(gCars, "Vehicle Model", 0.9)
	for key, value in ipairs( activeShop ) do
		local row = guiGridListAddRow(gCars)
		guiGridListSetItemText(gCars, row, col, tostring(getVehicleNameFromModel(value[1])), false, false)
		guiGridListSetItemData(gCars, row, col, tostring(key), false, false)
	end
	
	lCost = guiCreateLabel(0.3, 0.85, 0.2, 0.1, "Cost: ---", true, wCars)
	guiSetFont(lCost, "default-bold-small")
	guiGridListSetSelectedItem(gCars, 0, 1)
	
	updateCar()
	
	lColors = guiCreateLabel(0.6, 0.15, 0.2, 0.1, "Colors:", true, wCars)
	guiSetFont(lColors, "default-bold-small")
	
	sCol1 = guiCreateScrollBar(0.6, 0.25, 0.35, 0.1, true, true, wCars)
	sCol2 = guiCreateScrollBar(0.6, 0.35, 0.35, 0.1, true, true, wCars)
	
	addEventHandler("onClientGUIScroll", sCol1, updateColors)
	addEventHandler("onClientGUIScroll", sCol2, updateColors)
	
	guiSetProperty(sCol1, "StepSize", "0.01")
	guiSetProperty(sCol2, "StepSize", "0.01")
	
	setCameraMatrix(unpack(activeShop.cameramatrix))
	
	guiSetInputEnabled(true)
	
	outputChatBox("Welcome to " .. activeShop.name .. ".")
end
addEvent("showCarshopUI", true)
addEventHandler("showCarshopUI", getRootElement(), showCarshopUI)

function updateCar()
	local row, col = guiGridListGetSelectedItem(gCars)
	
	if row ~= -1 and col ~= -1 then
		local key = tonumber(guiGridListGetItemData(gCars, row, col))
		local value = activeShop[key]
		setElementModel(car, value[1])
		guiSetText(lCost, "Cost: " .. tostring(value[2]) .. "$")
		
		local money = exports.global:getMoney(getLocalPlayer())
		if value[2] > money then
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
	setElementRotation(car, 0, 0, rz+1)
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
	
	if activeShop.rotate then
		removeEventHandler("onClientRender", getRootElement(), rotateCar)
	end
	
	activeShop = nil
	shopID = nil

	setCameraTarget(getLocalPlayer())
	guiSetInputEnabled(false)
end

function buyCar(button)
	if (button=="left") then
		if exports.global:hasSpaceForItem(getLocalPlayer()) then
			local row, col = guiGridListGetSelectedItem(gCars)
			local key = tonumber(guiGridListGetItemData(gCars, row, col))
			local value = activeShop[key]
			local car = value[1]
			local cost = value[2]
			local col1 = guiScrollBarGetScrollPosition(sCol1)
			local col2 = guiScrollBarGetScrollPosition(sCol2)
			
			local px, py, pz, prz = unpack(activeShop.player)
			local x, y, z, rz = unpack(activeShop.car)
			local shopid = shopID

			hideCarshopUI()
			triggerServerEvent("buyCar", getLocalPlayer(), car, cost, col1, col2, x, y, z, rz, px, py, pz, prz, shopid)
		else
			outputChatBox("You can't carry the car keys - your inventory is full.", 255, 0, 0)
		end
	end
end
