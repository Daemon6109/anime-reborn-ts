local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["Height"] = .55,
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "GUARDIAN",
	["OverheadColor"] = Color3.fromRGB(255,20,80),
	["MapAffinity"] = "Land of the Sky",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.7- .5,
	["Damage"] = 30,
	["HealthMultiplier"] = 1.5,
	--["Health"] = 7000*3, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Guardian",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["World Collision"]["1"].Heavy
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy