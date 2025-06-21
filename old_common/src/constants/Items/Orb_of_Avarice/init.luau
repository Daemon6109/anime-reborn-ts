local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Sphere Of Flame" :: string,
	Description = "Used to evolve Chui!" :: string,

	ViewportCFrame = CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -5) * CFrame.Angles(0, math.pi, 0) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
