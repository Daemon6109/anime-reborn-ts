local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["DisplayName"] = "Enemy",
	["RandomizeCustomization"] = false,
	["MapAffinity"] = "Burned York",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 2.2,
	["Damage"] = 10,
	["HealthMultiplier"] = 1,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Regular",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Burned York"].Regenerator --game.ReplicatedStorage.EnemyModels["West City"].Basic
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy