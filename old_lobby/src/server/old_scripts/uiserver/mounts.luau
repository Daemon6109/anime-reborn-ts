local AnalyticsService = game:GetService("AnalyticsService")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local MountsRegistry = _G.Registry.registry.Mounts

local DataAPI = DataAccess:GetAPI()

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local Mounts = {
	BuyMount = function(player, mount: string)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local MountsInventory = PlayerProfile:GetField("Inventory").Mounts
		local FoundInRegistry = MountsRegistry[mount]

		if not FoundInRegistry or MountsInventory[mount] then
			return
		end

		local MountInfo = FoundInRegistry.configuration
		local Price = MountInfo.PriceInGems

		if not Price or PlayerProfile:GetField("Currencies").Gems < Price then
			return
		end

		PlayerProfile:WriteDirectory("Currencies/Gems", PlayerProfile:GetField("Currencies").Gems - Price, true)

		trackEngagement(player, "BuyMount")

		_G.serverServices.MountsManager:GiveMount(player, mount)
	end,

	ToggleEquip = function(player, mount: string)
		if player:GetAttribute("ToggleMountCooldown") then
			return
		end --// Avoid bad use

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local MountsInventory = PlayerProfile:GetField("Inventory").Mounts

		if not MountsInventory[mount] then
			return
		end

		player:SetAttribute("ToggleMountCooldown", true)

		task.delay(0.5, function()
			player:SetAttribute("ToggleMountCooldown", nil)
		end)

		if PlayerProfile:GetField("EquippedMount") == mount then
			_G.serverServices.MountsManager:UnequipMount(player)
			PlayerProfile:WriteField("EquippedMount", "", true)
		else
			_G.serverServices.MountsManager:EquipMount(player, mount)
			PlayerProfile:WriteField("EquippedMount", mount, true)
		end
	end,
}

return Mounts
