local Portal = {}

Portal.Rewards = {
	Set = {	
		Currencies = {
		},

		Items = {},

		Units = {},
	},

	FirstClear = {
		Currencies = {
		},

		Items = {},

		Units = {},
	},

	["Random"] = {
		Currencies = {
			Gems = {Amount = NumberRange.new(100, 100), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Items = {
			T3_RuinedAntCavePortal = {Amount = NumberRange.new(1, 2), Chance = 1, RNG = NumberRange.new(1,1)},
			T4_RuinedAntCavePortal = {Amount = NumberRange.new(1, 1), Chance = 50, RNG = NumberRange.new(1,100)},
			OrangeStar = {Amount = NumberRange.new(5, 10), Chance = 1, RNG = NumberRange.new(1,5)},
			BlueStar = {Amount = NumberRange.new(1, 2), Chance = 1, RNG = NumberRange.new(1,50)},
			GreenStar = {Amount = NumberRange.new(1, 2), Chance = 1, RNG = NumberRange.new(1,50)},
			PurpleStar = {Amount = NumberRange.new(1, 2), Chance = 1, RNG = NumberRange.new(1,50)},
			RedStar = {Amount = NumberRange.new(1, 2), Chance = 1, RNG = NumberRange.new(1,50)},
			Crystals = {Amount = NumberRange.new(50,75), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Units = {
		},
	},
}



Portal.configuration = {
	DisplayName = "Ruined Ant Cave Portal",
	LevelRequirement = 10,
	MaxPlayers = 5,

	Description = "",
	Tier = 3,
	Image = "rbxassetid://94252223594193",
	MapName = "Ant Cave (Ruined)"
}
function Portal:GetModel()
	return script.Model
end

function Portal:Open(Holder: Part)
	local PortalModel = script.Model:Clone()
	PortalModel:PivotTo(Holder.CFrame * CFrame.new(0,-2,0) * CFrame.Angles(0,math.pi,0))
	PortalModel.Name = "RootModel"
	PortalModel.Parent = Holder
	PortalModel.AnimationController.Animator:LoadAnimation(script.IdleAnim):Play()
	return PortalModel
end

function Portal:Close(Holder: Part) --cleanup

end

return Portal
