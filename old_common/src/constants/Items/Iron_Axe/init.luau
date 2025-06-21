local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Metal Axe" :: string,
	Description = "Used to evolve Metal!" :: string,

	ViewportCFrame = CFrame.new(0, -2.1, -7.5) * CFrame.Angles(math.pi / 2, 0, math.pi / 2) :: CFrame,
	PreviewViewport = CFrame.new(0, -2.1, -7.5) * CFrame.Angles(math.pi / 2, 0, math.pi / 2) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
