local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["DisplayName"] = "Cod",
	["MapAffinity"] = "West City",
	["RessurectAnim"] = script.Ressurect,
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	--["Ressurect"] = true,
	--["RessurectDuration"] = 2,
	["Speed"] = 1.1,
	["Damage"] = 999999,
	["HealthMultiplier"] = 1,
	--["Health"] = 500000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Boss",
	["Element"] = "Neutral",
	["RewardsOnDeath"] = {
		Currencies = {
			--Gems = 30,
			--Gold = 80,
			--["Candy Cane"] = 750
		},

		Items = {
			["CidSword"] = {Amount = NumberRange.new(1,1), Chance = 5, RNG = NumberRange.new(1,100)},
		},

		Units = {},
	},
	IsBoss = true,
	IsAttackingType = true,
	AttackDelay = 15,
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.BossModels:FindFirstChild(script.Name):FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

function Enemy:onRessurect(npc, anim)
	--task.wait(.15)
	anim:Play(.25)
	task.delay(1, function()
		for i,v in npc:GetDescendants() do 
			if (v:IsA("ParticleEmitter") or v:IsA("Beam")) and v:GetAttribute("Marked") and v.Enabled == false then
				v:SetAttribute("Marked", true) v.Enabled = true 
			end 
		end
	end)

	task.delay(2, function()
		anim:Stop(.25)
	end)
end

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy