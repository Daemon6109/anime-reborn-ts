local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Redeemable Candy Sleigh" :: string,
	Description = "Redeem this item to gain the <Candy Sleigh> mount!" :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -10) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.6, -10) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,

	Rarity = "Mythical" :: string,
	Usable = true :: boolean,
	Sort = { "Misc", "Redeemable" },

	RedeemItem = "CandySleigh",
	RedeemItemType = "Mount",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
