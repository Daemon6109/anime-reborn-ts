local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Snowflake" :: string,
	Description = "Used to evolve Urane!" :: string,
	ViewportCFrame = CFrame.new(0, 0.1, -1) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0.1, -2) * CFrame.Angles(0, 0, 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
