local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Candy Cane Broomstick" :: string,
	Description = "Delicious magic." :: string,

	ViewportCFrame = CFrame.new(-0.2, 0.2, -10) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(-0.2, -0.6, -10) * CFrame.Angles(0, 0, 0) :: CFrame,

	MaxSpeed = 60,
	JumpHeight = 14,
	Acceleration = 54,

	Rarity = "Exclusive",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "86743507188786",
	walk = "85593691387979",
	jump = "77692552523420",
	doubleJump = "108031991860179",
}

return module
