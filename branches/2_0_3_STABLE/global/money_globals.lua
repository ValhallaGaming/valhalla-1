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
	if (tonumber(amount)>0) then
		local money = getElementData(thePlayer, "money")
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", money+tonumber(amount))
		givePlayerMoney(thePlayer, tonumber(amount))
	end
end

function takePlayerSafeMoney(thePlayer, amount)
	if (tonumber(amount)>0) then
		local money = getElementData(thePlayer, "money")
		
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", money-amount)
		takePlayerMoney(thePlayer, tonumber(amount))
	end
end

function setPlayerSafeMoney(thePlayer, amount)
	if (tonumber(amount)>=0) then
		local money = getElementData(thePlayer, "money")
		checkMoneyHacks(thePlayer)
		setElementData(thePlayer, "money", tonumber(amount))
		setPlayerMoney(thePlayer, tonumber(amount))
	end
end

function checkMoneyHacks(thePlayer)
	local safemoney = tonumber(getElementData(thePlayer, "money"))
	local hackmoney = getPlayerMoney(thePlayer)

	if (safemoney~=hackmoney) then
		--banPlayer(thePlayer, getRootElement(), "Money Hacks: " .. hackmoney .. "$.")
		return true
	else
		return false
	end
end