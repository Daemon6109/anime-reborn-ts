local Item = {}

Item.Limit = 5000
Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Smile Fruit" :: string,
	Description = "Used to craft items to evolve units! Also used as a food item." :: string,
	ViewportCFrame = CFrame.new(0, -0.1, -1.5) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc", "Food" },
	FoodXP = 80,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
