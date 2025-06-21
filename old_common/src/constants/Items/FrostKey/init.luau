local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Frost Key" :: string,
	Description = "Used to lock stats when rerolling potential stats for units!" :: string,
	ViewportCFrame = CFrame.new(0.35, 0.35, -1.2)
		* CFrame.Angles(0, math.pi / 2, 0)
		* CFrame.Angles(-math.pi / 4, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0.35, 0, -3)
		* CFrame.Angles(0, math.pi / 2, 0)
		* CFrame.Angles(-math.pi / 4, 0, 0) :: CFrame,
	Rarity = "Legendary" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
