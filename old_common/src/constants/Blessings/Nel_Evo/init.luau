local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value

local AnimModule = require(ReplicatedStorage.AnimModule)

local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer

function module:Equip(player: Player)
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local character = player.Character or player.CharacterAppearanceLoaded:Wait()	
	local Model = Instance.new("Model")
	Model.Name = "AccessoriesF"
	Model.Parent = character
	
	table.insert(CreatedModels[player.UserId], Model)

	for i,v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			local Accessory = script.Accessories:FindFirstChild(v.Name)
			if Accessory then
				for i2,v2 in pairs(Accessory:GetChildren()) do
					local Clone = v2:Clone()
					Clone.Parent = Model
					Clone:FindFirstChildWhichIsA("Motor6D").Part0 = v
				end
			end
			local Particles = script.Particles:Clone()
			Particles.Parent = v
			for i3,v3 in pairs(Particles:GetChildren()) do
				local Clone = v3:Clone()
				Clone.Parent = v
				table.insert(CreatedModels[player.UserId], Clone)
			end
			Particles:Destroy()
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 124109483162475
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
