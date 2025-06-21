local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["Height"] = .55,
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "EXPLOSIVE",
	["OverheadColor"] = Color3.fromRGB(255,200,100),
	["MapAffinity"] = "West City",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.8,
	["Damage"] = 30,
	["HealthMultiplier"] = 0.9,
	["OnDeathAction"] = "Explode",
	["DeathActionData"] = {
		Size = 20,
		Duration = 5,
	},
	--["Health"] = 7000*3, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Explosive",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["West City"].Heavy
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy