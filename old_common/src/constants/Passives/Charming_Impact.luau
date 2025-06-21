local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Charming Impact",
	PassiveDescription = "Every 3rd attack applies `Charm` to enemies in radius for 10 seconds, Charmed enemies are slowed by 25% and recieve +15% more DMG. Has a 5 seconds cooldown in between next `Charm` application",
} 

Passive.callbacks = {
	onAttack = function(self: {any}, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local Stacks = Unit:GetAttribute("BoaStacks") or 0
		
		if Stacks >= 2 then
			Unit:SetAttribute("BoaStacks", 0)
			
			local StatusName = Unit:HasTag("ColdHeartedEmpress") and "CharmBoaEvo" or "Charm"
			
			for index, EnemyConstruct in pairs(_G.Constructs) do
				local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= UnitRange
				
				if IsInRange then
					local StatusEffect = _G.Registry.registry.StatusEffects[StatusName] 
					
					if StatusName == "CharmBoaEvo" and EnemyConstruct.StatusEffects["Charm"] == true then
						continue
					end
					
					if StatusName == "Charm" and EnemyConstruct.StatusEffects["CharmBoaEvo"] == true then
						continue
					end

					if StatusEffect then
						StatusEffect:OnServer(Unit, {EnemyConstruct}, 10)
					end
				end
			end
		else
			Unit:SetAttribute("BoaStacks", Stacks + 1)
		end
		
		BuffLib = nil
		FastVector = nil
	end,
}

return Passive