local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "SHIELDER",
	["OverheadColor"] = Color3.fromHex("bc4fff"),
	["MapAffinity"] = "Red Army HQ",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.9,
	["Damage"] = 10,
	["HealthMultiplier"] = 1.15,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	["ShieldCharges"] = 3,
	["Class"] = "Shield",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Red Army HQ"].Shield
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy