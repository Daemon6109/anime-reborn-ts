local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Light Concentrated Crystal" :: string,
	Description = "Used to evolve a special unit!" :: string,

	ViewportCFrame = CFrame.new(0, 0, -2.75) * CFrame.Angles(0, math.rad(-0), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -4) * CFrame.Angles(0, math.rad(-0), 0) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
