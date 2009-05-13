function applyMods(res)
	if (res==getThisResource()) then
		-----------------
		-- Police Skins--
		-----------------
		-- LSPD (Black officer)
		tenpen = engineLoadTXD("skins/lvpd/tenpen.txd")
		engineImportTXD(tenpen, 280)
		tenpenDff = engineLoadDFF ( "skins/lvpd/tenpen.dff", 280 )
		engineReplaceModel ( tenpenDff, 280 )
		
		-- SFPD
		sfpd = engineLoadTXD("skins/lvpd/sfpd1.txd")
		engineImportTXD(sfpd, 281)
		
		-- Female cop
		famaleCop = engineLoadTXD("skins/lvpd/gungrl3.txd")
		engineImportTXD(famaleCop, 191)
		femaleCopDff = engineLoadDFF ( "skins/lvpd/gungrl3.dff", 191 )
		engineReplaceModel ( femaleCopDff, 191 )
		
		-- Cadet
		cadet = engineLoadTXD("skins/lvpd/wmysgrd.txd")
		engineImportTXD(cadet, 71)
		
		-- Csher
		csher = engineLoadTXD("skins/lvpd/csher.txd")
		engineImportTXD(csher, 283)
		csherDff = engineLoadDFF ( "skins/lvpd/csher.dff", 283 )
		engineReplaceModel ( csherDff, 283 )

		----------------
		-- Civs Skins --
		----------------
		
		-- Hmori (Old mafia guy / brown suit)
		hmori = engineLoadTXD("skins/civs/hmori.txd")
		engineImportTXD(hmori, 43)
		hmoriDff = engineLoadDFF ( "skins/civs/hmori.dff", 43 )
		engineReplaceModel ( hmoriDff, 43 )

		----------------
		-- Gang Skins --
		----------------
		
		-- Grove (Green)
		fam1 = engineLoadTXD("skins/gangs/fam1.txd")
		engineImportTXD(fam1, 105)
		fam1Dff = engineLoadDFF ( "skins/gangs/fam1.dff", 105 )
		engineReplaceModel ( fam1Dff, 105 )
		
		fam2 = engineLoadTXD("skins/gangs/fam2.txd")
		engineImportTXD(fam2, 106)
		fam2Dff = engineLoadDFF ( "skins/gangs/fam2.dff", 106 )
		engineReplaceModel ( fam2Dff, 106 )
		
		fam3 = engineLoadTXD("skins/gangs/fam3.txd")
		engineImportTXD(fam3, 107)
		fam3Dff = engineLoadDFF ( "skins/gangs/fam3.dff", 107 )
		engineReplaceModel ( fam3Dff, 107 )
		
		-- Ballas (purple)
		ballas1 = engineLoadTXD("skins/gangs/balla1.txd")
		engineImportTXD(ballas1, 102)
		ballas1Dff = engineLoadDFF ( "skins/gangs/balla1.dff", 102 )
		engineReplaceModel ( ballas1Dff, 102 )
		
		ballas2 = engineLoadTXD("skins/gangs/balla2.txd")
		engineImportTXD(ballas2, 103)
		ballas2Dff = engineLoadDFF ( "skins/gangs/balla2.dff", 103)
		engineReplaceModel ( ballas2Dff, 103 )
		
		ballas3 = engineLoadTXD("skins/gangs/balla3.txd")
		engineImportTXD(ballas3, 104)
		ballas3Dff = engineLoadDFF ( "skins/gangs/balla3.dff", 104 )
		engineReplaceModel ( ballas3Dff, 104 )
		
		-- Vagos (yellow)
		lsv1 = engineLoadTXD("skins/gangs/lsv1.txd")
		engineImportTXD(lsv1, 108)
		lsv1Dff = engineLoadDFF ( "skins/gangs/lsv1.dff", 108 )
		engineReplaceModel ( lsv1Dff, 108 )
		
		lsv2 = engineLoadTXD("skins/gangs/lsv2.txd")
		engineImportTXD(lsv2, 109)
		lsv2Dff = engineLoadDFF ( "skins/gangs/lsv2.dff", 109)
		engineReplaceModel ( lsv2Dff, 109 )
		
		lsv3 = engineLoadTXD("skins/gangs/lsv3.txd")
		engineImportTXD(lsv3, 110)
		lsv3Dff = engineLoadDFF ( "skins/gangs/lsv3.dff", 110 )
		engineReplaceModel ( lsv3Dff, 110 )
		
		-- Aztecs (blue)
		vla1 = engineLoadTXD("skins/gangs/vla1.txd")
		engineImportTXD(vla1, 114)
		lsv1Dff = engineLoadDFF ( "skins/gangs/vla1.dff", 114 )
		engineReplaceModel ( vla1Dff, 114 )
		
		vla2 = engineLoadTXD("skins/gangs/vla2.txd")
		engineImportTXD(vla2, 115)
		vla2Dff = engineLoadDFF ( "skins/gangs/vla2.dff", 115)
		engineReplaceModel ( vla2Dff, 115 )
		
		vla3 = engineLoadTXD("skins/gangs/vla3.txd")
		engineImportTXD(vla3, 116)
		vla3Dff = engineLoadDFF ( "skins/gangs/vla3.dff", 116 )
		engineReplaceModel ( vla3Dff, 116 )

		-- Rifa (blue)
		-- sfr1 = engineLoadTXD("skins/gangs/vla1.txd")
		-- engineImportTXD(sfr1, 173)
		-- sfr1Dff = engineLoadDFF ( "skins/gangs/vla1.dff", 173 )
		-- engineReplaceModel ( sfr1Dff, 173 )
		
		-- sfr2 = engineLoadTXD("skins/gangs/vla2.txd")
		-- engineImportTXD(sfr2, 174)
		-- sfr2Dff = engineLoadDFF ( "skins/gangs/vla2.dff", 174)
		-- engineReplaceModel ( sfr2Dff, 174 )
		
		-- sfr3 = engineLoadTXD("skins/gangs/vla3.txd")
		-- engineImportTXD(sfr3, 175)
		-- sfr3Dff = engineLoadDFF ( "skins/gangs/vla3.dff", 175 )
		-- engineReplaceModel ( sfr3Dff, 175 )

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

		tag7 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Bay Crest Bloods
		engineImportTXD ( tag7, 1530 )

		-- tag8 = engineLoadTXD ( "tags/tags_lavagos.txd" )
		-- engineImportTXD ( tag8, 1531 )
	end
end
addEventHandler("onClientResourceStart", getRootElement(), applyMods)