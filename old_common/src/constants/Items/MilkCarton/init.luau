local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Milk Carton" :: string,
	Description = "Used to evolve Mr. Shrimpy!" :: string,
	ViewportCFrame = CFrame.new(0.185, 0, -2.15) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(35)) :: CFrame,
	PreviewViewport = CFrame.new(0.185, 0, -2.15) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(35)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
