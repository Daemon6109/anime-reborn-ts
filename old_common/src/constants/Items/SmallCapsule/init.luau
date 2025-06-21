local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Small Capsule" :: string,
	Description = "Used to level up your unit!" :: string,
	ViewportCFrame = CFrame.new(0, -0.1, -1.5) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) :: CFrame,
	Rarity = "Rare" :: string,
	Usable = false :: boolean,
	Sort = { "Food" },
	FoodXP = 20,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
