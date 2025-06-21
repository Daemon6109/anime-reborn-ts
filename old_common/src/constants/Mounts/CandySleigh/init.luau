local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Candy Sleigh" :: string,
	Description = "Seriously? Who made this.." :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -10) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, -0.6, -10) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,

	MaxSpeed = 65,
	JumpHeight = 15,
	Acceleration = 42,

	Rarity = "Exclusive",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "124614346524326",
	walk = "121321767790039",
	jump = "101471326733202",
	doubleJump = "123249440421779",
}

return module
