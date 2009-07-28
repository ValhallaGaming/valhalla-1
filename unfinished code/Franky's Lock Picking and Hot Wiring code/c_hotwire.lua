function createHotwireGui2 ( )
	hotwire_Window = {}
	hotwire_Button = {}
	hotwire_Checkbox = {}
	hotwire_Image = {}
	
	hotwire_Window[1] = guiCreateWindow(0.33203,0.30729,0.30761,0.29817,"Hotwiring a car...",true)
		guiWindowSetMovable(hotwire_Window[1],false)
		guiWindowSetSizable(hotwire_Window[1],false)
	
	hotwire_Image[1] = guiCreateStaticImage(0.0571,0.1354,0.9048,0.8777,"images/wires.png",true,hotwire_Window[1])
	
	hotwire_Button[1] = guiCreateButton(0.7429,0.8341,0.2286,0.1266,"Close",true,hotwire_Window[1])
	hotwire_Button[2] = guiCreateButton(0.5016,0.8341,0.2286,0.1266,"Hotwire",true,hotwire_Window[1])
	
	hotwire_Checkbox[1] = guiCreateCheckBox(0.9143,0.179,0.0508,0.0655,"",false,true,hotwire_Window[1])
	hotwire_Checkbox[2] = guiCreateCheckBox(0.9143,0.2882,0.0508,0.0655,"",false,true,hotwire_Window[1])
	hotwire_Checkbox[3] = guiCreateCheckBox(0.9143,0.3974,0.0476,0.0655,"",false,true,hotwire_Window[1])
	hotwire_Checkbox[4] = guiCreateCheckBox(0.9143,0.5022,0.0476,0.0655,"",false,true,hotwire_Window[1])
	hotwire_Checkbox[5] = guiCreateCheckBox(0.9143,0.607,0.0476,0.0655,"",false,true,hotwire_Window[1])
	hotwire_Checkbox[6] = guiCreateCheckBox(0.6667,0.2271,0.0508,0.0699,"",false,true,hotwire_Window[1])

	addEventHandler ( "onClientGUIClick", hotwire_Window[1], onGuiClick )
	addEventHandler ( "onClientGUIClick", hotwire_Button[1], closeGui )
	addEventHandler ( "onClientGUIClick", hotwire_Button[2], tryHotwire )
	
	guiSetVisible ( hotwire_Window[1], false )
end
addEventHandler ( "onClientResourceStart", getRootElement( ), createHotwireGui2 )

function showHotwireGui ( )
	local player = getLocalPlayer ( )
	local theVehicle = getPedOccupiedVehicle ( player )
	local vehtype = getVehicleType ( theVehicle )
	local windowshown = guiGetVisible ( hotwire_Window[1] )
	if ( theVehicle == false ) then
		outputChatBox ( "You need to be in the vehicle!", 225, 0, 0 )
	else
		if ( vehtype == "BMX" ) then
			outputChatBox ( "You can't hotwire a bicycle", 225, 0, 0 )
		elseif ( vehtype == "Trailer" ) then
			outputChatBox ( "You can't hotwire a trailer", 225, 0, 0 )
		else
			if ( windowshown ) == false then
				guiSetVisible ( hotwire_Window[1], true )
				showCursor ( true, true )
				triggerServerEvent ( "startHotwire", getRootElement( ), theVehicle )
			else
				guiSetVisible ( hotwire_Window[1], false )
				showCursor ( false, false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
				guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
			end
		end
	end
end
addCommandHandler ( "hotwire", showHotwireGui )

function onGuiClick ( )
	guiMoveToBack( hotwire_Image[1] )
	local option1 = guiCheckBoxGetSelected ( hotwire_Checkbox[1] )
	local option2 = guiCheckBoxGetSelected ( hotwire_Checkbox[2] )
	local option3 = guiCheckBoxGetSelected ( hotwire_Checkbox[3] )
	local option4 = guiCheckBoxGetSelected ( hotwire_Checkbox[4] )
	local option5 = guiCheckBoxGetSelected ( hotwire_Checkbox[5] )
	local option6 = guiCheckBoxGetSelected ( hotwire_Checkbox[6] )
	if ( source == hotwire_Window[1] ) then
	elseif ( source == hotwire_Checkbox[1] ) then
		if ( option1 == false ) then
		else
			result = 0
			if ( option2 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option3 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option4 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option5 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option6 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end			
	elseif ( source == hotwire_Checkbox[2] ) then
		if ( option2 == false ) then
		else
			result = 0
			if ( option1 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option3 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option4 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option5 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option6 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end
		
	elseif ( source == hotwire_Checkbox[3] ) then
		if ( option3 == false ) then
		else
			result = 0
			if ( option1 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option2 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option4 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option5 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option6 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end
		
	elseif ( source == hotwire_Checkbox[4] ) then
		if ( option4 == false ) then
		else
			result = 0
			if ( option1 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option2 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option3 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option5 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option6 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end
		
	elseif ( source == hotwire_Checkbox[5] ) then
		if ( option5 == false ) then
		else
			result = 0
			if ( option1 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option2 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option3 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option4 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option6 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end
		
	elseif ( source == hotwire_Checkbox[6] ) then
		if ( option6 == false ) then
		else
			result = 0
			if ( option1 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option2 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option3 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option4 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
			if ( option5 ) == true then
				result = result+1
				if ( result < 3 ) then
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], true )
				else
					guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
					outputChatBox ( "You can only select 3 wires!", 255, 0, 0 )
				end
			end
		end
	end
end

function closeGui ( )
	if ( source == hotwire_Button[1] ) then
		guiSetVisible ( hotwire_Window[1], false )
		showCursor ( false, false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[1], false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[2], false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[3], false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[4], false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[5], false )
		guiCheckBoxSetSelected ( hotwire_Checkbox[6], false )
	end
end

function tryHotwire ( )
	if ( source == hotwire_Button[2] ) then
		local player = getLocalPlayer ( )
		local vehicle = getPedOccupiedVehicle ( player )

		local option1 = guiCheckBoxGetSelected ( hotwire_Checkbox[1] )
		local option2 = guiCheckBoxGetSelected ( hotwire_Checkbox[2] )
		local option3 = guiCheckBoxGetSelected ( hotwire_Checkbox[3] )
		local option4 = guiCheckBoxGetSelected ( hotwire_Checkbox[4] )
		local option5 = guiCheckBoxGetSelected ( hotwire_Checkbox[5] )
		local option6 = guiCheckBoxGetSelected ( hotwire_Checkbox[6] )
		
		local cwire1 = getElementData ( vehicle, "vehicle.hotwire1" )
		local cwire2 = getElementData ( vehicle, "vehicle.hotwire2" )
		local cwire3 = getElementData ( vehicle, "vehicle.hotwire3" )
		local swire1 = 0
		local swire2 = 0
		local swire3 = 0
		
		if ( option1 ) == true then
			if swire1 == 0 then
				swire1 = 1
			else
				if swire2 == 0 then
					swire2 = 1
				else
					if swire3 == 0 then
						swire3 = 1
					end
				end
			end
		end
		if ( option2 ) == true then
			if swire1 == 0 then
				swire1 = 2
			else
				if swire2 == 0 then
					swire2 = 2
				else
					if swire3 == 0 then
						swire3 = 2
					end
				end
			end
		end
		if ( option3 ) == true then
			if swire1 == 0 then
				swire1 = 3
			else
				if swire2 == 0 then
					swire2 = 3
				else
					if swire3 == 0 then
						swire3 = 3
					end
				end
			end
		end
		if ( option4 ) == true then
			if swire1 == 0 then
				swire1 = 4
			else
				if swire2 == 0 then
					swire2 = 4
				else
					if swire3 == 0 then
						swire3 = 4
					end
				end
			end
		end
		if ( option5 ) == true then
			if swire1 == 0 then
				swire1 = 5
			else
				if swire2 == 0 then
					swire2 = 5
				else
					if swire3 == 0 then
						swire3 = 5
					end
				end
			end
		end
		if ( option6 ) == true then
			if swire1 == 0 then
				swire1 = 6
			else
				if swire2 == 0 then
					swire2 = 6
				else
					if swire3 == 0 then
						swire3 = 6
					end
				end
			end
		end
		if ( cwire1 ) == swire1 or ( cwire1 ) == swire2 or ( cwire1 ) == swire3 then
			if ( cwire2 ) == swire1 or ( cwire2 ) == swire2 or ( cwire2 ) == swire3 then
				if ( cwire3 ) == swire1 or ( cwire3 ) == swire2 or ( cwire3 ) == swire3 then
					triggerServerEvent ( "onHotwireEnd", getRootElement( ), player, vehicle ) 
				else
					outputChatBox ( "You didn't succeed to start the engine!", 200, 0, 0 )
				end
			else
				outputChatBox ( "You didn't succeed to start the engine!", 200, 0, 0 )
			end
		else
			outputChatBox ( "You didn't succeed to start the engine!", 200, 0, 0 )
		end
	end
end
