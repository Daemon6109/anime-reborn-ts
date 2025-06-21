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
			for i3,v3 in pairs(script.Particles2:GetChildren()) do
				local Clone = v3:Clone()
				Clone.Parent = v
				table.insert(CreatedModels[player.UserId], Clone)
			end
		end
	end
	for i3,v3 in pairs(script.Particles:GetChildren()) do
		local Clone = v3:Clone()
		Clone.Parent = character.HumanoidRootPart
		table.insert(CreatedModels[player.UserId], Clone)
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 129142329827210
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
