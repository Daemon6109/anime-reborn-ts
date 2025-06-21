local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Soul" :: string,
	Description = "Real scary... Like, really. You just don't know." :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(35, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, 35) :: CFrame,
	Rarity = "Exclusive" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}
Item.Limit = 50_000

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
