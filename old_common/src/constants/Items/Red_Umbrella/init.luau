local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Umbrella" :: string,
	Description = "Used to evolve a special unit!" :: string,

	ViewportCFrame = CFrame.new(-0.5, -0.15, -5) * CFrame.Angles(math.rad(-45), math.rad(-45), math.rad(-90)) :: CFrame,
	PreviewViewport = CFrame.new(-0.5, -0.1, -7) * CFrame.Angles(math.rad(-45), math.rad(-45), math.rad(-90)) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
