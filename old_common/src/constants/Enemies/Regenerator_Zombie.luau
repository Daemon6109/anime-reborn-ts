local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "REGENERATOR",
	["OverheadColor"] = Color3.fromHex("adf195"),
	["MapAffinity"] = "Leaf Village",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Regen"] = 10/100,
	["RegenDelay"] = 10,
	["Speed"] = 1.9,
	["Damage"] = 10,
	["HealthMultiplier"] = 1.3,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	--["ShieldCharges"] = 4,
	["Class"] = "Regenerate",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Clover Kingdom"].Basic
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy