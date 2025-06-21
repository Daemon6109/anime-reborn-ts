local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Magic Mask" :: string,
	Description = "Used to evolve King Rimura!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
