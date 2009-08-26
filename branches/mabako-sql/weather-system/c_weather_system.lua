-- Weather system for Concrete Jungle Roleplay, written by Peter Gibbons (aka. Jason) on 16/08/08 --


function createWeatherGUI(weather)
	
	local X = 0.35
        local Y = 0.35
        local Width = 0.3
        local Height = 0.3
	
        guiWeather = guiCreateWindow(X, Y, Width, Height, "Weather Control Center", true)

	if(weather == "cloudy") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "cloudy.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Current Weather: Cloudy", true, guiWeather )
	elseif(weather == "clear") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "clear.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Current Weather: Clear", true, guiWeather )
	elseif(weather == "hot") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "hot.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Current Weather: Hot", true, guiWeather )
	elseif(weather == "rain") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "rain.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Current Weather: Rain", true, guiWeather )
	elseif(weather == "fog") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "foggy.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Current Weather: Foggy", true, guiWeather )
	end

	guiLabelSetHorizontalAlign ( guiWeatherNowLabel , "center")
	
	guiWeatherLable =  guiCreateLabel  ( 0.05 , 0.6, 1, 0.1, "Click on a button below to change the weather:", true, guiWeather )
	
	HotButton = guiCreateButton( 0.05, 0.72, 0.15, 0.1, "Hot", true, guiWeather )
	ClearButton = guiCreateButton( 0.23, 0.72, 0.15, 0.1, "Clear", true, guiWeather )
	CloudyButton = guiCreateButton( 0.41, 0.72, 0.15, 0.1, "Cloudy", true, guiWeather )
	FogButton = guiCreateButton( 0.59, 0.72, 0.15, 0.1, "Fog", true, guiWeather )
	RainButton = guiCreateButton( 0.77, 0.72, 0.15, 0.1, "Rain", true, guiWeather )
	
	ExitButton = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Back", true, guiWeather )
	guiLabelSetHorizontalAlign ( exitbutton , "center")
	
	addEventHandler ( "onClientGUIClick", HotButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(), getLocalPlayer(),"hot" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", ClearButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(), getLocalPlayer(), "clear" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", CloudyButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"cloudy" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", FogButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"fog" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", RainButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"rain" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	
	addEventHandler ( "onClientGUIClick", ExitButton,  function()  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	
	guiSetVisible(guiWeather, false)
	
end



function showWeatherControlGUI( weather)

	if(source == getLocalPlayer()) then
		createWeatherGUI(weather)
		guiSetInputEnabled ( true )
		guiSetVisible(guiWeather, true)
	end
		
end
addEvent ( "onCreateWeatherControlGUI", true )
addEventHandler("onCreateWeatherControlGUI", getLocalPlayer(), showWeatherControlGUI )




function createWeatherForecaseGUI(weather, nextWeather, laterWeather)
	
	local X = 0.35
        local Y = 0.35
        local Width = 0.3
        local Height = 0.3
	
        guiWeatherForecast = guiCreateWindow(X, Y, Width, Height, "Weather Forecast", true)
	
	guiWeatherForcecastTab = guiCreateTabPanel ( 0, 0.09, 1, 0.91 ,true,guiWeatherForecast )
	
	guiWeatherCurrentTab =  guiCreateTab ( "Current", guiWeatherForcecastTab )
	
		guiWeatherForcastNowLable = guiCreateLabel  ( 0.07 , 0.07, 0.5, 0.1, "Currently, the weather is:", true, guiWeatherCurrentTab )
		
		if(weather == "cloudy") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Overcast/Cloudy", true, guiWeatherCurrentTab )
		elseif(weather == "clear") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherCurrentTab)
			guiWeatherForecastNowLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Sunny", true, guiWeatherCurrentTab)
		elseif(weather == "hot") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Scorching hot", true, guiWeatherCurrentTab )
		elseif(weather == "rain") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Rain and thunderstorms", true, guiWeatherCurrentTab )

		elseif(weather == "fog") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true, guiWeatherCurrentTab)
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Thick fog", true, guiWeatherCurrentTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastNowLabel  , "center")
		
		guiWeatherForecastNowBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Back", true, guiWeatherCurrentTab )
		addEventHandler ( "onClientGUIClick", guiWeatherForecastNowBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
		
	guiWeatherNextTab = guiCreateTab ( "Next" , guiWeatherForcecastTab)
		
		guiWeatherForcastNextLable = guiCreateLabel  ( 0.07 , 0.07, 0.8, 0.1, "Sometime in the next 2 hours:", true, guiWeatherNextTab )
		
		if(nextWeather == "cloudy") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherNextTab )
			guiWeatherForecastNextLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Overcast/Cloudy", true, guiWeatherNextTab )
		elseif(nextWeather == "clear") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel   =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Sunny", true, guiWeatherNextTab)
		elseif(nextWeather == "hot") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel  =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Scorching hot", true, guiWeatherNextTab)
		elseif(nextWeather == "rain") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel   =  guiCreateLabel  ( 0.25 , 0.7, 0.5, 0.1, "Rain and thunderstorms", true, guiWeatherNextTab )
		elseif(nextWeather == "fog") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true,guiWeatherNextTab)
			guiWeatherForecastNextLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Thick fog", true, guiWeatherNextTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastNextLabel  , "center")
		
		guiWeatherForecastNextBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Back", true, guiWeatherNextTab)
		addEventHandler ( "onClientGUIClick", guiWeatherForecastNextBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
	
	
	guiWeatherLaterTab = guiCreateTab ( "Later", guiWeatherForcecastTab)
	
		guiWeatherForcastLaterLable = guiCreateLabel  ( 0.07 , 0.07, 0.8, 0.1, "Later on today (4 hours+):", true, guiWeatherLaterTab )
		
		if(laterWeather == "cloudy") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherLaterTab )
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Overcast/Cloudy", true, guiWeatherLaterTab)
		elseif(laterWeather  == "clear") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Sunny", true, guiWeatherLaterTab)
		elseif(laterWeather == "hot") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Scorching hot", true, guiWeatherLaterTab)
		elseif(laterWeather  == "rain") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel   =  guiCreateLabel  ( 0.25 , 0.7, 0.5, 0.1, "Rain and thunderstorms", true, guiWeatherLaterTab )
		elseif(laterWeather  == "fog") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true,guiWeatherLaterTab)
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Thick fog", true, guiWeatherLaterTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastLastLabel  , "center")
		
		guiWeatherForecastLaterBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Back", true, guiWeatherLaterTab)
		addEventHandler ( "onClientGUIClick", guiWeatherForecastLaterBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
	
	
	guiSetVisible(guiWeatherForecast, false)
end

function showWeatherForecastGUI(weather, nextWeather, laterWeather)

	if(source == getLocalPlayer()) then
		createWeatherForecaseGUI(weather, nextWeather, laterWeather)
		guiSetInputEnabled ( true )
		guiSetVisible(guiWeatherForecast, true)
	end
		
end
addEvent ( "onCreateWeatherForecastGUI", true )
addEventHandler("onCreateWeatherForecastGUI", getLocalPlayer(), showWeatherForecastGUI )

function ChangePlayerWeather(weather, blend)
	setWeather ( tonumber(weather) )
	if(blend ~= nil) then
		setWeatherBlended ( tonumber( blend ))
	end
end
addEvent( "onServerChangesWeather", true )
addEventHandler( "onServerChangesWeather", getRootElement(), ChangePlayerWeather )