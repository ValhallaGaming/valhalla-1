beautifulPeople = { [90]=true, [92]=true, [93]=true, [97]=true, [138]=true, [139]=true, [140]=true, [146]=true, [152]=true }
cop = { [280]=true, [281]=true, [282]=true, [283]=true, [84]=true, [286]=true, [288]=true, [287]=true }
swat = { [285]=true }
flashCar = { [601]=true, [541]=true, [415]=true, [480]=true, [411]=true, [506]=true, [451]=true, [477]=true, [409]=true, [580]=true, [575]=true, [603]=true }
emergencyVehicles = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [598]=true, [596]=true, [597]=true, [599]=true, [601]=true }

local pictureValue = 0
local collectionValue = 0
local localPlayer = getLocalPlayer()

-- Ped at submission desk just for the aesthetics.
local victoria = createPed(141, 359.7, 173.57419128418, 1008.3893432617)
setPedRotation(victoria, 270)
setElementDimension(victoria, 1289)
setElementInterior(victoria, 3)
setPedAnimation ( victoria, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false )

function snapPicture(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	local logged = getElementData(localPlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(localPlayer)
		
		if (theTeam) then
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==6) then
				if (weapon == 43) then
					pictureValue = 0
					local onScreenPlayers = {}
					local players = getElementsByType( "player" )
					for theKey, thePlayer in ipairs(players) do			-- thePlayer ~= localPlayer
						if (isElementOnScreen(thePlayer) == true ) then
							table.insert(onScreenPlayers, thePlayer)	-- Identify everyone who is on the screen as the picture is taken.
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
							if(beautifulPeople[skin]) then
								pictureValue=pictureValue+50
							end
							if(getPedWeapon(thePlayer)~=0)and(getPedTotalAmmo(thePlayer)~=0) then
								pictureValue=pictureValue+25
								if (cop[skin])then
									pictureValue=pictureValue+5
								end
							end
							if(swat[skin])then
								pictureValue=pictureValue+50
							end
							if(getPedControlState(thePlayer, "fire"))then
								pictureValue=pictureValue+50
							end
							if(isPedChoking(thePlayer))then
								pictureValue=pictureValue+50
							end
							if(isPedDoingGangDriveby(thePlayer))then
								pictureValue=pictureValue+100
							end
							if(isPedHeadless(thePlayer))then
								pictureValue=pictureValue+200
							end
							if(isPedOnFire(thePlayer))then
								pictureValue=pictureValue+250
							end
							if(isPlayerDead(thePlayer))then
								pictureValue=pictureValue+150
							end
							if (#onScreenPlayers>3)then
								pictureValue=pictureValue+10
							end
							--------------------
							-- Vehicle checks --
							--------------------
							local vehicle = getPedOccupiedVehicle(thePlayer)
							if(vehicle)then
								if(flashCar[vehicle])then
									pictureValue=pictureValue+200
								end
								if(emergencyVehicle[vehicle])and(getVehicleSirensOn(vehicle)) then
									pictureValue=pictureValue+100
								end
								if not (isVehicleOnGround(vehicle))then
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
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), snapPicture)

-- /totalvalue to see how much your collection of pictures is worth.
function showValue()
	outputChatBox("#FF9933Collection value: $"..collectionValue, 255, 104, 91, true)
end
addCommandHandler("totalvalue", showValue, false, false)

-- /sellpics to sell your collection of pictures to the news company.
function sellPhotos()
	local theTeam = getPlayerTeam(localPlayer)
	local factionType = getElementData(theTeam, "type")
			
	if (factionType==6) then
		if not(photoSubmitDeskMarker)then
			photoSubmitDeskMarker = createMarker( 362, 173, 1007, "cylinder", 1, 0, 100, 255, 170 )
			photoSubmitDeskColSphere = createColSphere( 362, 173, 1007, 2 )
			setElementInterior(photoSubmitDeskMarker,3)
			setElementInterior(photoSubmitDeskColSphere,3)			
			setElementDimension(photoSubmitDeskMarker, 1289)
			setElementDimension(photoSubmitDeskColSphere, 1289)
			
			outputChatBox("#FF9933You can sell your photographs at the #3399FFSan Andreas Network Tower #FF9933((/sellpics at the front desk)).", 255, 255, 255, true)
		else
			if (isElementWithinColShape(localPlayer, photoSubmitDeskColSphere))then
				if(collectionValue==0)then
					outputChatBox("None of the pictures you have are worth anything.", 255, 0, 0, true)
				else
					triggerServerEvent("submitCollection", localPlayer, collectionValue)
					collectionValue = 0
				end
			else
				outputChatBox("#FF9933You can sell your photographs at the #3399FFSan Andreas Network Tower #FF9933((/sellpics at the front desk)).", 255, 255, 255, true)
			end
		end
	end
end
addCommandHandler("sellpics", sellPhotos, false, false)