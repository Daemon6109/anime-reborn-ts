local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Pudding" :: string,
	Description = "Used to evolve Beruus!" :: string,
	ViewportCFrame = CFrame.new(0.2, 0.3, -1.2) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-35)) :: CFrame,
	PreviewViewport = CFrame.new(0.2, 0.3, -1.2) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-35)) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
