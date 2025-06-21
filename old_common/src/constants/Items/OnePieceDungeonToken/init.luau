local Item = {}

Item.Limit = 1_000_000

Item.configuration = {
	TrueName = script.Name :: string,

	DisplayName = "Belli Coin" :: string,
	Description = "Belli Coin, I wonder what I can do with them.." :: string,

	ViewportCFrame = CFrame.new(0, 0, -1.5) * CFrame.Angles(math.rad(15), math.rad(-150), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.1, -3.25) * CFrame.Angles(0, math.rad(-150), 0) :: CFrame,

	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
