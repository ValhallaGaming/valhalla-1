local myadminWindow = nil

function adminhelp (sourcePlayer, commandName)

    local sourcePlayer = getLocalPlayer()
    local adminLevel = getElementData(sourcePlayer, "adminlevel")
    if (adminLevel > 0) then
        if (myadminWindow == nil) then
            guiSetInputEnabled(true)
            myadminWindow = guiCreateWindow (0.2, 0.3, 0.6, 0.5, "Index of admin commands v4", true)
            local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
            local tabLevelOne = guiCreateTab("Level 1", tabPanel) -- tabs (start) 
            local tabLevelTwo = guiCreateTab("Level 2", tabPanel)
            local tabLevelThree = guiCreateTab("Level 3", tabPanel)
            local tabLevelFour = guiCreateTab("Level 4", tabPanel)
			local tabLevelFive = guiCreateTab("Level 5", tabPanel)
			local tabLevelSix = guiCreateTab("Level 6", tabPanel) -- tabs (end)
            local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button

            addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
                if (button == "left") then
                    if (state == "up") then
                        guiSetVisible(myadminWindow, false)
                        showCursor (thePlayer, false)
                        guiSetInputEnabled(false)
                        myadminWindow = nil
                        --destroyElement(gFactionWindow)
                    end
                end
            end, false)

            guiBringToFront (tlBackButton)

            if (tabLevelOne) then
            
                local levelonelist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelOne) -- commands for level one admins 
                local levelonecommand = guiGridListAddColumn (levelonelist, "Command", 0.2)
                local levelonecommanduse = guiGridListAddColumn (levelonelist, "Syntax", 1.0)
                local levelonecommandexplanation = guiGridListAddColumn (levelonelist, "Explanation", 1.3)

                checkcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, checkcreaterow, levelonecommand, "/check", false, false)
                guiGridListSetItemText ( levelonelist, checkcreaterow, levelonecommanduse, "/check [playername / id]", false, false)
                guiGridListSetItemText ( levelonelist, checkcreaterow, levelonecommandexplanation, "This command retrieves specified player's informations.", false, false)

                oldcarcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, oldcarcreaterow, levelonecommand, "/oldcar", false, false)
                guiGridListSetItemText ( levelonelist, oldcarcreaterow, levelonecommanduse, "/oldcar", false, false)
                guiGridListSetItemText ( levelonelist, oldcarcreaterow, levelonecommandexplanation, "This command retrieves the ID of the last car you drove.", false, false)

                thiscarcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, thiscarcreaterow, levelonecommand, "/thiscar", false, false)
                guiGridListSetItemText ( levelonelist, thiscarcreaterow, levelonecommanduse, "/thiscar", false, false)
                guiGridListSetItemText ( levelonelist, thiscarcreaterow, levelonecommandexplanation, "Using this command will allow you to retrieve the ID of the car that you are currently in.", false, false)
				
				setinteriornamecreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, setinteriornamecreaterow, levelonecommand, "/setinteriorname", false, false)
                guiGridListSetItemText ( levelonelist, setinteriornamecreaterow, levelonecommanduse, "/setinteriorname", false, false)
                guiGridListSetItemText ( levelonelist, setinteriornamecreaterow, levelonecommandexplanation, "Changes the name of the interior you are in.", false, false)
				
				auncuffcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, auncuffcreaterow, levelonecommand, "/auncuff", false, false)
                guiGridListSetItemText ( levelonelist, auncuffcreaterow, levelonecommanduse, "/auncuff [Player Name]", false, false)
                guiGridListSetItemText ( levelonelist, auncuffcreaterow, levelonecommandexplanation, "Unrestains a player.", false, false)
				
				mutecreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, mutecreaterow, levelonecommand, "/mute", false, false)
                guiGridListSetItemText ( levelonelist, mutecreaterow, levelonecommanduse, "/mute [Player Name]", false, false)
                guiGridListSetItemText ( levelonelist, mutecreaterow, levelonecommandexplanation, "Mutes a player.", false, false)
				
				disarmcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, disarmcreaterow, levelonecommand, "/disarm", false, false)
                guiGridListSetItemText ( levelonelist, disarmcreaterow, levelonecommanduse, "/disarm [Player Name]", false, false)
                guiGridListSetItemText ( levelonelist, disarmcreaterow, levelonecommandexplanation, "Removes the players weapons.", false, false)
				
				itemlistcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, itemlistcreaterow, levelonecommand, "/itemlist", false, false)
                guiGridListSetItemText ( levelonelist, itemlistcreaterow, levelonecommanduse, "/itemlist", false, false)
                guiGridListSetItemText ( levelonelist, itemlistcreaterow, levelonecommandexplanation, "Displays a list of all items and their IDs.", false, false)
				
				showfactionscreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, showfactionscreaterow, levelonecommand, "/showfactions", false, false)
                guiGridListSetItemText ( levelonelist, showfactionscreaterow, levelonecommanduse, "/showfactions", false, false)
                guiGridListSetItemText ( levelonelist, showfactionscreaterow, levelonecommandexplanation, "Displays a list of all factions and their IDs.", false, false)
				
				giveitemcreaterow = guiGridListAddRow ( levelonelist )
                guiGridListSetItemText ( levelonelist, giveitemcreaterow, levelonecommand, "/giveitem", false, false)
                guiGridListSetItemText ( levelonelist, giveitemcreaterow, levelonecommanduse, "/giveitem [player name][item ID][item value]", false, false)
                guiGridListSetItemText ( levelonelist, giveitemcreaterow, levelonecommandexplanation, "Gives the player the specified item.", false, false)
		
				fixvehcreaterow = guiGridListAddRow (levelonelist)
                guiGridListSetItemText (levelonelist, fixvehcreaterow, levelonecommand, "/fixveh", false, false)
                guiGridListSetItemText (levelonelist, fixvehcreaterow, levelonecommanduse, "/fixveh [playername / id]", false, false)
                guiGridListSetItemText (levelonelist, fixvehcreaterow, levelonecommandexplanation, "This command allows you to fix specified player's vehicle.", false, false)
                
                fixvehscreaterow = guiGridListAddRow (levelonelist)
                guiGridListSetItemText (levelonelist, fixvehscreaterow, levelonecommand, "/fixvehs", false, false)
                guiGridListSetItemText (levelonelist, fixvehscreaterow, levelonecommanduse, "/fixvehs", false, false)
                guiGridListSetItemText (levelonelist, fixvehscreaterow, levelonecommandexplanation, "Using this command allows you to fix all the vehicles in-game.", false, false)
				
				achatcreaterow = guiGridListAddRow (levelonelist)
                guiGridListSetItemText (levelonelist, achatcreaterow, levelonecommand, "/a", false, false)
                guiGridListSetItemText (levelonelist, achatcreaterow, levelonecommanduse, "/a [text]", false, false)
                guiGridListSetItemText (levelonelist, achatcreaterow, levelonecommandexplanation, "This allows you to use the admin chat and is the key to teamwork and communication.", false, false)

                addupgradecreaterow = guiGridListAddRow (levelonelist)
                guiGridListSetItemText (levelonelist, addupgradecreaterow, levelonecommand, "/addupgrade", false, false)
                guiGridListSetItemText (levelonelist, addupgradecreaterow, levelonecommanduse, "/addupgrade [player name / id] [upgrade id]", false, false)
                guiGridListSetItemText (levelonelist, addupgradecreaterow, levelonecommandexplanation, "Using this command will allow you to add any vehicle upgrade to specified player's car.", false, false)
				
								
                changenamecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, changenamecreaterow, leveltwocommand, "/changename", false, false)
                guiGridListSetItemText (leveltwolist, changenamecreaterow, leveltwocommanduse, "/changename [player name / id] [new name]", false, false)
                guiGridListSetItemText (leveltwolist, changenamecreaterow, leveltwocommandexplanation, "This command changes the name that appears above specified player's head.", false, false)

                delvehcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, delvehcreaterow, leveltwocommand, "/delveh", false, false)
                guiGridListSetItemText (leveltwolist, delvehcreaterow, leveltwocommanduse, "/delveh [vehicle id]", false, false)
                guiGridListSetItemText (leveltwolist, delvehcreaterow, leveltwocommandexplanation, "This allows you to delete any individual vehicle in-game.", false, false)

                findvehcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, findvehcreaterow, leveltwocommand, "/findvehid", false, false)
                guiGridListSetItemText (leveltwolist, findvehcreaterow, leveltwocommanduse, "/findvehid [player name / id]", false, false)
                guiGridListSetItemText (leveltwolist, findvehcreaterow, leveltwocommandexplanation, "This allows you to find any specified player's vehicle ID.", false, false)  
                
                forecastcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, forecastcreaterow, leveltwocommand, "/forecast", false, false)
                guiGridListSetItemText (leveltwolist, forecastcreaterow, leveltwocommanduse, "/forecast", false, false)
                guiGridListSetItemText (leveltwolist, forecastcreaterow, leveltwocommandexplanation, "Here you can see the current or the next weather set in the server.", false, false)
                    
                freezecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, freezecreaterow, leveltwocommand, "/freeze", false, false)
                guiGridListSetItemText (leveltwolist, freezecreaterow, leveltwocommanduse, "/freeze [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, freezecreaterow, leveltwocommandexplanation, "This command makes the player immobile, so you can talk to them. To unfreeze, see /unfreeze.", false, false)

                getposcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, getposcreaterow, leveltwocommand, "/getpos", false, false)
                guiGridListSetItemText (leveltwolist, getposcreaterow, leveltwocommanduse, "/getpos", false, false)
                guiGridListSetItemText (leveltwolist, getposcreaterow, leveltwocommandexplanation, "This command gets your co-ordinates, interior, dimension and rotation data.", false, false)
                
                gotocreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, gotocreaterow, leveltwocommand, "/goto", false, false)
                guiGridListSetItemText (leveltwolist, gotocreaterow, leveltwocommanduse, "/goto [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, gotocreaterow, leveltwocommandexplanation, "This command teleports you to the specified player.", false, false)

                hugeslapcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, hugeslapcreaterow, leveltwocommand, "/hugeslap", false, false)
                guiGridListSetItemText (leveltwolist, hugeslapcreaterow, leveltwocommanduse, "/hugeslap [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, hugeslapcreaterow, leveltwocommandexplanation, "This command slaps a desired player higher than the normal slap.", false, false)
                
                jailcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, jailcreaterow, leveltwocommand, "/jail", false, false)
                guiGridListSetItemText (leveltwolist, jailcreaterow, leveltwocommanduse, "/jail [playername / id] [minutes (>= 1) (999 = permanent jail)] [reason]", false, false)
                guiGridListSetItemText (leveltwolist, jailcreaterow, leveltwocommandexplanation, "This command admin jails the specified player, so they are unable to play as a form of punishment.", false, false)
                    
                kickcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, kickcreaterow, leveltwocommand, "/kickplr", false, false)
                guiGridListSetItemText (leveltwolist, kickcreaterow, leveltwocommanduse, "/kickplr [playername / id] [reason]", false, false)
                guiGridListSetItemText (leveltwolist, kickcreaterow, leveltwocommandexplanation, "This command kicks the specified player from the server. Be sure to give a valid reason", false, false)
                
				 getelecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, getelecreaterow, leveltwocommand, "/nearbyelevators", false, false)
                guiGridListSetItemText (leveltwolist, getelecreaterow, leveltwocommanduse, "/nearbyelevators", false, false)
                guiGridListSetItemText (leveltwolist, getelecreaterow, leveltwocommandexplanation, "Gets the ID of the elevator that is nearest to you.", false, false)
                
                getelecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, pbancreaterow, leveltwocommand, "/pban", false, false)
                guiGridListSetItemText (leveltwolist, pbancreaterow, leveltwocommanduse, "/pban [playername / id] [reason]", false, false)
                guiGridListSetItemText (leveltwolist, pbancreaterow, leveltwocommandexplanation, "Bans the specified player from the server, remember to give a proper reason.", false, false)
                
                reconcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, reconcreaterow, leveltwocommand, "/recon", false, false)
                guiGridListSetItemText (leveltwolist, reconcreaterow, leveltwocommanduse, "/recon [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, reconcreaterow, leveltwocommandexplanation, "This command allows you to watch the player without them knowing. /recon on it's own switches it off.", false, false)
                
                respawnallcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, respawnvehcreaterow, leveltwocommand, "/respawnveh", false, false)
                guiGridListSetItemText (leveltwolist, respawnvehcreaterow, leveltwocommanduse, "/respawnveh [vehicle id]", false, false)
                guiGridListSetItemText (leveltwolist, respawnvehcreaterow, leveltwocommandexplanation, "Using this command will allow you to respawn the specified vehicle.", false, false)
                
                respawnallcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, respawnallcreaterow, leveltwocommand, "/respawnall", false, false)
                guiGridListSetItemText (leveltwolist, respawnallcreaterow, leveltwocommanduse, "/respawnall", false, false)
                guiGridListSetItemText (leveltwolist, respawnallcreaterow, leveltwocommandexplanation, "Using this command will allow you to respawn all the vehicles, regardless of use. Be sure to notify people first.", false, false)
                
                setcolorcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, setcolorcreaterow, leveltwocommand, "/setcolor", false, false)
                guiGridListSetItemText (leveltwolist, setcolorcreaterow, leveltwocommanduse, "/setcolor [playername / id] [color 1] [color 2]", false, false)
                guiGridListSetItemText (leveltwolist, setcolorcreaterow, leveltwocommandexplanation, "This command changes the colors of the specified player's vehicle.", false, false)
                
                setintecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, setintecreaterow, leveltwocommand, "/setinteriorexit", false, false)
                guiGridListSetItemText (leveltwolist, setintecreaterow, leveltwocommanduse, "/setinteriorexit", false, false)
                guiGridListSetItemText (leveltwolist, setintecreaterow, leveltwocommandexplanation, "This command allows you to set a different exit for the interior you are in.", false, false)
               
			   setskincreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, setskincreaterow, leveltwocommand, "/setskin", false, false)
                guiGridListSetItemText (leveltwolist, setskincreaterow, leveltwocommanduse, "/setskin [playername / id] [skin id]", false, false)
                guiGridListSetItemText (leveltwolist, setskincreaterow, leveltwocommandexplanation, "This command changes the specified player's skin to the one you have chosen.", false, false)
    
                slapcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, slapcreaterow, leveltwocommand, "/slap", false, false)
                guiGridListSetItemText (leveltwolist, slapcreaterow, leveltwocommanduse, "/slap [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, slapcreaterow, leveltwocommandexplanation, "This command slaps the specified player into the air, to show them, they are doing something wrong.", false, false)
                
                togooccreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, togooccreaterow, leveltwocommand, "/togooc", false, false)
                guiGridListSetItemText (leveltwolist, togooccreaterow, leveltwocommanduse, "/togooc", false, false)
                guiGridListSetItemText (leveltwolist, togooccreaterow, leveltwocommandexplanation, "Using this command will disable the global out of character chat completely.", false, false)
                
                unfreezecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, unfreezecreaterow, leveltwocommand, "/unfreeze", false, false)
                guiGridListSetItemText (leveltwolist, unfreezecreaterow, leveltwocommanduse, "/unfreeze [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, unfreezecreaterow, leveltwocommandexplanation, "This command makes the specified player mobile again, this should be used after the player is frozen.", false, false)                
                
				unbancreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, unbancreaterow, leveltwocommand, "/unban", false, false)
                guiGridListSetItemText (leveltwolist, unbancreaterow, leveltwocommanduse, "/unban [full player name]", false, false)
                guiGridListSetItemText (leveltwolist, unbancreaterow, leveltwocommandexplanation, "Use this command to unban any desired player, be careful to spell the name correctly.", false, false)                
                
                uptimecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommand, "/astats", false, false)
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommanduse, "/astats", false, false)
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommandexplanation, "Using this command, you can see how long the server has been online since the last restart.", false, false)                
                
                vehposcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, vehposcreaterow, leveltwocommand, "/vehpos", false, false)
                guiGridListSetItemText (leveltwolist, vehposcreaterow, leveltwocommanduse, "/vehpos", false, false)
                guiGridListSetItemText (leveltwolist, vehposcreaterow, leveltwocommandexplanation, "This allows you to change the spawn location of any vehicle in-game.", false, false)    
                
                xcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, xcreaterow, leveltwocommand, "/x", false, false)
                guiGridListSetItemText (leveltwolist, xcreaterow, leveltwocommanduse, "/x [x value]", false, false)
                guiGridListSetItemText (leveltwolist, xcreaterow, leveltwocommandexplanation, "This moves you for the desired amount in the x direction.", false, false)
                 
                xyzcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, xyzcreaterow, leveltwocommand, "/xyz", false, false)
                guiGridListSetItemText (leveltwolist, xyzcreaterow, leveltwocommanduse, "/xyz [x value] [y value] [z value]", false, false)
                guiGridListSetItemText (leveltwolist, xyzcreaterow, leveltwocommandexplanation, "This moves you for the desired amount in each direction.", false, false)
                 
                ycreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, ycreaterow, leveltwocommand, "/y", false, false)
                guiGridListSetItemText (leveltwolist, ycreaterow, leveltwocommanduse, "/y [y value]", false, false)
                guiGridListSetItemText (leveltwolist, ycreaterow, leveltwocommandexplanation, "This moves you for the desired amount in the y direction.", false, false)
                    
                zcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, zcreaterow, leveltwocommand, "/z", false, false)
                guiGridListSetItemText (leveltwolist, zcreaterow, leveltwocommanduse, "/z [z value]", false, false)
                guiGridListSetItemText (leveltwolist, zcreaterow, leveltwocommandexplanation, "This moves you for the desired amount in the z direction.", false, false)
				
				 anncreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, anncreaterow, levelthreecommand, "/ann", false, false)
                guiGridListSetItemText (levelthreelist, anncreaterow, levelthreecommanduse, "/ann [text]", false, false)
                guiGridListSetItemText (levelthreelist, anncreaterow, levelthreecommandexplanation, "This command allows you to write anonymous admin text into the OOC channel.", false, false)

                getcarcreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, getcarcreaterow, levelthreecommand, "/getcar", false, false)
                guiGridListSetItemText (levelthreelist, getcarcreaterow, levelthreecommanduse, "/getcar [car id]", false, false)
                guiGridListSetItemText (levelthreelist, getcarcreaterow, levelthreecommandexplanation, "Using this command allows you to retrieve any car, providing you know the ID.", false, false)
                
                getherecreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, getherecreaterow, levelthreecommand, "/gethere", false, false)
                guiGridListSetItemText (levelthreelist, getherecreaterow, levelthreecommanduse, "/gethere [playername / id]", false, false)
                guiGridListSetItemText (levelthreelist, getherecreaterow, levelthreecommandexplanation, "This command teleports any player to your location.", false, false)mutecreaterow = guiGridListAddRow (levelthreelist)
                
                gotomarkrow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, gotomarkrow , levelthreecommand, "/gotomark", false, false)
                guiGridListSetItemText (levelthreelist, gotomarkrow , levelthreecommanduse, "/gotomark", false, false)
                guiGridListSetItemText (levelthreelist, gotomarkrow , levelthreecommandexplanation, "Teleports you to a point that you made with /mark earlier.", false, false)
                
                markcreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, markcreaterow, levelthreecommand, "/mark", false, false)
                guiGridListSetItemText (levelthreelist, markcreaterow, levelthreecommanduse, "/mark", false, false)
                guiGridListSetItemText (levelthreelist, markcreaterow, levelthreecommandexplanation, "Marks your spot, so you can teleport back to it with /gotomark", false, false)
				
				gotoplacecreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, gotoplacecreaterow, levelthreecommand, "/gotoplace", false, false)
                guiGridListSetItemText (levelthreelist, gotoplacecreaterow, levelthreecommanduse, "/gotoplace [lv/sf/ls]", false, false)
                guiGridListSetItemText (levelthreelist, gotoplacecreaterow, levelthreecommandexplanation, "TPs you to LV airport, SF airport or Pershing Square.", false, false)
				
            --elseif (tabTeamLeader) then
                local leveltwolist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelTwo) -- commands for level two admins
                local leveltwocommand = guiGridListAddColumn (leveltwolist, "Command", 0.2)
                local leveltwocommanduse = guiGridListAddColumn (leveltwolist, "Syntax", 1.0)
                local leveltwocommandexplanation = guiGridListAddColumn (leveltwolist, "Explanation", 1.3)
			 
				leveltwononecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, leveltwononecreaterow, leveltwocommand , "None", false, false)
                guiGridListSetItemText (leveltwolist, leveltwononecreaterow, leveltwocommanduse, "", false, false)
                guiGridListSetItemText (leveltwolist, leveltwononecreaterow, leveltwocommandexplanation, "", false, false)
                
            --elseif (tabLeadAdmin) then
                local levelthreelist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelThree)
                local levelthreecommand = guiGridListAddColumn (levelthreelist, "Command", 0.2)
                local levelthreecommanduse = guiGridListAddColumn (levelthreelist, "Syntax", 1.0)
                local levelthreecommandexplanation = guiGridListAddColumn (levelthreelist, "Explanation", 1.3)

                setfactcreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, setfactcreaterow, levelthreecommand, "/setfaction", false, false)
                guiGridListSetItemText (levelthreelist, setfactcreaterow, levelthreecommanduse, "/setfaction [playername / id] [faction id]", false, false)
                guiGridListSetItemText (levelthreelist, setfactcreaterow, levelthreecommandexplanation, "Using this command will allow you to assign any player to a faction in-game.", false, false)
                
                setweathercreaterow = guiGridListAddRow (levelthreelist)
                guiGridListSetItemText (levelthreelist, setweathercreaterow, levelthreecommand, "/setweather", false, false)
                guiGridListSetItemText (levelthreelist, setweathercreaterow, levelthreecommanduse, "/setweather", false, false)
                guiGridListSetItemText (levelthreelist, setweathercreaterow, levelthreecommandexplanation, "This creates a GUI where you can set the weather for the next few hours, take note that each change takes a few moments to load.", false, false)

                local levelfourlist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelFour)
                local levelfourcommand = guiGridListAddColumn (levelfourlist, "Command", 0.2)
                local levelfourcommanduse = guiGridListAddColumn (levelfourlist, "Syntax", 1.0)
                local levelfourcommandexplanation = guiGridListAddColumn (levelfourlist, "Explanation", 1.3)

                addelecreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, addelecreaterow, levelfourcommand, "/addelevator", false, false)
                guiGridListSetItemText (levelfourlist, addelecreaterow, levelfourcommanduse, "/addelevator [interior id] [dimension id] [x] [y] [z]", false, false)
                guiGridListSetItemText (levelfourlist, addelecreaterow, levelfourcommandexplanation, "This command allows you to create an elevator at any location.", false, false)
                
                addfuelcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, addfuelcreaterow, levelfourcommand, "/addfuelpoint", false, false)
                guiGridListSetItemText (levelfourlist, addfuelcreaterow, levelfourcommanduse, "/addfuelpoint", false, false)
                guiGridListSetItemText (levelfourlist, addfuelcreaterow, levelfourcommandexplanation, "This command allows you to create a fuel point at your location.", false, false)
                
                addinteriorcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, addinteriorcreaterow, levelfourcommand, "/addinterior", false, false)
                guiGridListSetItemText (levelfourlist, addinteriorcreaterow, levelfourcommanduse, "/addinterior [interior id] [x] [y] [z] [optimal angle] [type 0=house, 1=bus, 2=gov/other(unbuyable)] [cost] [name]", false, false)
                guiGridListSetItemText (levelfourlist, addinteriorcreaterow, levelfourcommandexplanation, "This command allows you to create any interior at a certain location.", false, false)
                
                delelecreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, delelecreaterow, levelfourcommand, "/delelevator", false, false)
                guiGridListSetItemText (levelfourlist, delelecreaterow, levelfourcommanduse, "/delelevator [elevator id]", false, false)
                guiGridListSetItemText (levelfourlist, delelecreaterow, levelfourcommandexplanation, "This command allows you to delete any desired elevator.", false, false)        
                
                delfuelcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, delfuelcreaterow, levelfourcommand, "/delfuelpoint", false, false)
                guiGridListSetItemText (levelfourlist, delfuelcreaterow, levelfourcommanduse, "/delfuelpoint", false, false)
                guiGridListSetItemText (levelfourlist, delfuelcreaterow, levelfourcommandexplanation, "This command allows you to delete the fuel point that is closest to you.", false, false)
                
                delintcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, delintcreaterow, levelfourcommand, "/delinterior", false, false)
                guiGridListSetItemText (levelfourlist, delintcreaterow, levelfourcommanduse, "/delinterior", false, false)
                guiGridListSetItemText (levelfourlist, delintcreaterow, levelfourcommandexplanation, "This command allows you to delete the interior you are currently in.", false, false) 
                
                makefactcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, makefactcreaterow, levelfourcommand, "/makefaction", false, false)
                guiGridListSetItemText (levelfourlist, makefactcreaterow, levelfourcommanduse, "/makefaction [faction type 0=gang, 1=mafia, 2=law, 3=gov, 4=med, 5=other] [faction name]", false, false)
                guiGridListSetItemText (levelfourlist, makefactcreaterow, levelfourcommandexplanation, "Using this command will allow you to create any faction in-game.", false, false)
                
                makevehcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, makevehcreaterow, levelfourcommand, "/makeveh", false, false)
                guiGridListSetItemText (levelfourlist, makevehcreaterow, levelfourcommanduse, "/makeveh [id] [color 1 (-1 for random)] [color 2 (-1 for random)] [owner's name / id] [faction vehicle (1/0)] [cost]", false, false)
                guiGridListSetItemText (levelfourlist, makevehcreaterow, levelfourcommandexplanation, "Using this command will allow you to create a permanent vehicle in game.", false, false)
                
				vehcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, vehcreaterow, leveltwocommand, "/veh", false, false)
                guiGridListSetItemText (levelfourlist, vehcreaterow, leveltwocommanduse, "/veh [vehicle id] [color 1] [color 2]", false, false)
                guiGridListSetItemText (levelfourlist, vehcreaterow, leveltwocommandexplanation, "Use this command to create a temporary vehicle in the server.", false, false)                
                
				makecivvehcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, makecivvehcreaterow, leveltwocommand, "/makecivveh", false, false)
                guiGridListSetItemText (levelfourlist, makecivvehcreaterow, leveltwocommanduse, "/makecivveh [vehicle id] [color 1] [color 2]", false, false)
                guiGridListSetItemText (levelfourlist, makecivvehcreaterow, leveltwocommandexplanation, "Use this command to create a permanent, unowned vehicle in the server.", false, false)                
                				
                setarmorcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, setarmorcreaterow, levelfourcommand, "/setarmor", false, false)
                guiGridListSetItemText (levelfourlist, setarmorcreaterow, levelfourcommanduse, "/setarmor [playername / id] [ammount]", false, false)
                guiGridListSetItemText (levelfourlist, setarmorcreaterow, levelfourcommandexplanation, "This command adds/removes armor to/from the specified player.", false, false)
                
                setfactleacreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, setfactleacreaterow, levelfourcommand, "/setfactionleader", false, false)
                guiGridListSetItemText (levelfourlist, setfactleacreaterow, levelfourcommanduse, "/setfactionleader [playername / id] [faction id]", false, false)
                guiGridListSetItemText (levelfourlist, setfactleacreaterow, levelfourcommandexplanation, "Using this command will allow you to assign any player as a leader of any faction.", false, false)    
                
                sethpcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, sethpcreaterow, levelfourcommand, "/sethp", false, false)
                guiGridListSetItemText (levelfourlist, sethpcreaterow, levelfourcommanduse, "/sethp [playername / id] [ammount]", false, false)
                guiGridListSetItemText (levelfourlist, sethpcreaterow, levelfourcommandexplanation, "This command adds/removes health to/from any player.", false, false)
               
                lchatcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, lchatcreaterow, levelfourcommand, "/l", false, false)
                guiGridListSetItemText (levelfourlist, lchatcreaterow, levelfourcommanduse, "/l [text]", false, false)
                guiGridListSetItemText (levelfourlist, lchatcreaterow, levelfourcommandexplanation, "This allows you to use the lead admin chat and is key to teamwork, organisation and communication.", false, false)
                
                makeadmincreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, makeadmincreaterow, levelfourcommand, "/makeadmin", false, false)
                guiGridListSetItemText (levelfourlist, makeadmincreaterow, levelfourcommanduse, "/makeadmin [playername / id] [admin rank]", false, false)
                guiGridListSetItemText (levelfourlist, makeadmincreaterow, levelfourcommandexplanation, "This allows you to give any admin rank to specified player.", false, false)
                
                restartrescreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, restartrescreaterow, levelfourcommand, "/restartres", false, false)
                guiGridListSetItemText (levelfourlist, restartrescreaterow, levelfourcommanduse, "/restartres [resource name]", false, false)
                guiGridListSetItemText (levelfourlist, restartrescreaterow, levelfourcommandexplanation, "This allows you to restart any script resource.", false, false)
                
                setmoneycreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, setmoneycreaterow, levelfourcommand, "/setmoney", false, false)
                guiGridListSetItemText (levelfourlist, setmoneycreaterow, levelfourcommanduse, "/setmoney [playername / id] [ammount]", false, false)
                guiGridListSetItemText (levelfourlist, setmoneycreaterow, levelfourcommandexplanation, "This command adds/removes money to/from any player.", false, false)
                
                startrescreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, startrescreaterow, levelfourcommand, "/startres", false, false)
                guiGridListSetItemText (levelfourlist, startrescreaterow, levelfourcommanduse, "/startres [resource name]", false, false)
                guiGridListSetItemText (levelfourlist, startrescreaterow, levelfourcommandexplanation, "This allows you to start any resource that has not yet been started.", false, false)
                    
                stoprescreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, stoprescreaterow, levelfourcommand, "/stopres", false, false)
                guiGridListSetItemText (levelfourlist, stoprescreaterow, levelfourcommanduse, "/stopres [resource name]", false, false)
                guiGridListSetItemText (levelfourlist, stoprescreaterow, levelfourcommandexplanation, "This allows you to stop any resource that has been running.", false, false)
                
				ckcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, ckcreaterow, levelfourcommand, "/ck", false, false)
                guiGridListSetItemText (levelfourlist, ckcreaterow, levelfourcommanduse, "/ck [player name]", false, false)
                guiGridListSetItemText (levelfourlist, ckcreaterow, levelfourcommandexplanation, "This character kills the player. A CK corpse is spawned at the spot they were Cked.", false, false)
                
				unckcreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, unckcreaterow, levelfourcommand, "/unck", false, false)
                guiGridListSetItemText (levelfourlist, unckcreaterow, levelfourcommanduse, "/unck [player name]", false, false)
                guiGridListSetItemText (levelfourlist, unckcreaterow, levelfourcommandexplanation, "Reverts a CKed character. The character can be selected a character selection again.", false, false)
                
				giveguncreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, giveguncreaterow, levelfourcommand, "/givegun", false, false)
                guiGridListSetItemText (levelfourlist, giveguncreaterow, levelfourcommanduse, "/givegun [player name][weaponID][ammo]", false, false)
                guiGridListSetItemText (levelfourlist, giveguncreaterow, levelfourcommandexplanation, "Gives the player the specified weapon.", false, false)
                
                local levelfivelist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelFive)
                local levelfivecommand = guiGridListAddColumn (levelfivelist, "Command", 0.2)
                local levelfivecommanduse = guiGridListAddColumn (levelfourlist, "Syntax", 1.0)
                local levelfivecommandexplanation = guiGridListAddColumn (levelfivelist, "Explanation", 1.3)
                
				hideadmincreaterow = guiGridListAddRow (levelfivelist)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfivecommand, "/hideadmin", false, false)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfivecommanduse, "/hideadmin", false, false)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfivecommandexplanation, "This allows you to not be seen on the admin list.", false, false)
                
				hchatcreaterow = guiGridListAddRow (levelfivelist)
                guiGridListSetItemText (levelfourlist, hchatcreaterow, levelfourcommand, "/h", false, false)
                guiGridListSetItemText (levelfourlist, hchatcreaterow, levelfourcommanduse, "/h [text]", false, false)
                guiGridListSetItemText (levelfourlist, hchatcreaterow, levelfourcommandexplanation, "This allows you to use the head admin chat and is key to teamwork, organisation and communication.", false, false)
               
                local levelsixlist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelSix)
                local levelsixcommand = guiGridListAddColumn (levelsixlist, "Command", 0.2)
                local levelsixcommanduse = guiGridListAddColumn (levelfourlist, "Syntax", 1.0)
                local levelsixcommandexplanation = guiGridListAddColumn (levelsixlist, "Explanation", 1.3)
                
                noentriesrow = guiGridListAddRow (levelsixlist)
                guiGridListSetItemText (levelsixlist, noentriesrow, levelsixcommand, "none", false, false)
                guiGridListSetItemText (levelsixlist, noentriesrow, levelsixcommanduse, "not available", false, false)
                guiGridListSetItemText (levelsixlist, noentriesrow, levelsixcommandexplanation, "currently no level 6 commands available", false, false)

            
        else
            local visible = guiGetVisible (myadminWindow)
            if (visible == false) then
                guiSetVisible( myadminWindow, true)
                showCursor (thePlayer, true)
            end                            
			end
        end
    showCursor(thePlayer, false)
    end
end
addCommandHandler("ah", adminhelp)