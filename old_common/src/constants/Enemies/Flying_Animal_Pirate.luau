local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["Height"] = 4,
	["WalkAnim"] = Animations["Flying Anims"]["Fujishima Island"].Fly1,
	["RunAnim"] = Animations["Flying Anims"]["Fujishima Island"].Fly1,
	["WingAnim"] = Animations["Flying Anims"]["Fujishima Island"].Wings,
	["FlinchAnim"] = Animations["Flying Anims"]["Fujishima Island"].AirFlinch,
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "AERIAL",
	["OverheadColor"] = Color3.fromHex("9AFFF9"),
	["MapAffinity"] = "Fujishima Island",
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
	ModelsPool = game.ReplicatedStorage.EnemyModels["Fujishima Island"].Aerial
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy