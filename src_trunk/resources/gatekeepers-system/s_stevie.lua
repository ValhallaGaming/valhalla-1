-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler~=nil) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

--function timeCheck(res)
	--if (res==getThisResource()) then
		--local realTime = getRealTime()
		--local hours = realTime.hour
		--hour = hours + 8
		--if (hours>=19) and (hours<=22) then -- If the time is between 1900 and 2200 create Stevie.
			--local minutesLeft = 60 - realTime.minute
			--local hoursLeft = 21 - realTimer.hour
			--setTimer ( removeStevie, time until 2200, 1 ) -- remove stevie at 2200.
		--else -- Start a timer to create him at 1900.
			--Calculate how long is left until it's 1900 in the server.
			--local minutesLeft = 60 - realTime.minute
			--local hoursLeft = 18 - realTime.hour
			--setTimer ( createStevie, time until 1900, 1 )	
		--end
	--end
--end
--addEventHandler("onResourceStart", getRootElement(), timeCheck)

--function createStevie()
	local stevie = createPed (258, 675.89807128906, -455.46102905273, -24.4140625)
	exports.pool:allocateElement(stevie)
	setPedRotation (stevie, 180.01502990723)
	setElementInterior (stevie, 1)
	setElementDimension (stevie, 406)
	setPedAnimation(stevie, "FOOD", "FF_Sit_Loop",  -1, true, false, true) -- Set the Peds Animation.
	setElementData(stevie, "name", "Steven Pullman")
	setElementData(stevie, "talk", true)
	setElementData (stevie, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
	setElementData(stevie, "deals", 0) -- reset how many deals he has made today. Stevie will do 5 deals over the phone each day. He can't be called while he is in the game world (19:00-22:00).
--end

function stevieIntro (thePlayer) -- When player enters the colSphere create GUI with intro output to all local players as local chat.
	-- Give the player the "Find Stevie" achievement.
	if(getElementData(thePlayer, "stevieCoolDown")==1)then
		local pedX, pedY, pedZ = getElementPosition( source )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		local name = string.gsub(getPlayerName(source), "_", " ")
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("* Stevie ignore the person trying to talk to him and contiues to eat.", player,  255, 51, 102)
		end
	else
		local pedX, pedY, pedZ = getElementPosition( stevie )
		local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
		exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		for i, player in ipairs( targetPlayers ) do
			outputChatBox("Steven Pulman says: Do you want something, pal?", player, 255, 255, 255) -- Stevies next question
		end
		setElementData (stevie, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
		destroyElement(chatSphere)
	end
end
addEvent( "startStevieConvo", true )
addEventHandler( "startStevieConvo", getRootElement(), stevieIntro )

-- Quick Close
function quickClose_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .." says: No. Sorry to bother you.", player, 255, 255, 255) -- Stevies next question
	end
	destroyElement(chatSphere)
end
addEvent( "quickCloseServerEvent", true )
addEventHandler( "quickCloseServerEvent", getRootElement(), quickClose_S )

-- Statement 2
function statement2_S()
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Can I take a seat?", player, 255, 255, 255) -- Players response to last question
		outputChatBox("Steven Pullman says: Sure, sit down. Have you tried the food here? It's f****** unbelievable.", player, 255, 255, 255) -- Stevies next question
	end
	destroyElement (chatSphere)
	
	-- Set players position and anim so they are sitting opposite Stevie. Freeze them so they can't move until they end the conversation
	setElementPosition (source, 675.81127929688, -457.45016479492, -24.406700134277)
	setPedRotation (source, 11.667144775391)
	exports.global:applyAnimation(source, "INT_OFFICE", "OFF_Sit_Watch", -1, false, false, true)
	
end
addEvent( "statement2ServerEvent", true )
addEventHandler( "statement2ServerEvent", getRootElement(), statement2_S )

-- Statement 3
function statement3_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: I’m a vegetarian. The thought of those poor animals suffering for you to stuff your face makes me sick.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Hey f*** you, pal. You don’t like it, go save a whale or some shit.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end	
addEvent( "statement3ServerEvent", true )
addEventHandler( "statement3ServerEvent", getRootElement(), statement3_S )

-- statement 4
function statement4_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Yeah I heard it’s good. I was just about to order something.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Get the Angus rib-eye. You won’t regret it. Where’s my manners...", player, 255, 255, 255)
		outputChatBox("* Steven Pullman wipes his hands on a napkin and offers "..name.." a hand shake.", player, 255, 51, 102)
		outputChatBox("Steven Pullman says: The name’s Stevie.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement4ServerEvent", true )
addEventHandler( "statement4ServerEvent", getRootElement(), statement4_S )

-- Statement 5
function statement5_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	exports.global:sendLocalMeAction( source,"leaves Stevie's hand lingering in the air.")
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	for i, player in ipairs( targetPlayers ) do
		outputChatBox("Steven Pullman says: I was just being polite but if you want to be an ass about it how about you leave me to eat in peace.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end	
addEvent( "statement5ServerEvent", true )
addEventHandler( "statement5ServerEvent", getRootElement(), statement5_S )

-- Statement 6
function statement6_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox("* "..name.." shakes Stevie's hand.", player, 255, 51, 102)
		outputChatBox("Steven Pullman says: Me and the boys from the freight depot come down here every week.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Football and steaks make a damn good combination don’t you think?", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement6ServerEvent", true )
addEventHandler( "statement6ServerEvent", getRootElement(), statement6_S )

-- Statement 7
function statement7_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name.." says: Are you kidding me? I’ve been a Beavers fan my whole life!", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: What?! The Beavers?", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: You’re lucky I don’t punch your lights out right here and now you piece-a beaver scum.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Look... now you made me lose my appetite.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement7ServerEvent", true )
addEventHandler( "statement7ServerEvent", getRootElement(), statement7_S )

-- Statement 8
function statement8_S()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox( name.." says: I never really liked football.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Yeah, maybe it isn’t to everyone’s taste. So what do you do?", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
end
addEvent( "statement8ServerEvent", true )
addEventHandler( "statement8ServerEvent", getRootElement(), statement8_S )

-- Statement 9
function statement9_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox( name.." says: Over worked and underappreciated. You know how it is.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Tell me about it! They got me bustin’ my ass at the freight yard for change.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: See it’s people like you and me that need to help each other out.", player, 255, 255, 255)
		outputChatBox("Steven Pullman says: Tell you what, here’s my card. You ever need anything I can help you out with, just give me a call.", player, 255, 255, 255)
	end
	destroyElement (chatSphere)
	
	-- Give the player the "A friend of Stevie" achievement.
	
end
addEvent( "statement9ServerEvent", true )
addEventHandler( "statement9ServerEvent", getRootElement(), statement9_S )

-- Success
function stevieSuccess_S()
	
	exports.global:removeAnimation(source)
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	exports.global:sendLocalMeAction( source,"takes Stevie's business card.")
	
	-- Give the player an item. Name = "Business card"  Description = "Steven Pullman, L.V. Freight Depot, Tel: 081016"  !NEEDS NEW ITEM!
	exports.global:givePlayerItem(source, 55, 1) -- change the ID.
	
	-- set the players "stevie" stat to "1" meaning they have met him and successfully made it through the conversation.
	setElementData(source, "stevie", 1)
	mysql_query(handler, "UPDATE characters SET stevie='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1") -- NOT WORKING
end
addEvent( "stevieSuccessServerEvent", true )
addEventHandler( "stevieSuccessServerEvent", getRootElement(), stevieSuccess_S )

-- Close Button
function CloseButtonClick_S()
	
	exports.global:removeAnimation(source)
	toggleAllControls(source, true, true, true)
	
	setElementData (stevie, "activeConvo", 0) -- set the NPCs conversation state to not active so others can begin to talk to him.
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name .. " says: Is that the time? I have to go.", player, 255, 255, 255, false)
		outputChatBox("Steven Pullman says: You take it easy. Maybe I'll run into you again some time.", player, 255, 255, 255, false)
	end
	destroyElement (chatSphere)
end
addEvent( "CloseButtonClickServerEvent", true )
addEventHandler( "CloseButtonClickServerEvent", getRootElement(), CloseButtonClick_S )


------------------------------------------------------------------------------------
------------------------------ telephone conversation ------------------------------
------------------------------------------------------------------------------------

function startPhoneCall(thePlayer)
	if not(exports.global:doesPlayerHaveItem(thePlayer, 2)) then -- does the player have a cell phone?
		outputChatBox("You need a cellphone to call someone.", thePlayer, 255, 0, 0)
	else
		local calling = getElementData(thePlayer, "calling")
		if (calling) then -- Using phone already.
			outputChatBox("You are already using your phone.", thePlayer, 255, 0, 0)
		else
			local money = getElementData(thePlayer, "money")
			if (money<10) then
				outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
			else
				--if (stevie) then -- If stevie is currently spawned (i.e., if it's between 1900 and 2200).   -- disabled while testing.
					outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 0, 0)
				--else
					local phoneState = getElementData(stevie, "phoneState")
					if (phoneState==1) then -- is someone already speaking to stevie?
						outputChatBox("The number you are trying to call is engaged.", thePlayer, 255, 0, 0)
					else
						setElementData (stevie, "phoneConvoState", 1)
						setElementData(thePlayer, "calling", "stevie")
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 1.0, 1.0, 0.0, false, false, true)
						toggleAllControls(thePlayer, true, true, true)
						setTimer(startPhoneAnim, 1000, 2, thePlayer)
						local friend = mysql_query(handler, "SELECT stevie FROM characters WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(name)) .. "'")-- check the sql that the player has meet stevie and completed the conversation.
						local factionID = getElementData(thePlayer, "faction") -- get the player's faction type to see if they are in law enforcement and later to determine what deal they are offered. -- NOT WORKING
						local factionType = mysql_query(handler, "SELECT type FROM factions WHERE id='" .. factionID .. "'") -- NOT WORKING
						if not(friend==1) or (factionType==4) then
							setTimer( endCall, 6000, 1, thePlayer)
							outputChatBox("#081016 [Cellphone]: Yeah?", thePlayer)
							setTimer(outputChatBox, 3000, 1, "#081016 [Cellphone]: How did you get this number? ", thePlayer)
							setTimer(outputChatBox, 6000, 1, "#081016 [Cellphone]: Sorry you must have the wrong number, pal.", thePlayer)
							setTimer(outputChatBox, 6000, 1, "They hung up.", thePlayer)
							setTimer(setElementData, 6500, 1, stevie, "phoneConvoState", 0) -- reset Stevie's convo state.
						else
							local doneDeals = getElementData(stevie,"deals")
							if(doneDeals > 5) then
								triggerClientEvent ( thePlayer, "outOfDeals", getRootElement() ) -- Trigger Client side function to create GUI.
							else
								triggerClientEvent ( thePlayer, "showPhoneConvo", getRootElement(), factionType) -- Trigger Client side function to create GUI.
							end
						end
					end
				--end
			end
		end
	end
end
addCommandHandler ( "081016", startPhoneCall )

function startPhoneAnim() -- taken from phone res.
	exports.global:applyAnimation(source, "ped", "phone_talk", 1.0, 1.0, 0.0, true, true, true)
end

-------------------------
-- Declining phone deal. --
-------------------------
function declineDeal_S ()
	
	-- Output the text from the last option to all player in radius
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, player in ipairs( targetPlayers ) do
		outputChatBox(name.. " says: Maybe another time.", player, 255, 255, 255)
	end			
	destroyElement (chatSphere)
	outputChatBox("((Steven Pullman)) #081016 [Cellphone]: Okay. Give me a call if you change your mind.", source)
	
	endCall(source)
	
end
addEvent( "declineSteviePhoneDeal", true )
addEventHandler( "declineSteviePhoneDeal", getRootElement(), declineDeal_S )

------------------------------
-- Accepting phone deal --
------------------------------

-- The item spawn locations. Stack the items 3 high to give 15 items in total.
locations_1 = { } 
locations_1[1] = { 1609, 889.6044921875, 10.701148033142 } -- x
locations_1[2] = { 1609.5, 889.6044921875, 10.701148033142 } -- x
locations_1[3] = { 1610, 889.6044921875, 10.701148033142 } -- x
locations_1[4] = { 1610.5, 889.6044921875, 10.701148033142 } -- x
locations_1[5] = { 1611, 889.6044921875, 10.701148033142 } -- x

location_2 = {}
location_2[1] = { 1313.4462890625, 1144, 10.8203125 } -- y
location_2[2] = { 1313.4462890625, 1144.5, 10.8203125 } -- y
location_2[3] = { 1313.4462890625, 1145, 10.8203125 } -- y
location_2[4] = { 1313.4462890625, 1145.5, 10.8203125 } -- y
location_2[5] = { 1313.4462890625, 1146, 10.8203125 } -- y

location_3 = {}
location_3[1] = { 1123, 1892.029296875, 10.8203125 } -- x
location_3[2] = { 1123.5, 1892.029296875, 10.8203125 } -- x
location_3[3] = { 1124, 1892.029296875, 10.8203125 } -- x
location_3[4] = { 1124.5, 1892.029296875, 10.8203125 } -- x
location_3[5] = { 1125, 1892.029296875, 10.8203125 } -- x

function acceptDeal_S( dealNumber )
	
	if(dealNumber==1)then -- work out the cost of the selected deal.
		local cost = 4000
		outputChatBox("Cost = $4000.", source, 255, 0, 0) -- trace
	elseif(dealNumber==2)then
		local cost = 2000
		outputChatBox("Cost = $2000.", source, 255, 0, 0) -- trace
	elseif(dealNumber==3)then
		local cost = 30000
		outputChatBox("Cost = $30000.", source, 255, 0, 0) -- trace
	elseif(dealNumber==4)then
		local cost = 10000
		outputChatBox("Cost = $10000.", source, 255, 0, 0) -- trace
	end
	
	local money = getElementData (source, "money") -- NOT WORKING
	if (money<cost) then -- can the player afford the deal?
		outputChatBox("((Steven Pullman)) #081016 [Cellphone]: Call me when you've got some money.", source)
		outputChatBox("You can't afford to pay Stevie for the deal.", source, 255, 0, 0)
	else
		exports.global:takePlayerSafeMoney(source, cost) -- pay the money.
		outputChatBox("You have sent Stevie $".. cost .." for the deal.", source, 255, 0, 0)
		
		local rand = math.random(1,3) -- select one of the drop off locations at the freight Depo.		
	
		-- create the items at the selected location.
		if(dealNumber == 1) then
			outputChatBox("Deal 1 selected.", source, 255, 0, 0) -- trace
			-- Ammunation weapons (colt, rifle, shotgun) Ammunation weapons.
		elseif(dealNumber == 2) then
			outputChatBox("Deal 2 selected.", source, 255, 0, 0) -- trace
			-- MP3 players, cellphones, radios.
		elseif(dealNumber == 3) then
			outputChatBox("Deal 3 selected.", source, 255, 0, 0) -- trace
			-- Snipers, M4, AK47, SMG, gas mask?, army skin.
		elseif(dealNumber == 4) then
			outputChatBox("Deal 4 selected.", source, 255, 0, 0) -- trace
			-- Cocaine Alkaloid, Unprocessed PCP, Lysergic Acid.
		end
		
		-- create a blip and marker on the players screen radar so they know where to collect the items from.
		
		endCall(source) -- end the call.
		
		setElementData(stevie, "deals", doneDeals+1)
	end
end
addEvent( "acceptSteviePhoneDeal", true )
addEventHandler( "acceptSteviePhoneDeal", getRootElement(), acceptDeal_S )

---------------------
-- ending the call --
---------------------
function endCall(thePlayer) -- to cancel the phone animation and reset the phone states. -- NOT WORKING
	outputChatBox("endCall function triggered.", thePlayer, 255, 0, 0) -- trace
	exports.global:removeAnimation(thePlayer)
	toggleAllControls(thePlayer, true, true, true)
	setElementData(thePlayer, "calling", nil)
	setElementData(stevie, "phoneConvoState", 0) -- reset the convo state so other players can call Stevie.
	exports.global:takePlayerSafeMoney(thePlayer, 10)
end
