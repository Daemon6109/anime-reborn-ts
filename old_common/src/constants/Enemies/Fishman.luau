local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = true,
	["MapAffinity"] = "Underwater Kingdom",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.8,
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
	ModelsPool = script,
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy