local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Potential Key" :: string,
	Description = "Used to reroll potential stats for units!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1.2)
		* CFrame.Angles(0, math.pi / 2, 0)
		* CFrame.Angles(-math.pi / 4, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -3)
		* CFrame.Angles(0, math.pi / 2, 0)
		* CFrame.Angles(-math.pi / 4, 0, 0) :: CFrame,
	Rarity = "Legendary" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
	DisplayIcon = "rbxassetid://108419160714054" :: string,
	DisplayIconSize = UDim2.fromScale(0.8, 0.8) :: UDim2,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
