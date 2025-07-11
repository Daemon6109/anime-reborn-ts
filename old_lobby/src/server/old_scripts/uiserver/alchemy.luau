local AnalyticsService = game:GetService("AnalyticsService")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local registry = _G.Registry.registry
local itemRegistry = registry.Items
local potionRegistry = registry.Potions

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local uiCommunication = game.ReplicatedStorage.Events.UiCommunication
local Alchemy = {
	Brew = function(player: Player, potion: string)
		local itemManager = _G.serverServices.ItemManager
		if not itemManager then
			return
		end
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Inventory = PlayerProfile:GetField("Inventory").Items

		local _FoundInRegistry = potionRegistry[potion]

		if _FoundInRegistry then
			local potionConfig = _FoundInRegistry.configuration
			local itemConfig = itemRegistry[potion].configuration

			local redstoneCount = Inventory.Redstone and Inventory.Redstone.Count or 0

			if redstoneCount >= potionConfig.RedstoneCost then
				local requirementTable = {}
				for i, v in potionConfig.Recipe do
					local count = Inventory[v.Name] and Inventory[v.Name].Count or 0
					if count < v.Cost then
						return
					end
					requirementTable[v.Name] = v.Cost * -1
				end
				requirementTable[potion] = 1
				requirementTable["Redstone"] = potionConfig.RedstoneCost * -1

				trackEngagement(player, "Alchemy")

				itemManager:GiveItems(player, requirementTable)
				uiCommunication:FireClient(player, "Alchemy/PotionBrewed", potion)
			end
		end
	end,
}

return Alchemy
