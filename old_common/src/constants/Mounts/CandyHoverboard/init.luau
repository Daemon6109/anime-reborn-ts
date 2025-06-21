local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Candy Hoverboard" :: string,
	Description = "Unfortunately non-magical." :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -5) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.4, -5) * CFrame.Angles(0, math.rad(180), 0) :: CFrame,

	MaxSpeed = 55,
	JumpHeight = 0,
	Acceleration = 46,

	Rarity = "Exclusive",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "128459754997755",
	walk = "119682363126300",
}

return module
