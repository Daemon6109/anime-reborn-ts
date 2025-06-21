local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["DisplayName"] = "Soul Boss",
	["MapAffinity"] = "Soul Desert",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.4,
	["Damage"] = 999999,
	["HealthMultiplier"] = 1,
	--["Health"] = 500000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Boss",
	["Element"] = "Neutral",
	IsBoss = true
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.BossModels:FindFirstChild("Soul Desert"):FindFirstChild("Story"):FindFirstChild("Stage 6"):FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy