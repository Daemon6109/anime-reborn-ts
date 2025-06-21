local Item = {}
Item.Limit = "inf"
Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Trait Crystal" :: string,
	DisplayIcon = "rbxassetid://124476779622214" :: string,
	Description = "Used to reroll traits for units!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -3) :: CFrame,
	Usable = false :: boolean,
	Sort = { "Misc" },
	Rarity = "Legendary",
	Gradient = {
		Color3.fromHex("#00ff80"),
		Color3.fromHex("#00fbff"),
		Color3.fromHex("#9742ff"),
	},
	DisplayIconSize = UDim2.fromScale(0.8, 0.8),
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
