beautifulPeople = { [90]=true, [92]=true, [93]=true, [97]=true, [138]=true, [139]=true, [140]=true, [146]=true, [152]=true }
cop = { [280]=true, [281]=true, [282]=true, [283]=true, [84]=true, [286]=true, [288]=true, [287]=true }
swat = { [285]=true }
flashCar = { [601]=true, [541]=true, [415]=true, [480]=true, [411]=true, [506]=true, [451]=true, [477]=true, [409]=true, [580]=true, [575]=true, [603]=true }
emergencyVehicles = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [598]=true, [596]=true, [597]=true, [599]=true, [601]=true }

local pictureValue = 0
local collectionValue = 0

-- Ped at submission desk just for the aesthetics.
local victoria = createPed(141, 359.7131652832, 173.87419128418, 1008.3893432617)
setPedRotation(victoria, 270)
setElementDimension(victoria, 787)
setElementInterior(victoria, 3)
setPedAnimation ( victoria, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false )

setElementData(getLocalPlayer(),"job",5)

-- Setup the markers.
function photoResStart(res)
	if (res==getThisResource())then
		if(getElementData(getLocalPlayer(),"job", 5))then
			photoSubmitEntranceMarker = createMarker( 2462.765625, 2245.14257812, 9.8203125, "cylinder", 2, 0,100, 255, 170 )
			photoSubmitDeskMarker = createMarker( 360, 177, 1008, "cylinder", 2, 0, 100, 255, 170 )
			photoSubmitEntranceBlip = createBlip( 2462.765625, 2245.14257812, 9.8203125, 0, 2, 0, 100, 255, 255 )
			photoSubmitDeskColSphere = createColSphere( 360, 177, 1008, 2 )
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), photoResStart)

function snapPicture(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	if weapon == 43 then
		pictureValue = 0
		local onScreenPlayers = {}
		local players = getElementsByType ( "player" )
		for theKey, thePlayer in ipairs(players) do 
			if (isElementOnScreen(thePlayer)) then
				table.insert(onScreenPlayers, thePlayer) -- Identify everyone who is on the screen as the picture is taken.
			end
		end
		for theKey,thePlayer in ipairs(onScreenPlayers) do
			local Tx,Ty,Tz = getElementPosition(thePlayer)
			local Px,Py,Pz = getElementPosition(getLocalPlayer())
			local isclear = isLineOfSightClear (Px, Py, Pz +1, Tx, Ty, Tz, true, true, false, true, true, false)
			if (isclear) then
				-------------------
				-- Player Checks --
				-------------------
				local skin = getElementModel(thePlayer)
				if(beautifulPeople[skin]) then -- beautiful people (beach skins)
					pictureValue=pictureValue+50
				end
				if((getPedWeapon(thePlayer)~=0)and(getPedTotalAmmo(thePLayer)~=0) then -- Armed player.
					pictureValue=pictureValue+25
					if cop[skin]) and -- armed Cop
						pictureValue=pictureValue+5
					end
				end
				if(swat[skin])then -- SWAT officer
					pictureValue=pictureValue+50
				end
				if(getPedControlState(thePlayer, "fire"))then -- Player is attacking.
					pictureValue=pictureValue+50
				end
				if(isPedChoking(thePlayer))then -- Are they choking?
					pictureValue=pictureValue+50
				end
				if(isPedDoingGangDriveby(thePlayer))then -- if drivebying
					pictureValue=pictureValue+100
				end
				if(isPedHeadless(thePlayer))then -- if headless
					pictureValue=pictureValue+200
				end
				if(isPedOnFire(thePlayer))then -- if on fire
					pictureValue=pictureValue+250
				end
				if(isPlayerDead(thePlayer))then -- if dead
					pictureValue=pictureValue+150
				end
				if (#onScreenPlayers>3)then
					pictureValue=pictureValue+10
				end
				--------------------
				-- Vehicle checks --
				--------------------
				local vehicle = getPedOccupiedCar(thePlayer)
				if(vehicle)then -- Are they in a vehicle?
					if(flashCar[vehicle])then -- Sports cars.
						pictureValue=pictureValue+200
					end
					if(emergencyVehicle[vehicle])and(getVehicleSirensOn(vehicle)) then -- Emergency vehicle with sirens on.
						pictureValue=pictureValue+100
					end
					if not (isVehicleOnGround(vehicle))then -- Vehicle in the air / stunts.
						pictureValue=pictureValue+200
					end
				end
			end
		end
		if(pictureValue==0)then
			outputChatBox("No one is going to pay for that picture...", 255, 0, 0)
		else
			collectionValue = collectionValue + pictureValue
			outputChatBox("#FF9933That's a keeper! Picture value: $"..pictureValue, 255, 104, 91, true)
		end
		outputChatBox("#FF9933Collection value: $"..collectionValue, 255, 104, 91, true)
	end		
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), snapPicture)

-- /totalvalue to see how much your collection of pictures is worth.
function showValue()
	outputChatBox("#FF9933Collection value: $"..collectionValue, 255, 104, 91, true)
end
addCommandHandler("totalvalue", showValue, false, false)

-- /submitpics to sell your collection of pictures to the news company.
function sellPhotos()
	if (isElementWithinColShape(getLocalPlayer(), photoSubmitDeskColSphere))then
		if(collectionValue==0)then
			outputChatBox("#FF9933You need to take some photographs before you can sell them.", 255, 255, 255, true)
		else
			triggerServerEvent("submitCollection", getLocalPlayer(), collectionValue)
		end
	else
		outputChatBox("#FF9933You can sell your photographs at the #3399FFSan Andreas Network News building #FF9933((/sellpics)).", 255, 255, 255, true)
	end
end
addCommandHandler("sellpics", sellPhotos, false, false)