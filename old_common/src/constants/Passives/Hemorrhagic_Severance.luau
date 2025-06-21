local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Hemorrhagic Severance",
	PassiveDescription = "Proccs 'Scar' while permanently getting rid of their regen, For bosses their regen will stop for 15s",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy then
			local EnemyID = Enemy.EnemyID
			if EnemyID and _G.Constructs and _G.Constructs[EnemyID] then
				warn("Enemy found")
				if _G.Constructs[EnemyID].Regen then
					warn("Disabled regen")
					_G.Constructs[EnemyID].Regen = false
					if _G.Constructs[EnemyID].IsBoss then
						warn("Is Boss, Enabling back in 15s")
						task.delay(15 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
							warn("Enabled back for boss.")
							_G.Constructs[EnemyID].Regen = true
						end)
					end
				end
			end
		end

		return 1
	end,
}

return Passive
