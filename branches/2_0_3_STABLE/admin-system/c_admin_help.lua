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

            --elseif (tabTeamLeader) then
                local leveltwolist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelTwo) -- commands for level two admins
                local leveltwocommand = guiGridListAddColumn (leveltwolist, "Command", 0.2)
                local leveltwocommanduse = guiGridListAddColumn (leveltwolist, "Syntax", 1.0)
                local leveltwocommandexplanation = guiGridListAddColumn (leveltwolist, "Explanation", 1.3)

                achatcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, achatcreaterow, leveltwocommand, "/a", false, false)
                guiGridListSetItemText (leveltwolist, achatcreaterow, leveltwocommanduse, "/a [text]", false, false)
                guiGridListSetItemText (leveltwolist, achatcreaterow, leveltwocommandexplanation, "This allows you to use the admin chat and is the key to teamwork and communication.", false, false)

                addupgradecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, addupgradecreaterow, leveltwocommand, "/addupgrade", false, false)
                guiGridListSetItemText (leveltwolist, addupgradecreaterow, leveltwocommanduse, "/addupgrade [player name / id] [upgrade id]", false, false)
                guiGridListSetItemText (leveltwolist, addupgradecreaterow, leveltwocommandexplanation, "Using this command will allow you to add any vehicle upgrade to specified player's car.", false, false)

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
                
                fixvehcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, fixvehcreaterow, leveltwocommand, "/fixveh", false, false)
                guiGridListSetItemText (leveltwolist, fixvehcreaterow, leveltwocommanduse, "/fixveh [playername / id]", false, false)
                guiGridListSetItemText (leveltwolist, fixvehcreaterow, leveltwocommandexplanation, "This command allows you to fix specified player's vehicle.", false, false)
                
                fixvehscreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, fixvehscreaterow, leveltwocommand, "/fixvehs", false, false)
                guiGridListSetItemText (leveltwolist, fixvehscreaterow, leveltwocommanduse, "/fixvehs", false, false)
                guiGridListSetItemText (leveltwolist, fixvehscreaterow, leveltwocommandexplanation, "Using this command allows you to fix all the vehicles in-game.", false, false)

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
                
                giveitemcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, giveitemcreaterow, leveltwocommand, "/giveitem", false, false)
                guiGridListSetItemText (leveltwolist, giveitemcreaterow, leveltwocommanduse, "/giveitem [playername / id] [item id] [item value (ammo for weapons, 0 for everything else)]", false, false)
                guiGridListSetItemText (leveltwolist, giveitemcreaterow, leveltwocommandexplanation, "Gives specified player the desired item. Be sure to watch the item's max weight. ID's can currently be found on the forum.", false, false)    
                
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
                
                getaacreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, getaacreaterow, leveltwocommand, "/nearbyaaguns", false, false)
                guiGridListSetItemText (leveltwolist, getaacreaterow, leveltwocommanduse, "/nearbyaaguns", false, false)
                guiGridListSetItemText (leveltwolist, getaacreaterow, leveltwocommandexplanation, "Gets the ID of the anti-aircraft gun that is nearest to you.", false, false)    
                
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
                
                setpsychecreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, setpsychecreaterow, leveltwocommand, "/setpsyche", false, false)
                guiGridListSetItemText (leveltwolist, setpsychecreaterow, leveltwocommanduse, "/setpsyche [playername / id] [ammount]", false, false)
                guiGridListSetItemText (leveltwolist, setpsychecreaterow, leveltwocommandexplanation, "This command adds/removes psyche to/from the specified player.", false, false)
    
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
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommand, "/uptime", false, false)
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommanduse, "/uptime", false, false)
                guiGridListSetItemText (leveltwolist, uptimecreaterow, leveltwocommandexplanation, "Using this command, you can see how long the server has been online since the last restart.", false, false)                
                
                vehcreaterow = guiGridListAddRow (leveltwolist)
                guiGridListSetItemText (leveltwolist, vehcreaterow, leveltwocommand, "/veh", false, false)
                guiGridListSetItemText (leveltwolist, vehcreaterow, leveltwocommanduse, "/veh [vehicle id] [color 1] [color 2]", false, false)
                guiGridListSetItemText (leveltwolist, vehcreaterow, leveltwocommandexplanation, "Use this command to create a temporary vehicle in the server.", false, false)                
                
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


            --elseif (tabLeadAdmin) then
                local levelthreelist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelThree)
                local levelthreecommand = guiGridListAddColumn (levelthreelist, "Command", 0.2)
                local levelthreecommanduse = guiGridListAddColumn (levelthreelist, "Syntax", 1.0)
                local levelthreecommandexplanation = guiGridListAddColumn (levelthreelist, "Explanation", 1.3)
                    
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
                
                hideadmincreaterow = guiGridListAddRow (levelfourlist)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfourcommand, "/hideadmin", false, false)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfourcommanduse, "/hideadmin", false, false)
                guiGridListSetItemText (levelfourlist, hideadmincreaterow, levelfourcommandexplanation, "This allows you to not be seen on the admin list.", false, false)
                    
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
                
                local levelfivelist = guiCreateGridList(0, 0, 1, 0.9, true, tabLevelFive)
                local levelfivecommand = guiGridListAddColumn (levelfivelist, "Command", 0.2)
                local levelfivecommanduse = guiGridListAddColumn (levelfourlist, "Syntax", 1.0)
                local levelfivecommandexplanation = guiGridListAddColumn (levelfivelist, "Explanation", 1.3)
                
                noentriesrow = guiGridListAddRow (levelfivelist)
                guiGridListSetItemText (levelfivelist, noentriesrow, levelfivecommand, "none", false, false)
                guiGridListSetItemText (levelfivelist, noentriesrow, levelfivecommanduse, "not available", false, false)
                guiGridListSetItemText (levelfivelist, noentriesrow, levelfivecommandexplanation, "currently no level 5 commands available", false, false)
                
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