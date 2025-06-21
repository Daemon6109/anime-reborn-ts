local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Blood XP Drop" :: string,
	DisplayIcon = "rbxassetid://85886977542964" :: string,
	Description = "Levels a unit to 50% the level cap" :: string,
	ViewportCFrame = CFrame.new(0.1, -0.1, -2) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.1, -2) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Food" },
	FoodXP = 100,
	FoodXPPercent = 50,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
