local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Kirit's Gun" :: string,
	Description = "Used to evolve Kirit!" :: string,
	ViewportCFrame = CFrame.new(0.5, 0, -2) * CFrame.Angles(math.rad(90), math.rad(0), 0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, 0, -2) * CFrame.Angles(math.rad(90), math.rad(0), 0) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
