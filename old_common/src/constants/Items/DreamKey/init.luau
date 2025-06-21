local Item = {}

Item.Limit = 1

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Dream Key" :: string,
	Description = "Used to access the dream place!" :: string,
	ViewportCFrame = CFrame.new(-0.8, 0, -3) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(45)) :: CFrame,
	PreviewViewport = CFrame.new(-0.8, 0, -3) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(45)) :: CFrame,
	Rarity = "Rare" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
