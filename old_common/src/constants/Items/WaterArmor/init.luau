local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Water Armor" :: string,
	Description = "Used to evolve Toboramo!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.3) * CFrame.Angles(0, math.rad(0), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -1.3) * CFrame.Angles(0, math.rad(0), 0) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
