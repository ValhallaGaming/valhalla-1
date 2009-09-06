local wCK, gCK, bClose

addEvent( "showCKList", true )
addEventHandler( "showCKList", getLocalPlayer(),
	function( names, data )
		if wCK then
			destroyElement( wCK )
			wCK = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			local windowname = data == 2 and "In Remembrance of ..." or "Missing People"
			wCK = guiCreateWindow( sx / 2 - 125, sy / 2 - 250, 250, 500, "(( " .. windowname .. " ))", false )
			
			gCK = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wCK )
			local colName = guiGridListAddColumn( gCK, "Name", 0.93 )
			for key, name in pairs( names ) do
				local row = guiGridListAddRow( gCK )
				guiGridListSetItemText( gCK, row, colName, name:gsub("_", " "), false, false, false )
			end
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wCK )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wCK )
						wCK = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)