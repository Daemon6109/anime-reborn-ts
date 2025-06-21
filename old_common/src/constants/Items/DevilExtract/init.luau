local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Devil Extract" :: string,
	Description = "Used to evolve Sidea!" :: string,
	ViewportCFrame = CFrame.new(0, 0.2, -2.5) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0.1, -5) * CFrame.Angles(0, 0, 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
