local Item = {}

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Slots Capsule" :: string,
	DisplayIcon = "rbxassetid://130577771455565" :: string,
	Description = "Unlockable after the completion of infinite castle season 2!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -2.4) * CFrame.Angles(math.rad(0), 0, 0) :: CFrame,
	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
	RequestAmountOnUsage = true,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

Item.ClientCallback = function()
	local Notify = require(game.ReplicatedStorage.Libs.NotificationLib)
	Notify("Error", "Try again after the season ends!")
	return

	--[[game.Players.LocalPlayer:SetAttribute("Summoning", true)
	
	_G.WindowManager:CloseWindow("ItemInventory")]]
end

Item.ClientCheck = function(amount)
	local Notify = require(game.ReplicatedStorage.Libs.NotificationLib)
	Notify("Error", "Try again after the season ends!")
	return

	--[[local DataAccess = require(game.ReplicatedStorage.Libs.DataAccessAPIClient)
	local Notify = require(game.ReplicatedStorage.Libs.NotificationLib)
	local DataAPI = DataAccess:GetAPI()
	local PlayerProfile = DataAPI:GetLocalProfileClass()
	
	local Inventory = PlayerProfile:GetField("Inventory")
	
	if Length(Inventory.Units) + amount > Inventory.MaxUnitStorage then
		Notify("Error", "Your unit storage is full!")
		return 
	end
	
	return true]]
end

return Item
