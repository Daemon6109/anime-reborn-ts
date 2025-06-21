local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ice Rain",
	PassiveDescription = "This unit damages enemy in range for 35% of their damage each 45 seconds",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		task.spawn(function()
			while task.wait(45 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
				if Unit and Unit.Parent then
					
					game.ReplicatedStorage.Events.VisualEffects:FireAllClients("DirectRun", script.Passive, nil, nil, nil, {Unit, Unit.HumanoidRootPart, nil})
					
					local BuffLib = require(replicated.Libs.BuffLib)
					local FastVector = require(replicated.Libs.FastVector).new()
					
					local UnitRange = BuffLib:GetRangeScaled(Unit)
					local DamageToDeal = BuffLib:GetDamage(Unit) * .35
					
					for index, EnemyConstruct in pairs(_G.Constructs) do
						if EnemyConstruct then
							local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, EnemyConstruct["Position"])
							local IsInRange = Distance <= UnitRange
							
							if IsInRange then
								_G.EnemyAPI:DamageEnemy(EnemyConstruct.EnemyID, DamageToDeal, game.HttpService:GenerateGUID(false), Unit)
							end
						end
					end
					
				else
					break
				end
			end
		end)
	end,
}

return Passive
