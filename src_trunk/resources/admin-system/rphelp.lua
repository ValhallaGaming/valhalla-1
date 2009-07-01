myWindow = nil
pressed = false
----------------------[KEY BINDS]--------------------
function bindKeys()
	bindKey("F1", "down", F1RPhelp)
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function resetState()
	pressed = false
end

---------------------------[HELP]--------------------
function F1RPhelp( key, keyState )
	if not (pressed) then
		pressed = true
		setTimer(resetState, 200, 1)
		if ( myWindow == nil ) then
			myWindow = guiCreateWindow ( 0.20, 0.20, 0.6, 0.6, "Roleplay Information", true )
			tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
			tabRules = guiCreateTab( "Server Rules", tabPanel )
			tabOverview = guiCreateTab( "Roleplay Overview", tabPanel )
			tabPowergaming = guiCreateTab( "Powergaming", tabPanel )
			tabMetagaming = guiCreateTab( "Metagaming", tabPanel )
			tabCommonSense = guiCreateTab( "Common Sense", tabPanel )
			tabRevengeKilling = guiCreateTab( "Revenge Killing", tabPanel )
			---------

			local xml1 = xmlLoadFile( "serverrules.xml" )
			local contents1 = xmlNodeGetValue( xml1 )
			local xm2 = xmlLoadFile( "whatisroleplaying.xml" )
			local contents2 = xmlNodeGetValue( xm2 )
			local xml3 = xmlLoadFile( "powergaming.xml" )
			local contents3 = xmlNodeGetValue( xml3 )
			local xml4 = xmlLoadFile( "metagaming.xml" )
			local contents4 = xmlNodeGetValue( xml4 )
			local xml5 = xmlLoadFile( "commonsense.xml" )
			local contents5 = xmlNodeGetValue( xml5 )
			local xml6 = xmlLoadFile( "revengekilling.xml" )
			local contents6 = xmlNodeGetValue( xml6 )

			---------
			guiCreateLabel(0.02,0.04,0.94,0.92,contents1,true,tabRules)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents2,true,tabOverview)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents3,true,tabPowergaming)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents4,true,tabMetagaming)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents5,true,tabCommonSense)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents6,true,tabRevengeKilling)
			showCursor ( true )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end