local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Strange Cloud" :: string,
	Description = "Does not rain." :: string,

	ViewportCFrame = CFrame.new(-0.2, 0.2, -5) * CFrame.Angles(0, math.rad(50), 0) :: CFrame,
	PreviewViewport = CFrame.new(-0.2, -0.6, -6) * CFrame.Angles(0, math.rad(50), 0) :: CFrame,

	MaxSpeed = 50,
	JumpHeight = 12,
	Acceleration = 49.02,

	PriceInGems = 5000,

	Rarity = "Epic",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "124190013010214",
	walk = "87555884482177",
	jump = "75822811139607",
	doubleJump = "90908897491682",
}

return module
