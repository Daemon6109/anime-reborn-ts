local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["MapAffinity"] = "Land of the Sky",
	["HideOverhead"] = true
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Radius"] = 2,
	["Speed"] = 10,
	["Damage"] = 10,
	["HealthMultiplier"] = 1,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Immortal",
	["Element"] = "Neutral",
	
	["StatusEffect"] = "Stun",
	["EffectDuration"] = 2.5
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.AllyModels:FindFirstChild(script.Name):FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.AllyModels:FindFirstChild(script.Name)
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy