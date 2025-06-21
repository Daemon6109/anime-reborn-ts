local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Enchanted Candy Key" :: string,
	Description = "Used to play Winter Mayhem Mode & Earn 2x Rewards!" :: string,
	ViewportCFrame = CFrame.new(-0.8, -1.1, -3) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(45)) :: CFrame,
	PreviewViewport = CFrame.new(-0.8, -1.1, -3) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(45)) :: CFrame,
	Rarity = "Epic" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
