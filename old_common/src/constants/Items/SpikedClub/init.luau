local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Spiked Club" :: string,
	Description = "Used to evolve Dragon Emperor!" :: string,
	ViewportCFrame = CFrame.new(0.4, 0.25, -2.5) * CFrame.Angles(math.rad(25), math.rad(-50), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.3, -4) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
