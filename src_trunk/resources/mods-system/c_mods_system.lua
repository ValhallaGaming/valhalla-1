function applyMods()	
	----------------------
	-- Pig Pen Interior --
	----------------------
	-- Bar
	pigpen1 = engineLoadTXD("lv/lee_stripclub1.txd")
	engineImportTXD(pigpen1, 14831)
	
	-- corver stage + seat
	pigpen2 = engineLoadTXD("lv/lee_stripclub.txd")
	engineImportTXD(pigpen2, 14832)
	-- Backwall seats
	engineImportTXD(pigpen2, 14833)
	-- columns
	engineImportTXD(pigpen2, 14835)
	-- corner seats
	engineImportTXD(pigpen2, 14837)
	-- main interior structure
	engineImportTXD(pigpen2, 14838)	
	
	------------------------
	--		 Cop Cars     --
	------------------------
	--copcarvg = engineLoadTXD ( "copcarvg.txd" )
	--engineImportTXD ( copcarvg, 596 )
	--copcarvgdff = engineLoadDFF ( "copcarvg.dff", 596 )
	--engineReplaceModel ( copcarvgdff, 596 )
	
	--copcarvgswat = engineLoadTXD ( "copcarvg.txd" )
	--engineImportTXD ( copcarvgswat, 597 )
	--copcarvgswatdff = engineLoadDFF ( "copcarvg.dff", 597 )
	--engineReplaceModel ( copcarvgswatdff, 597 )
	------------------------
	-- bus Stop --
	------------------------
	busStop = engineLoadTXD("lv/bustopm.txd")
	engineImportTXD(busStop, 1257)
			
	----------------
	-- Billboards --
	----------------
	
	------------------
	-- Police Skins --
	------------------
	-- LSPD
	--lspd = engineLoadTXD("skins/lvpd/lapd1.txd")
	--engineImportTXD(lspd, 280)
	
	-- SFPD
	--sfpd = engineLoadTXD("skins/lvpd/sfpd1.txd")
	--engineImportTXD(sfpd, 281)
	
	-- SWAT
	--swatCop = engineLoadTXD("skins/lvpd/swat.txd")
	--engineImportTXD(swatCop, 285)
	
	-- Cadet
	--cadet = engineLoadTXD("skins/lvpd/wmysgrd.txd")
	--engineImportTXD(cadet, 71)
	
	----------------
	-- Gang Tags --
	----------------
	tag1 = engineLoadTXD("tags/tags_lafront.txd") -- vG logo
	engineImportTXD(tag1, 1524)
	
	tag2 = engineLoadTXD("tags/tags_lakilo.txd") -- MTA 
	engineImportTXD(tag2, 1525)

	-- tag3 = engineLoadTXD ( "tags/tags_larifa.txd" )
	-- engineImportTXD ( tag3, 1526 )

	-- tag4 = engineLoadTXD ( "tags/tags_larollin.txd" )
	-- engineImportTXD ( tag4, 1527 )

	-- tag5 = engineLoadTXD ( "tags/tags_laseville.txd" )
	-- engineImportTXD ( tag5, 1528 )

	-- tag6 = engineLoadTXD ( "tags/tags_latemple.txd" )
	-- engineImportTXD ( tag6, 1529 )

	-- tag7 = engineLoadTXD ( "tags/tags_lavagos.txd" )
	-- engineImportTXD ( tag7, 1530 )

	tag8 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Los Malvados
	engineImportTXD ( tag8, 1531 )
end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)