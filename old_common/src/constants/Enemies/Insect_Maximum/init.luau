local Enemy = {}
local Animations = game:GetService("ReplicatedStorage").Animations

Enemy.configuration = {
	["DisplayName"] = "Insect Maximum",
	["MapAffinity"] = "West City",
	["CapeAnim"] = script.Tail,
	["RessurectAnim"] = script.Ressurect,
	['ViewportOffset'] = CFrame.new(0,-0.15,0)
}

Enemy.reward = {
	money = 20,
}

Enemy.stats = {
	["Ressurect"] = true,
	["RessurectDuration"] = 2,
	["Speed"] = 1.4,
	["Damage"] = 999999,
	["HealthMultiplier"] = 1,
	--["Health"] = 500000, -- 50
	["NPC_Type"] = "Ground",
	["Class"] = "Boss",
	["Element"] = "Neutral",
	IsBoss = true
}

Enemy.misc = {
	ScriptLink = script,
	Model = game.ReplicatedStorage.BossModels:FindFirstChild(script.Name):FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

function Enemy:onRessurect(npc, anim)
	--task.wait(.15)
	anim:Play(.25)
	local YCordBaseVal = workspace.YOffset
	local YCordRef = Vector3.new(0,YCordBaseVal.Value,0)
	local height = 2
	
	local model = npc 
	local BaseC0 = model.HumanoidRootPart.RootJoint.C0
	local SavedCFR = model.HumanoidRootPart.CFrame
	
	local numberVal
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local startScale = .5
	local endScale = 1

	local function tweenScale(startScale : number, endScale : number, tweenInfo : TweenInfo, model : Model)
		local elapsed = 0
		local scale = 0
		local tweenConnection

		local function onStep(deltaTime : number)
			elapsed = math.min(elapsed + deltaTime, tweenInfo.Time)

			local alpha = game.TweenService:GetValue(elapsed / tweenInfo.Time, tweenInfo.EasingStyle, tweenInfo.EasingDirection)

			scale = startScale + alpha * (endScale - startScale)

			model:ScaleTo(scale)
			model.HumanoidRootPart:PivotTo(SavedCFR)

			if elapsed == tweenInfo.Time then
				tweenConnection:Disconnect()
			end
		end

		tweenConnection = game["Run Service"].Heartbeat:Connect(onStep)
	end
	
	task.delay(1, function()
		for i,v in npc:GetDescendants() do
			if v:IsA("ParticleEmitter") then
				v.Enabled = true
			end
		end
	end)
	
	task.delay(2, function()
		anim:Stop(.25)
	end)

	game.TweenService:Create(model.HumanoidRootPart.RootJoint, tweenInfo, {C0 =  CFrame.new(BaseC0.Position+Vector3.new(0,YCordBaseVal.Value*height,0))*BaseC0.Rotation}):Play()
	tweenScale(startScale, endScale, tweenInfo, model)
	--task.wait(1)
	--game.TweenService:Create(model.HumanoidRootPart.RootJoint, tweenInfo, {C0 =  CFrame.new(BaseC0.Position+Vector3.new(0,YCordBaseVal.Value*height,0))*BaseC0.Rotation}):Play()
end

function Enemy:onSpawn(npc)
end

function Enemy:onClientDeath(npc)
end

return Enemy