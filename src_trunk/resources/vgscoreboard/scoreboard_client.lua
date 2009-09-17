toggleControl( 'action', false ) -- yay, that key has no purpose either way

local scoreboardRows = {}
local scoreboardGrid
local updateInterval = 1000 --ms
local indent = ' '

local playerCount

local localPlayer = getLocalPlayer()
local rootElement = getRootElement()

local players = {}
local columns = {
	{name="ID #"}, 
	{name="name",size=0.55},
	{name="ping"}
}

function addToScoreboard(player)
	local player = player or source
	if (isElement(player)) then
		local id = getElementData(player, "playerid")
		
		if not id then
			setTimer(addToScoreboard, 100, 1, player)
		else
			players[id] = player
			
			updatePlayers()
		end
	end
end

function removeFromScoreboard()
	local id = getElementData(source, "playerid")

	players[id] = nil
	
	updatePlayers()
end

function updatePlayers()
	guiGridListClear(scoreboardGrid)
	scoreboardRows = {}

	-- add all players
	local row = guiGridListAddRow(scoreboardGrid)
	scoreboardRows[localPlayer] = row

	guiGridListSetItemText(scoreboardGrid, row, 1, tostring(getElementData(localPlayer, "playerid")), false, true)
	guiGridListSetItemText(scoreboardGrid, row, 2, getPlayerName(localPlayer), false, false)
	guiGridListSetItemText(scoreboardGrid, row, 3, tostring(getPlayerPing(localPlayer)), false, true)

	for i = 1, 128 do
		if players[i] and players[i] ~= localPlayer then
			local player = players[i]
			local row = guiGridListAddRow(scoreboardGrid)
			scoreboardRows[player] = row
			
			guiGridListSetItemText(scoreboardGrid, row, 1, tostring(i), false, true)
			guiGridListSetItemText(scoreboardGrid, row, 2, getPlayerName(player), false, false)
			guiGridListSetItemText(scoreboardGrid, row, 3, tostring(getPlayerPing(player)), false, true)
		end
	end
	guiGridListSetSelectedItem(scoreboardGrid, 0, 1)
end

function updatePlayerNick(old, new)
	guiGridListSetItemText(scoreboardGrid, scoreboardRows[source], 2, new, false, false)
end

function refreshScoreboardPings()
	for i,player in ipairs(getElementsByType("player")) do
		if (isElement(player)) then
			guiGridListSetItemText(scoreboardGrid, scoreboardRows[player], 3, tostring(getPlayerPing(player)), false, false)
		end
	end
	guiSetText(playerCount, #getElementsByType("player"))
end

function updateScoreboard()
	refreshScoreboardPings()
	
	guiSetText(playerCount, "Players: " .. #getElementsByType("player"))
	guiGridListSetSelectedItem(scoreboardGrid, 0, 1)
end

function refreshScoreboard()
	if guiGetVisible(scoreboardGrid) and not isCursorShowing() then
		updateScoreboard()
	end
end

function showScoreboardCursor(key,keystate,show)
	showCursor(show)
	setControlState( 'fire', false )
	setControlState( 'weapon_aim', false )
end

function toggleScoreboard(state)
	if state == nil then state = not guiGetVisible(scoreboardGrid) end
	if state == true then
		showCursor(false)
		updateScoreboard()
		bindKey("mouse2","down",showScoreboardCursor,true)
		bindKey("mouse2","up",showScoreboardCursor,false)
		if isControlEnabled( 'fire' ) then
			setElementData(getLocalPlayer(), "scoreboard:reload", true)
			toggleControl( 'fire', false )
		end
		guiBringToFront(scoreboardGrid)
	elseif state == false then
		showCursor(false)
		unbindKey("mouse2","down",showScoreboardCursor)
		unbindKey("mouse2","up",showScoreboardCursor)
		if getElementData(getLocalPlayer(), "scoreboard:reload") then
			setElementData(getLocalPlayer(), "scoreboard:reload", false)
			toggleControl( 'fire', true )
		end
	end
	
	guiSetVisible(scoreboardGrid,state)
end

function toggleScoreboardPressed(key,keystate,state)
	toggleScoreboard(state)
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		scoreboardGrid = guiCreateGridList(0.15,0.2,0.7,0.6,true)
		
		guiSetAlpha(scoreboardGrid,0.7)
		guiSetVisible(scoreboardGrid,false)
		guiGridListSetSortingEnabled(scoreboardGrid,false)
		
		local rmbLabel = guiCreateLabel(0, 0, 0, 0, "(Hold right mouse button to enable scrolling)",false,scoreboardGrid)
		local scoreX, scoreY = guiGetSize(scoreboardGrid, false)
		local labelWidth = guiLabelGetTextExtent(rmbLabel)
		local labelHeight = guiLabelGetFontHeight(rmbLabel)
		
		guiSetPosition(rmbLabel, (scoreX - labelWidth)/6, scoreY - labelHeight - 10, false)
		guiSetSize(rmbLabel, labelWidth, labelHeight, false)
		guiSetAlpha(rmbLabel, .8)
		guiLabelSetColor(rmbLabel, 200, 200, 255)
		
		playerCount = guiCreateLabel(0, 0, 0, 0, "Players:        ",false,scoreboardGrid)
		labelWidth = guiLabelGetTextExtent(playerCount)
		labelHeight = guiLabelGetFontHeight(playerCount)
		
		guiSetPosition(playerCount, (scoreX - labelWidth)/1.25, scoreY - labelHeight - 10, false)
		guiSetSize(playerCount, labelWidth, labelHeight, false)
		guiSetAlpha(playerCount, .8)
		guiLabelSetColor(playerCount, 200, 200, 255)
		
		bindKey("tab","down",toggleScoreboardPressed,true)
		bindKey("tab","up",toggleScoreboardPressed,false)
		
		addCommandHandler("scoreboard", toggleScoreboard)
		
		setTimer(refreshScoreboard, updateInterval, 0)
		updateScoreboard()
		
		--scoreboard update event handlers
		addEventHandler("onClientPlayerJoin", rootElement, addToScoreboard)
		addEventHandler("onClientPlayerQuit", rootElement, removeFromScoreboard)
		addEventHandler("onClientPlayerChangeNick", rootElement, updatePlayerNick)
		
		addEventHandler("onClientClick", scoreboardGrid,
			function()
				if guiGetVisible(scoreboardGrid) then
					guiGridListSetSelectedItem(scoreboardGrid, scoreboardRows[localPlayer], 1)
				end
			end
		)

		-- add all columns
		for key, value in pairs(columns) do
			guiGridListAddColumn(scoreboardGrid,value.name,value.size or 0.1)
		end
		
		-- add all players
		for key, value in ipairs(getElementsByType("player")) do
			addToScoreboard(value)
		end
		
		updatePlayers()
	end
)