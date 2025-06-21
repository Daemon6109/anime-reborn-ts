local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Spiritual Core" :: string,
	Description = "Used to evolve Aizon!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -1) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -1) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
