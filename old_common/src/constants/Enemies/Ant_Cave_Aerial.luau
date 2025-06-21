local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["Height"] = 4,
	["WalkAnim"] = Animations["Flying Anims"]["Land of the Sky"].Enemy_Fly1,
	["RunAnim"] = Animations["Flying Anims"]["Land of the Sky"].Enemy_Fly1Fast,
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "AERIAL",
	["OverheadColor"] = Color3.fromHex("9AFFF9"),
	["MapAffinity"] = "Land of the Sky",
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
	ModelsPool = game.ReplicatedStorage.EnemyModels["Ant Cave"].Ariel
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy