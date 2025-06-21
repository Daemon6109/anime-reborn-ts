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

	local Model = Instance.new("Model")
	Model.Name = "AccessoriesF"
	Model.Parent = character

	table.insert(CreatedModels[player.UserId], Model)

	for i,v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			local Accessory = Path.Accessories:FindFirstChild(v.Name)
			if Accessory then
				for i2,v2 in pairs(Accessory:GetChildren()) do
					local Clone = v2:Clone()
					Clone.Parent = Model
					Clone:FindFirstChildWhichIsA("Motor6D").Part0 = v
				end
			end
		end
	end
	for _, part in script.Particles:GetChildren() do
		local matchingPart = character:FindFirstChild(part.Name)
		if matchingPart then
			for _, obj in part:GetChildren() do
				local clone = obj:Clone()
				clone.Parent = matchingPart
				table.insert(CreatedModels[player.UserId], clone)
			end
		end
	end
	
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 127524251906511
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
