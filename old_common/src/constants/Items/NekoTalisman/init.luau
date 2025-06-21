local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Neko Talisman" :: string,
	Description = "Used to evolve Turbo Grandmother!" :: string,
	ViewportCFrame = CFrame.new(0.05, -0.1, -1.25) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-35)) :: CFrame,
	PreviewViewport = CFrame.new(0.05, -0.1, -1.25) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-35)) :: CFrame,
	Usable = false :: boolean,
	Rarity = "Mythical" :: string,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
