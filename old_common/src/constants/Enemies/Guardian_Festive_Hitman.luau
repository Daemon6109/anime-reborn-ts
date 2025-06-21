local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "GUARDIAN",
	["OverheadColor"] = Color3.fromRGB(255,20,80),
	["MapAffinity"] = "Namek",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.7,
	["Damage"] = 25,
	["HealthMultiplier"] = .45,
	--["Health"] = 9000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Guardian",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Winter Mayhem"].Heavy
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy