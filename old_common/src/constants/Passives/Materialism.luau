local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Materialism",
	PassiveDescription = "3% Chance To Insta Kill Enemies That are Below 30% every 3 minutes, normal mobs only."
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})

		local Roll = math.random(1,100)
		local UlqPassiveCD = workspace:GetAttribute("UlquioraGlobalCD")
		if not UlqPassiveCD then
			workspace:SetAttribute("UlquioraGlobalCD", 0)
			UlqPassiveCD = workspace:GetAttribute("UlquioraGlobalCD")
		end

		if (tick() - tonumber(UlqPassiveCD)) > (3 * 60) then
			--warn("Triggered", (tick() - tonumber(UlqPassiveCD)))
			workspace:SetAttribute("UlquioraGlobalCD", tick())

			if Enemy and not Enemy.IsBoss and Enemy.Health > 0 and Enemy.Health <= Enemy.MaxHealth*.35 and Roll <= 3 then
				return 1, nil, nil, nil, Enemy.Health
			end

			return 1
		else
			return 1
		end
	end,
}

return Passive
