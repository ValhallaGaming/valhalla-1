function applyMods(res)
	if (res==getThisResource()) then
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
		-- Blackfield Stadium --
		------------------------
		BFStadium = engineLoadTXD("lv/vgs_stadium.txd")
		engineImportTXD(BFStadium, 8201)
		engineImportTXD(BFStadium, 8333)
		
		----------------
		-- Billboards --
		----------------
		-- UFA
		UFA1 = engineLoadTXD("lv/vgsn_billboard.txd")
		engineImportTXD(UFA1, 7309)
		engineImportTXD(UFA1, 7303)
		engineImportTXD(UFA1, 7301)
		
		------------------
		-- Police Skins --
		------------------
		-- LSPD
		lspd = engineLoadTXD("skins/lvpd/lapd1.txd")
		engineImportTXD(lspd, 280)
		
		-- SFPD
		sfpd = engineLoadTXD("skins/lvpd/sfpd1.txd")
		engineImportTXD(sfpd, 281)
		
		-- SWAT
		swatCop = engineLoadTXD("skins/lvpd/swat.txd")
		engineImportTXD(swatCop, 285)
		
		-- Cadet
		cadet = engineLoadTXD("skins/lvpd/wmysgrd.txd")
		engineImportTXD(cadet, 71)
		
		-----------
		-- Gangs --
		-----------
		-- Varios Los Aztecas (recolour to brown)
		vla1 = engineLoadTXD("skins/gangs/vla1.txd")
		engineImportTXD(vla1, 114)
		
		vla2 = engineLoadTXD("skins/gangs/vla2.txd")
		engineImportTXD(vla2, 115)
		
		vla3 = engineLoadTXD("skins/gangs/vla3.txd")
		engineImportTXD(vla3, 116)
		
		----------------
		-- Gang Tags --
		----------------
		tag1 = engineLoadTXD("tags/tags_lafront.txd") -- vG logo
		engineImportTXD(tag1, 1524)
		
		tag2 = engineLoadTXD("tags/tags_lakilo.txd") -- MTA 
		engineImportTXD(tag2, 1525)
		
		-- tag3 = engineLoadTXD("tags/tags_laseville.txd")
		-- engineImportTXD(tag2, 1528)

		-- tag3 = engineLoadTXD ( "tags/tags_larifa.txd" )
		-- engineImportTXD ( tag3, 1526 )

		-- tag4 = engineLoadTXD ( "tags/tags_larollin.txd" )
		-- engineImportTXD ( tag4, 1527 )

		tag5 = engineLoadTXD ( "tags/tags_laseville.txd" ) -- Dem Redsands Green Boys
		engineImportTXD ( tag5, 1528 )

		-- tag6 = engineLoadTXD ( "tags/tags_temple.txd" )
		-- engineImportTXD ( tag6, 1529 )

		tag7 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Bay Crest Bloods
		engineImportTXD ( tag7, 1530 )

		-- tag8 = engineLoadTXD ( "tags/tags_lavagos.txd" )
		-- engineImportTXD ( tag8, 1531 )
	end
end
addEventHandler("onClientResourceStart", getRootElement(), applyMods)