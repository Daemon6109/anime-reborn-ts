local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Totsuka Blade" :: string,
	Description = "Used to evolve Itaha!" :: string,
	ViewportCFrame = CFrame.new(0, -1, -6) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, 1, -12) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
