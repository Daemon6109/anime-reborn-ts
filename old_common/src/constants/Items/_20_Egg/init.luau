local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "20% Egg" :: string,
	Description = "20% Egg, I wonder what I can do with them.." :: string,

	ViewportCFrame = CFrame.new(0, 0, -10) * CFrame.Angles(math.rad(15), math.rad(-150), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -10) * CFrame.Angles(0, math.rad(-150), 0) :: CFrame,

	Usable = true :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
