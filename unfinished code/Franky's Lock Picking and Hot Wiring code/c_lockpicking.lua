lockGUI_Window = {}
lockGUI_Button = {}
lockGUI_Edit = {}
lockGUI_Image = {}

function createLockGUI ( )
	lockGUI_Window[1] = guiCreateWindow(0.32128,0.33593,0.36914,0.28385,"Picking a lock...",true)
		guiWindowSetMovable(lockGUI_Window[1],true)
		guiWindowSetSizable(lockGUI_Window[1],false)
	
	lockGUI_Button[1] = guiCreateButton(0.0529,0.6239,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[2] = guiCreateButton(0.2063,0.6239,0.0635,0.1055,">",true,lockGUI_Window[1])
	lockGUI_Button[3] = guiCreateButton(0.4021,0.6239,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[4] = guiCreateButton(0.5556,0.6239,0.0635,0.1055,">",true,lockGUI_Window[1])
	lockGUI_Button[5] = guiCreateButton(0.7222,0.6239,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[6] = guiCreateButton(0.8757,0.6239,0.0635,0.1055,">",true,lockGUI_Window[1])
	lockGUI_Button[7] = guiCreateButton(0.0529,0.7798,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[8] = guiCreateButton(0.2063,0.7798,0.0635,0.1055,">",true,lockGUI_Window[1])
	lockGUI_Button[9] = guiCreateButton(0.4021,0.7798,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[10] = guiCreateButton(0.5556,0.7798,0.0635,0.1055,">",true,lockGUI_Window[1])
	lockGUI_Button[11] = guiCreateButton(0.7222,0.7798,0.0635,0.1055,"<",true,lockGUI_Window[1])
	lockGUI_Button[12] = guiCreateButton(0.8757,0.7798,0.0635,0.1055,">",true,lockGUI_Window[1])
	
	lockGUI_Button[13] = guiCreateButton(0.6905,0.1789,0.2566,0.2018,"Try to turn the lock",true,lockGUI_Window[1])
	lockGUI_Button[14] = guiCreateButton(0.6905,0.4083,0.2566,0.1239,"Cancel",true,lockGUI_Window[1])
	
	lockGUI_Edit[1] = guiCreateEdit(0.119,0.6239,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[1], true )
	lockGUI_Edit[2] = guiCreateEdit(0.4683,0.6239,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[2], true )
	lockGUI_Edit[3] = guiCreateEdit(0.7884,0.6239,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[3], true )
	lockGUI_Edit[4] = guiCreateEdit(0.119,0.7798,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[4], true )
	lockGUI_Edit[5] = guiCreateEdit(0.4683,0.7798,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[5], true )
	lockGUI_Edit[6] = guiCreateEdit(0.7884,0.7798,0.0847,0.1055,"0",true,lockGUI_Window[1])
		guiEditSetReadOnly ( lockGUI_Edit[6], true )
	
	lockGUI_Image[1] = guiCreateStaticImage(0.0529,0.1101,0.4709,0.4266,"images/lock.png",true,lockGUI_Window[1])
	
	addEventHandler ( "onClientGUIClick", lockGUI_Window[1], lockClick )
	addEventHandler ( "onClientGUIClick", lockGUI_Button[13], lockTry )
	addEventHandler ( "onClientGUIClick", lockGUI_Button[14], lockClose )
	
	guiSetVisible ( lockGUI_Window[1], false )
end
addEventHandler ( "onClientResourceStart", getRootElement( ), createLockGUI )

function lockOpen ( )
	local visible = guiGetVisible ( lockGUI_Window[1] )
	if ( visible == false ) then
		local player = getLocalPlayer ( )
		for key, theVehicle in ipairs( getElementsByType ( "vehicle" ) ) do
			local vx, vy, vz = getElementPosition ( theVehicle )
			local px, py, pz = getElementPosition ( getLocalPlayer ( ) )
			local distance = getDistanceBetweenPoints3D ( px, py, pz, vx, vy, vz )
			if ( distance <= 2 ) then
				triggerServerEvent ( "startLockPick", getRootElement( ), theVehicle, player )
				guiSetVisible ( lockGUI_Window[1], true )
				showCursor ( true, true )
			end
		end
	else
		guiSetVisible ( lockGUI_Window[1], false )
		showCursor ( false, false )
		guiSetText ( lockGUI_Edit[1], "0" )
		guiSetText ( lockGUI_Edit[2], "0" )
		guiSetText ( lockGUI_Edit[3], "0" )
		guiSetText ( lockGUI_Edit[4], "0" )
		guiSetText ( lockGUI_Edit[5], "0" )
		guiSetText ( lockGUI_Edit[6], "0" )
	end
end
addCommandHandler ( "picklock", lockOpen )

function lockClose ( )
	if ( source == lockGUI_Button[14] ) then
		guiSetVisible ( lockGUI_Window[1], false )
		showCursor ( false, false )
		guiSetText ( lockGUI_Edit[1], "0" )
		guiSetText ( lockGUI_Edit[2], "0" )
		guiSetText ( lockGUI_Edit[3], "0" )
		guiSetText ( lockGUI_Edit[4], "0" )
		guiSetText ( lockGUI_Edit[5], "0" )
		guiSetText ( lockGUI_Edit[6], "0" )
	end
end

function separateLock ( )
	for key, theVehicle in ipairs( getElementsByType ( "vehicle" ) ) do
		local vx, vy, vz = getElementPosition ( theVehicle )
		local px, py, pz = getElementPosition ( getLocalPlayer ( ) )
		local distance = getDistanceBetweenPoints3D ( px, py, pz, vx, vy, vz )
		if ( distance <= 2 ) then
			local lockcode = getElementData ( theVehicle, "vehicle.lockcode" )
			local one = tonumber (string.sub ( lockcode, 1, 1 ) )
			local two = tonumber (string.sub ( lockcode, 2, 2 ) )
			local three = tonumber (string.sub ( lockcode, 3, 3 ) )
			local four = tonumber (string.sub ( lockcode, 4, 4 ) )
			local five = tonumber (string.sub ( lockcode, 5, 5 ) )
			local six = tonumber (string.sub ( lockcode, 6, 6 ) )
			return theVehicle, one, two, three, four, five, six
		end
	end
end

function lockClick ( )
	local theVehicle, one, two, three, four, five, six = separateLock ( )
	local chance = math.random ( 1, 5 )
	if ( source == lockGUI_Window[1] ) then
	elseif ( source == lockGUI_Button[1] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[1] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[1], tostring ( tonumber (guiGetText ( lockGUI_Edit[1] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[1] ) ) == tonumber ( one ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[2] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[1] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[1], tostring ( tonumber (guiGetText ( lockGUI_Edit[1] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[1] ) ) == tonumber ( one ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[3] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[2] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[2], tostring ( tonumber (guiGetText ( lockGUI_Edit[2] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[2] ) ) == tonumber ( two ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[4] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[2] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[2], tostring ( tonumber (guiGetText ( lockGUI_Edit[2] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[2] ) ) == tonumber ( two ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[5] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[3] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[3], tostring ( tonumber (guiGetText ( lockGUI_Edit[3] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[3] ) ) == tonumber ( three ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[6] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[3] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[3], tostring ( tonumber (guiGetText ( lockGUI_Edit[3] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[3] ) ) == tonumber ( three ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[7] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[4] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[4], tostring ( tonumber (guiGetText ( lockGUI_Edit[4] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[4] ) ) == tonumber ( four ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[8] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[4] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[4], tostring ( tonumber (guiGetText ( lockGUI_Edit[4] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[4] ) ) == tonumber ( four ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[9] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[5] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[5], tostring ( tonumber (guiGetText ( lockGUI_Edit[5] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[5] ) ) == tonumber ( five ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[10] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[5] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[5], tostring ( tonumber (guiGetText ( lockGUI_Edit[5] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[5] ) ) == tonumber ( five ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[11] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[6] ) ) <= 0 ) then
		else
			guiSetText ( lockGUI_Edit[6], tostring ( tonumber (guiGetText ( lockGUI_Edit[6] ) ) - 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[6] ) ) == tonumber ( six ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	elseif ( source == lockGUI_Button[12] ) then
		if ( tonumber ( guiGetText ( lockGUI_Edit[6] ) ) >= 9 ) then
		else
			guiSetText ( lockGUI_Edit[6], tostring ( tonumber (guiGetText ( lockGUI_Edit[6] ) ) + 1 ) )
			if ( tonumber ( guiGetText ( lockGUI_Edit[6] ) ) == tonumber ( six ) ) then
				if ( chance == 1 ) then
					playSoundFrontEnd ( 42 )
				end
			end
		end
	end
end

function lockTry ( )
	if ( source == lockGUI_Button[13] ) then
		local slot1 = tonumber ( guiGetText ( lockGUI_Edit[1] ) )
		local slot2 = tonumber ( guiGetText ( lockGUI_Edit[2] ) )
		local slot3 = tonumber ( guiGetText ( lockGUI_Edit[3] ) )
		local slot4 = tonumber ( guiGetText ( lockGUI_Edit[4] ) )
		local slot5 = tonumber ( guiGetText ( lockGUI_Edit[5] ) )
		local slot6 = tonumber ( guiGetText ( lockGUI_Edit[6] ) )
		local theVehicle, one, two, three, four, five, six = separateLock ( )
		
		if ( slot1 == tonumber ( one ) ) and ( slot2 == tonumber ( two ) ) and ( slot3 == tonumber ( three ) ) and ( slot4 == tonumber ( four ) ) and ( slot5 == tonumber ( five ) ) and ( slot6 == tonumber ( six ) ) then
			triggerServerEvent ( "onLockpickEnd", getRootElement( ), theVehicle )
			outputChatBox ( "You try to turn the lock and you succeed!", 106, 222, 1 )
		else
			outputChatBox ( "You try to turn the lock but it doesn't move!", 225, 0, 0 )
		end
	end
end
