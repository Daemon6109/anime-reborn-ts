local Item = {}

Item.Limit = 10

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Magic Necklaces" :: string,
	Description = "Buffs damage by 15% in Ancient Dungeon. (stacks)" :: string,

	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(15), math.pi, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -3.25) * CFrame.Angles(0, math.pi, 0) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
