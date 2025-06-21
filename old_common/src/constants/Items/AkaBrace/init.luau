local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Aka Brace" :: string,
	Description = "Used to evolve Akume!" :: string,
	ViewportCFrame = CFrame.new(-0.145, 0, -1.25) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0)) :: CFrame,
	PreviewViewport = CFrame.new(-0.145, 0, -1.25) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
