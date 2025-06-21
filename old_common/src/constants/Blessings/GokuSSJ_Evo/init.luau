local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local AnimModule = require(ReplicatedStorage.AnimModule)

local module = {}

local CreatedModels = {}

local function ToggleHair(model: Model, toggle)
	for _, v in model.Humanoid:GetAccessories() do
		if v:FindFirstChild("Handle") and v.Handle:FindFirstChild("HairAttachment") then
			v.Handle.Transparency = toggle and 0 or 1
		end
	end
end
local localPlayer = game.Players.LocalPlayer

function module:ShinyEquip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	ToggleHair(character)
	
	for _, v in script:GetChildren() do
		v = v:Clone()
		
		for _, motor in v:GetChildren() do
			if motor:IsA("Motor6D") then
				motor.Part0 = character:FindFirstChild(motor.Name)
			end
		end
		
		v.Parent = character
		table.insert(CreatedModels[player.UserId], v)
		
		if v.Name == "Hair" then
			if player == localPlayer then 
				AnimModule.PlayCustomAnim(74141329654855, v.AnimationController, 1)

			end

		end
	end
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = 121034505739814
end

function module:Unequip(player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	
	CreatedModels[player.UserId] = {}
	
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if player ~= localPlayer then return end

	ToggleHair(character, true)
	player.IdleAnimationValue.Value = DefaultIdle
end

return module
