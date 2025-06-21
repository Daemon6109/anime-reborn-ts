local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local AnimModule = require(ReplicatedStorage.AnimModule)

local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer

function module:Equip(player: Player)
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	local Path = script

	local Particles = Path.Particles:Clone()
	Particles.Parent = character:FindFirstChild("Torso")
	for i,v in pairs(Particles:GetChildren()) do
		v.Parent = character:FindFirstChild("Torso")
		table.insert(CreatedModels[player.UserId], v)
	end
	Particles:Destroy()
		
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 86579607855805
end

function module:Unequip(player)
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
