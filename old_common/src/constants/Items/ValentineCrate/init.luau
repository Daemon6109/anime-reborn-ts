local Item = {}

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end

Item.Limit = "inf"

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Valentine Crate" :: string,
	Description = "Can be used inside the Valentine Event Shop!" :: string,
	ViewportCFrame = CFrame.new(-0.1, -0.6, -7.33)
		* CFrame.Angles(math.rad(9.85), math.rad(180), math.rad(9.999)) :: CFrame,
	PreviewViewport = CFrame.new(-0.1, -0.6, -7.33)
		* CFrame.Angles(math.rad(9.85), math.rad(180), math.rad(9.999)) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = { "Misc" },
	RequestAmountOnUsage = true,
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
