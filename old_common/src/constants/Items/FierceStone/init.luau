local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Fierce Stone" :: string,
	Description = "Used to craft items to evolve units!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -5.5) * CFrame.Angles(0, math.rad(180), math.rad(15)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	Rarity = "Legendary" :: string,
	Usable = false :: boolean,
	Sort = { "Stones" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
