wBank, bClose, lBalance, tabPanel, tabPersonal, tabBusiness, lWithdrawP, tWithdrawP, bWithdrawP, lDepositP, tDepositP, bDepositP = nil
lWithdrawB, tWithdrawB, bWithdrawB, lDepositB, tDepositB, bDepositB, lBalanceB = nil
gfactionBalance = nil

function showBankUI(isInFaction, isFactionLeader, factionBalance)
	if not (wBank) then
		local width, height = 600, 400
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wBank = guiCreateWindow(x, y, width, height, "Bank of Las Venturas", false)
		guiWindowSetSizable(wCars, false)
		
		tabPanel = guiCreateTabPanel(0.05, 0.05, 0.9, 0.85, true, wBank)
		
		tabPersonal = guiCreateTab("Personal Banking", tabPanel)
		
		if (isInFaction) and (isFactionLeader) then
			tabBusiness = guiCreateTab("Business Banking", tabPanel)
			
			gfactionBalance = factionBalance
			
			lBalanceB = guiCreateLabel(0.1, 0.05, 0.9, 0.05, "Balance: " .. factionBalance .. "$", true, tabBusiness)
			guiSetFont(lBalanceB, "default-bold-small")
			
			-- WITHDRAWAL PERSONAL
			lWithdrawB = guiCreateLabel(0.1, 0.15, 0.2, 0.05, "Withdraw:", true, tabBusiness)
			guiSetFont(lWithdrawB, "default-bold-small")
			
			tWithdrawB = guiCreateEdit(0.22, 0.13, 0.2, 0.075, "0", true, tabBusiness)
			guiSetFont(tWithdrawB, "default-bold-small")
			
			bWithdrawB = guiCreateButton(0.44, 0.13, 0.2, 0.075, "Withdraw", true, tabBusiness)
			addEventHandler("onClientGUIClick", bWithdrawB, withdrawMoneyBusiness, false)
			
			-- DEPOSIT PERSONAL
			lDepositB = guiCreateLabel(0.1, 0.25, 0.2, 0.05, "Deposit:", true, tabBusiness)
			guiSetFont(lDepositB, "default-bold-small")
			
			tDepositB = guiCreateEdit(0.22, 0.23, 0.2, 0.075, "0", true, tabBusiness)
			guiSetFont(tDepositB, "default-bold-small")
			
			bDepositB = guiCreateButton(0.44, 0.23, 0.2, 0.075, "Deposit", true, tabBusiness)
			addEventHandler("onClientGUIClick", bDepositB, depositMoneyBusiness, false)
		end
		
		bClose = guiCreateButton(0.75, 0.91, 0.2, 0.1, "Close", true, wBank)
		addEventHandler("onClientGUIClick", bClose, hideBankUI, false)
		
		local balance = getElementData(getLocalPlayer(), "bankmoney")
		
		lBalance = guiCreateLabel(0.1, 0.05, 0.9, 0.05, "Balance: " .. balance .. "$", true, tabPersonal)
		guiSetFont(lBalance, "default-bold-small")
		
		-- WITHDRAWAL PERSONAL
		lWithdrawP = guiCreateLabel(0.1, 0.15, 0.2, 0.05, "Withdraw:", true, tabPersonal)
		guiSetFont(lWithdrawP, "default-bold-small")
		
		tWithdrawP = guiCreateEdit(0.22, 0.13, 0.2, 0.075, "0", true, tabPersonal)
		guiSetFont(tWithdrawP, "default-bold-small")
		
		bWithdrawP = guiCreateButton(0.44, 0.13, 0.2, 0.075, "Withdraw", true, tabPersonal)
		addEventHandler("onClientGUIClick", bWithdrawP, withdrawMoneyPersonal, false)
		
		-- DEPOSIT PERSONAL
		lDepositP = guiCreateLabel(0.1, 0.25, 0.2, 0.05, "Deposit:", true, tabPersonal)
		guiSetFont(lDepositP, "default-bold-small")
		
		tDepositP = guiCreateEdit(0.22, 0.23, 0.2, 0.075, "0", true, tabPersonal)
		guiSetFont(tDepositP, "default-bold-small")
		
		bDepositP = guiCreateButton(0.44, 0.23, 0.2, 0.075, "Deposit", true, tabPersonal)
		addEventHandler("onClientGUIClick", bDepositP, depositMoneyPersonal, false)
		
		guiSetInputEnabled(true)
		
		outputChatBox("Welcome to The Bank of Las Venturas")
	end
end
addEvent("showBankUI", true)
addEventHandler("showBankUI", getRootElement(), showBankUI)

function hideBankUI()
	destroyElement(bClose)
	bClose = nil
	
	destroyElement(lBalance)
	lBalance = nil
	
	destroyElement(tabPersonal)
	tabPersonal = nil
	
	if (tabBusiness) then
		destroyElement(tabBusiness)
		tabBusiness = nil
		
		destroyElement(lBalanceB)
		lBalanceB = nil
		
		destroyElement(lWithdrawB)
		lWithdrawB = nil
		
		destroyElement(tWithdrawB)
		tWithdrawB = nil
		
		destroyElement(bWithdrawB)
		bWithdrawB = nil
		
		destroyElement(lDepositB)
		lDepositB = nil
		
		destroyElement(tDepositB)
		tDepositB = nil
		
		destroyElement(bDepositB)
		bDepositB = nil
	end
	
	destroyElement(lWithdrawP)
	lWithdrawP = nil
		
	destroyElement(tWithdrawP)
	tWithdrawP = nil
		
	destroyElement(bWithdrawP)
	bWithdrawP = nil
		
	destroyElement(lDepositP)
	lDepositP = nil
		
	destroyElement(tDepositP)
	tDepositP = nil
		
	destroyElement(bDepositP)
	bDepositP = nil
	
	destroyElement(wBank)
	wBank = nil
	
	guiSetInputEnabled(false)
end

function withdrawMoneyPersonal(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tWithdrawP))
		local money = getElementData(getLocalPlayer(), "bankmoney")
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("withdrawMoneyPersonal", getLocalPlayer(), amount)
		end
	end
end

function depositMoneyPersonal(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tDepositP))
		local money = getElementData(getLocalPlayer(), "money")
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("depositMoneyPersonal", getLocalPlayer(), amount)
		end
	end
end

function withdrawMoneyBusiness(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tWithdrawB))
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>gfactionBalance) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("withdrawMoneyBusiness", getLocalPlayer(), amount)
		end
	end
end

function depositMoneyBusiness(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tDepositB))
		
		local money = getElementData(getLocalPlayer(), "money")

		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("depositMoneyBusiness", getLocalPlayer(), amount)
		end
	end
end