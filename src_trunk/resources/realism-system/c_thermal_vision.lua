blackMales = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

local localPlayer = getLocalPlayer()

function doVision()
	-- vehicles
	for key, value in ipairs(getElementsByType("vehicle")) do
		if (isElementOnScreen(value)) and (getPedOccupiedVehicle(localPlayer)~=value) then
			local x, y, z = getElementPosition(value)
			
			
			local tx, ty = getScreenFromWorldPosition(x, y, z+1, 5000, false)
			
			if (tx) then
				dxDrawLine(tx, ty, tx+150, ty-150, tocolor(255, 255, 255, 200), 2, false)
				dxDrawLine(tx+150, ty-150, tx+300, ty-150,  tocolor(255, 255, 255, 200), 2, false)
				dxDrawText(getVehicleName(value), tx+150, ty-200, tx+300, tx-160, tocolor(255, 255, 255, 200), 1, "bankgothic", "center", "middle")
			end
		end
	end
	
	-- players
	for key, value in ipairs(getElementsByType("player")) do
		if (isElementOnScreen(value)) and (localPlayer~=value) then
			local x, y, z = getPedBonePosition(value, 6)
			local skin = getPedSkin(value)
			
			
			local text
			if (blackMales[skin]) then text = "Black Male"
			elseif (whiteMales[skin]) then text = "White Male"
			elseif (asianMales[skin]) then text = "Asian Male"
			elseif (blackFemales[skin]) then text = "Black Female"
			elseif (whiteFemales[skin]) then text = "White Female"
			elseif (asianFemales[skin]) then text = "Asian Female"
			else text = "White Male"
			end
			
			local tx, ty = getScreenFromWorldPosition(x, y, z+0.2, 5000, false)
			
			if (tx) then
				dxDrawLine(tx, ty, tx+150, ty-150, tocolor(255, 255, 255, 200), 2, false)
				dxDrawLine(tx+150, ty-150, tx+300, ty-150,  tocolor(255, 255, 255, 200), 2, false)
				dxDrawText(text, tx+150, ty-200, tx+300, tx-160, tocolor(255, 255, 255, 200), 1, "bankgothic", "center", "middle")
			end
		end
	end
end

function applyVision(thePlayer, seat)
	if (seat==1 and thePlayer==localPlayer and getVehicleModel(source)==497) then
		addEventHandler("onClientRender", getRootElement(), doVision)
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), applyVision)

function removeVision(thePlayer, seat)
	if (seat==1 and thePlayer==localPlayer and getVehicleModel(source)==497) then
		removeEventHandler("onClientRender", getRootElement(), doVision)
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), removeVision)