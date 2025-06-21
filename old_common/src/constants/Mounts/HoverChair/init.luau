local module = {}

module.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Hover Chair" :: string,
	Description = "What better way to fly around than these?" :: string,

	ViewportCFrame = CFrame.new(0, 0.2, -5) * CFrame.Angles(0, 0, 0) :: CFrame,
	PreviewViewport = CFrame.new(0, 0, -7) * CFrame.Angles(0, 0, 0) :: CFrame,

	MaxSpeed = 55,
	JumpHeight = 14,
	Acceleration = 59.12,

	PriceInGems = 15000,

	Rarity = "Legendary",
}

-- module.misc = {
-- 	Model = script.Model :: Model;
-- }

module.animations = {
	idle = "84536523195656",
	walk = "131383125495707",
	custom = "135346370939217",
}

--function module:PlayCustom(character)

--	task.spawn(function()
--		local AnimModule = require(game.ReplicatedStorage.AnimModule)
--		task.spawn(function()
--			--pcall(function()
--			local MountObject = character:WaitForChild("MountObject", 15)
--			AnimModule.PlayCustomAnim(module.animations.custom, MountObject.Value:WaitForChild("AnimationController"), 1, "custom", {Weight = 2, Fade = .15})
--			--end)
--		end)
--	end)

--end

return module
