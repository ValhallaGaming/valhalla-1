cooldown = 0
count = 0

function clientTagWall(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon==41) then
		local team = getPlayerTeam(getLocalPlayer())
		local ftype = getElementData(team, "type")
        local tag = getElementData(source, "tag")

		if (ftype~=2) then
			if not (hitElement) or (getElementType(hitElement)~="player") then -- Didn't attack someone
				
				if (cooldown==0) then
					if (ammoInClip>10) and (weapon==41) then
						-- Check the player is near a wall
						local localPlayer = getLocalPlayer()
						local x, y, z = getElementPosition(localPlayer)
						local rot = getPedRotation(localPlayer)

						local matrix = getElementMatrix (localPlayer)
						local oldX = 0
						local oldY = 1
						local oldZ = 0
						local newX = oldX * matrix[1][1] + oldY * matrix [2][1] + oldZ * matrix [3][1] + matrix [4][1]
						local newY = oldX * matrix[1][2] + oldY * matrix [2][2] + oldZ * matrix [3][2] + matrix [4][2]
						local newZ = oldX * matrix[1][3] + oldY * matrix [2][3] + oldZ * matrix [3][3] + matrix [4][3]
						
						local facingWall, cx, cy, cz, element = processLineOfSight(x, y, z, newX, newY, newZ, true, false, false, true, false)
						
						if not (facingWall) then
							outputChatBox("You are not near a wall.", 255, 0, 0)
							count = 0
							cooldown = 1
							setTimer(resetCooldown, 5000, 1)
						else
							count = count + 1
							
							if (count==20) then
								count = 0
								cooldown = 1
								setTimer(resetCooldown, 30000, 1)
								local interior = getElementInterior(localPlayer)
								local dimension = getElementDimension(localPlayer)
								
								--cx = cx - math.sin(math.rad(rot)) * 0.1
								cy = cy - math.cos(math.rad(rot)) * 0.1
								
								triggerServerEvent("createTag", localPlayer, cx, cy, cz, rot, interior, dimension) 
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), clientTagWall)

function resetCooldown()
	cooldown = 0
end

function setTag(commandName, newTag)
	if not (newTag) then
		outputChatBox("SYNTAX: " .. commandName .. " [Tag # 1->8].", 255, 194, 14)
	else
        local newTag = tonumber(newTag)
		if (newTag>0) and (newTag<9) then
			setElementData(getLocalPlayer(), "tag", true, newTag)
			outputChatBox("Tag changed to #" .. newTag .. ".", 0, 255, 0)
		else
			outputChatBox("Invalid value, please enter a value between 1 and 8.", 255, 0, 0)
		end
	end
end
addCommandHandler("settag", setTag)