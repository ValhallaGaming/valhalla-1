--TAX
tax = 15 -- percent

function randomizeTax()
	tax = math.random(5, 30)
end
setTimer(randomizeTax, 3600000, 0)
randomizeTax()

function getTaxAmount()
	return (tax/100)
end

--INCOME TAX
tax = 10 -- percent


function randomizeIncomeTax()
	tax = math.random(1, 25)
end
setTimer(randomizeIncomeTax, 3600000, 0)
randomizeIncomeTax()

function getIncomeTaxAmount()
	return (tax/100)
end



function givePlayerSafeMoney(thePlayer, amount)
	if thePlayer and isElement(thePlayer) and tonumber(amount) > 0 then
		amount = math.floor( amount )
		local money = getElementData(thePlayer, "money")
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", money+tonumber(amount))
		return givePlayerMoney(thePlayer, tonumber(amount))
	end
	return false
end

function takePlayerSafeMoney(thePlayer, amount)
	if thePlayer and isElement(thePlayer) and tonumber(amount) > 0 then
		amount = math.ceil( amount )
		local money = getElementData(thePlayer, "money")
		
		if (amount>=money) then
			amount = money
		end
		
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", money-amount)
		return takePlayerMoney(thePlayer, tonumber(amount))
	end
	return false
end

function setPlayerSafeMoney(thePlayer, amount)
	if thePlayer and isElement(thePlayer) and tonumber(amount) >= 0 then
		amount = math.floor( amount )
		local money = getElementData(thePlayer, "money")
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", tonumber(amount))
		return setPlayerMoney(thePlayer, tonumber(amount))
	end
	return false
end

function checkMoneyHacks(thePlayer)
	if not getElementData(thePlayer, "money") then return end
	
	local safemoney = tonumber(getElementData(thePlayer, "money"))
	local hackmoney = getPlayerMoney(thePlayer)

	if (safemoney~=hackmoney) then
		--banPlayer(thePlayer, getRootElement(), "Money Hacks: " .. hackmoney .. "$.")
		setPlayerMoney(thePlayer, safemoney)
		sendMessageToAdmins("Possible money hack detected: "..getPlayerName(thePlayer))
		return true
	else
		return false
	end
end