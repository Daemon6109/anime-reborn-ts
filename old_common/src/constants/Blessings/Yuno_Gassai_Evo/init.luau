local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer

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
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = 114286473370067
end

function module:Unequip(player : Player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	
	CreatedModels[player.UserId] = {}
	
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = DefaultIdle
end

return module
