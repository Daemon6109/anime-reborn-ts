local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Special Eye" :: string,
	Description = "Used to evolve Itaha!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.5) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
