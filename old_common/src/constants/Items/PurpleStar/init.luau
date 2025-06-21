local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Purple Star" :: string,
	Description = "Used to craft items to evolve units!" :: string,
	ViewportCFrame = CFrame.new(0.25, 0, -3) * CFrame.Angles(math.rad(-18), math.rad(90), math.rad(90)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -5) * CFrame.Angles(math.rad(90), math.rad(-18), math.rad(0)) :: CFrame,
	Rarity = "Legendary" :: string,
	Usable = false :: boolean,
	Sort = { "Stars" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
