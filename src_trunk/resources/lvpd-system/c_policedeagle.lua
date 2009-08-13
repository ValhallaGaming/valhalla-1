cooldown = 0
cooldownTimer = nil
localPlayer = getLocalPlayer()

function isLSPD()
	return getTeamName(getPlayerTeam(getLocalPlayer())) == "Los Santos Police Department"
end

function switchMode()
	if (getPedWeapon(localPlayer)==24) and (getPedTotalAmmo(localPlayer)>0) then -- has an un-empty deagle
		local mode = getElementData(localPlayer, "deaglemode")
		if mode == 0 then -- tazer mode
			setElementData(localPlayer, "deaglemode", 1)
			triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "switched their multipurpose handgun to Lethal mode.")
		elseif mode == 1 and isLSPD() then -- lethal mode
			setElementData(localPlayer, "deaglemode", 2)
			triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "switched their multipurpose handgun to Radar Gun mode.")
		elseif mode == 2 or mode == 1 then -- radar gun mode
			setElementData(localPlayer, "deaglemode", 0)
			triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "switched their multipurpose handgun to Tazer mode.")
		end
	end
end

function bindKeys(res)
	bindKey("n", "down", switchMode)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function enableCooldown()
	cooldown = 1
	cooldownTimer = setTimer(disableCooldown, 3000, 1)
	toggleControl("fire", false)
end

function disableCooldown()
	cooldown = 0
	toggleControl("fire", true)

	if (cooldownTimer~=nil) then
		killTimer(cooldownTimer)
		cooldownTimer = nil
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), disableCooldown)

function weaponFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon==24) then -- deagle
		local mode = getElementData(localPlayer, "deaglemode")
		if (mode==0) then -- tazer mode
			enableCooldown()
			local px, py, pz = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D(hitX, hitY, hitZ, px, py, pz)
			
			if (distance<35) then
				fxAddSparks(hitX, hitY, hitZ, 1, 1, 1, 1, 10, 0, 0, 0, true, 3, 1)
			end
			playSoundFrontEnd(38)
			triggerServerEvent("tazerFired", localPlayer, hitX, hitY, hitZ, hitElement) 
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, weaponFire)

function weaponAim(target)
	if (target) then
		if (getElementType(target)=="vehicle") then
			if (getPedWeapon(localPlayer)==24) then
				local mode = getElementData(localPlayer, "deaglemode")
				
				if (mode==2) then
					local speedx, speedy, speedz = getElementVelocity(target)
					actualspeed = math.ceil(((speedx^2 + speedy^2 + speedz^2)^(0.5)*100))
					outputChatBox(getVehicleName(target) .. " clocked in at " .. actualspeed .. " MPH.", 255, 194, 14)
				end
			end
		end
	end
end
addEventHandler("onClientPlayerTarget", getRootElement(), weaponAim)

-- code for the target/tazed person
function cancelTazerDamage(attacker, weapon, bodypart, loss)
	if (weapon==24) then -- deagle
		local mode = getElementData(attacker, "deaglemode")
		if (mode==0 or mode==2) then -- tazer mode / radar gun mode
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, cancelTazerDamage)

function showTazerEffect(x, y, z)
	fxAddSparks(x, y, z, 1, 1, 1, 1, 100, 0, 0, 0, true, 3, 2)
	playSoundFrontEnd(38)
end
addEvent("showTazerEffect", true )
addEventHandler("showTazerEffect", getRootElement(), showTazerEffect)

local underfire = false
local fireelement = nil
local localPlayer = getLocalPlayer()
local originalRot = 0
local shotsfired = 0

function onTargetPDPed(element)
	if (isElement(element)) then
		if (getElementType(element)=="ped") and (getElementModel(element)==282) and not (underfire) and (getControlState("aim_weapon")) then
			underfire = true
			fireelement = element
			originalRot = getPedRotation(element)
			addEventHandler("onClientRender", getRootElement(), makeCopFireOnPlayer)
			addEventHandler("onClientPlayerWasted", getLocalPlayer(), onDeath)
		end
	end
end
addEventHandler("onClientPlayerTarget", getLocalPlayer(), onTargetPDPed)

function makeCopFireOnPlayer()
	if (underfire) and (fireelement) then
		local rot = getPedRotation(localPlayer)
		local x, y, z = getPedBonePosition(localPlayer, 7)
		
		setPedRotation(fireelement, rot - 180)
		
		setPedControlState(fireelement, "aim_weapon", true)
		setPedAimTarget(fireelement, x, y, z)
		setPedControlState(fireelement, "fire", true)
		shotsfired = shotsfired + 1
		
		if (shotsfired>40) then
			triggerServerEvent("killmebyped", getLocalPlayer(), fireelement)
		end
	end
end

function onDeath()
	if (fireelement) and (underfire) then
		setPedControlState(fireelement, "aim_weapon", false)
		setPedControlState(fireelement, "fire", false)
		setPedRotation(fireelement, originalRot)
		
		fireelement = nil
		underfire = false
		removeEventHandler("onClientRender", getRootElement(), makeCopFireOnPlayer)
		removeEventHandler("onClientPlayerWasted", getLocalPlayer(), onDeath)
	end
end