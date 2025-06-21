local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "SPEEDSTER",
	["OverheadColor"] = Color3.fromRGB(0,150,255),
	["MapAffinity"] = "Land of the Sky",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 3- .5,
	["Damage"] = 25,
	["HealthMultiplier"] = .45,
	--["Health"] = 9000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Speedster",
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["World Collision"]["3"].Fast
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy