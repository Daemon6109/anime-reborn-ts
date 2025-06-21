local Item = {}

Item.Limit = 10

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Rune Stones" :: string,
	Description = "Buffs damage by 15% in Golden Dungeon. (stacks)" :: string,

	ViewportCFrame = CFrame.new(0, 0, -1.5) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -3.25) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
