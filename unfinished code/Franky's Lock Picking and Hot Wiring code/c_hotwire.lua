function showHotwireGui ( )
	hotwire_Button = {}
	hotwire_Checkbox = {}
	
	hotwire_Window = guiCreateWindow(0.33203,0.30729,0.30761,0.29817,"Hotwiring a car...",true)
		guiWindowSetMovable(hotwire_Window,false)
		guiWindowSetSizable(hotwire_Window,false)
	
	hotwire_Image = guiCreateStaticImage(0.0571,0.1354,0.9048,0.8777,"images/wires.png",true,hotwire_Window)
	
	hotwire_Button[1] = guiCreateButton(0.7429,0.8341,0.2286,0.1266,"Close",true,hotwire_Window)
	hotwire_Button[2] = guiCreateButton(0.5016,0.8341,0.2286,0.1266,"Hotwire",true,hotwire_Window)
	
	hotwire_Checkbox[1] = guiCreateCheckBox(0.9143,0.179,0.0508,0.0655,"",false,true,hotwire_Window)
	hotwire_Checkbox[2] = guiCreateCheckBox(0.9143,0.2882,0.0508,0.0655,"",false,true,hotwire_Window)
	hotwire_Checkbox[3] = guiCreateCheckBox(0.9143,0.3974,0.0476,0.0655,"",false,true,hotwire_Window)
	hotwire_Checkbox[4] = guiCreateCheckBox(0.9143,0.5022,0.0476,0.0655,"",false,true,hotwire_Window)
	hotwire_Checkbox[5] = guiCreateCheckBox(0.9143,0.607,0.0476,0.0655,"",false,true,hotwire_Window)
	hotwire_Checkbox[6] = guiCreateCheckBox(0.6667,0.2271,0.0508,0.0699,"",false,true,hotwire_Window)

	addEventHandler ( "onClientGUIClick", hotwire_Window, onGuiClick )
	
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	local vehtype = getVehicleType ( vehicle )
	if vehicle then
		if ( vehtype == "BMX" ) then
			outputChatBox ( "You can't hotwire a bicycle", 225, 0, 0 )
		elseif ( vehtype == "Trailer" ) then
			outputChatBox ( "You can't hotwire a trailer", 225, 0, 0 )
		else
			local hotwires = getElementData ( vehicle, "vehicle.hotwires" )
			if not hotwires then
				local hotwire1, hotwire2
				repeat
					hotwire1 = math.random ( 1, 5 )
					hotwire2 = math.random ( 1, 5 )
				until hotwire1 ~= hotwire2
				setElementData ( vehicle, "vehicle.hotwires", hotwire1..","..hotwire2..",6")
			end
			guiSetVisible ( hotwire_Window, true )
			showCursor ( true )
		end
	else
		outputChatBox ( "You need to be in the vehicle!", 225, 0, 0 )
	end
end
addCommandHandler ( "hotwire", showHotwireGui )

function onGuiClick ()
	guiMoveToBack( hotwire_Image )
	if ( source == hotwire_Button[1] ) then
		destroyElement(hotwire_Window)
		showCursor(false)
	elseif ( source == hotwire_Button[2] ) then
		local player = getLocalPlayer ( )
		local vehicle = getPedOccupiedVehicle ( player )
		
		local cwires = split(getElementData ( vehicle, "vehicle.hotwires" ), string.byte(","))
		for i in ipairs(cwires) do
			cwires[i] = tonumber(cwires[i])
		end
		local swire1 = 0
		local swire2 = 0
		local swire3 = 0
		
		for i, checkbox in ipairs(hotwire_Checkbox) do
			if guiCheckBoxGetSelected(checkbox) then
				if swire1 == 0 then
					swire1 = i
				else
					if swire2 == 0 then
						swire2 = i
					else
						if swire3 == 0 then
							swire3 = i
						end
					end
				end
			end
		end
		if ( cwires[1] ) == swire1 or ( cwires[1] ) == swire2 or ( cwires[1] ) == swire3 then
			if ( cwires[2] ) == swire1 or ( cwires[2] ) == swire2 or ( cwires[2] ) == swire3 then
				if ( cwires[3] ) == swire1 or ( cwires[3] ) == swire2 or ( cwires[3] ) == swire3 then
					if math.random(1,5) == 1 then
						triggerServerEvent ( "onHotwireEnd", getLocalPlayer( ), vehicle )
						outputChatBox ( "You got the engine running.", 106, 222, 1 )
						destroyElement(hotwire_Window)
						showCursor(false)
					else
						outputChatBox ( "The engine made a sound but didn't start!", 200, 0, 0 )
					end
					return
				end
			end
		end
		outputChatBox ( "You didn't succeed to start the engine!", 200, 0, 0 )
	elseif source ~= hotwire_Window then
		local count = 0
		for i, checkbox in ipairs(hotwire_Checkbox) do
			if guiCheckBoxGetSelected(checkbox) then
				count = count + 1
			end
		end
		if count > 3 then
			outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
			guiCheckBoxSetSelected ( source, false )
		end
	end
end
