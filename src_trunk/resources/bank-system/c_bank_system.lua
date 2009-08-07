wBank, bClose, lBalance, tabPanel, tabPersonal, tabBusiness, lWithdrawP, tWithdrawP, bWithdrawP, lDepositP, tDepositP, bDepositP = nil
lWithdrawB, tWithdrawB, bWithdrawB, lDepositB, tDepositB, bDepositB, lBalanceB = nil
gfactionBalance = nil

local localPlayer = getLocalPlayer()

function showBankUI(isInFaction, isFactionLeader, factionBalance)
	if not (wBank) then
		local width, height = 600, 400
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wBank = guiCreateWindow(x, y, width, height, "Bank of Los Santos", false)
		guiWindowSetSizable(wCars, false)
		
		tabPanel = guiCreateTabPanel(0.05, 0.05, 0.9, 0.85, true, wBank)
		
		tabPersonal = guiCreateTab("Personal Banking", tabPanel)
		
		if (isInFaction) and (isFactionLeader) then
			tabBusiness = guiCreateTab("Business Banking", tabPanel)
			
			gfactionBalance = factionBalance
			
			lBalanceB = guiCreateLabel(0.1, 0.05, 0.9, 0.05, "Balance: " .. factionBalance .. "$", true, tabBusiness)
			guiSetFont(lBalanceB, "default-bold-small")
			
			-- WITHDRAWAL BUSINESS
			lWithdrawB = guiCreateLabel(0.1, 0.15, 0.2, 0.05, "Withdraw:", true, tabBusiness)
			guiSetFont(lWithdrawB, "default-bold-small")
			
			tWithdrawB = guiCreateEdit(0.22, 0.13, 0.2, 0.075, "0", true, tabBusiness)
			guiSetFont(tWithdrawB, "default-bold-small")
			
			bWithdrawB = guiCreateButton(0.44, 0.13, 0.2, 0.075, "Withdraw", true, tabBusiness)
			addEventHandler("onClientGUIClick", bWithdrawB, withdrawMoneyBusiness, false)
			
			-- DEPOSIT BUSINESS
			lDepositB = guiCreateLabel(0.1, 0.25, 0.2, 0.05, "Deposit:", true, tabBusiness)
			guiSetFont(lDepositB, "default-bold-small")
			
			tDepositB = guiCreateEdit(0.22, 0.23, 0.2, 0.075, "0", true, tabBusiness)
			guiSetFont(tDepositB, "default-bold-small")
			
			bDepositB = guiCreateButton(0.44, 0.23, 0.2, 0.075, "Deposit", true, tabBusiness)
			addEventHandler("onClientGUIClick", bDepositB, depositMoneyBusiness, false)
			
			-- TRANSFER BUSINESS
			lTransferB = guiCreateLabel(0.1, 0.45, 0.2, 0.05, "Transfer:", true, tabBusiness)
			guiSetFont(lTransferB, "default-bold-small")
			
			tTransferB = guiCreateEdit(0.22, 0.43, 0.2, 0.075, "0", true, tabBusiness)
			guiSetFont(tTransferB, "default-bold-small")
			
			bTransferB = guiCreateButton(0.44, 0.43, 0.2, 0.075, "Transfer to", true, tabBusiness)
			addEventHandler("onClientGUIClick", bTransferB, transferMoneyBusiness, false)
			
			eTransferB = guiCreateEdit(0.66, 0.43, 0.3, 0.075, "", true, tabBusiness)
		end
		
		bClose = guiCreateButton(0.75, 0.91, 0.2, 0.1, "Close", true, wBank)
		addEventHandler("onClientGUIClick", bClose, hideBankUI, false)
		
		local balance = getElementData(localPlayer, "bankmoney")
		
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
		
		-- TRANSFER PERSONAL
		lTransferP = guiCreateLabel(0.1, 0.45, 0.2, 0.05, "Transfer:", true, tabPersonal)
		guiSetFont(lTransferP, "default-bold-small")
		
		tTransferP = guiCreateEdit(0.22, 0.43, 0.2, 0.075, "0", true, tabPersonal)
		guiSetFont(tTransferP, "default-bold-small")
		
		bTransferP = guiCreateButton(0.44, 0.43, 0.2, 0.075, "Transfer to", true, tabPersonal)
		addEventHandler("onClientGUIClick", bTransferP, transferMoneyPersonal, false)
		
		eTransferP = guiCreateEdit(0.66, 0.43, 0.3, 0.075, "", true, tabPersonal)
		
		guiSetInputEnabled(true)
		
		outputChatBox("Welcome to The Bank of Los Santos")
	end
end
addEvent("showBankUI", true)
addEventHandler("showBankUI", getRootElement(), showBankUI)

function hideBankUI()		
	destroyElement(wBank)
	wBank = nil
		
	guiSetInputEnabled(false)
end
addEvent("hideBankUI", true)
addEventHandler("hideBankUI", getRootElement(), showBankUI)

function withdrawMoneyPersonal(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tWithdrawP))
		local money = getElementData(localPlayer, "bankmoney")
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("withdrawMoneyPersonal", localPlayer, amount)
		end
	end
end

function depositMoneyPersonal(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tDepositP))
		local money = getElementData(localPlayer, "money")
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("depositMoneyPersonal", localPlayer, amount)
		end
	end
end

function transferMoneyPersonal(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tTransferP))
		local money = getElementData(localPlayer, "bankmoney")
		local playername = guiGetText(eTransferP)
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		elseif playername == "" then
			outputChatBox("Please enter the full character name of the reciever!", 255, 0, 0)
		else
			triggerServerEvent("transferMoneyToPersonal", localPlayer, false, playername, amount) 
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
			triggerServerEvent("withdrawMoneyBusiness", localPlayer, amount)
		end
	end
end

function depositMoneyBusiness(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tDepositB))
		
		local money = getElementData(localPlayer, "money")

		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>money) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		else
			hideBankUI()
			triggerServerEvent("depositMoneyBusiness", localPlayer, amount)
		end
	end
end

function transferMoneyBusiness(button)
	if (button=="left") then
		local amount = tonumber(guiGetText(tTransferB))
		local playername = guiGetText(eTransferB)
		
		if (tostring(type(tonumber(amount)))~="number" or tonumber(amount)<=0) then
			outputChatBox("Please enter a number greater than 0!", 255, 0, 0)
		elseif (amount>gfactionBalance) then
			outputChatBox("You do not have enough funds.", 255, 0, 0)
		elseif playername == "" then
			outputChatBox("Please enter the full character name of the reciever!", 255, 0, 0)
		else
			triggerServerEvent("transferMoneyToPersonal", localPlayer, true, playername, amount) 
		end
	end
end