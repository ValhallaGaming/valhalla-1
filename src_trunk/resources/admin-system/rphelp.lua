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
			local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
			local tabRules = guiCreateTab( "Rules", tabPanel )
			local paneRules = guiCreateScrollPane(0.02, 0.02, 0.95, 0.95, true, tabRules)
			local tabRules2 = guiCreateTab( "Rules II", tabPanel )
			local paneRules2 = guiCreateScrollPane(0.02, 0.02, 0.95, 0.95, true, tabRules2)
			local tabOverview = guiCreateTab( "Roleplay Overview", tabPanel )
			local tabPowergaming = guiCreateTab( "Powergaming", tabPanel )
			local tabMetagaming = guiCreateTab( "Metagaming", tabPanel )
			local tabCommonSense = guiCreateTab( "Common Sense", tabPanel )
			local tabRevengeKilling = guiCreateTab( "Revenge Killing", tabPanel )
			---------
			guiScrollPaneSetScrollBars(paneRules, false, true)
			local xml1 = xmlLoadFile( "serverrules.xml" )
			local contents1 = xmlNodeGetValue( xml1 )
			local xml2 = xmlLoadFile( "serverrules2.xml" )
			local contents2 = xmlNodeGetValue( xml2 )
			local xml3 = xmlLoadFile( "whatisroleplaying.xml" )
			local contents3 = xmlNodeGetValue( xml3 )
			local xml4 = xmlLoadFile( "powergaming.xml" )
			local contents4 = xmlNodeGetValue( xml4 )
			local xml5 = xmlLoadFile( "metagaming.xml" )
			local contents5 = xmlNodeGetValue( xml5 )
			local xml6 = xmlLoadFile( "commonsense.xml" )
			local contents6 = xmlNodeGetValue( xml6 )
			local xml7 = xmlLoadFile( "revengekilling.xml" )
			local contents7 = xmlNodeGetValue( xml7 )

			---------
			guiCreateLabel(0.00,0.00,0.94,1.4,contents1,true,paneRules)
			guiCreateLabel(0.00,0.00,0.94,1.4,contents2,true,paneRules2)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents3,true,tabOverview)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents4,true,tabPowergaming)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents5,true,tabMetagaming)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents6,true,tabCommonSense)
			guiCreateLabel(0.02,0.04,0.94,0.92,contents7,true,tabRevengeKilling)
			showCursor ( true )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end