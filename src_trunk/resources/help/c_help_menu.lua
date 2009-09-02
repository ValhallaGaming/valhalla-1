local sx, sy = guiGetScreenSize( )
local guielements = { }
local camera, cameraview = {}, 0
cameraupdatetimer = nil

local function setCameraView( view )
	if view then
		cameraview = view
		
		if isTimer( cameraupdatetimer ) then
			killTimer( cameraupdatetimer )
			cameraupdatetimer = nil
		end
	else
		cameraview = ( cameraview % #camera ) + 1
	end
	
	-- set the camera view immediately
	local function setView( fade )
		local activeCam = camera[cameraview]
		local x, y, z = unpack( activeCam.matrix )
		setElementPosition( localPlayer, x, y, z - 2 )
		setElementInterior( localPlayer, activeCam.interior )
		
		setCameraMatrix( unpack( activeCam.matrix ) )
		setCameraInterior( activeCam.interior )
		setPedFrozen( localPlayer, true )
		
		-- optionally: fadeout
		if fade then
			fadeCamera( true, 1 )
		end
	end
	
	if view then -- if we want to switch to a specific view, use this
		setView( false )
	else -- next view
		fadeCamera( false, 1 )
		setTimer( setView, 1000, 1, true )
	end
end

local function findParent( start, node )
	if type( start ) == "table" then
		if start == node then
			return true
		else
			for key, value in pairs( start ) do
				local found = findParent( value, node )
				if found == true then
					return start
				elseif type( found ) == "table" then
					return found
				end
			end
		end
	end
end

function createMenu( node )
	if node and type( node ) == "table" then
		if #node == 0 and not node.window then
			outputDebugString( "Node " .. node.name .. " has no contents." )
		else
			-- add a help window if ne need one
			if node.window then
				local width = node.window.width or 350
				local height = node.window.height or 160
				
				local window = guiCreateWindow( ( sx - width - 160 ) / 2, sy / 2 - height, width, height, node.name, false )
				guiWindowSetMovable( window, false )
				guiWindowSetSizable( window, false )
				
				node.window.func( window )
				
				-- add it to the gui elements list
				table.insert( guielements, window )
			end
			
			-- buttons
			local spacer = 5
			local x = -10
			local width = 170
			local height = 45
			
			local size = 0
			for key, value in ipairs( node ) do
				if not value.requirement or value.requirement( ) then
					size = size + 1
				end
			end
			local y = ( sy - ( size + 1 ) * height - size * spacer ) / 2
			
			for key, value in ipairs( node ) do
				if not value.requirement or value.requirement( ) then
					local button = guiCreateButton( x, y, width, height, value.name, false )
					
					-- modify text color and alpha
					guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
					guiSetAlpha( button, 0.85 )
					
					-- add it to the gui elements list
					table.insert( guielements, button )
					
					-- add possible handlers
					if value.onClick then
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									value.onClick( )
								end
							end, false )
					end
					
					if #value > 0 or value.window then
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									destroyMenu( )
									createMenu( value )
								end
							end
						)
					end
					
					-- adjust the Y-position for the next element
					y = y + height + spacer
				end
			end
			
			local parent = findParent( help_menu, node )
			if parent == true then -- we're in the main menu
				local button = guiCreateButton( x, y, width, height, "Exit", false )
				
				-- modify text color and alpha
				guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
				guiSetAlpha( button, 0.85 )
				
				-- add it to the gui elements list
				table.insert( guielements, button )
				
				-- add exit handler
				addEventHandler( "onClientGUIClick", button,
					function( button, state )
						if button == "left" and state == "up" then
							triggerServerEvent( "exitHelp", localPlayer )
						end
					end
				)
			else
				local button = guiCreateButton( x, y, width, height, "Back", false )
				
				-- modify text color and alpha
				guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
				guiSetAlpha( button, 0.85 )
				
				-- add it to the gui elements list
				table.insert( guielements, button )
				
				-- add exit handler
				addEventHandler( "onClientGUIClick", button,
					function( button, state )
						if button == "left" and state == "up" then
							destroyMenu( )
							createMenu( parent )
						end
					end
				)
			end
			
			-- find an applicable camera matrix
			local look = node
			while not look.camera do
				look = findParent( help_menu, look )
				if look == true then
					look = help_menu
					break
				end
			end
			
			-- port there to make sure it's streamed in
			camera = look.camera
			setCameraView( 1 )
			if #camera > 1 then
				cameraupdatetimer = setTimer( setCameraView, 10000, 0 )
			end
		end
	else
		ouputDebugString( "Unexpected Node" )
	end
end

function destroyMenu( )
	for key, value in pairs( guielements ) do
		destroyElement( value )
	end
	guielements = { }
end