local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Grimoire Pages" :: string,
	Description = "Ancient pages, I wonder what I can do with them.." :: string,

	ViewportCFrame = CFrame.new(0, 0, -4) * CFrame.Angles(0, math.rad(-90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -5) * CFrame.Angles(0, math.rad(-90), 0) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
