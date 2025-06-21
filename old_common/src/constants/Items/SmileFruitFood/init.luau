local Item = {}

Item.Limit = 5000

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Smile Fruit" :: string,
	Description = "An ancient fruit, used as a food item!" :: string,
	ViewportCFrame = CFrame.new(0, -0.1, -4.25) * CFrame.Angles(math.rad(-90), math.rad(0), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -4.25) * CFrame.Angles(math.rad(-90), math.rad(0), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc", "Food" },
	FoodXP = 150,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
