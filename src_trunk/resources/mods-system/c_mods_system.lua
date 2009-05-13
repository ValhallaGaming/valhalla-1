function applyMods(res)
	if (res==getThisResource()) then
		-----------------
		-- Police Skins--
		-----------------
		
		-- SFPD
		sfpd = engineLoadTXD("skins/lvpd/sfpd1.txd")
		engineImportTXD(sfpd, 281)
		
		swatCop = engineLoadTXD("skins/lvpd/swat.txd")
		engineImportTXD(swatCop, 285)
		
		-- Cadet
		cadet = engineLoadTXD("skins/lvpd/wmysgrd.txd")
		engineImportTXD(cadet, 71)

		----------------
		-- Gang Tags --
		----------------
		tag1 = engineLoadTXD("tags/tags_lafront.txd") -- vG logo
		engineImportTXD(tag1, 1524)
		
		-- tag2 = engineLoadTXD("tags_lakilo.txd") 
		-- engineImportTXD(tag2, 1525)
		
		-- tag3 = engineLoadTXD("tags_laseville.txd")
		-- engineImportTXD(tag2, 1528)

		-- tag3 = engineLoadTXD ( "tags/tags_larifa.txd" )
		-- engineImportTXD ( tag3, 1526 )

		-- tag4 = engineLoadTXD ( "tags/tags_larollin.txd" )
		-- engineImportTXD ( tag4, 1527 )

		tag5 = engineLoadTXD ( "tags/tags_laseville.txd" ) -- Dem Redsands Green Boys
		engineImportTXD ( tag5, 1528 )

		-- tag6 = engineLoadTXD ( "tags/tags_temple.txd" )
		-- engineImportTXD ( tag6, 1529 )

		--tag7 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Bay Crest Bloods
		--engineImportTXD ( tag7, 1530 )

		-- tag8 = engineLoadTXD ( "tags/tags_lavagos.txd" )
		-- engineImportTXD ( tag8, 1531 )
	end
end
addEventHandler("onClientResourceStart", getRootElement(), applyMods)