local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Cross Necklace" :: string,
	Description = "Used to evolve Hawk Eyes!" :: string,
	ViewportCFrame = CFrame.new(0, -0.5, -2.5) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -5) * CFrame.Angles(math.rad(90), math.rad(-18), math.rad(0)) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
