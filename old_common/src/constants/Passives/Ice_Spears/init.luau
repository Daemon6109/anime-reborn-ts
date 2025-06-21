local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ice Spears",
	PassiveDescription = "This unit damages enemy every 5th hit, dealing 150% of current damage and freezes the enemy for 5s",
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()

		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local DamageToDeal = BuffLib:GetDamage(Unit) * 1.5

		local Stacks = Unit:GetAttribute("SpearStack") or 0

		Unit:SetAttribute("SpearStack", Stacks+1)

		local StatusEffect = _G.Registry.registry.StatusEffects["Frozen"]

		if Unit:GetAttribute("SpearStack") >= 5 then
			task.delay(.33 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				local IDs = {}
				
				for index, EnemyConstruct in pairs(_G.Constructs) do
					if EnemyConstruct then
						local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, EnemyConstruct["Position"])
						local IsInRange = Distance <= UnitRange

						if IsInRange then
							game.ReplicatedStorage.Events.VisualEffects:FireAllClients("DirectPassiveRun", script["Ice Trident"], nil, nil, nil, {Unit, Unit.HumanoidRootPart, EnemyConstruct.EnemyID})
							StatusEffect:OnServer(Unit, {EnemyConstruct}, 5)
							_G.EnemyAPI:DamageEnemy(EnemyConstruct.EnemyID, DamageToDeal, game.HttpService:GenerateGUID(false), Unit)
							Unit:SetAttribute("SpearStack", 0)
							
							table.insert(IDs, EnemyConstruct.EnemyID)
						end
					end
				end
				
				task.wait(.33 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
				game.ReplicatedStorage.Events.VisualEffects:FireAllClients("PassiveDirectDamage", nil, nil, Unit, IDs, DamageToDeal)
			end)
		end
	end,
}

return Passive
