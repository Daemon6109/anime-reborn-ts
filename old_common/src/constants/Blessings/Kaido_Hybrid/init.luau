local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local module = {}

local CreatedModels = {}
local localPlayer = game.Players.LocalPlayer
local Connnections: {[Player]: RBXScriptConnection} = {}
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Include
Params.FilterDescendantsInstances = {workspace:WaitForChild("Map")}

local function emit(p: Instance)
	for _,v in p:GetDescendants() do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
end

function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script:GetChildren() do
		if v.Name == "KaidoStrike" then continue end
		v = v:Clone()

		for _, motor in v:GetChildren() do
			if motor:IsA("Motor6D") then
				motor.Part0 = character:FindFirstChild(motor.Name)
			end
		end

		v.Parent = character
		table.insert(CreatedModels[player.UserId], v)
	end
	
	if Connnections[player] then 
		Connnections[player]:Disconnect()
	end
	local cd = tick()
	
	
	Connnections[player] = game["Run Service"].RenderStepped:Connect(function()
		if cd - tick() <= 0 then
			local RNG = Random.new()
			local cf = character.HumanoidRootPart.CFrame * CFrame.new(RNG:NextNumber(-9,9), 0, RNG:NextNumber(-9,9))
			local raycastPos = workspace:Raycast(cf.Position, Vector3.new(0,-100,0), Params)
			raycastPos = raycastPos and raycastPos.Position   or (cf * CFrame.new(0,-4,0)).Position
			
			local strike = script.KaidoStrike:Clone()
			strike.Position = raycastPos
			strike.Parent = character
			emit(strike)
			task.delay(1, function()
				strike:Destroy()
			end)
			cd = tick() + 0.5
		end
	end)
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = 107830578194597
end

function module:Unequip(player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	if Connnections[player] then 
		Connnections[player]:Disconnect()
	end
	CreatedModels[player.UserId] = {}
	
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = DefaultIdle
end

return module
