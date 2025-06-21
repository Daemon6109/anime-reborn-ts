local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Io's Heaven Diary" :: string,
	Description = "Used to evolve Io from Heaven!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(90)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(90)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
