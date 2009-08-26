addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function ( )

	-- F1 vehicles
	local txd = engineLoadTXD ( "bmw.txd", 502 )
	engineImportTXD ( txd, 502 )
	local dff = engineLoadDFF ( "bmw.dff", 502 )
	engineReplaceModel ( dff, 502 )
	
	local txd = engineLoadTXD ( "mp4.txd", 503 )
	engineImportTXD ( txd, 503 )
	local dff = engineLoadDFF ( "mp4.dff", 503 )
	engineReplaceModel ( dff, 503 )

	local txd = engineLoadTXD ( "ferrari.txd", 494 )
	engineImportTXD ( txd, 494 )
	local dff = engineLoadDFF ( "ferrari.dff", 494 )
	engineReplaceModel ( dff, 494 )
	
	local txd = engineLoadTXD ( "renault.txd", 411 )
	engineImportTXD ( txd, 411 )
	local dff = engineLoadDFF ( "renault.dff", 411 )
	engineReplaceModel ( dff, 411 )
	
	-- Shangai circuit
	local txd = engineLoadTXD ( "chinaspeed.txd" )
	engineImportTXD ( txd, 3376 )
	engineImportTXD ( txd, 3377 )
	engineImportTXD ( txd, 3378 )
	engineImportTXD ( txd, 3379 )
	
	local col = engineLoadCOL ( "hjp04b.col" )
	engineReplaceCOL ( col, 3376 )
	local dff = engineLoadDFF ( "hjp04b.dff", 3376 )
	engineReplaceModel ( dff, 3376 )

	local col = engineLoadCOL ( "hjp04c.col" )
	engineReplaceCOL ( col, 3377 )
	local dff = engineLoadDFF ( "hjp04c.dff", 3377 )
	engineReplaceModel ( dff, 3377 )
	
	local col = engineLoadCOL ( "hjp04a.col" )
	engineReplaceCOL ( col, 3378 )
	local dff = engineLoadDFF ( "hjp04a.dff", 3378 )
	engineReplaceModel ( dff, 3378 )

	local col = engineLoadCOL ( "hjp03.col" )
	engineReplaceCOL ( col, 3379 )
	local dff = engineLoadDFF ( "hjp03.dff", 3379 )
	engineReplaceModel ( dff, 3379 )
	
	local lodDistance = 500
	engineSetModelLODDistance ( 3376, lodDistance )
	engineSetModelLODDistance ( 3377, lodDistance )
	engineSetModelLODDistance ( 3378, lodDistance )
	engineSetModelLODDistance ( 3379, lodDistance )
end, false)