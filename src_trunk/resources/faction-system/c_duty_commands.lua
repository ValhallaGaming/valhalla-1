wShowDuty = nil

tItemTypeTab = {}
gItemTypeGrid = {}
gcItemTypeColumnName = {}
gcItemTypeColumnDesc = {}
gcItemTypeColumnID = {}
gcItemTypeColumnValue = {}

grItemTypeRow = {{ },{},{},{},{},{},{}}

titles = {"Clothes","Weapons", "Ammo", "Keys", "Consumable", "Police", "Misc"}

-- function to create the delete crime window
function createDutyWindow(duty_type)

	showCursor(true)

	local screenwidth, screenheight = guiGetScreenSize ()
	local x, y, z = getElementPosition(getLocalPlayer())
	
	local Width = 450
	local Height = 350
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	local dutyName = getDutyTypeName(duty_type)
	
	wShowDuty = guiCreateWindow ( X , Y , Width , Height , "You are going on "..dutyName.." duty." , false )
		
	-- create the different tabs for the different item types
	tItemType = guiCreateTabPanel ( 0, 20,450, 260,false, wShowDuty  )
	
	
	-- loop through each heading
	for i = 1, 7 do
		tItemTypeTab[i] = guiCreateTab ( titles[i], tItemType )
		gItemTypeGrid[i] =  guiCreateGridList ( 0.02, 0.05, 0.96, 0.9, true, tItemTypeTab[i]  )
		gcItemTypeColumnID[i] = guiGridListAddColumn (gItemTypeGrid[i] ,"ID", 0.1)
		gcItemTypeColumnName[i] = guiGridListAddColumn (gItemTypeGrid[i] ,"Item Name", 0.3)
		gcItemTypeColumnValue[i] = guiGridListAddColumn (gItemTypeGrid[i] ,"Ammo", 0.1)
		gcItemTypeColumnDesc[i] = guiGridListAddColumn (gItemTypeGrid[i] ,"Description", 0.7)
		
		local itemsName, itemDescription, itemId, itemValue = getItemsForDuty(duty_type, i )

		
		for y, key in pairs(itemsName) do
			grItemTypeRow[i][y] = guiGridListAddRow (gItemTypeGrid[i] )
			guiGridListSetItemText ( gItemTypeGrid[i] , grItemTypeRow[i][y] , gcItemTypeColumnName[i] ,itemsName[y], false, false )
			guiGridListSetItemText ( gItemTypeGrid[i] , grItemTypeRow[i][y] ,gcItemTypeColumnDesc[i] ,itemDescription[y], false, false )
			guiGridListSetItemText ( gItemTypeGrid[i] , grItemTypeRow[i][y] , gcItemTypeColumnID[i] ,itemId[y], false, true )
			guiGridListSetItemText ( gItemTypeGrid[i] , grItemTypeRow[i][y] , gcItemTypeColumnValue[i]  ,itemValue[y], false, true)
		end

	end
	
	lInstruction = guiCreateLabel(0, 285, 450, 20, "Select an item by double clicking it to pick it up from the locker room.", false, wShowDuty)
	guiLabelSetHorizontalAlign ( lInstruction,"center" )
	
	bGoOnDuty = guiCreateButton(175, 310, 100, 25, "Go On Duty!", false, wShowDuty)
	
	addEventHandler( "onClientGUIClick", bGoOnDuty, function(button, state)
		if(button == "left" and state == "down") then
			if(source == bGoOnDuty) then
			
				triggerServerEvent("onGoOnDuty", getLocalPlayer(), duty_type)
			
				-- hide the window and cursor
				guiSetVisible(wShowDuty, false)
				showCursor(false)
				destroyElement(wShowDuty)
				removeEventHandler ("onClientGUIDoubleClick",  getRootElement(), getSelectedItem )
			
			end	
		end	
	end)
	
	addEventHandler("onClientGUIDoubleClick", getRootElement(), getSelectedItem)
end
 addEvent( "onShowDutyGUI", true)
 addEventHandler( "onShowDutyGUI", getLocalPlayer() ,   createDutyWindow)
 
 
 function getSelectedItem(button, state)
	if(button == "left" and state == "down") then
		if(guiGetVisible(wShowDuty)) then
				
			-- get the selected row
			local row, column = nil
				
			local row_temp, column_temp = guiGridListGetSelectedItem ( source )
				
			if((row == nil) and (row_temp)) then
				row = row_temp
				column = column_temp
					
				-- get the item id and value that has been clicked on
				local id = tonumber(guiGridListGetItemText ( source, row,1 ))
				local value = tonumber(guiGridListGetItemText ( source, row,3 ))
					
				if(id) then
					-- if the value wasn't specified, set it as 1
					if not (value) then
						value = 1
					end

						
					-- trigger the server to give the player an item
					triggerServerEvent("onGiveItemToPlayer", getLocalPlayer(), id, value)
						
				end
			end				
		end
	end
 end
 
 
 function getItemsForDuty(duty_type, heading )
 
	local names = {}
	local desc = {}
	local id = {}
	local value = {}
	
	if(duty_type == 1 or duty_type == 2 or duty_type == 3 or duty_type == 4 or duty_type == 5 or duty_type == 6 or duty_type == 7 or duty_type == 8) then -- PD DUTY
		if(heading == 1) then
			names={"Body Armour", "Cadet Uniform", "Officer Uniform", "Sergeant Uniform", "Lt Uniform", "Dark CoP Uniform", "Police Biker Uniform", "SWAT Uniform", "Light CoP Uniform", "SWAT Gas Mask"}
			desc = {"A set of body armour", "Cadets uniform to be used by cadets only.", "Officer uniform to be used by officers only.", "Sergeants uniform to be used by sergeants only.", "Lt Uniform to be used by Lieutenants only.", "Chief of Police uniform to be used by the CoP Only.","Police Biker Uniform to be used on PMU patrol", "SWAT uniform to be used on SWAT patrol.", "Chief of Police uniform to be used by the CoP Only.", "SWAT Gas Mask to protect from gas attacks."}
			id = {"119", "83", "84", "85", "86", "87", "88", "89", "90", "2"}
			value = {"", "", "", "", "", "", "", "", "",""}
		elseif(heading == 2) then
			names = {"Pepper Spray", "Tazer", "Nightstick", "9mm Pistol", "Desert Eagle", "Pump Action Shotgun", "MP5", "M4", "Sniper Rifle", "Tear Gas"}
			desc = {"Use to stun the suspect", "Passes high voltage shock to the suspect", "Your non-lethal melee weapon", "9mm Pistol for normal patrol.", "More powerfull patrol weapon", "Shotgun to be kept in cruisers.", "MP5 weapon.", "High power M4 weapon for marksmen and SWAT.", "Sniper Rifle for marksmen and SWAT.", "Tear Gas for SWAT."}
			id = {"4", "5", "14", "22", "24", "25", "29", "32", "34", "40"}
			value = {"1000", "", "", "30", "30", "20", "125", "200", "30", "5"}
		elseif(heading == 3) then
			names = {"9mm Pistol Ammo", "Desert Eagle Ammo", "Shotgun Ammo", "MP5 Ammo", "M4 Ammo", "Sniper Rifle Ammo"}
			desc = {"20 rounds of 9mm pistol ammo", "25 rounds of Desert Eagle Ammo", "15 rounds of shotgun ammo", "100 rounds of MP5 Ammo", "150 rounds of M4 ammo", "20 rounds of Sniper Rifle ammo."}
			id = {"99", "101", "102", "106", "109", "111"}
			value = {"","","","", "", ""}
		elseif(heading == 4) then
			names = {"Hand Cuff Keys"}
			desc = {"A set of hand cuff keys to release people"}
			id = {"98"}
			value = {""}
		elseif(heading == 5) then
			names = {"Donut", "Haggis"}
			desc = {"A hot sugar covered donut.", "Freshly imported from Scotland."}
			id = {"120", "132"}
			value = {"", ""}
		elseif(heading == 6) then
			names = {"Hand Cuffs", "Officer Badge", "Sgt. Badge", "Lt. Badge", "Cpt. Badge", "Chief Badge.", "Zip Cuffs", "Traffic Cone", "Traffic Barrier", "Traffic Barrier Small", "Riot Shield"}
			desc = {"A set of hand cuffs", "A LSPD Police Officer Badge", "A LSPD Police Sergeant badge", "A LSPD Police Lieutenant badge.", "A LSPD Police Captain badge.", "A LSPD Police Chief Badge", "A set of SWAT zip cuffs", "Traffic cone to block off the road", "A barrier to block off the road", "A small barrier to block part of the road", "A Riot Shield to be used in riots."}
			id = {"3", "69", "67", "70", "68", "66", "97", "116", "117", "118", "1"}
			value = {"", "", "", "", "", "", "", "", "", "", ""}
		elseif(heading == 7) then
			names = {"Radio", "Fire Extinguisher", "Camera",  "First Aid Kit", "Megaphone", "Infra Red", "Night Vision"}
			desc = {"A government radio to communicate to other law enforcement.", "To put out fires!", "For the SID to take pictures with", "Everyone needs a first aid kit in their cruiser", "To make you loud and clear!", "Infra red googles to see anything hot.", "Night vision goggles to see in the dark."}
			id = {"6", "44", "45", "54", "94", "51", "50"}
			value = {"", "200", "30", "", "", "", ""}
		end
	elseif(duty_type == 10 or duty_type == 11) then -- MEDIC DUTY
		if(heading == 1) then
			names = {"Doctors Uniform", "Paramedic Uniform 1", "Paramedic Uniform 2", "Paramedic Uniform 3"}
			desc = {"Uniform for a doctor", "One of the 3 Paramedic Uniforms available","One of the 3 Paramedic Uniforms available","One of the 3 Paramedic Uniforms available"}
			id = {"72", "73", "74", "75"}
			value = {"", "", "", ""}
		elseif(heading == 2) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 3) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 4) then	
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 5) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading ==6) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 7) then
			names = {"Government Radio, Camera, First Aid Kit, Notepad, Megaphone."}
			desc = {"A government radio to communicate to other law enforcement.", "To take pictures with", "Everyone needs a first aid kit, espeically a medic!", "To write notes on.", "To make you loud and clear!"}
			id = {"6", "45", "54", "57", "94"}
			value = {"","30", "", "",""}
		end	
	elseif(duty_type == 12) then
		if(heading == 1) then
			names = {"Firefighters Uniform 1", "Firefighters Uniform 2","Firefighters Uniform 3"}
			desc = {"One of the 3 Firefighter Uniforms available","One of the 3 Firefighter Uniforms available","One of the 3 Firefighter Uniforms available",}
			id = {"76", "77", "78"}
			value = {"", "", ""}
		elseif(heading == 2) then
			names = {"Shovel", "Chainsaw", "Fire Extinguisher"}
			desc = {"A large shovel.","A chainsaw for cutting through things.","For, well, putting out fires."}
			id = {"17", "20", "44"}
			value = {"","", "600"}
		elseif(heading == 3) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 4) then	
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 5) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading ==6) then
			names = {""}
			desc = {""}
			id = {""}
			value = {""}
		elseif(heading == 7) then
			names = {"Government Radio, Camera, First Aid Kit, Notepad, Megaphone."}
			desc = {"A government radio to communicate to other law enforcement.", "To take pictures with", "Everyone needs a first aid kit, espeically a medic!", "To write notes on.", "To make you loud and clear!"}
			id = {"6", "45", "54", "57", "94"}
			value = {"","30", "", "",""}
		end
	elseif(duty_type == 9) then
		if(heading == 1) then
			names={"Body Armour", "SWAT Gas Mask", "Army Uniform"}
			desc = {"A set of body armour",  "SWAT Gas Mask to protect from gas attacks.", "Standard Issue Army Uniform"}
			id = {"119", "2", "91"}
			value = {"", "", ""}
		elseif(heading == 2) then
			names = {"Pepper Spray", "Tazer", "Nightstick", "9mm Pistol", "Desert Eagle", "Pump Action Shotgun", "MP5", "M4", "Sniper Rifle", "Tear Gas", "Grenade", "C2 Charges", "C2 Detonator"}
			desc = {"Use to stun the suspect", "Passes high voltage shock to the suspect", "Your non-lethal melee weapon", "9mm Pistol for normal patrol.", "More powerfull patrol weapon", "Shotgun to be kept in cruisers.", "MP5 weapon.", "High power M4 weapon for marksmen and SWAT.", "Sniper Rifle for marksmen and SWAT.", "Tear Gas for SWAT.", "10 powerfull grenades", "10 C2 Charges", "Detonator for the C2 Charges"}
			id = {"4", "5", "14", "22", "24", "25", "29", "32", "34", "40", "39", "42", "53"}
			value = {"1000", "", "", "30", "30", "20", "125", "200", "30", "5", "10", "10", "1"}
		elseif(heading == 3) then
			names = {"9mm Pistol Ammo", "Desert Eagle Ammo", "Shotgun Ammo", "MP5 Ammo", "M4 Ammo", "Sniper Rifle Ammo"}
			desc = {"20 rounds of 9mm pistol ammo", "25 rounds of Desert Eagle Ammo", "15 rounds of shotgun ammo", "100 rounds of MP5 Ammo", "150 rounds of M4 ammo", "20 rounds of Sniper Rifle ammo."}
			id = {"99", "101", "102", "106", "109", "111"}
			value = {"","","","", "", ""}
		elseif(heading == 4) then
			names = {"Hand Cuff Keys"}
			desc = {"A set of hand cuff keys to release people"}
			id = {"98"}
			value = {""}
		elseif(heading == 5) then
			names = {"Donut"}
			desc = {"A hot sugar covered donut."}
			id = {"120"}
			value = {""}
		elseif(heading == 6) then
			names = {"Hand Cuffs",  "Zip Cuffs", "Traffic Cone", "Traffic Barrier", "Traffic Barrier Small", "Riot Shield"}
			desc = {"A set of hand cuffs",  "A set of SWAT zip cuffs", "Traffic cone to block off the road", "A barrier to block off the road", "A small barrier to block part of the road", "A Riot Shield to be used in riots."}
			id = {"3", "97", "116", "117", "118", "1"}
			value = {"", "", "", "", "", ""}
		elseif(heading == 7) then
			names = {"Radio", "Fire Extinguisher", "Camera",  "First Aid Kit", "Megaphone", "Infra Red", "Night Vision"}
			desc = {"A government radio to communicate to other law enforcement.", "To put out fires!", "For the SID to take pictures with", "Everyone needs a first aid kit in their cruiser", "To make you loud and clear!", "Infra red googles to see anything hot.", "Night vision goggles to see in the dark."}
			id = {"6", "44", "45", "54", "94", "51", "50"}
			value = {"", "200", "30", "", "", "", ""}
		end
	
	end
	
	return names, desc, id, value
 
 end
 
 
 
 --- DUTY TYPE
-- 1 = SWAT
-- 2 = SWAT Shotgun
-- 3 = SWAT Sniper
-- 4 = Police Normal
-- 5 = PMU
-- 6 = SID
-- 7 = SWAT MP5
-- 8 = RIOT
-- 9 = Army
-- 10 = MEDIC
-- 12 = Fireman
-- 11 = Doctor
 function getDutyTypeName(duty_type)
 
	if(duty_type == 1) then
	
		return "SWAT"
		
	elseif(duty_type == 2) then
	
		return "SWAT Shotgun"
		
	elseif(duty_type == 3) then
	
		return "SWAT Sniper"
		
	elseif(duty_type == 4) then
	
		return "Police"
		
	elseif(duty_type == 5) then
	
		return "Police Motorbike"
		
	elseif(duty_type == 6) then
	
		return "Special Investigations"

	elseif(duty_type == 7) then
	
		return "SWAT MP5"
		
	elseif(duty_type == 8) then
	
		return "Riot"

	elseif(duty_type == 9) then
	
		return "Army"
		
	elseif(duty_type == 10) then
	
		return "Medic"
		
	elseif(duty_type == 11) then
	
		return "Doctor"
		
	elseif(duty_type == 12) then
	
		return "Fireman"
	end 
 end