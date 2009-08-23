function doesPlayerHaveAchievement(thePlayer, id)
	return call( getResourceFromName( "achievement-system" ), "doesPlayerHaveAchievement", thePlayer, id )
end

function givePlayerAchievement(thePlayer, id)
	return call( getResourceFromName( "achievement-system" ), "givePlayerAchievement", thePlayer, id )
end
