local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Ray's Lighter" :: string,
	Description = "Used to evolve Ray!" :: string,
	ViewportCFrame = CFrame.new(0.35, 0.3, -1.898) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(180)) :: CFrame,
	PreviewViewport = CFrame.new(0.35, 0.3, -1.898) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(180)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
