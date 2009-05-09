--- create a colSphere to set co-ordinates of duty for medics
--- create a colSphere to set co-ordinates of duty for LVFD
--- Create marker shizzle

function lvesduty (thePlayer, commandName)
    local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	    if (isElementWithinColShape(thePlayer, --colshape)) then
		    local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
			    if (duty==0) then
				    outputChatBox("You are now on duty as a medic.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their uniform from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 276)
					
					setElementData(thePlayer, "duty", 2)
				elseif (duty==2) then
				    takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")			
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", lvesduty, false, false)

function fireduty (thePlayer, commandName)
    local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	    if (isElementWithinColShape(thePlayer, --colshape)) then
		    local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
			    if (duty==0) then
				    outputChatBox("You are now on duty as a fire officer.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their uniform from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 42, 5000) -- Fire Extinguisher
					giveWeapon(thePlayer, 9, 1) -- Chainsaw
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 279)
					
					setElementData(thePlayer, "duty", 2)
				elseif (duty==2) then
				    takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")			
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", fireduty, false, false)

function lvesheal (thePlayer, commandName, targetPartialNick, price)
    if not (targetPartialNick) then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Price of Heal]", thePlayer, 255, 194, 14)
	else
	    local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
		if not (targetPlayer) then -- is the player online?
			outputChatBox("Player not found.", thePlayer, 255, 0, 0)
	    else
		    local logged = getElementData(thePlayer, "loggedin")
	
	        if (logged==1) then
	            local theTeam = getPlayerTeam(thePlayer)
		        local factionType = getElementData(theTeam, "type")
				
				if not (factionType==2) then
				    outputChatBox("You have no basic medic skills, contact the ES", thePlayer, 255, 0, 0)
				else
				    if (price) then
			            price = tonumber(price)
		            end
				
				    local targetPlayerName = getPlayerName(targetPlayer)
		            local x, y, z = getElementPosition(thePlayer)
		            local tx, ty, tz = getElementPosition(targetPlayer)
		        
		            if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
				        outputChatBox("You are too far away to be healed "..targetPlayerName..".", thePlayer, 255, 0, 0)
	                else
				        local money = getPlayerMoney(targetPlayer)
							
					    if (price>money) then
						    outputChatBox("The player cannot afford the heal.", thePlayer, 255, 0, 0)
				        else
					    
					        local amount = money - price
						    setPlayerMoney(targetPlayer, amount)
					        setElementHealth(targetPlayer, 100)
					        outputChatBox("You have been healed by " ..thePlayer.. ".", targetPlayer, 255, 0, 0)
					    end
					end
				end
			end
		end
	end
end
addCommandHandler("/heal", lvesheal, false, false)
	    