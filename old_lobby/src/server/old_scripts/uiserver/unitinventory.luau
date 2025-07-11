local ServerScripts = game:GetService("ServerScriptService")
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local RaidShop = {
	Gold = function(player: Player)
		local PlayerService = _G.serverServices.PlayerService
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local Currencies = PlayerProfileClass:GetField("Currencies")
		if Currencies["Gold"] < 50_000 then
			return
		end

		PlayerService:GiveCurrency(player, "Gold", -50_000)

		local Inventory = PlayerProfileClass:GetField("Inventory")
		local UnitStorage = Inventory.MaxUnitStorage
		UnitStorage += 50
		PlayerProfileClass:ReplicateField("Currencies")
		PlayerProfileClass:WriteDirectory("Inventory/MaxUnitStorage", UnitStorage, true)
	end,
	Gems = function(player)
		local PlayerService = _G.serverServices.PlayerService
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

		local Currencies = PlayerProfileClass:GetField("Currencies")
		if Currencies["Gems"] < 7_500 then
			return
		end

		PlayerService:GiveCurrency(player, "Gems", -7_500)

		local Inventory = PlayerProfileClass:GetField("Inventory")
		local UnitStorage = Inventory.MaxUnitStorage
		UnitStorage += 50
		PlayerProfileClass:ReplicateField("Currencies")
		PlayerProfileClass:WriteDirectory("Inventory/MaxUnitStorage", UnitStorage, true)
	end,
}

return RaidShop
