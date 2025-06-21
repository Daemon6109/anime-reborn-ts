local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Demon Blood Vial" :: string,
	DisplayIcon = "rbxassetid://90069901255429" :: string,
	Description = "Levels a unit to the level cap" :: string,
	ViewportCFrame = CFrame.new(0.1, -0.1, -4.25) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.1, -4.25) :: CFrame,
	Rarity = "Secret" :: string,
	Usable = false :: boolean,
	Sort = { "Food" },
	FoodXP = 100,
	FoodXPPercent = 100,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
