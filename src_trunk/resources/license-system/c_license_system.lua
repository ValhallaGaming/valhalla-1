wLicense, licenseList, bAcceptLicense, bCancel = nil
local ped = createPed(71, 356.29598999023, 161.48677062988, 1008.3762207031)
setPedRotation(ped, 271.4609375)
setElementDimension(ped, 125)
setElementInterior(ped, 3)

function showLicenseWindow()
	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wLicense= guiCreateWindow(x, y, width, height, "LVMPD Licensing", false)
	
	licenseList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wLicense)
    local column = guiGridListAddColumn(licenseList, "License", 0.7)
	local column2 = guiGridListAddColumn(licenseList, "Cost", 0.2)

	local vehiclelicense = getElementData(getLocalPlayer(), "license.car")
	
	if (vehiclelicense==0) then
		local row = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row, column, "Car License", false, false)
		guiGridListSetItemText(licenseList, row, column2, "450", true, false)
	end
	
	local weaponlicense = getElementData(getLocalPlayer(), "license.gun")
	
	if (weaponlicense==0) then
		local row2 = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row2, column, "Weapon License", false, false)
		guiGridListSetItemText(licenseList, row2, column2, "4000", true, false)
	end
	
	bAcceptLicense = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Buy License", true, wLicense)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, wLicense)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptLicense, acceptLicense)
	addEventHandler("onClientGUIClick", bCancel, cancelLicense)
end
addEvent("onLicense", true)
addEventHandler("onLicense", getRootElement(), showLicenseWindow)

function acceptLicense(button, state)
	if (source==bAcceptLicense) and (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Please select a license first!", 255, 0, 0)
		else
			local license = 0
			local licensetext = guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 1)
			local licensecost = tonumber(guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 2))
			
			if (licensetext=="Car License") then
				license = 1
			elseif (licensetext=="Weapon License") then
				license = 2
			end
			
			if (license>0) then
				local money = getElementData(getLocalPlayer(), "money")
				outputDebugString(tostring(licensecost))
				if (money<licensecost) then
					outputChatBox("You cannot afford this license.", 255, 0, 0)
				else
					triggerServerEvent("acceptLicense", getLocalPlayer(), license, licensecost)
					destroyElement(licenseList)
					destroyElement(bAcceptLicense)
					destroyElement(bCancel)
					destroyElement(wLicense)
					wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
					showCursor(false)
				end
			end
		end
	end
end

function cancelLicense(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(licenseList)
		destroyElement(bAcceptLicense)
		destroyElement(bCancel)
		destroyElement(wLicense)
		wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end