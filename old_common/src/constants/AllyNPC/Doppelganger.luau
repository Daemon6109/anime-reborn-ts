local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["MapAffinity"] = "Land of the Sky",
	["DeathVFX"] = "ExplosiveEnemyVFXSize20",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Radius"] = 2,
	["Speed"] = 2.15,
	["Damage"] = 10,
	["HealthMultiplier"] = 1,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Explosive",
	["Element"] = "Neutral",
	["ExplosionMagnitude"] = 20,
	["ExplosionMulti"] = 1/3,
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.AllyModels:FindFirstChild(script.Name):FindFirstChild("Model"),
	ShinyModel = game.ReplicatedStorage.AllyModels:FindFirstChild(script.Name):FindFirstChild("ShinyModel"),
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy