function CreateCarList()

 
	Window = {}
	TabPanel = {}
	Tab = {}
	Button = {}
	Image = {}
	Window[1] = guiCreateWindow(354,187,316,417,"Vehicle ID list.",false)
	TabPanel[2] = guiCreateTabPanel(701,246,150,306,false)
	Tab[2] = guiCreateTab("MENU",TabPanel[2])
	Button[2] = guiCreateButton(0.0133,0.0065,0.9533,0.0523,"SUV and wagon.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[2], SUV ,false)
	Button[3] = guiCreateButton(0.0133,0.0621,0.9533,0.0523,"2-door sedan.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[3], TwoDoor ,false)
	Button[4] = guiCreateButton(0.0133,0.1176,0.9533,0.0523,"4-door luxury sedan.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[4], FourDoor ,false)
	Button[5] = guiCreateButton(0.0133,0.1732,0.9533,0.0523,"muscle car.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[5], Muscle ,false)
	Button[6] = guiCreateButton(0.0133,0.2288,0.9533,0.0523,"street racer.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[6], Street ,false)
	Button[7] = guiCreateButton(0.0133,0.2843,0.9533,0.0523,"high performance.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[7], HighPer ,false)
	Button[8] = guiCreateButton(0.0133,0.3399,0.9533,0.0523,"heavy truck/utility.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[8], Heavy ,false)
	Button[9] = guiCreateButton(0.0133,0.3954,0.9533,0.0523,"light truck and van.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[9], Light ,false)
	Button[10] = guiCreateButton(0.0133,0.451,0.9533,0.0523,"lowrider.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[10], Lowrider ,false)
	Button[11] = guiCreateButton(0.0133,0.5621,0.9533,0.0523,"bike.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[11], Bike ,false)
	Button[12] = guiCreateButton(0.0133,0.5065,0.9533,0.0523,"recreational.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[12], Recreational ,false)
	Button[13] = guiCreateButton(0.0133,0.6176,0.9533,0.0523,"civil servant.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[13], Civil ,false)
	Button[14] = guiCreateButton(0.0133,0.6732,0.9533,0.0523,"commercial/gov.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[14], Commercial ,false)
	Button[15] = guiCreateButton(0.0133,0.7288,0.9533,0.0523,"aircraft.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[15], Air ,false)
	Button[16] = guiCreateButton(0.0133,0.7843,0.9533,0.0523,"boat.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[16], Boat ,false)
	Button[17] = guiCreateButton(0.0133,0.8399,0.9533,0.0523,"trailer.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[17], Trailer ,false)
	Button[18] = guiCreateButton(0.04,0.902,0.4467,0.0882,"Color list.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[18], OpenColors ,false)
	Button[19] = guiCreateButton(0.5,0.8987,0.4467,0.0882,"Close.",true,Tab[2])
	addEventHandler( "onClientGUIClick", Button[19], Close ,false)
	Window[2] = guiCreateWindow(177,250,667,247,"Vehicle color selection.",false)
	guiBringToFront(Window[2])
	Button[20] = guiCreateButton(0.8261,0.834,0.1304,0.1012,"Close window.",true,Window[2])
	addEventHandler( "onClientGUIClick", Button[20], CloseColors ,false)
	Button[1] = guiCreateLabel(0.0285,0.3046,0.9399,0.6403,"Use the panel on the right to navigate.",true,Window[1])
	guiLabelSetVerticalAlign(Button[1],"top")
	guiLabelSetHorizontalAlign(Button[1],"left",false)
	Image[1] = guiCreateStaticImage(0.081,0.1093,0.8366,0.668,"colors.png",true,Window[2])
	Image[2] = guiCreateStaticImage(0.0285,0.0528,0.943,0.211,"banner.png",true,Window[1])
	guiSetVisible(Window[1], false)
	guiSetVisible(TabPanel[2], false)
	guiSetVisible(Window[2], false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),

        function ()
                CreateCarList()
        end
)


function CarMenu(sourcePlayer, command)
	guiSetVisible(Window[1], true)
	guiSetVisible(TabPanel[2], true)
	guiSetInputEnabled(true)
	showCursor ( true )
end
addCommandHandler("carlist", CarMenu)

function OpenColors(sourcePlayer, command)
	
	guiSetVisible(Window[2], true)
	guiSetVisible(Window[1], false)
	guiSetVisible(TabPanel[2], false)
	
end

function CloseColors(sourcePlayer, command)
	
	guiSetVisible(Window[2], false)
	guiSetVisible(Window[1], true)
	guiSetVisible(TabPanel[2], true)
	
end


function Close( )
	guiSetVisible(Window[1], false)
	guiSetVisible(TabPanel[2], false)
	guiSetInputEnabled(false)
	showCursor ( false )
end 

function SUV( )

	xml = getResourceConfig("SUV.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 

function TwoDoor( )

	xml = getResourceConfig("twodoor.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function FourDoor( )

	xml = getResourceConfig("fourdoor.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Muscle( )

	xml = getResourceConfig("muscle.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 

function Street( )

	xml = getResourceConfig("street.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 

function HighPer( )

	xml = getResourceConfig("highper.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Heavy( )

	xml = getResourceConfig("heavy.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 

function Light( )

	xml = getResourceConfig("light.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Lowrider( )

	xml = getResourceConfig("lowrider.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Recreational( )

	xml = getResourceConfig("recreational.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Bike( )

	xml = getResourceConfig("bikes.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Civil( )

	xml = getResourceConfig("civil.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Commercial( )

	xml = getResourceConfig("commercial.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Air( )

	xml = getResourceConfig("air.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end

function Boat( )

	xml = getResourceConfig("boat.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 

function Trailer( )

	xml = getResourceConfig("trailer.xml")      
	cars = xmlNodeGetValue(xml)  
	guiSetText ( Button[1], cars)

end 