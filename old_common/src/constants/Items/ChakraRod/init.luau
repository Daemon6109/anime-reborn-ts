local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Chakra rod" :: string,
	Description = "Used to evolve Payne!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -4) * CFrame.Angles(0, 0, -35) :: CFrame,
	PreviewViewport = CFrame.new(0, -1, -6) * CFrame.Angles(0, 0, -35) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
