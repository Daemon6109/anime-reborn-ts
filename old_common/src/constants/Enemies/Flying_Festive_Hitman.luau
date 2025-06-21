local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	--["RootJointAngle"] = CFrame.Angles(math.rad(-45),0,0),
	["Height"] = 3,
	["WalkAnim"] = Animations["Flying Anims"]["Ancient Dungeon"].Fly1,
	["RunAnim"] = Animations["Flying Anims"]["Ancient Dungeon"].Fly1,
	["FlinchAnim"] = Animations["Flying Anims"]["Ancient Dungeon"].AirFlinch,
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "AERIAL",
	["OverheadColor"] = Color3.fromHex("9AFFF9"),
	["MapAffinity"] = "Underwater Kingdom",
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
	ModelsPool = game.ReplicatedStorage.EnemyModels["Winter Mayhem"].Aerial
}

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy