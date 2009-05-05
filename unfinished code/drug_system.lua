mixableItem = { [CannabisSativa itemID]=true, [cocaineAlkaloid itemID]=true, [lysergicAcid itemID]=true, [phencyclidine itemID]=true }

wChemSet, buttonRemove, buttonAdd, buttonMix, buttonClose, subtanceList, mixtureList = nil

---------------------------------------------------------------------------------
----------------------------- Items That Need Creating --------------------------
---------------------------------------------------------------------------------

	-- Chemistry set, A small Chamistry Set ( When used the Chemistry Set GUI opens ).

-- Substance items / Chemicals ( These do nothing without the chemistry set item )
	
	-- Name, Description, ( Identifier )
	
	-- Cannabis Sativa, A Cannabis Sativa Leaf ( identifier = 1 )
	-- Cocaine Alkaloid, A bottle of Cocaine Alkaloid ( identifier = 10 )
	-- Lysergic Acid, A bottle of Lysergic Acid ( identifier = 25 )
	-- Phencyclidine, A bottle of Phencyclidine ( identifier = 33 )

-- Finished drug items ( When used these will trigger their specific effects. The identifier of the 
-- finished drug item is the sum of the identifiers of the two ingredients that combine to produce it ).
	
	-- Name, Description: ingredients need to make it ( identifier )
	
	-- Cocaine, 50 mg of Cocaine: Cocaine Alkaloid (10) + Cocaine Alkaloid (10) ( identifier  = 20 )
	-- Drug 2, 5 grams of laced Maijuana: Cocaine Alkaloid  (10) + Cannabis Sativa (1) ( identifier = 11 )
	-- Drug 3: Lysergic Acid (25) + Cocaine Alkaloid (10) ( identifier = 35 )
	-- Drug 4: Phencyclidine (33) + Cocaine Alkaloid (10) ( identifier = 43 )
	-- Marijuana, 5 grams of Marijuana: Cannabis Sativa (1) + Cannabis Sativa (1) ( identifier = 2 )
	-- Drug 6, 5grams of laced marijuana: Cannabis Sativa (1) + Lysergic acid (25)( identifier = 26 )
	-- Drug 7, 5 grams of laced marijuana: Cannabis Sativa (1) + Phencyclidine (33) ( identifier = 34 )
	-- LSD, 80 micrograms of LCD: Lysergic Acid (25)+ Lysergic Acid (25) ( identifier = 50 )
	-- Drug 9: Lysergic Acid (25) + Phencyclidine (33) ( identifier = 58 )
	-- Angel Dust, of powder: Phencyclidine (33) + Phencyclidine(33) ( identifier = 66 )

---------------------------------------------------------------------------------
---------------------------- Chemistry Set Functions ----------------------------
---------------------------------------------------------------------------------

-- Draw the chemistry set GUI and populate the substanceList
function createChemSet()

	-- Window variables
	local Width = 340
	local Height = 250
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	-- Create the window
	wChemSet = guiCreateWindow( x, y, Width, Height, "Chemistry Set", true )
    guiWindowSetSizable ( wChemSet, false )
	
	-- Create Remove and Add buttons to add substances to the mixture
	buttonRemove = guiCreateButton( 0.6, 0.5, 0.17, 0.1, "Remove", true, wChemSet )
	addEventHandler( "onClientGUIClick", buttonRemove, removeButtonClick, false )
	buttonAdd = guiCreateButton( 0.2, 0.8, 0.17, 0.1, "add", true, wChemSet )
	addEventHandler( "onClientGUIClick", buttonAdd, addButtonClick, false )
	
	-- Create Mix button to perform the drug making process
	buttonMix = guiCreateButton( 0.8, 0.7, 0.17, 0.1, "Mix", true, wChemSet )
	addEventHandler( "onClientGUIClick", buttonMix, mixButtonClick, false )	
	
	-- Create Cancel button to cancel and close the window
	buttonClose = guiCreateButton( 0.6, 0.7, 0.17, 0.1, "Close", true, wChemSet )
	addEventHandler( "onClientGUIClick", buttonClose, closeButtonClick, false )
	
	-- Create gridlist to show the substances in the players inventory
	substancesList = guiCreateGridList ( 0.05, 0.1, 0.15, 0.6, true, wChemSet )
	local substances = guiGridListAddColumn( substanceList, "Substances", 0.95 )
	guiCreateLabel(0.05, 0, 0.2,0.2,"Substances",true, wChemSet )
	
	-- Create gridlist to show the two selected substances that will be mixed
	mixtureList = guiCreateGridList ( 0.6, 0.1, 0.15, 0.6, true, wChemSet )
	local mixture = guiGridListAddColumn( mixtureList, "Mixture", 0.95 )	
	guiCreateLabel(0.6, 0, 0.2,0.2,"mixture", true, wChemSet )
	
	-- Loop through the players inventory and if the item is a "mixableItem" add it to the substanceList
	
end
-- Add Event Handler (When chemistry set item is used)

-- function of add button
function addButtonClick( )

	-- Check an item is selected in the substnaceList.
	local itemToAdd = guiGridListGetItemText ( substanceList, guiGridListGetSelectedItem ( substances ), 1 )
	
	if itemToAdd = nil then
	
		-- Output a message that they need to select an item first
		outputChatBox( "You need to select a substance to add to the mixture.", localPlayer, 255, 255, 255 )
		
	else
	
		-- Are there already two items on the mixtureList?
		local itemsToMix = guiGridListGetRowCount ( mixtureList )
	
		if itemsToMix > 2 then 
		
			-- Output a message that they need to remove an item first
			outputChatBox( "You can't mix more than two substances at a time.", localPlayer, 255, 255, 255 )
		
		else
		
			-- Add the substance selected in the substanceList to the next available row in MixtureList
			guiGridListSetItemText ( mixtureList, ( itemsToMix + 1 ), 1, itemToAdd, false, false )
	
			-- remove the selected substance from the substanceList
		end
	end
end

-- function of remove button
function removeButtonClick( )
	
	-- Check an item is selected in the mixtureList.
	local itemToRemove = guiGridListGetItemText ( mixtureList, guiGridListGetSelectedItem ( mixture ), 1 )
	
	if itemToRemove = nil then
	
		-- Output an error message.
		outputChatBox( "You need to select an item to remove.", localPlayer, 255, 255, 255 )
		
	else	

		-- Find how many entries there are in the substanceList
		local itemsOnSubstnaceList = guiGridListGetRowCount ( substanceList )
	
		-- Add the substance selected in the mixtureList to the substanceList
		guiGridListSetItemText ( substanceList, ( itemsOnSubstanceList + 1 ), 1, itemToRemove, false, false )
	
		-- remove the selected substance from the mixtureList
		
end

-- function of mix button
function mixButtonClick( )
	
	-- Check the player has 10 empty inventory slots. If not prompt the player that they need at least 10 empty slots
	
	-- Check there are two substance in the mixtureList
	local itemsToMix = guiGridListGetRowCount ( mixtureList )
	
	if not itemsToMix == 2 then
		
		-- if there aren't two items in the mixture list prompt the player to add substances before clicking the mix button
		outputChatBox( "You need to add more items to the mixture.", localPlayer, 255, 255, 255 )
		
	else
	
		-- Get the identifer values of the two substances in the mixtureList
		local subtance1 = guiGridListGetItemText ( mixtureList, guiGridListGetSelectedItem ( mixture ), 1 )
		local subtance2 = guiGridListGetItemText ( mixtureList, guiGridListGetSelectedItem ( mixture ), 2 )
		local substance1Identifier = getElementData ( substance1, "identifier" )
		local substance2Identifier = getElementData ( substance2, "identifier" )
		
		-- Calculate the total of the two values
		local IdentifierTotal = ( substance1Identifier + substance2Identifier )
	
		-- Give the player the drug item associated to the identifierTotal / susbstance combination
		if ( identifierTotal == 20 ) then
			-- Add 10 x Cocaine to players inventory
		elseif ( identifierTotal == 11 ) then
			-- Add 10 x drug2 to players inventory
		elseif ( identifierTotal == 35 ) then
			-- Add 10 x drug3 to players inventory
		elseif ( identifierTotal == 43 ) then
			-- Add 10 x drug4 to players inventory
		elseif ( identifierTotal == 2 ) then
			-- Add 10 x Marijuana to players inventory
		elseif ( identifierTotal == 26 ) then
			-- Add 10 x drug6 to players inventory
		elseif ( identifierTotal == 34 ) then
			-- Add 10 x drug7 to players inventory
		elseif ( identifierTotal == 50 ) then
			-- Add 10 x LSD to players inventory
		elseif ( identifierTotal == 58 ) then
			-- Add 10 x drug9 to players inventory
		elseif ( identifierTotal == 66 ) then
			-- Add 10 x AngelDust to players inventory
		end
	
		-- Output /me
		local posX, posY, posZ = getElementPosition(thePlayer)
		local chatSphere = createColSphere( posX, posY, posZ, 20 ) -- Big radius so people don't cook up drugs in the middle of the street
		local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
		destroyElement( chatSphere )
		for index, targetPlayers in ipairs( targetPlayers ) do
			local name = string.gsub(getPlayerName(thePlayer), "_", " ")
			exports.global:sendLocalMeAction( name.." mixes "..substance1.." and "..substance2.." and creates a drug." )
		
		-- remove the two substance items in the mixtureList from the players inventory
			
		-- Remove the chemistry GUI
		destroyElement ( buttonAdd )
		destroyElement ( buttonRemove )
		destroyElement ( buttonClose )
		destroyElement ( buttonMix )
		destroyElement ( substantList )
		destroyElement ( mixtureList )
		destroyElement ( wChemSet )
		buttonAdd = nil
		buttonRemove = nil
		buttonClose = nil
		buttonMix = nil
		SubstanceList = nil
		mixtureList = nil
		wChemSet = nil
	end
end

-- function of cancel button
function closeButtonClick( )
	destroyElement ( buttonAdd )
	destroyElement ( buttonRemove )
	destroyElement ( buttonClose )
	destroyElement ( buttonMix )
	destroyElement ( substantList )
	destroyElement ( mixtureList )
	destroyElement ( wChemSet )
	buttonAdd = nil
	buttonRemove = nil
	buttonClose = nil
	buttonMix = nil
	SubstanceList = nil
	mixtureList = nil
	wChemSet = nil
end

---------------------------------------------------------------------------------
---------------------------------- Drug Effects ---------------------------------
---------------------------------------------------------------------------------

-- Cocaine Effect
function cocaine ()
	-- Increase the players addiction level by 4 ( miximum = 20 )
	-- Create a timer for duration of the effect
	-- Health degeneration stops (appitite surpresent)
    -- Chat ranges increase slightly (Central nervouse system stimulant)
    -- Motion blur
end

-- Drug 2 Effect
function drug2 ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 3 ( miximum = 20 )
	-- Chat ranges increase slightly (Central nervouse system stimulant)
    -- Player loses less health when attacked (Psychotropic)
    -- Motion blur
end

-- Drug 3 Effect
function drug3 ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 4 ( miximum = 20 )
	-- Pink skys (psychodelic)
    -- Slow motion
    -- Creates random chat from nearby players (hallucinations)
    -- Chat ranges increase slightly (Central nervouse system stimulant)
end

-- Drug 4 Effect
function drug4 ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 5 ( miximum = 20 )
	-- Health degeneration stops (appitite surpresent)
    -- Chat ranges increase slightly (Central nervouse system stimulant)
    -- NPCs randomly spawn client side (client side) (hallucinations)
    -- Pink skys (psychodelic)
    -- Staggered walk anim

end

-- Marijuana Effect
function marijuana ()
	-- Increase the players addiction level by 2 ( miximum = 20 )
    -- Player loses less health when attacked (Psychotropic)
    -- Motion blur
	-- Pink Skys
end

-- Drug 6 Effect
function drug6 ()
	-- Increase the players addiction level by 1 ( miximum = 20 )
	-- Player loses less health when attacked (Psychotropic)
    -- Motion blur
    -- Pink skys (psychodelic)
    -- Slow motion
    -- Creates random chat from nearby players (hallucinations)
end

-- Drug 7 Effect
function drug5 ()
	-- Increase the players addiction level by 3 ( miximum = 20 )
	-- Player loses less health when attacked (Psychotropic)
    -- Motion blur
    -- Pink skys (psychodelic)
    -- Slow motion
    -- Creates random chat from nearby players (hallucinations)
end

-- LSD Effect
function lsd ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 1 ( miximum = 20 )
    -- Pink skys (psychodelic)
    -- Slow motion
    -- Creates random chat from nearby players (hallucinations)
end

-- Drug 9 Effect
function drug9 ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 3 ( miximum = 20 )
    -- Pink skys (psychodelic)
    -- Slow motion
    -- Creates random chat from nearby players (hallucinations)
    -- NPCs randomly spawn (client side) (hallucinations)
    -- Pink skys (psychodelic)
    -- Staggered walk anim
end

-- Angel Dust Effect
function angelDust ()
	-- Health degeneration stops (addiction effect)
	
	-- Increase the players addiction level by 3 ( miximum = 20 )
	-- Motion Blur
	-- Desync time with day / night cycle
	-- Creates random chat from nearby players (hallucinations)
    -- Pink skys (psychodelic)
    -- Exaggerated walk anim
end
