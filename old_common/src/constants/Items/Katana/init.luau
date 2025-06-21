local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Katana" :: string,
	Description = "Used to evolve Yune Gossi!" :: string,
	ViewportCFrame = CFrame.new(0, -1, -2.5) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, 1, -5) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
