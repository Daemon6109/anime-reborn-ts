local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local FastVector = require(game.ReplicatedStorage.Libs.FastVector).new()
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Anti-Spirit Domain" :: string,
	AbilityImage = "rbxassetid://110784579191257",
	Description = "Forms an exorcist domain. Enemies who step inside the domain recieve +30% incoming DMG. The domain lasts for 10s. (GLOBAL CD)",
	Cooldown = 50 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Barrier" :: Enums.SpecialCooldownGroups,
	AbilityType = "OnTickCallback" :: Enums.SpecialAbilityTypes,
	AbilityData = {
		callback = function(Unit: Model)
			--local UnitsInRange = _G.UnitHandler:GetAvaliableSortedEnemies(Unit)
			
			for _, Enemy in _G.Constructs do
				local IsInSpiritDomain = Enemy.InAntiSpiritDomain
				if FastVector:FastMagnitudeVec2XZ(Enemy.Position, Unit.HumanoidRootPart.Position) <= 20 * _G.RD then
					if not IsInSpiritDomain then
						Enemy:UpdateEnemy("InAntiSpiritDomain", true)
						Enemy:UpdateEnemy("IncomingDamageMulti", Enemy.IncomingDamageMulti+.3)
						
					end
				else
					if IsInSpiritDomain then
						Enemy:UpdateEnemy("InAntiSpiritDomain", nil)
						Enemy:UpdateEnemy("IncomingDamageMulti", Enemy.IncomingDamageMulti-.3)
					end
				end
				IsInSpiritDomain = nil
			end
		end,
		onEndCallback = function(Unit: Model)
			for _, Enemy in _G.Constructs do
				local IsInSpiritDomain = Enemy.InAntiSpiritDomain
				
				if IsInSpiritDomain then
					Enemy:UpdateEnemy("InAntiSpiritDomain", nil)
					Enemy:UpdateEnemy("IncomingDamageMulti", Enemy.IncomingDamageMulti-.3)
				end
				
				IsInSpiritDomain = nil
			end
		end,
	},
	Windup = 0 :: number,
	Duration = 10 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility