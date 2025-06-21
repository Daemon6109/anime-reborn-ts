local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local module = {}


local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer



function module:ShinyEquip(player: Player)
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
	--if connections[player] then
	--	connections[player]:Disconnect()
	--end
	--local cd = tick()
	--connections[player] = RunService.RenderStepped:Connect(function(dt)
	--	if cd - tick()	<= 0 then
	--		local rock = Instance.new("Part")
	--		local randomSize = Random.new():NextNumber(1,1.5)
	--		rock.Size = Vector3.new(randomSize,randomSize,randomSize)
	--		rock.Anchored = true
	--		rock.CanCollide = false
	--		rock.Massless = true
	--		rock.Material = Enum.Material.Mud
	--		rock.Color = Color3.new(0.458824, 0.458824, 0.458824)
			
	--		rock.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(Random.new():NextNumber(-5,5), -5,Random.new():NextNumber(-5,5) )
	--		rock.Parent = character
	--		local randomAngle = CFrame.Angles(math.rad(Random.new():NextNumber(0,180)), math.rad(Random.new():NextNumber(0,180)), math.rad(Random.new():NextNumber(0,180)))
	--		TS:Create(rock, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Size = Vector3.new(0,0,0), CFrame = rock.CFrame * CFrame.new(0,9,0) * randomAngle}):Play()
	--		cd = tick() + 0.05
	--		task.delay(1.2, function()
	--			rock:Destroy()
	--		end)
	--	end	
	--end)
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = 102343566290153
end

function module:Unequip(player : Player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	
	CreatedModels[player.UserId] = {}
	--if connections[player] then
	--	connections[player]:Disconnect()
	--	connections[player] = nil
	--end
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = DefaultIdle
end

return module
