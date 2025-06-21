local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Fairy Wings" :: string,
	Description = "What better way to fly around than these?" :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -5) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -7) * CFrame.Angles(0, 0, 0) :: CFrame,

	MaxSpeed = 45,
	JumpHeight = 14,
	Acceleration = 44.12,

	PriceInGems = 2250,

	Rarity = "Rare",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "84536523195656",
	walk = "131383125495707",
}

return module
