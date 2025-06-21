local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["MapAffinity"] = "Land of the Sky",
	["OverheadDisplay"] = "EXPLOSIVE",
	["OverheadColor"] = Color3.fromRGB(255,200,100),
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.8- .5,
	["Damage"] = 10,
	["HealthMultiplier"] = 0.9,
	--["Health"] = 7000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Regular",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["World Collision"]["1"].Basic
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy