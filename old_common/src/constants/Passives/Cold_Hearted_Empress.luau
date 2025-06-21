local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Cold Hearted Empress",
	PassiveDescription = "If the Attacked Enemy has `Charmed` status on, Bao [Empress] does +150% DMG to them. When an enemy `Charmed` by a unit named `Bao [Empress]` is defeated, a `Heart Explosion` happens, stunning nearby enemies for 3 seconds (6s application CD).",
	TagName = "ColdHeartedEmpress",
	PercentIncrease = 1.5
} 

Passive.callbacks = {
	onPlace = function(self: {any}, Unit: Model)
		Unit:AddTag(Passive.configuration.TagName)
	end,
	
	onConditionalDamage = function(self: {any}, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and (Enemy.StatusEffects["Charm"] == true or Enemy.StatusEffects["CharmBoaEvo"] == true) then

			return Passive.configuration.PercentIncrease
		end

		return 1
	end,
	
	onAnyKill = function(self: {any}, Unit: Model, Killer: Model, Enemy: {any})
		if Enemy.StatusEffects["CharmBoaEvo"] == true then
			local FastVector = require(replicated.Libs.FastVector).new()

			for index, EnemyConstruct in pairs(_G.Constructs) do
				local Distance = FastVector:FastMagnitudeVec3(EnemyConstruct["Position"], Enemy.Position)
				local IsInRange = Distance <= 20

				if IsInRange then
					local StatusEffect = _G.Registry.registry.StatusEffects["CharmStun"] 

					if StatusEffect then
						StatusEffect:OnServer(Unit, {EnemyConstruct}, 3)
					end
				end
			end

			FastVector = nil
		end
		
		Killer = nil
		Enemy = nil
	end,
}

return Passive