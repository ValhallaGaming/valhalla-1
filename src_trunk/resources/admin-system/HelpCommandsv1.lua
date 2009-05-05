local myWindow = nil

function playerhelp( sourcePlayer, commandName )
    local sourcePlayer = getLocalPlayer()
    local var = getElementData (sourcePlayer, "loggedin")
	if ( (var - 0) == 1) then
	    if ( myWindow == nil ) then
		    guiSetInputEnabled(true)
			myWindow = guiCreateWindow ( 0.2, 0.3, 0.6, 0.5, "Index of Server Commands for Players V2.2", true )
		    local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
		    local tabChatCommands = guiCreateTab ( "Chat Commands", tabPanel )
			local tabFactCommands = guiCreateTab ( "Faction Commands", tabPanel )
			local tabItemCommands = guiCreateTab ( "Item Commands", tabPanel )
			local tabMiscCommands = guiCreateTab ( "Miscellaneous Commands", tabPanel )
			
			local BackButton = guiCreateButton( 0.82, 0.05, 0.18, 0.08, "Close", true, myWindow ) -- Button part
			
			addEventHandler ( "onClientGUIClick", BackButton, function( button, state )	        
    			if (button == "left") then
	    	        if (state == "up") then
		    	        guiSetVisible(myWindow, false)
						showCursor (false )
						guiSetInputEnabled(false)
						myWindow = nil
		            end
	            end
			end, false)
			
			guiBringToFront ( BackButton )
			
			if (tabChatCommands) then    
		        local chatcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabChatCommands )
				local chatcommand = guiGridListAddColumn ( chatcommandslist, "Command", 0.2 )
				local chatcommanduse = guiGridListAddColumn ( chatcommandslist, "Command Syntax", 0.3 )
				local chatcommandexample = guiGridListAddColumn ( chatcommandslist, "Example of Command", 0.5 )
				local chatcommandexplanation = guiGridListAddColumn ( chatcommandslist, "Command Explanation", 0.7 )
				
				-- Chat Commands
				
				icchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommand, "IC chat", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommanduse, "Press 't' [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommandexplanation, "Here you can speak in character to another character.", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommandexample, "'t' Hello my name is Jack, who are you?", false, false )
				
				radiochatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommand, "Radio chat", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommanduse, "Press 'y' [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommandexplanation, "This can only be used when you have purchased a radio and are in the same channel.", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommandexample, "'y' What is your position? over", false, false )
				
				adchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommand, "/ad", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommanduse, "/ad [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommandexplanation, "This is an in character announcement, used to simulate advertisements.", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommandexample, "/ad Pig Pen Club now open, phone for vacany details.", false, false )
				
				loocchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommand, "/b", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommanduse, "/b [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommandexplanation, "This is an out of character chat in an in character area.", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommandexample, "/b Hey man, why haven't you been online?", false, false )
				
				dochatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommand, "/do", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommanduse, "/do [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommandexplanation, "This is used to simulate events for objects, similar to /me and is in character.", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommandexample, "/do The engine breaks down", false, false )
				
				districtchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommand, "/d", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommanduse, "/d [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexplanation, "This is OOC chat which is limited to your area of the city.", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexample, "/d Hey, what's up?", false, false )
				
				districtchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommand, "/f", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommanduse, "/f [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommandexample, "/f How you been mate?", false, false )
				
				megachatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommand, "/m", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommanduse, "/m [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommandexplanation, "Use this only with the megaphone item, this allows you to speak to people in a wide radius.", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommandexample, "/m Move to the side of the road now!", false, false )
				
				mechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommand, "/me", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommanduse, "/me [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommandexplanation, "Use this to simulate actions that your player is doing.", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommandexample, "/me shakes his fist at the person", false, false )
								
				oocchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommand, "/o", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommanduse, "/o [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommandexplanation, "This is the global out of character chat.", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommandexample, "/o Where is everyone in the server?", false, false )
			   
			    phonechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, phonechatcreaterow, chatcommand, "/p", false, false )
				guiGridListSetItemText ( chatcommandslist, phonechatcreaterow, chatcommanduse, "/p [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, phonechatcreaterow, chatcommandexplanation, "You have to have the phone item and rang someones number to use this.", false, false )
				guiGridListSetItemText ( chatcommandslist, phonechatcreaterow, chatcommandexample, "/p I need you to get me a lawyer.", false, false )
			   
				shoutchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommand, "/s", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommanduse, "/s [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommandexplanation, "This is used to simulate your player shouting and is in character.", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommandexample, "/s Help!! The man stole my wallet!", false, false )
				
				whispchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommand, "/w", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommanduse, "/w [Partial Player Name] [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommandexplanation, "Use this to whisper to a player close to you. Only you and them can see it.", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommandexample, "/w Jack_Konstantine He's looking right at me.", false, false )
				
				carwhispchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommand, "/cw", false, false )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommanduse, "/cw [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommandexplanation, "Use this to whisper to all players in a vehicle with you. Only you and the other occupants can see it.", false, false )
				guiGridListSetItemText ( chatcommandslist, wcarwhispchatcreaterow, chatcommandexample, "/cw Keep an eye out. I'll be right back", false, false )
				
				closechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommand, "/c", false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommanduse, "/c [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommandexplanation, "Use this to talk quietly to all players around you." , false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommandexample, "/c Don't look now but he's walking over.", false, false )
				
				privatemessagechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommand, "/pm", false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommanduse, "/pm [Player name] [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommandexplanation, "Use this to privately message another player." , false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommandexample, "/pm John_Doe Thanks for helping me.", false, false )
				
				--Faction Commands
				
				local factcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabFactCommands )
				local factcommand = guiGridListAddColumn ( factcommandslist, "Command", 0.2 )
				local factusecommand = guiGridListAddColumn ( factcommandslist, "Faction", 0.2 )
				local factcommanduse = guiGridListAddColumn ( factcommandslist, "Command Syntax", 0.7 )
				local factcommandexplanation = guiGridListAddColumn ( factcommandslist, "Command Explanation", 0.7 )
				local factcommandexample = guiGridListAddColumn ( factcommandslist, "Example of Command", 0.7 )
				
				-- local theTeam = getPlayerTeam(thePlayer)
			    -- local factionType = getElementData(theTeam, "type")
				
				-- if (factionType == 0) then
				
				    -- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )
				
				-- elseif (factionType == 1) then
				
				    -- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )

                -- elseif (factiontype == 2) then

					fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
					guiGridListSetItemText ( factcommandslist, fthreecreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )

                    pcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommand, "'P'", false, false )
					guiGridListSetItemText ( factcommandslist, pcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommanduse, "'P' (keyboard bind key [Out of a Vehicle])", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommandexplanation, "This will enable the riot shield.", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommandexample, "n/a.", false, false )
					
					p1createrow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommand, "'P'", false, false )
					guiGridListSetItemText ( factcommandslist, p1createrow, factusecommand, "Government Only", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommanduse, "'P' (keyboard bind key [In a Vehicle])", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexplanation, "This will enable the flasher's on the emergency vehicle.", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexample, "n/a.", false, false )
					
				    factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
					guiGridListSetItemText ( factcommandslist, factchatcreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )				
				    
					cuffcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, cuffcreaterow, factcommand, "/cuff", false, false )
					guiGridListSetItemText ( factcommandslist, cuffcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, cuffcreaterow, factcommanduse, "/cuff [Partial Player Name] (NEED'S THE ITEM HANDCUFFS)", false, false )
				    guiGridListSetItemText ( factcommandslist, cuffcreaterow, factcommandexplanation, "Using this command you can cuff any desired playing, limiting their action.", false, false )
				    guiGridListSetItemText ( factcommandslist, cuffcreaterow, factcommandexample, "/cuff Makoto_Katsuki", false, false )
					
					dutycreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommand, "/duty", false, false )
					guiGridListSetItemText ( factcommandslist, dutycreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommanduse, "/duty (PD Only - inside PD locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexplanation, "This is to be used in the PD locker room and will make you on duty as an officer.", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexample, "/duty", false, false )
					
					swatcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommand, "/swat", false, false )
					guiGridListSetItemText ( factcommandslist, swatcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommanduse, "/swat (PD Only - inside PD locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexplanation, "This is to be used in the PD locker room and will make you on duty as a SWAT member.", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexample, "/swat", false, false )
					
					ticketcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommand, "/ticket", false, false )
					guiGridListSetItemText ( factcommandslist, ticketcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommanduse, "/ticket [Partial Player Name] [Amount] [Reason]", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexplanation, "Using this command you can ticket any player and issue them a fine.", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexample, "/ticket Angelo_Pappas 500 Failure to comply", false, false )
					
					uncuffcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, uncuffcreaterow, factcommand, "/uncuff", false, false )
					guiGridListSetItemText ( factcommandslist, uncuffcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, uncuffcreaterow, factcommanduse, "/uncuff [Partial Player Name] (NEED ITEM HANDCUFFS)", false, false )
				    guiGridListSetItemText ( factcommandslist, uncuffcreaterow, factcommandexplanation, "Using this command you can uncuff any player.", false, false )
				    guiGridListSetItemText ( factcommandslist, uncuffcreaterow, factcommandexample, "/uncuff Makoto_Katsuki", false, false )
				
				-- elseif (factiontype == 3) then
				
				    -- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )
					
				-- elseif (factiontype == 4) then
				
				    -- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- p1createrow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommand, "'P'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommanduse, "'P' (keyboard bind key [In a Vehicle])", false, false )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexplanation, "This will enable the flasher's on the emergency vehicle.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )
			
					
				-- elseif (factionType == 5) then
					
					-- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )
				
				-- end
					
				--Item Commands
				
				local itemcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabItemCommands )
				local itemcommand = guiGridListAddColumn ( itemcommandslist, "Command", 0.2 )
				local itemcommanduse = guiGridListAddColumn ( itemcommandslist, "Command Syntax", 0.55 )
				local itemcommandexplanation = guiGridListAddColumn ( itemcommandslist, "Command Explanation", 0.72 )
				local itemcommandexample = guiGridListAddColumn ( itemcommandslist, "Example of Command", 0.7 )
				
				invcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommand, "'I'", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommanduse, "'I' (keyboard bind button)", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommandexplanation, "This is used to access your inventory screen.", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommandexample, "n/a.", false, false )
				
				callcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommand, "/call", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommanduse, "/call [Phone Number] (NEEDS THE CELLPHONE)", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommandexplanation, "Use this command to call anyplayer in character.", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommandexample, "/call 5555", false, false )
				
				hangupcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommand, "/hangup", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommanduse, "/hangup (NEEDS THE CELLPHONE)", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommandexplanation, "This is used to put down the phone whilst speaking to someone.", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommandexample, "/hangup", false, false )
				
				loudspeakercreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommand, "/loudspeaker", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommanduse, "/loudspeaker (NEEDS THE CELLPHONE)", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommandexplanation, "This is used to place the call on loudspeaker, so people around you can here both sides of the conversation.", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommandexample, "/loudspeaker", false, false )
				
				pchatcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommand, "/p", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommanduse, "/p [Text] (NEEDS THE CELLPHONE)", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommandexplanation, "Use this to speak into the phone.", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommandexample, "/p Hello? Who is this?", false, false )
				
				pickupcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommand, "/pickup", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommanduse, "/pickup (NEEDS THE CELLPHONE)", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommandexplanation, "This is used to answer a ringing phone.", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommandexample, "/pickup", false, false )
				
				phonebookcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommand, "/phonebook", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommanduse, "/phonebook [Partial Player Name] (NEEDS THE PHONEBOOK)", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommandexplanation, "This allows you to retrieve any players phone number if you know their name.", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommandexample, "/phonebook Jack_Konstantine", false, false )
				
				radiofreqcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommand, "/tuneradio", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommanduse, "/tuneradio [Channel Number 0->65535] (NEEDS THE ITEM RADIO)", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommandexplanation, "Use this command to change the radio frequency of your radio.", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommandexample, "/tuneradio 18", false, false )
				
				--Misc Commands
				
				local misccommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabMiscCommands )
				local misccommand = guiGridListAddColumn ( misccommandslist, "Command", 0.2 )
				local misccommanduse = guiGridListAddColumn ( misccommandslist, "Command Syntax", 0.4 )
				local misccommandexplanation = guiGridListAddColumn ( misccommandslist, "Command Explanation", 0.75 )
				local misccommandexample = guiGridListAddColumn ( misccommandslist, "Example of Command", 0.7 )
				
				entercreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommand, "'Enter' or 'F'", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommanduse, "'Enter' or 'F'  (keyboard bind key)", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommandexplanation, "Using this bind key you are able to enter interiors. This is also the key to buy interiors.", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommandexample, "n/a", false, false )
				
				fonecreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommand, "'F1'", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommanduse, "'F1' (keyboard bind key)", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommandexplanation, "This triggers a help tool, that explains the concepts of roleplay.", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommandexample, "n/a", false, false )
				
				ftwocreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommand, "'F2'", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommanduse, "'F2' (keyboard bind key)", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommandexplanation, "This triggers admin report (/report).", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommandexample, "n/a", false, false )
				
				mkeycreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommand, "'m'", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommanduse, "'m' (keyboard bind key)", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommandexplanation, "This enables cursor mode to pick up items and right click on other players.", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommandexample, "n/a", false, false )
				
				gluecreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommand, "/glue", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommanduse, "/glue", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommandexplanation, "This sticks you to a vehicle. Useful for when travelling in a boat or back of a truck.", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommandexample, "/glue", false, false )

				ocreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommand, "'o'", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommanduse, "'o' (keyboard bind)", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommandexplanation, "This will open your friends list window.", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommandexample, "n/a", false, false )
				
				jcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommand, "'J'", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommanduse, "'J' (keyboard bind key) (VEHICLE USE ONLY)", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommandexplanation, "This keyboard bind key will start the car.", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommandexample, "n/a", false, false )
				
				kcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommand, "'K'", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommanduse, "'K' (keyboard bind key) (VEHICLE USE ONLY)", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommandexplanation, "This keyboard bind key will lock the door's of the vehicle you are in.", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommandexample, "n/a", false, false )
				
				lcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommand, "'L'", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommanduse, "'L' (keyboard bind key) (VEHICLE USE ONLY)", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommandexplanation, "This keyboard bind key will turn on the car headlights.", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommandexample, "n/a", false, false )
				
				sqbrkcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommand, "'[' and ']'", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommanduse, "'[' or ']'(keyboard bind key) (VEHICLE USE ONLY)", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommandexplanation, "This keyboard bind key will turn on and off the cars indicators.", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommandexample, "n/a", false, false )
				
				fillcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommand, "/fill", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommanduse, "/fill", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommandexplanation, "Using this command when in a car will allow you to fill it up with fuel.", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommandexample, "/fill", false, false )
				
				oldcarcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommand, "/oldcar", false, false )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommanduse, "/oldcar", false, false )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommandexplanation, "This command retrieves the ID of the last car that you was in.", false, false )				
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommandexample, "The cars ID is 55.", false, false )
	
				thiscarcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommand, "/thiscar", false, false )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommanduse, "/thiscar", false, false )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommandexplanation, "Using this command will allow you to retrieve the ID of the car that you are currently in.", false, false )				
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommandexample, "This cars ID is 20.", false, false )
				
				paycreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommand, "/pay", false, false )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommanduse, "/pay [Player Partial Nick] [Amount]", false, false )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommandexplanation, "Using this command you can pay any player a desired amount of money.", false, false )				
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommandexample, "/pay Nathan_Daniels 1000", false, false )

				adminscreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommand, "/admins", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommanduse, "/admins", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommandexplanation, "This command when used will display all the admins currently online. Hidden admins are not seen on the list.", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommandexample, "n/a", false, false )
				
				taxicreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommand, "/taxi", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommanduse, "/taxi [message]", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommandexplanation, "This command will call for a taxi.", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommandexample, "/taxi I need a taxi from Las Venturas General Hospital.", false, false )
		
				ordersuppliescreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommand, "/ordersupplies", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommanduse, "/ordersupplies [amount]", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommandexplanation, "This command will restock your business with the amount of supplies specified. Supplies cost $2 each.", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommandexample, "/ordersupplies 2500", false, false )
				
                settagcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommand, "/settag", false, false )
				guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommanduse, "/settag [1-8]", false, false )
				guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommandexplanation, "This command allows you to change the tag you're spraying using a spraycan.", false, false )
				guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommandexample, "/settag 7", false, false )
                
		else
		    local visible = guiGetVisible ( myWindow )
		    if ( visible == false ) then
			    guiSetVisible( myWindow, true )
			    showCursor (true )
			end
			end
		end
	showCursor(false)
	end
end
addCommandHandler("helpcmds", playerhelp)