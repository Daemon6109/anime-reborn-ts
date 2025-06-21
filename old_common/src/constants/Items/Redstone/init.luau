local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Red Stone" :: string,
	DisplayIcon = "rbxassetid://100271666848832" :: string,
	Description = "Used to brew potions" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -3) :: CFrame,
	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Mythical",
	Gradient = {
		Color3.new(1, 0, 0.0156863),
		Color3.new(1, 0.34902, 0.34902),
	},
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
