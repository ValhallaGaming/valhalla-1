gezn = getElementZoneName

-- custom areas
local hospitalcol = createColCuboid( 1520, 1750, 2070, 100, 80, 30 )
setElementInterior( hospitalcol, 4 )

local custommaps =
{ 
	[ hospitalcol ] = { 'All Saints General Hospital', 'Los Santos' }
}

-- caching to improve efficiency
local cache = { [true] = {}, [false] = {} }

function getElementZoneName( element, citiesonly )
	if citiesonly ~= true and citiesonly ~= false then citiesonly = false end
	
	-- check for hospital
	for col, name in pairs( custommaps ) do
		if getElementDimension( element ) == getElementDimension( col ) and getElementInterior( element ) == getElementInterior( col ) and isElementWithinColShape( element, col ) then
			return citiesonly and name[2] or name[1]
		end
	end
	
	if not cache[citiesonly][ getElementDimension( element ) ] then
		name = ''
		if getElementDimension( element ) > 0 then
			if citiesonly then
				local parent = exports['interior-system']:findParent( element )
				if parent then
					name = getElementZoneName( parent, citiesonly, true )
				end
			else
				local dimension, entrance = exports['interior-system']:findProperty( element )
				if entrance then
					name = getElementData( entrance, 'name' )
				end
			end
			cache[citiesonly][ getElementDimension( element ) ] = name
		else
			name = gezn( element, citiesonly ), gezn( element, not citiesonly )
		end
		
		return name
	else
		return cache[citiesonly][ getElementDimension( element ) ]
	end
end
