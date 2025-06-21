local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Spirit Hands" :: string,
	Description = "Used to evolve Mimi!" :: string,
	ViewportCFrame = CFrame.new(-0, 0, -1.15) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(225)) :: CFrame,
	PreviewViewport = CFrame.new(-0, 0, -1.15) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(225)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
