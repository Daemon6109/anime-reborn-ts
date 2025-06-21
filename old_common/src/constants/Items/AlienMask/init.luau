local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Alien Mask" :: string,
	Description = "Used to evolve Spiral!" :: string,
	ViewportCFrame = CFrame.new(0.1, 0.1, -1.85) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(0)) :: CFrame,
	PreviewViewport = CFrame.new(0.1, 0.1, -1.85) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(0)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
