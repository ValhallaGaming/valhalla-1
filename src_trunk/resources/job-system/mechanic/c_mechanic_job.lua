-- Main Mechanic window
wMechanic, bMechanicOne, bMechanicOne, bMechanicThree, bMechanicClose = nil

-- Tyre change window
wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil

-- Paint window
wPaint, iColour1, iColour2, iColour3, iColour4, colourChart, bPaintSubmit, bPaintClose = nil

currentVehicle = nil

function displayMechanicJob()
	outputChatBox("#FF9933Use the #FF0000right-click menu#FF9933 to view the services you can provide.", 255, 194, 15, true)
end

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
				
				-- Body work
				bMechanicOne = guiCreateButton( 0.05, 0.05, 0.9, 0.1, "Bodywork Repair - $50", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicOne, bodyworkTrigger, false)
				
				-- Service
				bMechanicTwo = guiCreateButton( 0.05, 0.15, 0.9, 0.1, "Full Service - $100", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicTwo, serviceTrigger, false)
				
				-- Tyre Change
				bMechanicThree = guiCreateButton( 0.05, 0.25, 0.9, 0.1, "Tyre Change - $10", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicThree, tyreWindow, false)
				
				-- Recolour
				bMechanicFour = guiCreateButton( 0.05, 0.35, 0.9, 0.1, "Repaint Vehicle - $100", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicFour, paintWindow, false)
				
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
	local Width = 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wTyre) then
		-- Create the window
		wTyre = guiCreateWindow(X+100, Y, Width, Height, "Select a tyre to change.", false )
		
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
		
		-- Close
		bTyreClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Close", true, wTyre )
		addEventHandler( "onClientGUIClick", bTyreClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bTyreOne)
				destroyElement(bTyreTwo)
				destroyElement(bTyreThree)
				destroyElement(bTyreFour)
				destroyElement(bTyreClose)
				destroyElement(wTyre)
				wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
				
			end
		end, false)
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
				
				if(col1 == "") and (col2 == "") and (col3 == "") and (col4 == "")then
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
					
					triggerServerEvent( "repaintVehicle", getLocalPlayer(), currentVehicle, col1, col2, col3, col4)
					
					closeMechanicWindow()
				end				
			end
		end, false)
		
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
				
			end
		end, false)	 
	end
end

function serviceTrigger()
	triggerServerEvent( "serviceVehicle", currentVehicle, getLocalPlayer())
	closeMechanicWindow()
end

function bodyworkTrigger()
	triggerServerEvent( "repairBody", currentVehicle, getLocalPlayer())
	closeMechanicWindow()
end

function closeMechanicWindow()
	
	if(wTyre)then
		destroyElement(bTyreOne)
		destroyElement(bTyreTwo)
		destroyElement(bTyreThree)
		destroyElement(bTyreFour)
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
	end
	
	destroyElement(bMechanicOne)
	destroyElement(bMechanicTwo)
	destroyElement(bMechanicThree)
	destroyElement(bMechanicClose)
	destroyElement(wMechanic)
	wMechanic, bMechanicOne, bMechanicOne, bMechanicClose, bMechanicThree = nil
	
	currentVehicle = nil
	
	showCursor(false)
end

