local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Saber" :: string,
	Description = "Used to evolve Sabur!" :: string,
	ViewportCFrame = CFrame.new(0, 0.1, -4.2) * CFrame.Angles(0, 0, math.rad(45)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -5.25) * CFrame.Angles(0, 0, math.rad(45)) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
