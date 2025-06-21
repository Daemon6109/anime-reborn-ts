local Portal = {}

Portal.Rewards = {
	Set = {	
		Currencies = {
		},

		Items = {["T1_GhostPortal"] = 1,	},

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
			--Gold = {Amount = NumberRange.new(20,50), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Items = {
			--["Soul"] = {Amount = NumberRange.new(3,5), Chance = 1, RNG = NumberRange.new(1,1)},
			["GoldenMarble"] = {Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Units = {
			["Okarun"] = {Amount = NumberRange.new(1,1), Chance = 75, RNG = NumberRange.new(1,10000)},
		},
	},
}



Portal.configuration = {
	DisplayName = "Ghost Portal",
	LevelRequirement = 10,
	MaxPlayers = 5,

	Description = "+10% Damage for Ghost Tunnel units",
	Tier = 10,
	Image = "rbxassetid://94252223594193",
	MapName = "Ghost Tunnel"
}
function Portal:GetModel()
	return script.Model
end

function Portal:Open(Holder: Part)
	local PortalModel = script.Model:Clone()
	PortalModel:PivotTo(Holder.CFrame * CFrame.new(0,1,0) * CFrame.Angles(0,math.rad(-90),0))
	PortalModel.Name = "RootModel"
	PortalModel.Parent = Holder
	PortalModel.AnimationController.Animator:LoadAnimation(script.IdleAnim):Play()
	return PortalModel
end

function Portal:Close(Holder: Part) --cleanup

end

return Portal
