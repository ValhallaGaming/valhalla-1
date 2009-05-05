
function ChangePlayerWeather(weather, blend)
	setWeather ( tonumber(weather) )
	if(blend ~= nil) then
		setWeatherBlended ( tonumber( blend ))
	end
end
addEvent( "onClientWeatherChange", true )
addEventHandler( "onClientWeatherChange", getRootElement(), ChangePlayerWeather )



