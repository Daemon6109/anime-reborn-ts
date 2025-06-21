local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Crazy Bike" :: string,
	Description = "With great performance and great looks, the Crazy Bike is suitable for many mages." :: string,

	ViewportCFrame = CFrame.new(0, 0, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -12) * CFrame.Angles(0, math.rad(90), 0) :: CFrame,

	MaxSpeed = 60,
	JumpHeight = 8,
	Acceleration = 39.22,

	PriceInGems = 10000,

	Rarity = "Legendary",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "134849489568369",
	walk = "127154542263408",
	jump = "110335166175469",
	doubleJump = "111601390034038",
}

return module
