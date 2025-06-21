local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Sky Shell (Dial)" :: string,
	Description = "Used to level up your unit!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.6) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	Rarity = "Rare" :: string,
	Usable = false :: boolean,
	Sort = { "Food" },
	FoodXP = 60,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
