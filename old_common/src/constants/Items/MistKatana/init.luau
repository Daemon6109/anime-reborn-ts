local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Mist Katana" :: string,
	Description = "Used to evolve Muichori!" :: string,
	ViewportCFrame = CFrame.new(0, 0.1, -5.5) * CFrame.Angles(0, 0, math.rad(45)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -7) * CFrame.Angles(0, 0, math.rad(45)) :: CFrame,

	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
