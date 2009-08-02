function applyPDModels(res)
	if (res==getThisResource()) then
		-- tags
		tag1 = engineLoadTXD("tags_lafront.txd")
		engineImportTXD(tag1, 1524)
		-- tag2 = engineLoadTXD("tags_lakilo.txd")
		-- engineImportTXD(tag2, 1525)
		tag3 = engineLoadTXD("tags_laseville.txd")
		engineImportTXD(tag2, 1528)
	end
end
--addEventHandler("onClientResourceStart", getRootElement(), applyPDModels)