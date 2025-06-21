local Item = {}

Item.Limit = "inf"
Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Basic Luck Potion" :: string,
	DisplayIcon = "rbxassetid://114034975822906" :: string,
	Description = "Grants the player a 20% banner luck boost" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -2) * CFrame.Angles(math.rad(90), 0, 0) :: CFrame,
	Usable = true :: boolean,
	Sort = { "Potions" },
	Rarity = "Epic",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
