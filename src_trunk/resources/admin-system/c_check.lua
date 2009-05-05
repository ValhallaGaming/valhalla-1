CheckTimer = {}
playerElement = nil
function CreateCheckWindow()
	Window = {}
	Button = {}
	Label = {}
	Image = {}
	Window[1] = guiCreateWindow(28,271,454,248,"Player check.",false)
	--Button[1] = guiCreateButton(0.3524,0.8387,0.2026,0.0968,"Recon player.",true,Window[1])
	--addEventHandler( "onClientGUIClick", Button[1], ReconPlayer)
	--Button[2] = guiCreateButton(0.5705,0.8387,0.2026,0.0968,"Freeze player.",true,Window[1])
	--addEventHandler( "onClientGUIClick", Button[2], FreezePlayer)
	Button[3] = guiCreateButton(0.7885,0.8387,0.1894,0.0968,"Close window.",true,Window[1])
	addEventHandler( "onClientGUIClick", Button[3], CloseCheck )
	Label[1] = guiCreateLabel(0.0529,0.1331,0.9524,0.0887,"Name: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[1],"top")
	guiLabelSetHorizontalAlign(Label[1],"left",false)
	Label[2] = guiCreateLabel(0.0529,0.2056,0.3524,0.0887,"IP: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[2],"top")
	guiLabelSetHorizontalAlign(Label[2],"left",false)
	Label[3] = guiCreateLabel(0.0529,0.3823,0.9524,0.0887,"Money: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[3],"top")
	guiLabelSetHorizontalAlign(Label[3],"left",false)
	Label[4] = guiCreateLabel(0.0529,0.4556,0.2093,0.0806,"Health: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[4],"top")
	guiLabelSetHorizontalAlign(Label[4],"left",false)
	Label[5] = guiCreateLabel(0.2621,0.4516,0.2093,0.0806,"Armour: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[5],"top")
	guiLabelSetHorizontalAlign(Label[5],"left",false)
	Label[6] = guiCreateLabel(0.0529,0.5323,0.2093,0.0806,"Skin: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[6],"top")
	guiLabelSetHorizontalAlign(Label[6],"left",false)
	Label[7] = guiCreateLabel(0.2621,0.5242,0.2093,0.0806,"Weapon: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[7],"top")
	guiLabelSetHorizontalAlign(Label[7],"left",false)
	Label[8] = guiCreateLabel(0.0529,0.6048,0.4531,0.0806,"Faction: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[8],"top")
	guiLabelSetHorizontalAlign(Label[8],"left",false)
	Label[9] = guiCreateLabel(0.0529,0.6773,0.2093,0.0806,"Ping: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[9],"top")
	guiLabelSetHorizontalAlign(Label[9],"left",false)
	Label[10] = guiCreateLabel(0.0529,0.804,0.2093,0.0806,"Vehicle: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[10],"top")
	guiLabelSetHorizontalAlign(Label[10],"left",false)
	Label[11] = guiCreateLabel(0.0529,0.8806,0.2093,0.0806,"Vehicle ID: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[11],"top")
	guiLabelSetHorizontalAlign(Label[11],"left",false)
	Label[12] = guiCreateLabel(0.5441,0.4435,0.4031,0.0766,"Location: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[12],"top")
	guiLabelSetHorizontalAlign(Label[12],"left",false)
	Label[18] = guiCreateLabel(0.5441,0.36035,0.4031,0.0766,"Admin Reports: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[18],"top")
	guiLabelSetHorizontalAlign(Label[18],"left",false)
	Label[13] = guiCreateLabel(0.5441,0.5323,0.4031,0.0766,"X:",true,Window[1])
	guiLabelSetVerticalAlign(Label[13],"top")
	guiLabelSetHorizontalAlign(Label[13],"left",false)
	Label[14] = guiCreateLabel(0.5441,0.6169,0.4031,0.0766,"Y: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[14],"top")
	guiLabelSetHorizontalAlign(Label[14],"left",false)
	Label[15] = guiCreateLabel(0.5441,0.7056,0.4031,0.0766,"Z: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[15],"top")
	guiLabelSetHorizontalAlign(Label[15],"left",false)
	Label[16] = guiCreateLabel(0.6674,0.129,0.2907,0.0806,"Interior: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[16],"top")
	guiLabelSetHorizontalAlign(Label[16],"left",false)
	Label[17] = guiCreateLabel(0.6674,0.1935,0.2907,0.0806,"Dimension: N/A",true,Window[1])
	guiLabelSetVerticalAlign(Label[17],"top")
	guiLabelSetHorizontalAlign(Label[17],"left",false)
	Image[1] = guiCreateStaticImage(0.4758,0.1089,0.1278,0.2177,"search.png",true,Window[1])
	guiSetVisible(Window[1], false)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),

        function ()
                CreateCheckWindow()
        end
)


function OpenCheck(watcher,noob,x,y,z,ip,health,armour,skin,weapon,team,ping,carid,carname,loc,int,world,gameaccountusername, money, bankmoney, adminreports)
	playerElement = noob
	guiSetText ( Label[1], "Name: " .. noob .. " (" .. gameaccountusername .. ")")
	guiSetText ( Label[13], "X: " .. x )
	guiSetText ( Label[14], "Y: " .. y )
	guiSetText ( Label[15], "Z: " .. z )
	guiSetText ( Label[2], "IP: " .. ip )
	guiSetText ( Label[3], "Money: " .. money .. "$ (Bank: " .. bankmoney .. "$)")
	guiSetText ( Label[4], "Health: " .. health )
	guiSetText ( Label[5], "Armour: " .. armour )
	guiSetText ( Label[6], "Skin: " .. skin )
	guiSetText ( Label[7], "Weapon: " .. weapon )
	if(team ~= nil) then
		guiSetText ( Label[8], "Faction: " .. team )
	else
		guiSetText ( Label[8], "Faction: N/A")
	end
	guiSetText ( Label[9], "Ping: " .. ping )
	if(carname ~= nil) then
		guiSetText ( Label[10], "Vehicle: " .. carname )
		guiSetText ( Label[11], "Vehicle ID: " .. carid )
	else
		guiSetText ( Label[10], "Vehicle: N/A")
		guiSetText ( Label[11], "Vehicle ID: N/A")
	end
	guiSetText ( Label[12], "Location: " .. loc)
	guiSetText ( Label[16], "Interior: " .. int)
	guiSetText ( Label[17], "Dimension: " .. world)
	guiSetText ( Label[18], "Admin Reports: " .. adminreports)
	if(guiGetVisible ( Window[1] ) == false) then
		guiSetVisible(Window[1], true)
		showCursor ( true )
		local event = function() triggerServerEvent ( "onChecking", getRootElement(), watcher,noob) end
		--CheckTimer = setTimer( event, 2000, 0)
	end 
		
end

addEvent( "onCheck", true )
addEventHandler( "onCheck", getRootElement(), OpenCheck )

function CloseCheck(sourcePlayer, command)
	guiSetVisible(Window[1], false)
	showCursor ( false )
	if(CheckTimer ~= false and CheckTimer ~= nil) then
	end

end

function ReconPlayer()
	triggerServerEvent("remoteReconPlayer", getLocalPlayer(), getLocalPlayer(), "recon", playerElement)
end

function FreezePlayer()
	triggerServerEvent("remoteFreezePlayer", getLocalPlayer(), getLocalPlayer(), "freeze", playerElement)
end
