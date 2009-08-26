local myWindow = nil

function playerhelp( sourcePlayer, commandName )
    local sourcePlayer = getLocalPlayer()
    local var = getElementData (sourcePlayer, "loggedin")
	if ( (var - 0) == 1) then
	    if ( myWindow == nil ) then
			myWindow = guiCreateWindow ( 0.2, 0.3, 0.6, 0.5, "Index of player commands v2.3", true )
		    local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
		    local tabChatCommands = guiCreateTab ( "Chat", tabPanel )
			local tabFactCommands = guiCreateTab ( "Factions", tabPanel )
			local tabItemCommands = guiCreateTab ( "Items", tabPanel )
			local tabMiscCommands = guiCreateTab ( "Misc", tabPanel )
			
			local BackButton = guiCreateButton( 0.82, 0.05, 0.18, 0.08, "Close", true, myWindow ) -- Button part
			
			addEventHandler ( "onClientGUIClick", BackButton, function( button, state )	        
    			if (button == "left") then
	    	        if (state == "up") then
		    	        guiSetVisible(myWindow, false)
						showCursor (false )
						myWindow = nil
		            end
	            end
			end, false)
			
			guiBringToFront ( BackButton )
			
			if (tabChatCommands) then    
		        local chatcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabChatCommands )
				local chatcommand = guiGridListAddColumn ( chatcommandslist, "Command", 0.2 )
				local chatcommanduse = guiGridListAddColumn ( chatcommandslist, "Syntax", 0.3 )
				local chatcommandexample = guiGridListAddColumn ( chatcommandslist, "Example", 0.5 )
				local chatcommandexplanation = guiGridListAddColumn ( chatcommandslist, "Explanation", 0.7 )
				
				-- Chat Commands
				
				icchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommand, "IC chat", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommanduse, "press 'T' <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommandexplanation, "This is the local in character chat.", false, false )
				guiGridListSetItemText ( chatcommandslist, icchatcreaterow, chatcommandexample, "'t' Hello, my name is Jack. Who are you?", false, false )
				
				radiochatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommand, "/r or 'Y'", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommanduse, "/r <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommandexplanation, "This can be used by people who have a radio and are on the same frequency.", false, false )
				guiGridListSetItemText ( chatcommandslist, radiochatcreaterow, chatcommandexample, "/r What is your position? Over.", false, false )
				
				adchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommand, "/ad", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommanduse, "/ad <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommandexplanation, "This is an in character announcement, used to simulate advertisements.", false, false )
				guiGridListSetItemText ( chatcommandslist, adchatcreaterow, chatcommandexample, "/ad The Pig Pen club is now open. Call us for further details.", false, false )
				
				loocchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommand, "/b or 'B'", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommanduse, "/b <OOC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommandexplanation, "This is a local out of character chat.", false, false )
				guiGridListSetItemText ( chatcommandslist, loocchatcreaterow, chatcommandexample, "/b Hey, what's going on around here?", false, false )
				
				mechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommand, "/me", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommanduse, "/me <IC action>", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommandexplanation, "Use this to simulate actions of your character.", false, false )
				guiGridListSetItemText ( chatcommandslist, mechatcreaterow, chatcommandexample, "/me shakes the man's hand.", false, false )
				
				dochatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommand, "/do", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommanduse, "/do <IC event>", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommandexplanation, "This is used to simulate events and the surroundings. Similar to /me.", false, false )
				guiGridListSetItemText ( chatcommandslist, dochatcreaterow, chatcommandexample, "/do The engine breaks down.", false, false )
				
				districtchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommand, "/f", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommanduse, "/f <OOC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommandexplanation, "This is an out of character faction chat to organize roleplay. Can only be used by factions.", false, false )
				guiGridListSetItemText ( chatcommandslist, factchatcreaterow, chatcommandexample, "/f How are my fellow faction members doing?", false, false )
				
				megachatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommand, "/m", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommanduse, "/m <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommandexplanation, "This allows you to speak to people in a wide radius with a megaphone.", false, false )
				guiGridListSetItemText ( chatcommandslist, megachatcreaterow, chatcommandexample, "/m Police! Move to the side of the road!", false, false )
								
				oocchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommand, "/o or 'U'", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommanduse, "/o <OOC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommandexplanation, "This is the global out of character chat.", false, false )
				guiGridListSetItemText ( chatcommandslist, oocchatcreaterow, chatcommandexample, "/o Where is everyone in the server?", false, false )
			   
				shoutchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommand, "/s", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommanduse, "/s <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommandexplanation, "This is used to simulate your player shouting.", false, false )
				guiGridListSetItemText ( chatcommandslist, shoutchatcreaterow, chatcommandexample, "/s Help!! The man stole my wallet!", false, false )
				
				whispchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommand, "/w", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommanduse, "/w <player name/ID> <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommandexplanation, "Use this to whisper to a player close to you. Only the two of you can see it.", false, false )
				guiGridListSetItemText ( chatcommandslist, whispchatcreaterow, chatcommandexample, "/w Jack_Konstantine He's looking right at me.", false, false )
				
				carwhispchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommand, "/cw", false, false )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommanduse, "/cw <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, carwhispchatcreaterow, chatcommandexplanation, "Use this to whisper to all players in a vehicle with you. Only you and the other occupants can see it.", false, false )
				guiGridListSetItemText ( chatcommandslist, wcarwhispchatcreaterow, chatcommandexample, "/cw Keep an eye out. I'll be right back", false, false )
				
				closechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommand, "/c", false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommanduse, "/c <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommandexplanation, "Use this to talk quietly to all the players around you." , false, false )
				guiGridListSetItemText ( chatcommandslist, closechatcreaterow, chatcommandexample, "/c He is walking right over here.", false, false )
				
				privatemessagechatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommand, "/pm", false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommanduse, "/pm <player name/ID> <OOC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommandexplanation, "Use this to privately message another player." , false, false )
				guiGridListSetItemText ( chatcommandslist, privatemessagechatcreaterow, chatcommandexample, "/pm John_Doe Thanks for helping me.", false, false )

				districtchatcreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommand, "/district or /dooc", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommanduse, "/district <OOC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexplanation, "Use this to talk to players in the same area of the map." , false, false )
				guiGridListSetItemText ( chatcommandslist, districtchatcreaterow, chatcommandexample, "/district Don't come in the bank. The doors are locked.", false, false )
				
				icreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommand, "/i", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommanduse, "/i <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexplanation, "This allows an interviewee to participate in the interview." , false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexample, "/i At that time, I never thought my idea would be so successful.", false, false )
				
				--Faction Commands
				
				local factcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabFactCommands )
				local factcommand = guiGridListAddColumn ( factcommandslist, "Command", 0.2 )
				local factusecommand = guiGridListAddColumn ( factcommandslist, "Faction", 0.2 )
				local factcommanduse = guiGridListAddColumn ( factcommandslist, "Syntax", 0.7 )
				local factcommandexplanation = guiGridListAddColumn ( factcommandslist, "Explanation", 0.7 )
				local factcommandexample = guiGridListAddColumn ( factcommandslist, "Example", 0.7 )
				
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
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f <text>", false, false )
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
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f <text>", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )

                -- elseif (factiontype == 2) then

					fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
					guiGridListSetItemText ( factcommandslist, fthreecreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "press 'F3'", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )

					ffourcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommand, "'F4'", false, false )
					guiGridListSetItemText ( factcommandslist, ffourcreaterow, factusecommand, "All Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommanduse, "press 'F4'", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommandexplanation, "This brings up the duty skin selection.", false, false )
				    guiGridListSetItemText ( factcommandslist, ffourcreaterow, factcommandexample, "n/a", false, false )

                    pcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommand, "'P'", false, false )
					guiGridListSetItemText ( factcommandslist, pcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommanduse, "press 'P' [while not in a vehicle]", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommandexplanation, "This will enable the riot shield.", false, false )
				    guiGridListSetItemText ( factcommandslist, pcreaterow, factcommandexample, "n/a", false, false )
					
					p1createrow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommand, "'P'", false, false )
					guiGridListSetItemText ( factcommandslist, p1createrow, factusecommand, "Government Factions", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommanduse, "press 'P' [while inside a vehicle]", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexplanation, "This will enable the flashers on an emergency vehicle.", false, false )
				    guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexample, "n/a", false, false )
					
					arrestcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommand, "/arrest", false, false )
					guiGridListSetItemText ( factcommandslist, arrestcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommanduse, "/arrest <player name/ID> <time (in minutes)> <fine> <charges> [at the booking desk]", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommandexplanation, "This will arrest the specified player.", false, false )
				    guiGridListSetItemText ( factcommandslist, arrestcreaterow, factcommandexample, "/arrest John_Sm 30 1000 Attempted murder, DUI, evading, possession of an illegal substance", false, false )

					releasecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommand, "/release", false, false )
					guiGridListSetItemText ( factcommandslist, releasecreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommanduse, "/release <player name/ID>", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommandexplanation, "This will release the specified player from the jail.", false, false )
				    guiGridListSetItemText ( factcommandslist, releasecreaterow, factcommandexample, "/release John_Sm", false, false )			
					
					dutycreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommand, "/duty", false, false )
					guiGridListSetItemText ( factcommandslist, dutycreaterow, factusecommand, "Police Department and Emergency Services", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommanduse, "/duty [inside the locker room]", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexplanation, "This is used to go on duty. Adds faction specific equipment and clothes selected with F4.", false, false )
				    guiGridListSetItemText ( factcommandslist, dutycreaterow, factcommandexample, "/duty", false, false )
					
					swatcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommand, "/swat", false, false )
					guiGridListSetItemText ( factcommandslist, swatcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommanduse, "/swat [inside the locker room]", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexplanation, "This will make you go on duty as a SWAT member.", false, false )
				    guiGridListSetItemText ( factcommandslist, swatcreaterow, factcommandexample, "/swat", false, false )

					cadetcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommand, "/cadet", false, false )
					guiGridListSetItemText ( factcommandslist, cadetcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommanduse, "/cadet [inside the locker room]", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommandexplanation, "This will make you go on duty as a cadet.", false, false )
				    guiGridListSetItemText ( factcommandslist, cadetcreaterow, factcommandexample, "/cadet", false, false )
					
					firefightercreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommand, "/firefighter", false, false )
					guiGridListSetItemText ( factcommandslist, firefightercreaterow, factusecommand, "Emergency Servies", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommanduse, "/firefighter [inside the locker room]", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommandexplanation, "This will make you go on duty as a firefighter.", false, false )
				    guiGridListSetItemText ( factcommandslist, firefightercreaterow, factcommandexample, "/firefighter", false, false )
					
					ticketcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommand, "/ticket", false, false )
					guiGridListSetItemText ( factcommandslist, ticketcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommanduse, "/ticket <player name/ID> <amount> <reason>", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexplanation, "Using this command you can ticket any player and issue them a fine.", false, false )
				    guiGridListSetItemText ( factcommandslist, ticketcreaterow, factcommandexample, "/ticket Angelo_Pappas 500 Failure to comply", false, false )
				
					backupcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommand, "/backup", false, false )
					guiGridListSetItemText ( factcommandslist, backupcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommanduse, "/backup", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexplanation, "This relays your position to all faction members by placing a blip on their radar.", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexample, "/backup", false, false )

					roadblockcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommand, "/rb1 and /rb2", false, false )
					guiGridListSetItemText ( factcommandslist, backupcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommanduse, "/rb1 or /rb2", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexplanation, "This spawns either roadblock 1 or roadblock 2.", false, false )
				    guiGridListSetItemText ( factcommandslist, backupcreaterow, factcommandexample, "/rb1", false, false )

					nearbyroadblockcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, nearbyroadblockcreaterow, factcommand, "/nearbyrb", false, false )
					guiGridListSetItemText ( factcommandslist, nearbyroadblockcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, nearbyroadblockcreaterow, factcommanduse, "/nearbyrb", false, false )
				    guiGridListSetItemText ( factcommandslist, nearbyroadblockcreaterow, factcommandexplanation, "This displays the nearby roadblocks with their respective IDs.", false, false )
				    guiGridListSetItemText ( factcommandslist, nearbyroadblockcreaterow, factcommandexample, "/nearbyrb", false, false )
					
					delroadblockcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommand, "/delroadblock", false, false )
					guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommanduse, "/delroadblock <ID>", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommandexplanation, "This removes the specified roadblock.", false, false )
				    guiGridListSetItemText ( factcommandslist, delroadblockcreaterow, factcommandexample, "/delroadblock 1", false, false )

					delallroadblockscreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommand, "/delallroadblocks", false, false )
					guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommanduse, "/delallroadblocks", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommandexplanation, "This removes all spawned roadblocks.", false, false )
				    guiGridListSetItemText ( factcommandslist, delallroadblockscreaterow, factcommandexample, "/delallroadblocks", false, false )
					
					spikescreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommand, "/deployspikes", false, false )
					guiGridListSetItemText ( factcommandslist, spikescreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommanduse, "/deployspikes", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommandexplanation, "This drops a spike strip that will burst vehicles tires.", false, false )
				    guiGridListSetItemText ( factcommandslist, spikescreaterow, factcommandexample, "/deployspikes", false, false )
					
					delspikescreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommand, "/removespikes", false, false )
					guiGridListSetItemText ( factcommandslist, delspikescreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommanduse, "/removespikes <ID>", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommandexplanation, "This removes a spike strip.", false, false )
				    guiGridListSetItemText ( factcommandslist, delspikescreaterow, factcommandexample, "/removespikes 1", false, false )

					gatecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommand, "/gate", false, false )
					guiGridListSetItemText ( factcommandslist, gatecreaterow, factusecommand, "All factions", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommanduse, "/gate [while near a faction gate]", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommandexplanation, "This opens a nearby faction gate.", false, false )
				    guiGridListSetItemText ( factcommandslist, gatecreaterow, factcommandexample, "/gate", false, false )

					mdccreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommand, "/mdc", false, false )
					guiGridListSetItemText ( factcommandslist, mdccreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommanduse, "/mdc", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommandexplanation, "This opens the PD MDC window.", false, false )
				    guiGridListSetItemText ( factcommandslist, mdccreaterow, factcommandexample, "/mdc", false, false )

					healcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommand, "/heal", false, false )
					guiGridListSetItemText ( factcommandslist, healcreaterow, factusecommand, "Emergency Services", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommanduse, "/heal <player name/ID> <price>", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommandexplanation, "This heals another player.", false, false )
				    guiGridListSetItemText ( factcommandslist, healcreaterow, factcommandexample, "/heal John_Smith 50", false, false )

					armorcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommand, "/armor", false, false )
					guiGridListSetItemText ( factcommandslist, armorcreaterow, factusecommand, "Police Department", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommanduse, "/armor [while inside the locker room]", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommandexplanation, "This gives you a new bullet proof vest.", false, false )
				    guiGridListSetItemText ( factcommandslist, armorcreaterow, factcommandexample, "/armor", false, false )
					
					ncreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, ncreaterow, factcommand, "/n", false, false )
					guiGridListSetItemText ( factcommandslist, ncreaterow, factusecommand, "News Faction", false, false )
				    guiGridListSetItemText ( factcommandslist, ncreaterow, factcommanduse, "/n <IC text>", false, false )
				    guiGridListSetItemText ( factcommandslist, ncreaterow, factcommandexplanation, "Used to globally broadcast the news.", false, false )
				    guiGridListSetItemText ( factcommandslist, ncreaterow, factcommandexample, "/n The weather is sunny and you are tuned in to LS News!", false, false )
					
					interviewcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, interviewcreaterow, factcommand, "/interview", false, false )
					guiGridListSetItemText ( factcommandslist, interviewcreaterow, factusecommand, "News Faction", false, false )
				    guiGridListSetItemText ( factcommandslist, interviewcreaterow, factcommanduse, "/interview <player name/ID>", false, false )
				    guiGridListSetItemText ( factcommandslist, interviewcreaterow, factcommandexplanation, "Starts an interview with the specified player.", false, false )
				    guiGridListSetItemText ( factcommandslist, interviewcreaterow, factcommandexample, "/interview Daemon_Fawkes", false, false )

					endinterviewcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, endinterviewcreaterow, factcommand, "/endinterview", false, false )
					guiGridListSetItemText ( factcommandslist, endinterviewcreaterow, factusecommand, "News Faction", false, false )
				    guiGridListSetItemText ( factcommandslist, endinterviewcreaterow, factcommanduse, "/endinterview", false, false )
				    guiGridListSetItemText ( factcommandslist, endinterviewcreaterow, factcommandexplanation, "Ends the current interview.", false, false )
				    guiGridListSetItemText ( factcommandslist, endinterviewcreaterow, factcommandexample, "/endinterview", false, false )
					
					forecastcreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, forecastcreaterow, factcommand, "/forecast", false, false )
					guiGridListSetItemText ( factcommandslist, forecastcreaterow, factusecommand, "News Faction", false, false )
				    guiGridListSetItemText ( factcommandslist, forecastcreaterow, factcommanduse, "/forecast", false, false )
				    guiGridListSetItemText ( factcommandslist, forecastcreaterow, factcommandexplanation, "Displays the weather prediction.", false, false )
				    guiGridListSetItemText ( factcommandslist, forecastcreaterow, factcommandexample, "/forecast", false, false )
					
					issuebadgecreaterow = guiGridListAddRow ( factcommandslist )
				    guiGridListSetItemText ( factcommandslist, issuebadgecreaterow, factcommand, "/issuebadge", false, false )
					guiGridListSetItemText ( factcommandslist, issuebadgecreaterow, factusecommand, "PD and ES", false, false )
				    guiGridListSetItemText ( factcommandslist, issuebadgecreaterow, factcommanduse, "/issuebadge <player name/ID><badge number>", false, false )
				    guiGridListSetItemText ( factcommandslist, issuebadgecreaterow, factcommandexplanation, "Issue a goverment faction (PD or ES) ID.", false, false )
				    guiGridListSetItemText ( factcommandslist, issuebadgecreaterow, factcommandexample, "/issuebadge John_Smith 1337", false, false )
					
				-- elseif (factiontype == 3) then
				
				    -- fthreecreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommand, "'F3'", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommanduse, "'F3' (keyboard bind key)", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexplanation, "This brings up the faction interface.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, fthreecreaterow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f <text>", false, false )
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
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommanduse, "'P' (keyboard bind key [while inside a vehicle])", false, false )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexplanation, "This will enable the flasher's on the emergency vehicle.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, p1createrow, factcommandexample, "n/a.", false, false )
				
				    -- factchatcreaterow = guiGridListAddRow ( factcommandslist )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommand, "/f", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f <text>", false, false )
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
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommanduse, "/f <text>", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexplanation, "This is an out of character faction chat to organise roleplay. Can only be used by factions.", false, false )
				    -- guiGridListSetItemText ( factcommandslist, factchatcreaterow, factcommandexample, "/f How you been mate?", false, false )
				
				-- end
					
				--Item Commands
				
				local itemcommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabItemCommands )
				local itemcommand = guiGridListAddColumn ( itemcommandslist, "Command", 0.2 )
				local itemcommanduse = guiGridListAddColumn ( itemcommandslist, "Syntax", 0.55 )
				local itemcommandexplanation = guiGridListAddColumn ( itemcommandslist, "Explanation", 0.72 )
				local itemcommandexample = guiGridListAddColumn ( itemcommandslist, "Example", 0.7 )
				
				invcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommand, "'I'", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommanduse, "press 'I'", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommandexplanation, "This is used to access your inventory screen.", false, false )
				guiGridListSetItemText ( itemcommandslist, invcreaterow, itemcommandexample, "n/a", false, false )
				
				callcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommand, "/call", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommanduse, "/call <phone number>", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommandexplanation, "Use this command to call another character on their cellphone.", false, false )
				guiGridListSetItemText ( itemcommandslist, callcreaterow, itemcommandexample, "/call 5555", false, false )
				
				hangupcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommand, "/hangup", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommanduse, "/hangup", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommandexplanation, "This is used to end the current phone conversation.", false, false )
				guiGridListSetItemText ( itemcommandslist, hangupcreaterow, itemcommandexample, "/hangup", false, false )
				
				loudspeakercreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommand, "/loudspeaker", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommanduse, "/loudspeaker", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommandexplanation, "This is used to place the call on the loudspeaker, so people around you can hear both sides of the conversation.", false, false )
				guiGridListSetItemText ( itemcommandslist, loudspeakercreaterow, itemcommandexample, "/loudspeaker", false, false )
				
				pchatcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommand, "/p", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommanduse, "/p <IC text>", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommandexplanation, "Use this to speak into the phone.", false, false )
				guiGridListSetItemText ( itemcommandslist, pchatcreaterow, itemcommandexample, "/p Hello? Who is this?", false, false )
				
				pickupcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommand, "/pickup", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommanduse, "/pickup", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommandexplanation, "This is used to answer a ringing phone.", false, false )
				guiGridListSetItemText ( itemcommandslist, pickupcreaterow, itemcommandexample, "/pickup", false, false )
				
				phonebookcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommand, "/phonebook", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommanduse, "/phonebook <player name/ID>", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommandexplanation, "This allows you to retrieve any character's phone number if you know their name.", false, false )
				guiGridListSetItemText ( itemcommandslist, phonebookcreaterow, itemcommandexample, "/phonebook Jack_Konstantine", false, false )
				
				radiofreqcreaterow = guiGridListAddRow ( itemcommandslist )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommand, "/tuneradio", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommanduse, "/tuneradio <channel mumber 0-65535>", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommandexplanation, "Use this command to change the frequency of your radio.", false, false )
				guiGridListSetItemText ( itemcommandslist, radiofreqcreaterow, itemcommandexample, "/tuneradio 7331", false, false )

				toggleradiocreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, toggleradiocreaterow, chatcommand, "/toggleradio", false, false )
				guiGridListSetItemText ( chatcommandslist, toggleradiocreaterow, chatcommanduse, "/toggleradio", false, false )
				guiGridListSetItemText ( chatcommandslist, toggleradiocreaterow, chatcommandexplanation, "Turns your radio on or off." , false, false )
				guiGridListSetItemText ( chatcommandslist, toggleradiocreaterow, chatcommandexample, "/toggleradio", false, false )
				
				--Misc Commands
				
				local misccommandslist = guiCreateGridList( 0, 0, 1, 0.9, true, tabMiscCommands )
				local misccommand = guiGridListAddColumn ( misccommandslist, "Command", 0.2 )
				local misccommanduse = guiGridListAddColumn ( misccommandslist, "Syntax", 0.4 )
				local misccommandexplanation = guiGridListAddColumn ( misccommandslist, "Explanation", 0.75 )
				local misccommandexample = guiGridListAddColumn ( misccommandslist, "Example", 0.7 )
				
				entercreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommand, "'Enter' or 'F'", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommanduse, "press 'Enter' or 'F'", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommandexplanation, "Using this bind key you are able to enter interiors. This is also the key used to buy new properties.", false, false )
				guiGridListSetItemText ( misccommandslist, entercreaterow, misccommandexample, "n/a", false, false )
				
				fonecreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommand, "'F1'", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommanduse, "press 'F1'", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommandexplanation, "This triggers a help tool, that explains the concepts of roleplay.", false, false )
				guiGridListSetItemText ( misccommandslist, fonecreaterow, misccommandexample, "n/a", false, false )
				
				ftwocreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommand, "/report or 'F2'", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommanduse, "/report", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommandexplanation, "This triggers the admin report window..", false, false )
				guiGridListSetItemText ( misccommandslist, ftwocreaterow, misccommandexample, "n/a", false, false )
				
				mkeycreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommand, "'m'", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommanduse, "press 'm'", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommandexplanation, "This enables the cursor to pick up items and right click on other players.", false, false )
				guiGridListSetItemText ( misccommandslist, mkeycreaterow, misccommandexample, "n/a", false, false )
				
				gluecreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommand, "/glue", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommanduse, "/glue [while on top of a vehicle]", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommandexplanation, "This sticks you to a vehicle. Useful for when travelling in a boat or in the back of a truck.", false, false )
				guiGridListSetItemText ( misccommandslist, gluecreaterow, misccommandexample, "/glue", false, false )

				ocreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommand, "'o'", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommanduse, "press 'o'", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommandexplanation, "This will open your friends list window.", false, false )
				guiGridListSetItemText ( misccommandslist, ocreaterow, misccommandexample, "n/a", false, false )
				
				jcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommand, "'J'", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommanduse, "press 'J'", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommandexplanation, "This key will start the vehicle.", false, false )
				guiGridListSetItemText ( misccommandslist, jcreaterow, misccommandexample, "n/a", false, false )
				
				kcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommand, "'K'", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommanduse, "press 'K'", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommandexplanation, "This key will lock the doors of the vehicle you are in.", false, false )
				guiGridListSetItemText ( misccommandslist, kcreaterow, misccommandexample, "n/a", false, false )
				
				lcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommand, "'L'", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommanduse, "press 'L'", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommandexplanation, "This key will turn on the car headlights.", false, false )
				guiGridListSetItemText ( misccommandslist, lcreaterow, misccommandexample, "n/a", false, false )
				
				sqbrkcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommand, "/indicator_left and /indicator_right", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommanduse, "(MOVING VEHICLE USE ONLY) Bind these keys by typing '/bind <desired key> indicator_<left or right>'", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommandexplanation, "This turns on and off the car's indicators.", false, false )
				guiGridListSetItemText ( misccommandslist, sqbrkcreaterow, misccommandexample, "n/a", false, false )
				
				fillcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommand, "/fill", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommanduse, "/fill [while at a gas station]", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommandexplanation, "Using this command when in a car will allow you to fill it up with fuel.", false, false )
				guiGridListSetItemText ( misccommandslist, fillcreaterow, misccommandexample, "/fill", false, false )
				
				oldcarcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommand, "/oldcar", false, false )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommanduse, "/oldcar", false, false )
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommandexplanation, "This command retrieves the ID of the last car that you were in.", false, false )				
				guiGridListSetItemText ( misccommandslist, oldcarcreaterow, misccommandexample, "/oldcar", false, false )
	
				thiscarcreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommand, "/thiscar", false, false )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommanduse, "/thiscar", false, false )
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommandexplanation, "Using this command will allow you to retrieve the ID of the car that you are currently in.", false, false )				
				guiGridListSetItemText ( misccommandslist, thiscarcreaterow, misccommandexample, "/thiscar", false, false )
				
				paycreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommand, "/pay", false, false )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommanduse, "/pay <player name/ID> <amount>", false, false )
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommandexplanation, "Using this command you can pay the specified player a desired amount of money.", false, false )				
				guiGridListSetItemText ( misccommandslist, paycreaterow, misccommandexample, "/pay Nathan_Daniels 1000", false, false )

				adminscreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommand, "/admins", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommanduse, "/admins", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommandexplanation, "This command when used will display all the admins currently online. Hidden admins are not seen on the list.", false, false )
				guiGridListSetItemText ( misccommandslist, adminscreaterow, misccommandexample, "/admins", false, false )
				
				taxicreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommand, "/taxi", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommanduse, "/taxi <IC message>", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommandexplanation, "This command will allow you to call for a taxi.", false, false )
				guiGridListSetItemText ( misccommandslist, taxicreaterow, misccommandexample, "/taxi I need a taxi from the Los Santos General Hospital.", false, false )
		
				ordersuppliescreaterow = guiGridListAddRow ( misccommandslist )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommand, "/ordersupplies", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommanduse, "/ordersupplies <amount>", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommandexplanation, "This command will restock your business with the amount of supplies specified. Supplies cost $2 each.", false, false )
				guiGridListSetItemText ( misccommandslist, ordersuppliescreaterow, misccommandexample, "/ordersupplies 2500", false, false )
				
                settagcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommand, "/settag", false, false )
				guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommanduse, "/settag <1-8>", false, false )
				guiGridListSetItemText ( misccommandslist, settagcreaterow, misccommandexplanation, "This command allows you to change the tag you're spraying using a spray can.", false, false )
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
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommanduse, "/id <player name/ID>", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexplanation, "This command displays the requested players name and ID.", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexample, "/id John_S", false, false )

				lasercreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, idcreaterow, misccommand, "/toglaser", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommanduse, "/toglaser", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexplanation, "This command toggles the weapon laser on and off (not available on all weapons).", false, false )
				guiGridListSetItemText ( misccommandslist, idcreaterow, misccommandexample, "/toglaser", false, false )                

				chaticonscreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommand, "/togchaticons", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommanduse, "/togchaticons", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommandexplanation, "This command toggless the speech bubble over players heads while they are typing.", false, false )
				guiGridListSetItemText ( misccommandslist, chaticonscreaterow, misccommandexample, "/togchaticons", false, false )    

				nametagscreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommand, "/tognametags", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommanduse, "/tognametags", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommandexplanation, "This command toggles other people's name tags (it only changes on your screen).", false, false )
				guiGridListSetItemText ( misccommandslist, nametagscreaterow, misccommandexample, "/tognametags", false, false )  

				animlistcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, animlistcreaterow, misccommand, "/animlist", false, false )
				guiGridListSetItemText ( misccommandslist, animlistcreaterow, misccommanduse, "/animlist", false, false )
				guiGridListSetItemText ( misccommandslist, animlistcreaterow, misccommandexplanation, "This command shows you a list of animations available on the server.", false, false )
				guiGridListSetItemText ( misccommandslist, animlistcreaterow, misccommandexample, "/animlist", false, false )  

				toggleooccreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, toggleooccreaterow, misccommand, "/toggleooc", false, false )
				guiGridListSetItemText ( misccommandslist, toggleooccreaterow, misccommanduse, "/toggleooc", false, false )
				guiGridListSetItemText ( misccommandslist, toggleooccreaterow, misccommandexplanation, "This command turns the global OOC on and off for the player, depending on it's current state.", false, false )
				guiGridListSetItemText ( misccommandslist, toggleooccreaterow, misccommandexample, "/toggleooc", false, false )  
	
				togglenewscreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, togglenewscreaterow, misccommand, "/togglenews", false, false )
				guiGridListSetItemText ( misccommandslist, togglenewscreaterow, misccommanduse, "/togglenews", false, false )
				guiGridListSetItemText ( misccommandslist, togglenewscreaterow, misccommandexplanation, "This command turns the news on and off for the player, depending on it's current state.", false, false )
				guiGridListSetItemText ( misccommandslist, togglenewscreaterow, misccommandexample, "/togglenews", false, false )
				
				startjobcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, startjobcreaterow, misccommand, "/startjob", false, false )
				guiGridListSetItemText ( misccommandslist, startjobcreaterow, misccommanduse, "/startjob [when at the appropriate location]", false, false )
				guiGridListSetItemText ( misccommandslist, startjobcreaterow, misccommandexplanation, "This command starts the job you applied for.", false, false )
				guiGridListSetItemText ( misccommandslist, startjobcreaterow, misccommandexample, "/startjob", false, false )
				
				quitjobcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, quitjobcreaterow, misccommand, "/quitjob", false, false )
				guiGridListSetItemText ( misccommandslist, quitjobcreaterow, misccommanduse, "/quitjob", false, false )
				guiGridListSetItemText ( misccommandslist, quitjobcreaterow, misccommandexplanation, "This command quits the job you applied for.", false, false )
				guiGridListSetItemText ( misccommandslist, quitjobcreaterow, misccommandexample, "/quitjob", false, false )
				
				dumploadcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, dumploadcreaterow, misccommand, "/dumpload", false, false )
				guiGridListSetItemText ( misccommandslist, dumploadcreaterow, misccommanduse, "/dumpload [while inside the appropriate marker]", false, false )
				guiGridListSetItemText ( misccommandslist, dumploadcreaterow, misccommandexplanation, "This command is used to deliver goods as part of the delivery job.", false, false )
				guiGridListSetItemText ( misccommandslist, dumploadcreaterow, misccommandexample, "/dumpload", false, false )
				
				fishcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, fishcreaterow, misccommand, "/fish", false, false )
				guiGridListSetItemText ( misccommandslist, fishcreaterow, misccommanduse, "/fish [while out on the sea with a boat]", false, false )
				guiGridListSetItemText ( misccommandslist, fishcreaterow, misccommandexplanation, "This command is used to fish as part of the fishing job.", false, false )
				guiGridListSetItemText ( misccommandslist, fishcreaterow, misccommandexample, "/fish", false, false )

				sellfishcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, sellfishcreaterow, misccommand, "/sellfish", false, false )
				guiGridListSetItemText ( misccommandslist, sellfishcreaterow, misccommanduse, "/sellfish [while at the fish market]", false, false )
				guiGridListSetItemText ( misccommandslist, sellfishcreaterow, misccommandexplanation, "This command is used to sell the fish you caught.", false, false )
				guiGridListSetItemText ( misccommandslist, sellfishcreaterow, misccommandexample, "/sellfish", false, false )
				
				cruisecontrolcreaterow = guiGridListAddRow ( misccommandslist )
                guiGridListSetItemText ( misccommandslist, cruisecontrolcreaterow, misccommand, "/cc", false, false )
				guiGridListSetItemText ( misccommandslist, cruisecontrolcreaterow, misccommanduse, "/cc [Speed or none to disable]", false, false )
				guiGridListSetItemText ( misccommandslist, cruisecontrolcreaterow, misccommandexplanation, "This command is used to toggle cruise control.", false, false )
				guiGridListSetItemText ( misccommandslist, cruisecontrolcreaterow, misccommandexample, "/cc 40", false, false )
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