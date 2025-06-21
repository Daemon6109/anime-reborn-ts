local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Funny Explosion",
	PassiveDescription = "Every 3 eliminations, applies stun to nearby enemies",
} 

Passive.callbacks = {
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local FastVector = require(replicated.Libs.FastVector).new()
		
		local Stacks = Unit:GetAttribute("FunnyStacks") or 0
		
		if Stacks >= 3 then
			Unit:SetAttribute("FunnyStacks", 0)
			
			for index, EnemyConstruct in pairs(_G.Constructs) do
				local Distance = FastVector:FastMagnitudeVec3(Enemy.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= 30
				
				if IsInRange then
					local StatusEffect = _G.Registry.registry.StatusEffects["Stun"] 

					if StatusEffect then
						StatusEffect:OnServer(Unit, {EnemyConstruct}, 5)
					end
				end
			end
			
			game.ReplicatedStorage.Events.VisualEffects:FireAllClients("DirectPassiveRun", script.Passive, nil, nil, nil, {Unit, Unit.HumanoidRootPart, Enemy.EnemyID})
		else
			Unit:SetAttribute("FunnyStacks", Stacks + 1)
		end
		
		FastVector = nil
	end,
}

return Passive