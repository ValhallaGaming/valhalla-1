wGeneralShop, iClothesPreview  = nil

items = nil

tGShopItemTypeTab = {}
gGShopItemTypeGrid = {}
gcGShopItemTypeColumnName = {}
gcGShopItemTypeColumnDesc = {}
gcGShopItemTypeColumnPrice = {}

grGShopItemTypeRow = {{ },{}}

--- clothe shop skins
blackMales = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

-- these are all the skins
skins = { 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }

function resourceStart(res)
	guiSetInputEnabled(false)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), resourceStart)


function showGeneralshopUI(shop_type, race)
	if not (wGeneralShop) then
		local screenwidth, screenheight = guiGetScreenSize ()
		
		local Width = 500
		local Height = 350
		local X = (screenwidth - Width)/2
		local Y = (screenheight - Height)/2
		
		local shopTypeName = getShopTypeName(shop_type)
		local ShopTabTitles = getShopTabTitles(shop_type)
		local imageName = getImageName(shop_type)
		local introMessage = getIntroMessage(shop_type)
		
		wGeneralshop = guiCreateWindow ( X , Y , Width , Height ,  shopTypeName, false )

		lInstruction = guiCreateLabel ( 0, 20, 500, 15, "Double click on an item to buy it.", false, wGeneralshop )
		guiLabelSetHorizontalAlign ( lInstruction,"center" )
		
		lIntro = guiCreateLabel ( 0, 40, 500, 15,introMessage, false, wGeneralshop )
		guiLabelSetHorizontalAlign ( lIntro,"center" )
		guiBringToFront (lIntro)
		guiSetFont ( lIntro, "default-bold-small" )
		
		iImage =  guiCreateStaticImage ( 400, 20, 90, 80,"images/"..imageName, false,wGeneralshop )

		
		tGShopItemType = guiCreateTabPanel ( 15, 60, 470, 240, false,wGeneralshop )
		
		items = getItemsForSale(shop_type, race)
		
		-- loop through each heading
		for i = 1, #ShopTabTitles do
			tGShopItemTypeTab[i] = guiCreateTab (ShopTabTitles[i], tGShopItemType)
			gGShopItemTypeGrid[i] =  guiCreateGridList ( 0.02, 0.05, 0.96, 0.9, true, tGShopItemTypeTab[i])
			gcGShopItemTypeColumnName[i] = guiGridListAddColumn (gGShopItemTypeGrid[i],"Name", 0.25)
			gcGShopItemTypeColumnPrice[i] = guiGridListAddColumn (gGShopItemTypeGrid[i] ,"Price", 0.1)
			gcGShopItemTypeColumnDesc[i] = guiGridListAddColumn (gGShopItemTypeGrid[i] ,"Description", 0.62)
					
			for y = 1, #items do

				if(items[y][6] == i) then
					grGShopItemTypeRow[i][y] = guiGridListAddRow (gGShopItemTypeGrid[i]  )
					guiGridListSetItemText ( gGShopItemTypeGrid[i]  , grGShopItemTypeRow[i][y] , gcGShopItemTypeColumnName[i] ,items[y][1], false, false )
					guiGridListSetItemText ( gGShopItemTypeGrid[i] , grGShopItemTypeRow[i][y] ,gcGShopItemTypeColumnPrice[i], "$"..items[y][3], false, false )
					guiGridListSetItemText ( gGShopItemTypeGrid[i] , grGShopItemTypeRow[i][y], gcGShopItemTypeColumnDesc[i] ,items[y][2], false, false)
				end
			end
		end
		
		guiSetInputEnabled(true)
		guiSetVisible(wGeneralshop, true)
		
		bClose = guiCreateButton(200, 315, 100, 25, "Close", false, wGeneralshop)
		addEventHandler("onClientGUIClick", bClose, hideGeneralshopUI)
		
		addEventHandler("onClientGUIDoubleClick", getRootElement(), getShopSelectedItem)
			
		-- if player has clicked to see a skin preview
		addEventHandler ( "onClientGUIClick", getRootElement(), function (button, state)
			if(button == "left") then
				
				if(iClothesPreview) then
					destroyElement(iClothesPreview )
				end
				
				if(shop_type == 5) then
					if(source == gGShopItemTypeGrid[1]) then
						if(guiGetVisible(wGeneralshop)) then
							
							-- get the selected row
							local row, column = nil
					
							local row_temp, column_temp = guiGridListGetSelectedItem ( source )
					
							if((row == nil) and (row_temp)) then
								row = row_temp
								column = column_temp
													
								local skin = tonumber(skins[row+1] )
								
								if(skin<10) then
									skin = tostring("00"..skin)
								elseif(skin < 100) then
									skin = tostring("0"..skin)
								else
									skin = tostring(skin)
								end
								
								local accountRes = getResourceFromName("account-system")
								iClothesPreview = guiCreateStaticImage ( 320, 20, 100, 100, "img/" .. skin..".png" , false , gGShopItemTypeGrid[1], accountRes)
							end		
						end
					end
				end
			end
		end)
	end
end

addEvent("showGeneralshopUI", true )
addEventHandler("showGeneralshopUI", getRootElement(), showGeneralshopUI)

function hideGeneralshopUI()
	if (source==bClose) then
		guiSetInputEnabled(false)
		guiSetVisible(wGeneralshop, false)
		destroyElement(wGeneralshop)
		removeEventHandler ("onClientGUIDoubleClick",  getRootElement(), getShopSelectedItem )
	end
end



-- function gets the shop name,
function  getShopTypeName(shop_type)

	if(shop_type == 1) then
		return "General Store"
	elseif(shop_type == 2) then
		return "Gun and Ammo Store"
	elseif(shop_type == 3) then
		return "Food store"
	elseif(shop_type == 4) then
		return "Sex Shop"
	elseif(shop_type == 5) then
		return "Clothes Shop"
	elseif(shop_type == 6) then
		return "Gym"
	else
		return "This isn't a shop. Go Away."
	end
end


function getShopTabTitles(shop_type)
	
	if(shop_type == 1) then
		return {"General Items", "Consumable"}
	elseif(shop_type == 2) then
		return {"Guns"}
	elseif(shop_type == 3) then
		return {"Food","Drink"}
	elseif(shop_type == 4) then
		return {"Sexy"}
	elseif(shop_type == 5) then
		return {"Clothes"}
	elseif(shop_type == 6) then
		return {"Fighting Styles"}
	else
		return "This isn't a shop. Go Away."
	end


end


function getItemsForSale(shop_type, race)

	local item = {}
	-- { Name, Description, Price, item_id, value, heading, isWeapon }

	-- general store
	if(shop_type == 1) then
		
		-- General Items
		item[1] = {"Camera", "A small black analogue camera.", "75", 43, 25,1,true, 30}
		item[2] = {"Flowers", "A bouquet of lovely flowers.", "5", 14, 1,1, true,2}
		item[3] = {"Phonebook", "A large phonebook of everyones phone numbers.", "30", 7, 1,1,false,20}
		item[4] = {"Cellphone", "A stylish, slim cell phone.", "75", 2, 1,1,false,50}
		item[5] = {"Radio", "A black radio.", "50", 6, 1,1,false,30}
		item[6] = {"Dice", "A black dice with white dots, perfect for gambling.", "2", 10, 1,1,false,1}
		item[7] = {"Golf Club", "Perfect golf club for hitting that hole-in-one.", "60", 2, 1,1,true,30}
		item[8] = {"Knife", "You're only going to use this in the kitchen, right?", "50", 4,  1,1,true,40}
		item[9] = {"Baseball Bat", "Hit a home run with this.", "60", 5, 1,1,true,40}
		item[10] = {"Shovel", "Perfect tool to dig a hole.", "40", 6, 1,1,true,20}
		item[11] = {"Pool Cue", "For that game of pub pool.", "35", 7, 1,1,true,15}
		item[12] = {"Cane", "A stick has never been so classy.", "65", 15, 1,1,true,35}
		item[13] = {"Fire Extinguisher", "There is never one of these around when there is a fire", "50", 42, 500, 1,true,25}
		item[14] = {"Spray Can", "Hey, you better not tag with this punk!", "50", 41, 500, 1,true,35}
		item[17] = {"Watch", "Telling the time was never so sexy!", "25", 17, 1, 1,false,10}
		item[18] = {"City Guide", "A small city guide booklet.", "15", 18, 1,1,false,7}
		item[19] = {"MP3 Player", "A white, sleek looking MP3 Player. The brand reads EyePod.", "120", 19, 1,1,false,7}

		


		-- Consumable
		item[15] = {"Sandwich", "A yummy sandwich with cheese.", "8", 8, 1,2,false,4}
		item[16] = {"Softdrink", "A can of coca cola.", "7", 9, 1,2,false,3}
		
	-- gun shop
	elseif(shop_type == 2) then
	
		-- guns --
		item[1] = {"Brass Knuckles","A pair of brass knuckles, ouch.", "100", 1, 1, 1,true,50}
		item[2] = {"Katana", "You're favourite Japanese sword.", "200", 8, 1, 1,true,100}
		item[3] = {"9mm Pistol", "A silver, 9mm handgun, comes with 100 ammo.", "250",  22, 100, 1,true,200}
		item[4] = {"Sawn-Off", "A sawn off shotgun - comes with 30 ammo.", "450", 26, 30, 1,true,400}
		item[5] = {"Uzi", "A small micro-uzi - comes with 250 ammo.", "450", 28, 250, 1,true,190}
		item[6] = {"Tec-9", "A Tec-9 micro-uzi - comes with 250 ammo", "500", 32, 250, 1,true,300}
		item[7] = {"AK-47", "An AK-47 rifle - comes with 400 ammo", "750", 30, 450, 1,true,600}
	
	-- food + drink
	elseif(shop_type == 3) then
	
		item[1] = {"Sandwich", "A yummy sandwich with cheese", "5", 8, 1, 1, false,4}
		item[2] = {"Taco", "A greasy mexican taco", "7", 11, 1, 1, false,3}
		item[3] = {"Burger", "A double cheeseburger with bacon", "6", 12, 1, 1, false,2}
		item[4] = {"Donut", "Hot sticky sugar covered donut", "3", 13, 1, 1, false,1}
		item[5] = {"Cookie", "A luxuty chocolate chip cookie", "3", 14, 1, 1, false,1}
		item[6] = {"Haggis", "Freshly imported from Scotland", "5", 1, 1, 1, false,1}
		
		
		-- drinks
		item[7] = {"Softdrink", "A cold can of coca cola.", "2", 9, 1, 2, false,3}
		item[8] = {"Water", "A bottle of mineral water.", "1", 15, 1, 2, false,1}
	
	-- sex shop
	elseif(shop_type == 4) then
	
		-- sexy
		item[1] = {"Long Purple Dildo","A very large purple dildo", "20", 10, 1, 1, true,10}
		item[2] = {"Short Tan Dildo","A small tan dildo.", "15", 11, 1, 1, true,7}
		item[3] = {"Vibrator","A vibrator, what more needs to be said?", "25", 12, 1, 1, true,12}
		item[4] = {"Flowers","A bouquet of lovely flowers.", "5", 14, 1, 1, true,2}
	
	elseif(shop_type == 5) then
		if (race==0) then
			race=1
		end
		
		for i = 1, #skins do
			item[i] = {"Skin "..skins[i] , "MTA Skin id "..skins[i]..".", "50", 92, skins[i], 1}
		end
	
	-- gym
	elseif(shop_type == 6) then
	
		item[1] = {"Standard Combat","Standard everyday fighting.", "10", 4, -1, 1, true}
		item[2] = {"Boxing","Mike Tyson, on drugs.", "50", 5, -1, 1, true}
		item[3] = {"Kung Fu","I know kung-fu, so can you.", "50", 6, -1, 1, true}
		item[4] = {"Knee Head","Ever had a knee to the head? Pretty sore.", "50", 7, -1, 1, true}
		item[5] = {"Grab & Kick","Kick his 'ead in!", "50", 15, -1, 1, true}
		item[6] = {"Elbows","You may look retarded, but you will kick his ass!", "50", 16, -1, 1, true}
	end
		
	return item

end






function getImageName(shop_type)
	
	if(shop_type == 1) then
		return "general.png"
	elseif(shop_type == 2) then
		return "gun.png"
	elseif(shop_type == 3) then
		return "food.png"
	elseif(shop_type == 4) then
		return "sex.png"
	elseif(shop_type == 5) then
		return "clothes.png"
	elseif(shop_type == 1) then
		return "general.png"
	else
		return "This isn't a shop. Go Away."
	end


end

function getIntroMessage(shop_type)

	if(shop_type == 1) then
		return "This shops sells all kind of general purpose items."
	elseif(shop_type == 2) then
		return "This shop specialises in weapons and amunition."
	elseif(shop_type == 3) then
		return "Buy all your food and drink here."
	elseif(shop_type == 4) then
		return "All of the items you'll need for the perfect night in."
	elseif(shop_type == 5) then
		return "We've picked out some clothes that we think will suit you."
	elseif(shop_type == 6) then
		return "This gym is the best in town for hand-to-hand combat."
	else
		return "This isn't a shop. Go Away."
	end

end

function getShopSelectedItem(button, state)
	if(button == "left") then

		if(guiGetVisible(wGeneralshop)) then
				
			-- get the selected row
			local row, column = nil
				
			local row_temp, column_temp = guiGridListGetSelectedItem ( source )

			if((row == nil) and (row_temp)) then
				row = row_temp
				column = column_temp
				
				-- get the name of the item just brought
				local name = tostring(guiGridListGetItemText ( source, row_temp,1 ))
				-- find out which item it was in the list

				for i = 1, #items do
				
					if(items[i][1] == name) then
						local id = items[i][4]
						local value = items[i][5]
						local price = tonumber(items[i][3])
						local isWeapon = items[i][7]
						local name = items[i][1]
						local supplyCost = items[i][8]
						
						triggerServerEvent("ItemBought", getLocalPlayer(), id, value, price, isWeapon, name, supplyCost)
					end
				end
			end				
		end
	end
 end
