local myadminWindow = nil

function adminhelp (sourcePlayer, commandName)

    local sourcePlayer = getLocalPlayer()
    local adminLevel = getElementData(sourcePlayer, "adminlevel")
    if (adminLevel > 0) then
        if (myadminWindow == nil) then
            guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
            myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Index of admin commands v5", false)
            local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
            local lists = {}
			for level = 1, 6 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Command", 0.15)
				guiGridListAddColumn (lists[level], "Syntax", 0.35)
				guiGridListAddColumn (lists[level], "Explanation", 1.3)
			end
            local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button

			local commands =
			{
				-- level 1: Trial Admin
				{
					-- player/*
					{ "/check", "/check [player]", "retrieves specified player's information" },
					{ "/auncuff", "/auncuff [player]", "uncuffs the player" },
					{ "/mute", "/mute [player]", "mutes the player" },
					{ "/disarm", "/disarm [player]", "takes all weapon from the player" },
					{ "/freconnect", "/freconnect [player]", "reconnects the player" },
					{ "/giveitem", "/giveitem [player] [item id] [item value]", "gives the player the specified item, see /itemlist for ids" },
					{ "/sethp", "/sethp [player] [new hp]", "sets the health of the player" },
					{ "/setarmor", "/setarmor [player] [new armor]", "sets the armor of the player" },
					{ "/setskin", "/setskin [player] [skin id]", "sets the skin of a player" },
					{ "/changename", "/changename [player] [new character name]", "changes the character name" },
					{ "/slap", "/slap [player]", "drops the player from a height of 15" },
					{ "/hugeslap", "/hugeslap [player]", "drops the player from a height of 50" },
					{ "/recon", "/recon [player]", "spectate a player" },
					{ "/pkick", "/pkick [player] [reason]", "kicks the player from the server" },
					{ "/pban", "/pban [player] [hours] [reason]", "bans the player for the given time, specify 0 as hours for permanent ban" },
					{ "/unban", "/unban [full char name]", "unbans the player with the given character name" },
					{ "/unbanip", "/unbanip [ip]", "unbans the specified ip" },
					{ "/gotoplace", "/gotoplace [ls/sf/lv]", "teleports you to one of those 3 cities" },
					{ "/jail", "/jail [player] [minutes] [reason]", "jails the player, if minutes >= 999 it's permanent" },
					{ "/unjail", "/unjail [player]", "unjails the player" },
					{ "/jailed", "/jailed", "shows a list of players that are in adminjail, including time left and reason" },
					{ "/goto", "/goto [player]", "teleport to another player" },
					{ "/gethere", "/gethere [player]", "teleports the player to you" },
					{ "/freeze", "/freeze [player]", "freezes the player" },
					{ "/unfreeze", "/unfreeze [player]", "unfreezes the player" },
					{ "/mark", "/mark", "saves your current position" },
					{ "/gotomark", "/gotomark", "teleports to the position where you did /mark" },
					{ "/makedonator", "/makedonator [player] [level]", "changes the player's donator level" },
					{ "/adminduty", "/adminduty", "(un)marks you as admin on duty" },
					{ "/setmotd", "/setmotd [message]", "updates the message of the day" },
					{ "/warn", "/warn [player]", "issues a warning, player is banned when having 3 warnings" },
					{ "/showinv", "/showinv [player]", "views the inventory of the player" },
					{ "/togmytag", "/togmytag", "toggles your nametag on and off" },
					{ "/dropme", "/dropme", "drops you off at the current freecam position" },
					{ "/disappear", "/disappear", "toggles invisibility" },
					{ "/findalts", "/findalts [player]", "shows all characters the player has" },
					{ "/setlanguage", "/setlanguage [player] [language] [skill]", "adjusts the skill of a player's language, or learns it to him" },
					{ "/dellanguage", "/dellanguage [player] [language]", "deletes a language from the player's knowledge" },
					
					-- vehicle/*
					{ "/unflip", "/unflip", "unflips the car" },
					{ "/unlockcivcars", "/unlockcivcars", "unlocks all civilian vehicles" },
					{ "/veh", "/veh [model] [color 1] [color 2]", "spawns a temporary vehicle" },
					{ "/oldcar", "/oldcar", "retrieves the id of the last car you drove" },
					{ "/thiscar", "/thiscar", "retrieves the id of your current car" },
					{ "/gotocar", "/gotocar [id]", "teleports you to the car with that id" },
					{ "/getcar", "/getcar [id]", "teleports the car to you" },
					{ "/nearbyvehicles", "/nearbyvehicles", "shows all vehicles within a radius of 20" },
					{ "/respawnveh", "/respawnveh [id]", "respawns the vehicle with that id" },
					{ "/respawnall", "/respawnall", "respawns all vehicles" },
					{ "/respawnciv", "/respawnciv", "respawns all civilian (job) vehicles" },
					{ "/addupgrade", "/addupgrade [player] [upgrade id]", "upgrades a players car" },
					{ "/resetupgrades", "/resetupgrades [player]", "removes all upgrades on the player's car" },
					{ "/findveh", "/findveh [name]", "retrieves the model for that vehicle name" },
					{ "/fixveh", "/fixveh [player]", "repairs a player's vehicle" },
					{ "/fixvehs", "/fixvehs", "repairs all vehicles" },
					{ "/fixvehis", "/fixvehis [player]", "fixes the vehicles look, engine may remain broken" },
					{ "/blowveh", "/blowveh [player]", "blows up a players car" },
					{ "/setcarhp", "/setcarhp [player]", "sets the health of a car, full health is 1000." },
					{ "/fuelveh", "/fuelveh [player]", "refills a players vehicle" },
					{ "/fuelvehs", "/fuelvehs", "refills all vehicles" },
					{ "/setcolor", "/setcolor [player] [color 1] [color 2]", "changes the players vehicle colors" },
					{ "/delveh", "/delveh [id]", "removes the temporary vehicle with that id" },

					-- interior/*
					{ "/getpos", "/getpos", "outputs your current position, interior and dimension" },
					{ "/x", "/x [value]", "increases your x-coordinate by the given value" },
					{ "/y", "/z [value]", "increases your y-coordinate by the given value" },
					{ "/z", "/y [value]", "increases your z-coordinate by the given value" },
					{ "/set*", "/set[any combination of xyz] [coordinates]", "sets your coordinates - available combinations: x, y, z, xyz, xy, xz, yz" },
					
					{ "/restartgatekeepers", "/restartgatekeepers", "restarts the gatekeepers resource" }
				},
				-- level 2: Admin
				{
				},
				-- level 3: Super Admin
				{
				},
				-- level 4: Lead Admins
				{
					-- player/*
					{ "/reskick", "/reskick [amount]", "kicks the given amount of players from the server" },
					{ "/ck", "/ck [player]", "permanently kills the character; spawns a corpse at the location the player is at" },
					{ "/unck", "/unck [player]", "reverts a character kill" },
					{ "/bury", "/bury [player]", "buries the player; removes the ck corpse" },
					{ "/givegun", "/givegun [player] [weapon id] [ammo]", "gives the player the specified weapon" },
					{ "/setmoney", "/setmoney [player] [money]", "sets the players money to that value" },
					{ "/givemoney", "/givemoney [player] [money]", "gives the player money in addition to his current cash" },
					{ "/delveh", "/delveh [id]", "removes the vehicle with that id" },
					{ "/delthisveh", "/delthisveh", "removes the vehicle you currently occupy" },
					{ "/resetcharacter", "/resetcharacter [Firstname_Lastname]", "fully resets the character" }
				},
				-- level 5: Head Admins
				{
					-- player/*
					{ "/hideadmin", "/hideadmin", "toggles hidden/visible the admin status" },
					{ "/ho", "/ho [text]", "send global ooc as hidden admin" },
					{ "/hw", "/hw [player] [text]", "send a pm as hidden admin" },
					{ "/makeadmin", "/makeadmin [player] [rank]", "gives the player an admin rank" },
					
					-- resource/*
					{ "/startres", "/startres [resource name]", "starts the resource" },
					{ "/stopres", "/stopres [resource name]", "stops the resource" },
					{ "/restartres", "/restartres [resource name]", "restarts the resource" }
				},
				-- level 6: Owner
				{
				}
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
            addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
                if (button == "left") then
                    if (state == "up") then
                        guiSetVisible(myadminWindow, false)
                        showCursor (false)
                        guiSetInputEnabled(false)
                        myadminWindow = nil
                    end
                end
            end, false)

            guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
        else
            local visible = guiGetVisible (myadminWindow)
            if (visible == false) then
                guiSetVisible( myadminWindow, true)
                showCursor (true)
			else
				showCursor(false)
			end
        end
    end
end
addCommandHandler("ah", adminhelp)