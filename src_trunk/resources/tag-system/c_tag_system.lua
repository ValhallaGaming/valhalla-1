cooldown = 0
count = 0
MAX_TAGCOUNT = 2
MAX_TAG_RADIUS = 100

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
						local oldX, oldY, oldZ = getElementPosition(getLocalPlayer())
						local rot = getPedRotation(getLocalPlayer())

						local matrix = getElementMatrix (getLocalPlayer())
						local newX = oldX * matrix[1][1] + oldY * matrix [1][2] + oldZ * matrix [1][3] + matrix [1][4]
						local newY = oldX * matrix[2][1] + oldY * matrix [2][2] + oldZ * matrix [2][3] + matrix [2][4]
						local newZ = oldX * matrix[3][1] + oldY * matrix [3][2] + oldZ * matrix [3][3] + matrix [3][4]
							
						local facingWall, cx, cy, cz, element = processLineOfSight(oldX, oldY, oldZ, newX, newY, newZ, true, false, false, true, false)

						if not (facingWall) then
							outputChatBox("You are not near a wall.", 255, 0, 0)
							count = 0
							cooldown = 1
							setTimer(resetCooldown, 5000, 1)
						else
							local colshape = createColSphere(cx, cy, cz, MAX_TAG_RADIUS)
							local tags = getElementsWithinColShape(colshape, "object")
							local tagcount = 0

							for key, value in ipairs(tags) do
								local objtype = getElementData(value, "type")

								if (tostring(objtype)=="tag") then
									tagcount = tagcount + 1
								end
							end

                            if tag == 9 then tagcount = 0 end --ignore tagcount if the tag type is 9 (city maintenance)
                            
							if (tagcount<MAX_TAGCOUNT) then
								
								count = count + 1
								
								if (count==20) then
									count = 0
									cooldown = 1
									setTimer(resetCooldown, 30000, 1)
									local interior = getElementInterior(getLocalPlayer())
									local dimension = getElementDimension(getLocalPlayer())
									
									--cx = cx - math.sin(math.rad(rot)) * 0.1
									--cy = cy - math.cos(math.rad(rot)) * 0.1
									
									triggerServerEvent("createTag", getLocalPlayer(), cx, cy, cz, rot, interior, dimension) 
								end
							else
								count = 0
								cooldown = 1
								setTimer(resetCooldown, 30000, 1)
								outputChatBox("This area has too many tags already.", source, 255, 194, 14)
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