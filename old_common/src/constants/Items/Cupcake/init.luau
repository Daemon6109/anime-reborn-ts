local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Cupcake" :: string,
	Description = "Used to evolve Twenty One!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -4) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -5) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
