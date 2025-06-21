local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Menos Mask" :: string,
	Description = "Used to level up your unit!" :: string,
	ViewportCFrame = CFrame.new(0.1, -0.1, -2) * CFrame.Angles(-math.pi / 2, math.pi, 0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.1, -2) * CFrame.Angles(-math.pi / 2, math.pi, 0) :: CFrame,
	Rarity = "Legendary" :: string,
	Usable = false :: boolean,
	Sort = { "Food" },
	FoodXP = 175,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
