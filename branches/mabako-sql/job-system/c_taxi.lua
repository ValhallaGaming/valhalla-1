-------------------------------------------------------
--	Script written by Morelli
--	Given copy to vg.MTA on 17th December 2008
--
--
-- THIS COPY WAS INTENDED FOR vG.MTA
-- GAMING ONLY. FULL RIGHTS TO SCRIPT
-- ARE HELD BY Morelli (Cris G.)
-------------------------------------------------------



taxiID = { [420]=true,[438]=true } -- Define what vehicle ID the Cabbie and Taxi is
busID = { [431]=true, [437]=true } -- Define what vehicle ID the Bus and Coach is
trainID = { [537]=true, [538]=true, [449]=true } -- Define what vehicle ID the Brownstreak  (train) and the Freight (train) is
tcarriageID = { [569]=true, [590]=true, [570]=true } -- Define what vehicle ID the Freight Flat Trailer (Train), Freight Box Trailer (Train) and the Streak Trailer (Train) is
oX, oY, oZ = nil
totaldistanceTraveled = 0.0
--------------------------------------------------------------------------------

g_root = getRootElement()
g_rootElement = getResourceRootElement( getThisResource() )
g_Player = getLocalPlayer()

-----------------------------------[FARE]------------------------------------

TaxiGui = nil

function TaxiSettings ( theVehicle, seat )
	if (taxiID[getElementModel ( theVehicle )]) then
		local width, height = 200, 150
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)+100
		local y = scrHeight - (height+20)
		TaxiGui = guiCreateStaticImage ( x, y, width, height, "images/Background.png", false )
		ArrowUp = guiCreateStaticImage ( 163, 125, 10, 10, "images/ArrowUP.png", false, TaxiGui )
		ArrowDown = guiCreateStaticImage ( 163, 138, 10, 10, "images/ArrowDOWN.png", false, TaxiGui )
			
		FarePrice = guiCreateLabel ( 20, 123, 70, 20, "0", false, TaxiGui )
		guiLabelSetHorizontalAlign ( FarePrice, "right" )
			
		--DistanceKM = guiCreateLabel ( 20, 85, 65, 20, "0", false, TaxiGui )
		--guiLabelSetHorizontalAlign ( DistanceKM, "right" )
		--guiSetFont ( DistanceKM, "clear-normal" )
		
		--guiCreateLabel ( 90, 85, 55, 20, ".", false, TaxiGui )
		
		DistanceM = guiCreateLabel ( 90, 85, 30, 20, "000", false, TaxiGui )
		guiLabelSetHorizontalAlign ( DistanceM, "right" )
		guiSetFont ( DistanceM, "clear-normal" )
		
		TotalFarePrice = guiCreateLabel ( 30, 28, 95, 20, "0", false, TaxiGui )
		guiLabelSetHorizontalAlign ( TotalFarePrice, "left" )
		guiSetFont ( TotalFarePrice, "clear-normal" )
		
		setVehicleTaxiLightOn(theVehicle, true)
		
		OnButton = guiCreateStaticImage ( 180, 5, 20, 21, "images/On.png", false, TaxiGui )
		PauseButton = guiCreateStaticImage ( 180, 20, 20, 21, "images/Pause.png", false, TaxiGui )
		OffButton = guiCreateStaticImage ( 180, 35, 20, 21, "images/Off.png", false, TaxiGui )
		
		OFFLight = guiCreateStaticImage ( 163, 22, 15, 15, "images/OFFlight.png", false, TaxiGui )
		
		if ( seat == 0 ) then -- Only the driver has access to these buttons
			addEventHandler("onClientGUIClick", ArrowUp, ChangeFareSetting)
			addEventHandler("onClientGUIClick", ArrowDown, ChangeFareSetting)
			addEventHandler("onClientGUIClick", OnButton, ChangeFareState)
			addEventHandler("onClientGUIClick", PauseButton, ChangeFareState)
			addEventHandler("onClientGUIClick", OffButton, ChangeFareState)
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter", g_Player, TaxiSettings)

function TaxiExit ( theVehicle, seat )
	if (taxiID[getElementModel ( theVehicle )]) then
		setVehicleTaxiLightOn(source, false)
		destroyElement(TaxiGui)
		TaxiGui = nil
	end
end
addEventHandler("onClientPlayerVehicleExit", g_Player, TaxiExit)

function ChangeFareSetting ( )
	local fare = tonumber(guiGetText ( FarePrice ))
	if ( source == ArrowUp ) then
		local newfare = fare +  1
		guiSetText ( FarePrice, tostring(newfare) )
	elseif ( source == ArrowDown ) then
		if ( fare ) == 0 then -- Cannot go lower than 0
		else
			local newfare = fare -  1
			guiSetText ( FarePrice, tostring(newfare) )
			local thevehicle = getPedOccupiedVehicle ( g_Player )
			setElementData( thevehicle, "fare", tostring(newfare) )
		end
	end
end

function ChangeFareState( )
	if ( source == OnButton ) then
		destroyElement(OFFLight)
		destroyElement(PAUSElight)
		OFFLight = nil
		PAUSElight = nil
		
		ONLight = guiCreateStaticImage ( 163, 22, 15, 15, "images/ONlight.png", false, TaxiGui )
		setVehicleTaxiLightOn(getPedOccupiedVehicle ( g_Player ), false)
		local totalfare = tonumber(guiGetText ( TotalFarePrice ))
		if totalfare == 0 then -- If it hasn't yet been started
			oX,oY,oZ = getElementPosition( g_Player )
			totaldistanceTraveled = 0.00
			
			addEventHandler("onClientRender", getRootElement(), monitoring)
		else
			addEventHandler("onClientRender", getRootElement(), monitoring)
		end
		
		TaxiTimer = setTimer ( updatethetotalfare, 10000, 0 ) -- Update every 10 seconds
		
		local thevehicle = getPedOccupiedVehicle ( g_Player )
		setElementData( thevehicle, "lightstate", "images/ONlight.png" )
	elseif ( source == PauseButton ) then
		destroyElement(OFFLight)
		destroyElement(ONlight)
		OFFLight = nil
		ONlight = nil
		
		PAUSELight = guiCreateStaticImage ( 163, 22, 15, 15, "images/STANDBYlight.png", false, TaxiGui )
		setVehicleTaxiLightOn(getPedOccupiedVehicle ( g_Player ), false)
		removeEventHandler ( "onClientRender", getRootElement(), monitoring )
		
		killTimer ( TaxiTimer )
		TaxiTimer = nil
		
		local thevehicle = getPedOccupiedVehicle ( g_Player )
		setElementData( thevehicle, "lightstate", "images/STANDBYlight.png" )
	elseif ( source == OffButton ) then
		destroyElement(ONLight)
		destroyElement(PAUSElight)
		ONLight = nil
		PAUSElight = nil
		
		OFFLight = guiCreateStaticImage ( 163, 22, 15, 15, "images/OFFlight.png", false, TaxiGui )
		setVehicleTaxiLightOn(getPedOccupiedVehicle ( g_Player ), true)
		killTimer ( TaxiTimer )
		TaxiTimer = nil
		
		removeEventHandler ( "onClientRender", g_Player, monitoring )
		
		killTimer ( TaxiTimer )
		TaxiTimer = nil
		
		local thevehicle = getPedOccupiedVehicle ( g_Player )
		setElementData( thevehicle, "lightstate", "images/OFFlight.png" )
		
		setElementData( thevehicle, "totalkmdistance", "0" )
		setElementData( thevehicle, "totalmdistance", "000" )
		guiSetText ( TotalFarePrice, "0" )
	end
end


function monitoring()
	local thevehicle = getPedOccupiedVehicle ( g_Player )
	---
	local x,y,z = getElementPosition(g_Player)
	totaldistanceTraveled = (totaldistanceTraveled + getDistanceBetweenPoints3D(x,y,z,oX,oY,oZ)) -- Metres
			
	local distanceMtravelled = math.floor(totaldistanceTraveled)
	
	distanceM1 = "00"..tostring(distanceMtravelled)
	guiSetText ( DistanceM, distanceM1 )

	
	
	setElementData( thevehicle, "totalkmdistance", tostring(newtotalkm) )
	setElementData( thevehicle, "totalmdistance", tostring(distanceM1) )
	
	oX = x
	oY = y
	oZ = z
end

function StoptheWorks( theVehicle )
	if (taxiID[getElementModel ( theVehicle )]) then -- If they are in a taxi
		destroyElement(TaxiGui)
		TaxiGui = nil
		removeEventHandler ( "onClientRender", getRootElement(), monitoring )
	end
end
addEventHandler("onClientVehicleStartExit", g_Player, StoptheWorks)

function updatethetotalfare( )
	local fare = tonumber(guiGetText ( FarePrice ))
	local totalfare = tonumber(guiGetText ( TotalFarePrice ))
	local newtotalfare = totalfare + fare
	guiSetText ( TotalFarePrice, newtotalfare )
	
	local thevehicle = getPedOccupiedVehicle ( g_Player )
	setElementData( thevehicle, "totalfare", tostring(newtotalfare) )
end

function UpdateForPassengers( )
	if ( isPedInVehicle ( g_Player ) ) then
		local theVehicle = getPedOccupiedVehicle ( g_Player )
		if (taxiID[getElementModel ( theVehicle )]) then
			local seat = 1
			if ( tonumber(seat) > 0 ) then -- if they are not the driver then
				local totalfare = getElementData( theVehicle, "totalfare" )
				local totalkmdistance = getElementData( theVehicle, "totalkmdistance" )
				local totalmdistance = getElementData( theVehicle, "totalmdistance" )
				local lightstate = getElementData( theVehicle, "lightstate" )
				local fare = getElementData( theVehicle, "fare" )
				
				
				------------------------------------------------------------------------------------------
				guiSetText ( DistanceM, tostring(totalmdistance) )
				guiSetText ( DistanceKM, tostring(totalkmdistance) )
				------------------------------------------------------------------------------------------
				guiSetText ( FarePrice, fare )
				guiSetText ( TotalFarePrice, totalfare )
				------------------------------------------------------------------------------------------
				if ( lightstate == "images/OFFlight.png" ) then
					destroyElement(ONLight)
					destroyElement(OFFLight)
					destroyElement(PAUSElight)
					OFFLight = nil
					PAUSElight = nil
					ONLight = nil
					
					OFFLight = guiCreateStaticImage ( 163, 22, 15, 15, lightstate, false, TaxiGui )
				elseif ( lightstate == "images/STANDBYlight.png" ) then
					destroyElement(ONLight)
					destroyElement(OFFLight)
					destroyElement(PAUSElight)
					OFFLight = nil
					PAUSElight = nil
					ONLight = nil
					
					PAUSELight = guiCreateStaticImage ( 163, 22, 15, 15, lightstate, false, TaxiGui )
				elseif ( lightstate == "images/STANDBYlight.png" ) then
					destroyElement(ONLight)
					destroyElement(OFFLight)
					destroyElement(PAUSElight)
					OFFLight = nil
					PAUSElight = nil
					ONLight = nil
					
					ONLight = guiCreateStaticImage ( 163, 22, 15, 15, "images/ONlight.png", false, TaxiGui )
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), UpdateForPassengers)
