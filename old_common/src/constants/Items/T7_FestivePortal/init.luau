local Item = {}

Item.NotStackable = true
Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "T7 Festive Portal" :: string,
	Description = "Use to open" :: string,
	ViewportCFrame = CFrame.new(-0.3, -1.3, -14) * CFrame.Angles(math.rad(-90), math.rad(-180), 0) :: CFrame,
	PreviewViewport = CFrame.new(-0.5, -0.3, -21) * CFrame.Angles(math.rad(-90), math.rad(-180), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = true :: boolean,
	Sort = { "Portal" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
