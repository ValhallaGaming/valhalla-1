function getPaid(collectionValue)
	exports.global:giveMoney(source, tonumber(collectionValue))
	exports.global:sendLocalMeAction(source,"hands his collection of photographs to the woman behind the desk.")
	local pedX, pedY, pedZ = getElementPosition( source )
	local chatSphere = createColSphere( pedX, pedY, pedZ, 10 )
	exports.pool:allocateElement(chatSphere) -- Create the colSphere for chat output to local players.
	local targetPlayers = getElementsWithinColShape( chatSphere, "player" )
	local name = string.gsub(getPlayerName(source), "_", " ")
	for i, key in ipairs( targetPlayers ) do
		outputChatBox("Victoria Greene says: Thank you. These should make the morning edition. Keep up the good work.", key, 255, 255, 255)
	end
	destroyElement(chatSphere)
	outputChatBox("#FF9933You made $".. collectionValue .." from the photographs.", source, 255, 104, 91, true)
end
addEvent("submitCollection", true)
addEventHandler("submitCollection", getRootElement(), getPaid)