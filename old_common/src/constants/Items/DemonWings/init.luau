local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Demon Wings" :: string,
	Description = "Used to evolve Rise!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -5.5) * CFrame.Angles(0, math.rad(180), math.rad(25)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
