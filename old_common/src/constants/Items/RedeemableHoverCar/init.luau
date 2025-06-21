local Item = {}

Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Redeemable Hover Car" :: string,
	Description = "Redeem this item to gain the <Hover Car> mount!" :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.6, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,

	Rarity = "Mythical" :: string,
	Usable = true :: boolean,
	Sort = { "Misc", "Redeemable" },

	RedeemItem = "HoverCar",
	RedeemItemType = "Mount",
}

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
