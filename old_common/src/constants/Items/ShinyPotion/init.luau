local Item = {}

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Shiny Potion" :: string,
	DisplayIcon = "rbxassetid://139517965516468" :: string,
	Description = "Grants the player a 10% banner shiny luck boost, (stacks with Shiny hunter)" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -2) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	Usable = true :: boolean,
	Sort = { "Potions" },
	Rarity = "Legendary",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
