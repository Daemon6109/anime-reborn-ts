local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer
local connections: {[Player]: RBXScriptConnection} = {}
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Include
Params.FilterDescendantsInstances = {workspace:WaitForChild("Map")}
function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script:GetChildren() do
		v = v:Clone()

		for _, motor in v:GetChildren() do
			if motor:IsA("Motor6D") then
				motor.Part0 = character:FindFirstChild(motor.Name)
			end
		end

		v.Parent = character
		table.insert(CreatedModels[player.UserId], v)
	end
	
	if connections[player] then
		connections[player]:Disconnect()
	end
	local cd = tick()
	connections[player] = game["Run Service"].RenderStepped:Connect(function(dt)
		if cd - tick()	<= 0 then
			local pos  =character.HumanoidRootPart.CFrame * CFrame.new(Random.new():NextNumber(-5,5), 0,Random.new():NextNumber(-5,5) )
			local rcPos = workspace:Raycast(pos.Position, Vector3.new(0,-100,0), Params)
			rcPos = rcPos and rcPos.Position - Vector3.new(0,2,0) or  (pos * CFrame.new(0,-5,0)).Position
			local rock = Instance.new("Part")
			local randomSize = Random.new():NextNumber(1,1.5)
			rock.Size = Vector3.new(randomSize,randomSize,randomSize)
			rock.Anchored = true
			rock.CanCollide = false
			rock.Massless = true
			rock.Material = Enum.Material.Mud
			rock.Color = Color3.new(0.458824, 0.458824, 0.458824)

			rock.Position = rcPos
			rock.Parent = character
			local randomAngle = CFrame.Angles(math.rad(Random.new():NextNumber(0,180)), math.rad(Random.new():NextNumber(0,180)), math.rad(Random.new():NextNumber(0,180)))
			game.TweenService:Create(rock, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Size = Vector3.new(0,0,0), CFrame = rock.CFrame * CFrame.new(0,9,0) * randomAngle}):Play()
			cd = tick() + 0.05
			task.delay(1.2, function()
				rock:Destroy()
			end)
		end	
	end)
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = 139583734439575
end

function module:Unequip(player : Player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	
	
	CreatedModels[player.UserId] = {}
	if connections[player] then
		connections[player]:Disconnect()
		connections[player] = nil
	end
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = DefaultIdle
end

return module
