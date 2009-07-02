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

				districtchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommand, "/district or /dooc", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommanduse, "/district [Text]", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexplanation, "Use this to talk OOC to players in the same area of the map." , false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexample, "/district Don't come in the bank. The doors are locked.", false, false )
				
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

					ffourcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommand, "'F4'", false, false )
					guiGridListSetItemText ( factcommandslist, ffourcreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommanduse, "'F4' (keyboard bind key)", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommandexplanation, "This brings up the duty skin selection.", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommandexample, "n/a.", false, false )

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
					
					arrestcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommand, "/arrest", false, false )
					guiGridListSetItemText ( factcommandslist, arrestcreaterow, factusecommand, "PD Only - at the booking desk of either station.", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommanduse, "/arrest [Partial Name/ ID][time (in minutes)][fine][charges]", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommandexplanation, "This will arrest the player.", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommandexample, "/arrest John_Sm 30 1000 Attempted murder, DUI, evading, possession of an illegal substance", false, false )

					releasecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommand, "//release", false, false )
					guiGridListSetItemText ( factcommandslist, releasecreaterow, factusecommand, "PD Only.", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommanduse, "//release [player name]", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommandexplanation, "This will release the player from IC jail.", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommandexample, "/release John_S", false, false )

					
				    factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
					guiGridListSetItemText ( factcommandslist, factchatcreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f [Text]", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )				
					
					dutycreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommand, "/duty", false, false )
					guiGridListSetItemText ( factcommandslist, dutycreaterow, factusecommand, "PD & ES", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommanduse, "/duty (Inside locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexplanation, "This is to be used in thelocker room and will make you on duty as an officer.", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexample, "/duty", false, false )
					
					swatcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommand, "/swat", false, false )
					guiGridListSetItemText ( factcommandslist, swatcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommanduse, "/swat (PD Only - inside PD locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexplanation, "This is to be used in the PD locker room and will make you on duty as a SWAT member.", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexample, "/swat", false, false )

					cadetcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommand, "/cadet", false, false )
					guiGridListSetItemText ( factcommandslist, cadetcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommanduse, "/cadet (PD Only - inside PD locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommandexplanation, "This is to be used in the PD locker room and will make you on duty as a cadet.", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommandexample, "/cadet", false, false )
					
					firefightercreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommand, "/firefighter", false, false )
					guiGridListSetItemText ( factcommandslist, firefightercreaterow, factusecommand, "ES Only", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommanduse, "/firefighter (ES Only - inside ES locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommandexplanation, "This is to be used in the ES locker room and will make you on duty as a fire fighter.", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommandexample, "/firefighter", false, false )
					
					ticketcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommand, "/ticket", false, false )
					guiGridListSetItemText ( factcommandslist, ticketcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommanduse, "/ticket [Partial Player Name] [Amount] [Reason]", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexplanation, "Using this command you can ticket any player and issue them a fine.", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexample, "/ticket Angelo_Pappas 500 Failure to comply", false, false )
				
					backupcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommand, "/backup", false, false )
					guiGridListSetItemText ( factcommandslist, backupcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommanduse, "/backup", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexplanation, "This relays your position to all faction members by placing a blip on the radar.", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexample, "/backup", false, false )

					roadblockcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommand, "/rb1 and /rb2", false, false )
					guiGridListSetItemText ( factcommandslist, backupcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommanduse, "/rb 1 or /rb 2", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexplanation, "This spawns a roadblock item.", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexample, "/rb 1", false, false )

					delroadblockcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommand, "/delroadblock", false, false )
					guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommanduse, "/delroadblock [ID]", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommandexplanation, "This removes a roadblock.", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommandexample, "/delroadblock 1", false, false )

					delallroadblockscreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommand, "/delallroadblocks", false, false )
					guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommanduse, "/delallroadblocks", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommandexplanation, "This removes all spawned roadblocks.", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommandexample, "/delallroadblocks", false, false )
					
					spikescreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommand, "/deployspikes", false, false )
					guiGridListSetItemText ( factcommandslist, spikescreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommanduse, "/deployspikes", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommandexplanation, "This drops a spike strip that will burst vehicles tyres.", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommandexample, "/deployspikes", false, false )
					
					delspikescreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommand, "/removespikes", false, false )
					guiGridListSetItemText ( factcommandslist, delspikescreaterow, factusecommand, "PD Only", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommanduse, "/removespikes [ID]", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommandexplanation, "This removes a spike strip.", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommandexample, "/removespikes 1", false, false )

					gatecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommand, "/gate", false, false )
					guiGridListSetItemText ( factcommandslist, gatecreaterow, factusecommand, "All factions", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommanduse, "/gate", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommandexplanation, "This opens a faction gate.", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommandexample, "/gate", false, false )

					mdccreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommand, "/mdc", false, false )
					guiGridListSetItemText ( factcommandslist, mdccreaterow, factusecommand, "PD only", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommanduse, "/mdc", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommandexplanation, "This opens the PD MDC window.", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommandexample, "/mdc", false, false )

					healcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommand, "/heal", false, false )
					guiGridListSetItemText ( factcommandslist, healcreaterow, factusecommand, "ES only", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommanduse, "/heal [Player Partial Nick / ID] [Price]", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommandexplanation, "This heals another player.", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommandexample, "/heal John_Smith 50", false, false )

					armorcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommand, "/armor", false, false )
					guiGridListSetItemText ( factcommandslist, armorcreaterow, factusecommand, "PD Only - inside PD locker room)", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommanduse, "/armor", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommandexplanation, "This gives you a new bullet proof vest.", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommandexample, "/armor", false, false )
					
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
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommand, "/indicator_left and /indicator_right", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommanduse, "(MOVING VEHICLE USE ONLY) Bind these keys by typing '/bind [any key] indicator_left' and vice versa", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommandexplanation, "This turn on and off the cars indicators.", false, false )
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

                jailtimecreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, jailtimecreaterow, misccommand, "/jailtime", false, false )
				guiGridListSetItemText ( misccommandslist, jailtimecreaterow, misccommanduse, "/jailtime", false, false )
				guiGridListSetItemText ( misccommandslist, jailtimecreaterow, misccommandexplanation, "This command displays the time left on your jail sentence.", false, false )
				guiGridListSetItemText ( misccommandslist, jailtimecreaterow, misccommandexample, "/jailtime", false, false )

                raidcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, raidcreaterow, misccommand, "/raid", false, false )
				guiGridListSetItemText ( misccommandslist, raidcreaterow, misccommanduse, "/raid", false, false )
				guiGridListSetItemText ( misccommandslist, raidcreaterow, misccommandexplanation, "This command searchs the location for the hidden drug stash.", false, false )
				guiGridListSetItemText ( misccommandslist, raidcreaterow, misccommandexample, "/raid", false, false )
				
				fastropecreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, fastropecreaterow, misccommand, "/fastrope", false, false )
				guiGridListSetItemText ( misccommandslist, fastropecreaterow, misccommanduse, "/fastrope", false, false )
				guiGridListSetItemText ( misccommandslist, fastropecreaterow, misccommandexplanation, "This command fastropes the player from a helicopter.", false, false )
				guiGridListSetItemText ( misccommandslist, fastropecreaterow, misccommandexample, "/fastrope", false, false )				

				timesavedcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, timesavedcreaterow, misccommand, "/timesaved", false, false )
				guiGridListSetItemText ( misccommandslist, timesavedcreaterow, misccommanduse, "/timesaved", false, false )
				guiGridListSetItemText ( misccommandslist, timesavedcreaterow, misccommandexplanation, "This command displays the amount of time played since the last payday was received.", false, false )
				guiGridListSetItemText ( misccommandslist, timesavedcreaterow, misccommandexample, "/timesaved", false, false )
				
				idcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, idcreaterow, misccommand, "/id", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommanduse, "/id [Partial Name / ID]", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexplanation, "This command displays the requested players name and ID.", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexample, "/id John_S", false, false )

				lasercreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, idcreaterow, misccommand, "/toglaser", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommanduse, "/toglaser", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexplanation, "This command togs the weapon laser sight on and off (not available on all weapons).", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexample, "/toglaser", false, false )                

				chaticonscreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommand, "/togchaticons", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommanduse, "/togchaticons", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommandexplanation, "This command togs the speech bubble over players heads while they are typing.", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommandexample, "/togchaticons", false, false )    

				nametagscreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommand, "/tognametags", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommanduse, "/tognametags", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommandexplanation, "This command togs others name tags (The change is only made to your screen. Everyone else still sees them).", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommandexample, "/tognametags", false, false )  
				
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