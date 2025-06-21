local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Hover Car" :: string,
	Description = "Definitely creates traffic." :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.6, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,

	MaxSpeed = 70,
	JumpHeight = 18,
	Acceleration = 58,

	Rarity = "Exclusive",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "122737879607336",
	walk = "129976927486593",
	jump = "75070882414014",
	doubleJump = "93771811596735",
}

return module
