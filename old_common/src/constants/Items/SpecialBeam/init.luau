local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Special Beam" :: string,
	Description = "Used to evolve Gohun!" :: string,
	ViewportCFrame = CFrame.new(0, 0.1, -2.25) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0.1, -2.6) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
