local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Gromjaw Mask" :: string,
	Description = "Used to evolve Gromjaw!" :: string,
	ViewportCFrame = CFrame.new(0.04, -0.02, -0.45) * CFrame.Angles(0, math.rad(-90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0.04, -0.02, -0.45) * CFrame.Angles(0, math.rad(-90), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
