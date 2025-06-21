local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Monster Slayer" :: string,
	Description = "Despite how heavy this sword is, it offers amazing travelling qualities. They claim the fuel of this sword is Dark Magic.." :: string,

	ViewportCFrame = CFrame.new(0, 0.1, -5.5) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -6.5) * CFrame.Angles(0, 0, 0) :: CFrame,

	MaxSpeed = 55,
	JumpHeight = 10,
	Acceleration = 53.92,

	PriceInGems = 12399,

	Rarity = "Mythical",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "110139661929681",
	walk = "136686227484848",
	jump = "75822811139607",
	doubleJump = "90908897491682",
}

return module
