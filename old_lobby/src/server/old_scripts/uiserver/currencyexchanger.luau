local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local GemsRequiredPer = 3

local module = {
	Convert = function(player, amount)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if amount ~= amount or not tonumber(amount) then
			return
		end

		amount = math.floor(math.abs(tonumber(amount)))
		amount = math.clamp(amount, GemsRequiredPer, math.huge)

		if amount % GemsRequiredPer ~= 0 then
			amount -= amount % GemsRequiredPer
		end

		local Converted = PlayerProfile:GetField("CurrencyExchangerData").Exchanged

		if (amount + Converted) > 30000 then
			return
		end

		if PlayerProfile:GetField("Currencies").Gems >= amount then
			PlayerProfile:WriteDirectory("CurrencyExchangerData/Exchanged", amount + Converted, true)

			_G.serverServices.PlayerService:GiveCurrency(player, "Gems", -amount)
			_G.serverServices.PlayerService:GiveCurrency(player, "Candy Cane", math.floor(amount / GemsRequiredPer))
		end
	end,
}

return module
