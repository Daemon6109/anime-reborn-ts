local Portal = {}

Portal.Rewards = {
	Set = {	
		Currencies = {
			["Candy Cane"] = 1
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
			--Gold = {Amount = NumberRange.new(20,50), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Items = {
		},

		Units = {
			--["Esdeath"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,10)},
		},
	},
}

Portal.configuration = {
	DisplayName = "Festive Portal",
	LevelRequirement = 10,
	MaxPlayers = 5,
	PotentialRewards = {
		Guaranteed = {
			Items = {
				["TraitCrystal"] = {
					Range = NumberRange.new(30, 50)
				},
				["Redstone"] = {
					Range = 10 --guaranteed 10 redstone
				}
			}	
		},
		Chance = {
			Units = {
				["Sakura"] = {
					Range = 1,
					Chance = 10 --%
				}
			}
		}
	},
	Description = "SANTA IS NOT REAL!!!",
	Tier = 3,
	Image = "rbxassetid://94252223594193",
	MapName = "Ancient Dungeon"
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
