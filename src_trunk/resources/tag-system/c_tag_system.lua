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
						local x, y, z = getElementPosition(getLocalPlayer())

						local rot = getPedRotation(getLocalPlayer())
						local px = x + math.sin(math.rad(rot)) * 3
						local py = y + math.cos(math.rad(rot)) * 3
							
						local facingWall, cx, cy, cz, element = processLineOfSight(x, y, z, px, py, z, true, false, false, true, false)

						if not (facingWall) then
							outputChatBox("You are not near a wall.", 255, 0, 0)
							count = 0
							cooldown = 1
							setTimer(resetCooldown, 5000, 1)
						else
							local colshape = createColSphere(x, y, z, MAX_TAG_RADIUS)
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
									
									cx = cx - math.sin(math.rad(rot)) * 0.1
									cy = cy - math.cos(math.rad(rot)) * 0.1
									
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
addEventHandler("onClientPedWeaponFire", getLocalPlayer(), clientTagWall)

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