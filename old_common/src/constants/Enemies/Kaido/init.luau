local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["DisplayName"] = "Dragon Emperor",
	["Height"] = -1.4,
	["BossPopupCorrection"] = CFrame.new(0, -1.05, 0),
	["MapAffinity"] = "Fujishima Island",
	["WalkAnim"] = Animations.Generic:FindFirstChild("KaidoWalk"),
	["RunAnim"] = Animations.Generic:FindFirstChild("KaidoWalk"),
	['ViewportOffset'] = CFrame.new(0,-2.75,0)
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 1.4,
	["Damage"] = 999999,
	["HealthMultiplier"] = 1,
	--["Health"] = 500000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Boss",
	["Element"] = "Neutral",
	IsBoss = true,
	IsAttackingType = true,
	AttackDelay = 10,
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.BossModels:FindFirstChild(script.Name):FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy