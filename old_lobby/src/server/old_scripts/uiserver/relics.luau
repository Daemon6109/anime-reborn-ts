local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local NotifyRemote = game:GetService("ReplicatedStorage").Events.NotifyPlayer

local function GetUnitWithRelic(player, relic)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local Inventory = PlayerProfile:GetField("Inventory")
	local Units = Inventory.Units

	for id, data in Units do
		if data.Relic == relic then
			return id
		end
	end
end

local Relics = {
	EquipRelic = function(player, unit, relic)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Inventory = PlayerProfile:GetField("Inventory")
		local Units = Inventory.Units
		local Items = Inventory.Items

		local RelicsServer = _G.serverServices.RelicsServer

		if Units[unit] and Items[relic] then
			local IsEquipped = GetUnitWithRelic(player, relic)

			if IsEquipped then
				RelicsServer:UnequipRelic(player, IsEquipped)
			end

			RelicsServer:EquipRelic(player, unit, relic)

			NotifyRemote:FireClient(player, {
				text = `Equipped relic!`,
				color = "Success",
			})
		end
	end,

	UnequipRelic = function(player, relic)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Inventory = PlayerProfile:GetField("Inventory")
		local Items = Inventory.Items

		local RelicsServer = _G.serverServices.RelicsServer

		if Items[relic] then
			local Unit = GetUnitWithRelic(player, relic)

			if Unit then
				RelicsServer:UnequipRelic(player, Unit)

				NotifyRemote:FireClient(player, {
					text = `Unequipped relic!`,
					color = "Success",
				})
			end
		end
	end,
}

return Relics
