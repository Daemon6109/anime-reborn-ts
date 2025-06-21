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
	DisplayName = "Winter Present (Epic)" :: string,
	Description = "An Epic present with gifts inside!" :: string,
	ViewportCFrame = CFrame.new(-0.1, -1.4, -4.33) * CFrame.Angles(math.rad(14), math.rad(45), math.rad(0)) :: CFrame,
	PreviewViewport = CFrame.new(-0.1, -1.4, -4.33) * CFrame.Angles(math.rad(14), math.rad(45), math.rad(0)) :: CFrame,
	Rarity = "Epic" :: string,
	Usable = true :: boolean,
	Sort = { "Misc" },
	RequestAmountOnUsage = true,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

Item.ClientCallback = function()
	game.Players.LocalPlayer:SetAttribute("Summoning", true)

	_G.WindowManager:CloseWindow("ItemInventory")
end

Item.ClientCheck = function(amount)
	local DataAccess = require(game.ReplicatedStorage.Libs.DataAccessAPIClient)
	local Notify = require(game.ReplicatedStorage.Libs.NotificationLib)
	local DataAPI = DataAccess:GetAPI()
	local PlayerProfile = DataAPI:GetLocalProfileClass()

	local Inventory = PlayerProfile:GetField("Inventory")

	if Length(Inventory.Units) + amount > Inventory.MaxUnitStorage then
		Notify("Error", "Your unit storage is full!")
		return
	end

	return true
end

return Item
