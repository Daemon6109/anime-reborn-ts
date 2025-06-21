local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["RandomizeCustomization"] = false,
	["OverheadDisplay"] = "SHADE",
	["OverheadColor"] = Color3.fromRGB(122, 122, 122),
	["MapAffinity"] = "Ghost Tunnel",
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Speed"] = 2,
	["Damage"] = 25,
	["HealthMultiplier"] = .85,
	["HideDelay"] = 10,
	["HideDuration"] = 5,
	--["Health"] = 9000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Shade",
	["DetectedBy"] = {
		["Exorcist"] = true,
		["Yokai"] = true,
	},
	["Element"] = "Neutral",
}

Enemy.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
	ModelsPool = game.ReplicatedStorage.EnemyModels["Ghost Tunnel"].Shade
}

function Enemy:onHide(body, state)
	body.Torso.ShadeAura.Enabled = state == "Yes" and true or false
	if state == "Yes" then
		for i,v in body:GetChildren() do
			if v:IsA("BasePart") then
				v.Color = BrickColor.new("Black").Color
			end
		end
		return
	end
	
	for i,v in body:GetChildren() do
		if v:IsA("BasePart") then
			v.Color = BrickColor.new("Dark stone grey").Color
		end
	end
end

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy