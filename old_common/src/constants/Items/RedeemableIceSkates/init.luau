local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Redeemable Ice Skates" :: string,
	Description = "Redeem this item to gain the <Ice Skates> mount!" :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -3) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.4, -5) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,

	Rarity = "Mythical" :: string,
	Usable = true :: boolean,
	Sort = { "Misc", "Redeemable" },

	RedeemItem = "IceSkates",
	RedeemItemType = "Mount",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
