local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Broken Limiter" :: string,
	Description = "Used to evolve Brolio!" :: string,
	ViewportCFrame = CFrame.new(-0.08, 0, -1.5) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.2, -2.5) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
