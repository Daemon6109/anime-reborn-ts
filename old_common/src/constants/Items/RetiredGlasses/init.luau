local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Retired Glasses" :: string,
	Description = "Used to evolve Retired Hitman!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.35) * CFrame.Angles(math.rad(180), math.rad(0), math.rad(135)) :: CFrame,
	PreviewViewport = CFrame.new(-0.245, 0, -2.35) * CFrame.Angles(math.rad(180), math.rad(0), math.rad(135)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
