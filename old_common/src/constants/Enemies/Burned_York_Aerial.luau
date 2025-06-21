local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["MapAffinity"] = "Burned York",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.9,
	["Damage"] = 10,
	["HealthMultiplier"] = .75,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Air",
	["Class"] = "Regular",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Burned York"].Aerial --game.ReplicatedStorage.EnemyModels["West City"].Basic
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy