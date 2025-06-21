local relic = {}

relic.NotStackable = true
relic.configuration = {
	Icon = "http://www.roblox.com/asset/?id=607147195",
	Description = "A simple knife used to cook",
	StatRanges = {
		Damage = NumberRange.new(5, 10),
		Range = NumberRange.new(3,8),
		AttackSpeed = NumberRange.new(-10, -5),
	},
	Passive = "Ego",
	------------------------------------------------------------------------
	TrueName = script.Name :: string,
	DisplayName = "Kitchen Knife" :: string,
	ViewportCFrame = CFrame.new(0, 0, -2) * CFrame.Angles(35,0,0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -2) * CFrame.Angles(0,0,35) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = false :: boolean,
	Sort = {"Relic"}
}

relic.misc = {
	Model = script:FindFirstChild("Model"),
}

return relic
