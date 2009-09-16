-- Main Mechanic window
wMechanic, bMechanicOne, bMechanicOne, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix, bMechanicClose = nil

-- Tyre change window
wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil

-- Paint window
wPaint, iColour1, iColour2, iColour3, iColour4, colourChart, bPaintSubmit, bPaintClose = nil

-- Paintjob window
wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil

-- Upgrade window
wUpgrades, gUpgrades, bUpgradesClose = nil

currentVehicle = nil
vehicleWithPaintjob = { [534] = true, [535] = true, [558] = true, [559] = true, [560] = true, [561] = true, [562] = true, [565] = true }

function displayMechanicJob()
	outputChatBox("#FF9933Use the #FF0000right-click menu#FF9933 to view the services you can provide.", 255, 194, 15, true)
end

local noTyres = { Boat = true, Helicopter = true, Plane = true, Train = true }
local noUpgrades = { Boat = true, Helicopter = true, Plane = true, Train = true, BMX = true }

function mechanicWindow(vehicle)
	local job = getElementData(getLocalPlayer(), "job")
	if (job==5)then
		if not vehicle then
			outputChatBox("You must select a vehicle.", 255, 0, 0)
		else
			currentVehicle = vehicle
			-- Window variables
			local Width = 200
			local Height = 450
			local screenwidth, screenheight = guiGetScreenSize()
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			if not (wMechanic) then
				-- Create the window
				wMechanic = guiCreateWindow(X, Y, Width, Height, "Mechanic Options.", false )
				
				local y = 0.05
				-- Body work
				bMechanicOne = guiCreateButton( 0.05, y, 0.9, 0.1, "Bodywork Repair - $50", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicOne, bodyworkTrigger, false)
				y = y + 0.1
				
				-- Service
				bMechanicTwo = guiCreateButton( 0.05, y, 0.9, 0.1, "Full Service - $100", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicTwo, serviceTrigger, false)
				y = y + 0.1
				
				-- Tyre Change
				if not noTyres[getVehicleType(vehicle)] then
					bMechanicThree = guiCreateButton( 0.05, y, 0.9, 0.1, "Tyre Change - $10", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicThree, tyreWindow, false)
					y = y + 0.1
				end
				
				-- Recolour
				bMechanicFour = guiCreateButton( 0.05, y, 0.9, 0.1, "Repaint Vehicle - $100", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicFour, paintWindow, false)
				y = y + 0.1
				
				-- Upgrades
				if not noUpgrades[getVehicleType(vehicle)] and #getVehicleCompatibleUpgrades(vehicle) > 0 then
					bMechanicFive = guiCreateButton( 0.05, y, 0.9, 0.1, "Add Upgrade", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicFive, upgradeWindow, false)
					y = y + 0.1
				end
				
				-- Paintjob
				if vehicleWithPaintjob[getElementModel(vehicle)] then
					bMechanicSix = guiCreateButton( 0.05, y, 0.9, 0.1, "Paintjob - $7500", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicSix, paintjobWindow, false)
					y = y + 0.1
				end
				
				-- Close
				bMechanicClose = guiCreateButton( 0.05, 0.85, 0.9, 0.1, "Close", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicClose, closeMechanicWindow, false )
				
				showCursor(true)
			end
		end
	end
end
addEvent("openMechanicFixWindow")
addEventHandler("openMechanicFixWindow", getRootElement(), mechanicWindow)
-- addCommandHandler("fix", mechanicWindow, false, false)

function tyreWindow()
	-- Window variables
	local Width = getVehicleType(currentVehicle) == "Bike" and 100 or 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wTyre) then
		-- Create the window
		wTyre = guiCreateWindow(X+100, Y, Width, Height, "Select a tyre to change.", false )
		
		if getVehicleType(currentVehicle) ~= "Bike" then
			-- Front left
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.45, 0.35, "Front Left", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- Back left
			bTyreTwo = guiCreateButton( 0.05, 0.5, 0.45, 0.35, "Back Left", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreTwo, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- front right
			bTyreThree = guiCreateButton( 0.5, 0.1, 0.45, 0.35, "Front Right", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 3)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- back right
			bTyreFour = guiCreateButton( 0.5, 0.5, 0.45, 0.35, "Back Right", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreFour, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 4)
					closeMechanicWindow()
					
				end
			end, false)
		else
			-- Front
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.9, 0.35, "Front", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
		
			-- back right
			bTyreThree = guiCreateButton( 0.05, 0.5, 0.9, 0.35, "Back", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
		end
		-- Close
		bTyreClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wTyre )
		addEventHandler( "onClientGUIClick", bTyreClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bTyreOne)
				if bTyreTwo then
					destroyElement(bTyreTwo)
				end
				destroyElement(bTyreThree)
				if bTyreFour then
					destroyElement(bTyreFour)
				end
				destroyElement(bTyreClose)
				destroyElement(wTyre)
				wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
				
			end
		end, false)
	end
end

function previewColors()
	local col1 = guiGetText(iColour1)
	local col2 = guiGetText(iColour2)
	local col3 = guiGetText(iColour3)
	local col4 = guiGetText(iColour4)
	
	if(col1 == "") and (col2 == "") and (col3 == "") and (col4 == "") then
		triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
	else
		if(col1 == "") then
			col1 = nil
		end
		if(col2 == "") then
			col2 = nil
		end
		if(col3 == "") then
			col3 = nil
		end
		if(col4 == "") then
			col4 = nil
		end
		
		triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, col1, col2, col3, col4)
	end
end

function paintWindow()
	-- Window variables
	local Width = 700
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wPaint) then
		guiSetInputEnabled(true)
		
		-- Create the window
		wPaint = guiCreateWindow(X, Y, Width, Height, "Enter the colours to paint the vehicle.", false )
		
		-- Colour chart image
		colourChart = guiCreateStaticImage( 0.05, 0.1, 0.75, 0.65, "mechanic/colourChart.png", true, wPaint)
		
		-- colour ID inputs
		iColour1 = guiCreateEdit( 0.85, 0.2, 0.25, 0.075, "", true, wPaint )
		lcol1 = guiCreateLabel( 0.85, 0.1, 0.25, 0.075, "Colour 1 ID", true, wPaint )
		iColour2 = guiCreateEdit( 0.85, 0.4, 0.25, 0.075, "", true, wPaint )
		lcol2 = guiCreateLabel( 0.85, 0.3, 0.25, 0.075, "Colour 2 ID", true, wPaint )
		iColour3 = guiCreateEdit( 0.85, 0.6, 0.25, 0.075, "", true, wPaint )
		lcol3 = guiCreateLabel( 0.85, 0.5, 0.25, 0.075, "Colour 3 ID", true, wPaint )
		iColour4 = guiCreateEdit( 0.85, 0.8, 0.25, 0.075, "", true, wPaint )
		lcol4 = guiCreateLabel( 0.85, 0.7, 0.25, 0.075, "Colour 4 ID", true, wPaint )
		
		-- Repaint
		bPaintSubmit = guiCreateButton( 0.05, 0.8, 0.3, 0.2, "Paint Vehicle", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintSubmit,  function(button, state)
			if(button == "left" and state == "up") then
				
				local col1 = guiGetText(iColour1)
				local col2 = guiGetText(iColour2)
				local col3 = guiGetText(iColour3)
				local col4 = guiGetText(iColour4)
				
				if(col1 == "") and (col2 == "") and (col3 == "") and (col4 == "") then
					outputChatBox("You need to input at least one colour ID", 255, 0, 0)
				else
					if(col1 == "") then
						col1 = nil
					end
					if(col2 == "") then
						col2 = nil
					end
					if(col3 == "") then
						col3 = nil
					end
					if(col4 == "") then
						col4 = nil
					end
					
					triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
					triggerServerEvent( "repaintVehicle", getLocalPlayer(), currentVehicle, col1, col2, col3, col4)
					
					closeMechanicWindow()
				end				
			end
		end, false)
		
		addEventHandler( "onClientGUIChanged", iColour1, previewColors, false )
		addEventHandler( "onClientGUIChanged", iColour2, previewColors, false )
		addEventHandler( "onClientGUIChanged", iColour3, previewColors, false )
		addEventHandler( "onClientGUIChanged", iColour4, previewColors, false )
		
		-- Close
		bPaintClose = guiCreateButton( 0.35, 0.8, 0.3, 0.2, "Close", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(iColour1)
				destroyElement(iColour2)
				destroyElement(iColour3)
				destroyElement(iColour4)
				destroyElement(lcol1)
				destroyElement(lcol2)
				destroyElement(lcol3)
				destroyElement(lcol4)
				destroyElement(colourChart)
				destroyElement(bPaintClose)
				destroyElement(wPaint)
				wPaint, iColour1, iColour2, iColour3, iColour4, lcol1, lcol2, lcol3, lcol4, colourChart, bPaintClose = nil				
				triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
				guiSetInputEnabled(false)
			end
		end, false)	 
	end
end

function paintjobWindow()
	-- Window variables
	local Width = 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wPaintjob) then
		oldPaintjob = getVehiclePaintjob( currentVehicle )
		oldColors = { getVehicleColor( currentVehicle ) }
		
		-- Create the window
		wPaintjob = guiCreateWindow(X+100, Y, Width, Height, "Select a new Paintjob.", false )
		
		-- Paintjob 1
		bPaintjob1 = guiCreateButton( 0.05, 0.1, 0.9, 0.17, "Paintjob 1", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob1, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 0)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob1, function()
			if source == bPaintjob1 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 0)
			end
		end)
		
		-- Paintjob 2
		bPaintjob2 = guiCreateButton( 0.05, 0.3, 0.9, 0.17, "Paintjob 2", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob2, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 1)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob2, function()
			if source == bPaintjob2 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 1)
			end
		end)
		
		-- Paintjob 3
		bPaintjob3 = guiCreateButton( 0.05, 0.5, 0.9, 0.17, "Paintjob 3", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob3, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 2)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob3, function()
			if source == bPaintjob3 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 2)
			end
		end)
		
		-- Paintjob 4
		bPaintjob4 = guiCreateButton( 0.05, 0.7, 0.9, 0.17, "Paintjob 4", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob4, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 3)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob4, function()
			if source == bPaintjob4 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 3)
			end
		end)
		
		function restorePaintjob()
			triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
		end
		
		addEventHandler( "onClientMouseLeave", bPaintjob1, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob2, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob3, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob4, restorePaintjob)
		
		-- Close
		bPaintjobClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjobClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bPaintjob1)
				destroyElement(bPaintjob2)
				destroyElement(bPaintjob3)
				destroyElement(bPaintjob4)
				destroyElement(bPaintjobClose)
				destroyElement(wPaintjob)
				wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
				triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
				
			end
		end, false)
	end
end

local spoilerPrice = 8000
local hoodPrice = 2700
local sideskirtPrice = 5000
local roofPrice = 2500
local lightPrice = 1500
local wheelPrice = 4500
local exhaustPrice = 2000
local bullbarPrice = 3000
local bumperPrice = 3000
local upgrades = {
	{ "Pro", spoilerPrice }, -- TRANSFENDER
	{ "Win", spoilerPrice },
	{ "Drag", spoilerPrice },
	{ "Alpha", spoilerPrice },
	{ "Champ Scoop", hoodPrice },
	{ "Fury Scoop", hoodPrice },
	{ "Roof Scoop", roofPrice },
	{ "Right Sideskirt", sideskirtPrice },
	--{ "5x Nitro", 10000 }, -- NOS
	--{ "2x Nitro", 6000 },
	--{ "10x Nitro", 20000 },
	false,
	false,
	false,
	{ "Race Scoop", hoodPrice }, -- TRANSFENDER
	{ "Worx Scoop", hoodPrice },
	{ "Round Fog", lightPrice },
	{ "Champ", spoilerPrice },
	{ "Race", spoilerPrice },
	{ "Worx", spoilerPrice },
	{ "Left Sideskirt", sideskirtPrice },
	{ "Upswept", exhaustPrice },
	{ "Twin", exhaustPrice },
	{ "Large", exhaustPrice },
	{ "Medium", exhaustPrice },
	{ "Small", exhaustPrice },
	{ "Fury", spoilerPrice },
	{ "Square Fog", lightPrice },
	{ "Offroad", wheelPrice },
	{ "Right Alien Sideskirt", sideskirtPrice }, -- SULTAN
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Alien", exhaustPrice },
	{ "X-Flow", exhaustPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien Roof Vent", roofPrice },
	{ "X-Flow Roof Vent", roofPrice },
	{ "Alien", exhaustPrice }, -- ELEGY
	{ "X-Flow Roof Vent", roofPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "X-Flow", exhaustPrice },
	{ "Alien Roof Vent", roofPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Right Chrome Sideskirt", sideskirtPrice }, -- BROADWAY
	{ "Slamin", exhaustPrice },
	{ "Chrome", exhaustPrice },
	{ "X-Flow", exhaustPrice }, -- FLASH
	{ "Alien", exhaustPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", spoilerPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "X-Flow", roofPrice },
	{ "Alien", roofPrice },
	{ "Alien", roofPrice }, -- STRATUM
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", exhaustPrice },
	{ "X-Flow", spoilerPrice },
	{ "X-Flow", roofPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", exhaustPrice },
	{ "Alien", exhaustPrice }, -- JESTER
	{ "X-Flow", exhaustPrice },
	{ "Alien", roofPrice },
	{ "X-Flow", roofPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Shadow", wheelPrice }, -- MOST CARS (WHEELS)
	{ "Mega", wheelPrice },
	{ "Rimshine", wheelPrice },
	{ "Wires", wheelPrice },
	{ "Classic", wheelPrice },
	{ "Twist", wheelPrice },
	{ "Cutter", wheelPrice },
	{ "Switch", wheelPrice },
	{ "Grove", wheelPrice },
	{ "Import", wheelPrice },
	{ "Dollar", wheelPrice },
	{ "Trance", wheelPrice },
	{ "Atomic", wheelPrice },
	{ "Stereo", 1000 },
	{ "Hydraulics", 2200 },
	{ "Alien", roofPrice }, -- URANUS
	{ "X-Flow", exhaustPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "X-Flow", roofPrice },
	{ "Alien", exhaustPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Ahab", wheelPrice }, -- MOST CARS(WHEELS)
	{ "Virtual", wheelPrice },
	{ "Access", wheelPrice },
	{ "Left Chrome Sideskirt", sideskirtPrice }, -- BROADWAY
	{ "Chrome Grill", 4000 }, -- REMINGTON
	{ "Left Chrome Flames Sideskirt", sideskirtPrice },
	{ "Left Chrome Strip Sideskirt", sideskirtPrice }, -- SAVANNA
	{ "Covertible", roofPrice }, -- BLADE
	{ "Chrome", exhaustPrice },
	{ "Slamin", exhaustPrice },
	{ "Right Chrome Arches", sideskirtPrice }, -- REMINGTON
	{ "Left Chrome Strip Sideskirt", sideskirtPrice }, -- BLADE
	{ "Right Chrome Strip Sideskirt", sideskirtPrice },
	{ "Chrome", bullbarPrice }, -- SLAMVAN
	{ "Slamin", bullbarPrice },
	false,
	false, 
	{ "Chrome", exhaustPrice },
	{ "Slamin", exhaustPrice },
	{ "Chrome", bullbarPrice },
	{ "Slamin", bullbarPrice },
	{ "Chrome", bumperPrice },
	{ "Right Chrome Trim Sideskirt", sideskirtPrice },
	{ "Right Wheelcovers Sideskirt", sideskirtPrice },
	{ "Left Chrome Trim Sideskirt", sideskirtPrice },
	{ "Left Wheelcovers Sideskirt", sideskirtPrice },
	{ "Right Chrome Flames Sideskirt", sideskirtPrice }, -- REMINGTON
	{ "Bullbar Chrome Bars", bullbarPrice },
	{ "Left Chrome Arches Sideskirt", sideskirtPrice },
	{ "Bullbar Chrome Lights", bullbarPrice },
	{ "Chrome Exhaust", exhaustPrice },
	{ "Slamin Exhaust", exhaustPrice },
	{ "Vinyl Hardtop", roofPrice }, -- BLADE
	{ "Chrome", exhaustPrice }, -- SAVANNA
	{ "Hardtop", roofPrice },
	{ "Softtop", roofPrice },
	{ "Slamin", exhaustPrice },
	{ "Right Chrom Strip Sideskirt", sideskirtPrice },
	{ "Right Chrom Strip Sideskirt", sideskirtPrice }, -- TORNADO
	{ "Slamin", exhaustPrice },
	{ "Chrome", exhaustPrice },
	{ "Left Chrome Strip Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice }, -- SULTAN
	{ "X-Flow", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Left Oval Vents", 500 }, -- CERTAIN TRANSFENDER CARS
	{ "Right Oval Vents", 500 },
	{ "Left Square Vents", 500 },
	{ "Right Square Vents", 500 },
	{ "X-Flow", spoilerPrice }, -- ELEGY
	{ "Alien", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- FLASH
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- STRATUM
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "X-Flow", spoilerPrice }, -- JESTER
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", spoilerPrice }, -- URANUS
	{ "Alien", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- SULTAN
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice }, -- ELEGY
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice }, -- JESTER
	{ "Chrome", bumperPrice }, -- BROADWAY
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Slamin", bumperPrice }, -- REMINGTON
	{ "Chrome", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- BLADE
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- REMINGTON
	{ "Slamin", bumperPrice }, -- SAVANNA
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- TORNADO
	{ "Chrome", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }
}

oldUpgradeSlot = nil
function upgradeWindow()
	-- Window variables
	local Width = 270
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wUpgrades) then
		-- Create the window
		wUpgrades = guiCreateWindow(X+100, Y, Width, Height, "Select the Upgrades you want", false )
		
		-- Add a gridlist with upgrades
		gUpgrades = guiCreateGridList( 0.05, 0.1, 0.9, 0.75, true, wUpgrades )
		cUpgradeName = guiGridListAddColumn( gUpgrades, "Name", 0.62 )
		cUpgradePrice = guiGridListAddColumn( gUpgrades, "Price", 0.25 )
		cUpgradeSlot = guiGridListAddColumn( gUpgrades, "", 0.01 )
		
		-- add all compatible upgrades
		for i = 0, 16 do
			if i ~= 8 then -- skip nos
				local slotupgrades = getVehicleCompatibleUpgrades(currentVehicle, i)
				if #slotupgrades > 0 then
					local row = guiGridListAddRow( gUpgrades )
					guiGridListSetItemText( gUpgrades, row, cUpgradeName, getVehicleUpgradeSlotName(i), true, false)
					
					local currentUpgrade = getVehicleUpgradeOnSlot(currentVehicle, i)
					-- add all items for that category
					for key, value in pairs(slotupgrades) do
						local upgrade = upgrades[value - 999]
						if upgrade then
							local row = guiGridListAddRow( gUpgrades )
							guiGridListSetItemText( gUpgrades, row, cUpgradeName, upgrade[1], false, true)
							guiGridListSetItemData( gUpgrades, row, cUpgradeName, tostring(value))
							guiGridListSetItemText( gUpgrades, row, cUpgradePrice, "$" .. upgrade[2], false, true)
							guiGridListSetItemData( gUpgrades, row, cUpgradePrice, tostring(upgrade[2]))
							guiGridListSetItemText( gUpgrades, row, cUpgradeSlot, " ", false, true)
							guiGridListSetItemData( gUpgrades, row, cUpgradeSlot, tostring(i))
						end
					end
				end
			end
		end
		
		addEventHandler( "onClientGUIClick", gUpgrades, function(button, state)
			if button == "left" and state == "up" then
				if oldUpgradeSlot then
					triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
					oldUpgradeSlot = nil
				end
				local row, col = guiGridListGetSelectedItem(gUpgrades)
				if row ~= -1 and col ~= -1 then
					oldUpgradeSlot = tonumber(guiGridListGetItemData(gUpgrades, row, 3))
					triggerServerEvent( "upgradePreview", getLocalPlayer(), currentVehicle, tonumber(guiGridListGetItemData(gUpgrades, row, 1)), oldUpgradeSlot)
				end
			end
		end)
		
		addEventHandler( "onClientGUIDoubleClick", gUpgrades, function(button, state)
			if button == "left" and state == "up" then
				if oldUpgradeSlot then
					triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
					oldUpgradeSlot = nil
				end
				local row, col = guiGridListGetSelectedItem(gUpgrades)
				if row ~= -1 and col ~= -1 then
					triggerServerEvent( "changeVehicleUpgrade", getLocalPlayer(), currentVehicle, tonumber(guiGridListGetItemData(gUpgrades, row, 1)), guiGridListGetItemText(gUpgrades, row, 1), tonumber(guiGridListGetItemData(gUpgrades, row, 2)))
				end
			end
		end)		
		-- Close
		bUpgradesClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wUpgrades )
		addEventHandler( "onClientGUIClick", bUpgradesClose, function(button, state)
			if(button == "left" and state == "up") then
				if oldUpgradeSlot then
					triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
					oldUpgradeSlot = nil
				end
				destroyElement(bUpgradesClose)
				destroyElement(gUpgrades)
				destroyElement(wUpgrades)
				wUpgrades, gUpgrades, bUpgradesClose = nil
			end
		end, false)
	end
end

function serviceTrigger()
	triggerServerEvent( "serviceVehicle", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function bodyworkTrigger()
	triggerServerEvent( "repairBody", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function closeMechanicWindow()
	
	if(wTyre)then
		destroyElement(bTyreOne)
		if bTyreTwo then
			destroyElement(bTyreTwo)
		end
		destroyElement(bTyreThree)
		if bTyreFour then
			destroyElement(bTyreFour)
		end
		destroyElement(bTyreClose)
		destroyElement(wTyre)
		wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
	end
	
	if(wPaint)then
		destroyElement(iColour1)
		destroyElement(iColour2)
		destroyElement(iColour3)
		destroyElement(iColour4)
		destroyElement(lcol1)
		destroyElement(lcol2)
		destroyElement(lcol3)
		destroyElement(lcol4)
		destroyElement(colourChart)
		destroyElement(bPaintClose)
		destroyElement(wPaint)
		wPaint, iColour1, iColour2, iColour3, iColour4, lcol1, lcol2, lcol3, lcol4, colourChart, bPaintClose = nil
		triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
		guiSetInputEnabled(false)
	end
	
	if wPaintjob then
		destroyElement(bPaintjob1)
		destroyElement(bPaintjob2)
		destroyElement(bPaintjob3)
		destroyElement(bPaintjob4)
		destroyElement(bPaintjobClose)
		destroyElement(wPaintjob)
		wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
		triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
	end
	
	if wUpgrades then
		destroyElement(bUpgradesClose)
		destroyElement(gUpgrades)
		destroyElement(wUpgrades)
		wUpgrades, gUpgrades, bUpgradesClose = nil	
		
		if oldUpgradeSlot then
			triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
			oldUpgradeSlot = nil
		end
	end
	
	destroyElement(bMechanicOne)
	destroyElement(bMechanicTwo)
	if bMechanicThree then
		destroyElement(bMechanicThree)
	end
	destroyElement(bMechanicFour)
	if bMechanicFive then
		destroyElement(bMechanicFive)
	end
	if bMechanicSix then
		destroyElement(bMechanicSix)
	end
	destroyElement(bMechanicClose)
	destroyElement(wMechanic)
	wMechanic, bMechanicOne, bMechanicOne, bMechanicClose, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix = nil
	
	currentVehicle = nil
	
	showCursor(false)
end

