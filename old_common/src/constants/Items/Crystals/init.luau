local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Crystals" :: string,
	Description = "I wonder what I can do with those.." :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.5) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -3.25) :: CFrame,
	Rarity = "Legendary",
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
