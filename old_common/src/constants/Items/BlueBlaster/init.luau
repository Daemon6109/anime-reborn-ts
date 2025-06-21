local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Blue Blaster" :: string,
	Description = "Used to evolve Delta Brothers!" :: string,
	ViewportCFrame = CFrame.new(0.2, 0, -2.7) * CFrame.Angles(math.rad(25), math.rad(-60), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -3) * CFrame.Angles(0, math.rad(-60), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
