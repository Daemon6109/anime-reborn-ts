local Item = {}

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end

Item.Limit = 1

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Story Skip (Leaf Village)" :: string,
	--DisplayIcon = "rbxassetid://130577771455565" :: string;
	Description = "Use to skip Leaf Village!" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(0, 0, math.rad(-25)) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -2.4) * CFrame.Angles(math.rad(0), 0, 0) :: CFrame,
	Usable = true :: boolean,
	Sort = { "Misc" },
	Rarity = "Secret",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
