local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Ice Skates" :: string,
	Description = "Cold... Like, seriously cold." :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -3) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.4, -5) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,

	MaxSpeed = 40,
	JumpHeight = 7.2,
	Acceleration = 50,

	Rarity = "Exclusive",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "130309540918082",
	walk = "78354774427096",
	jump = "98602785444714",
	doubleJump = "103743115325154",
}

return module
