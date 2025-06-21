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
			local Accessory = script.Delta.Accessories:FindFirstChild(v.Name)
			if Accessory then
				for i2,v2 in pairs(Accessory:GetChildren()) do
					if not v2:FindFirstChildWhichIsA("Motor6D") then warn("Missing", v2) continue end
					local Clone = v2:Clone()
					Clone.Parent = Model
					Clone:FindFirstChildWhichIsA("Motor6D").Part0 = v
				end
			end
			for i3,v3 in pairs(script.Delta.Particles:GetChildren()) do
				local Clone = v3:Clone()
				Clone.Parent = v
				table.insert(CreatedModels[player.UserId], Clone)
			end
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 134452293324965
end

function module:ShinyEquip(player: Player)
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local character = player.Character or player.CharacterAppearanceLoaded:Wait()

	local Model = Instance.new("Model")
	Model.Name = "AccessoriesF"
	Model.Parent = character

	table.insert(CreatedModels[player.UserId], Model)

	for i,v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			local Accessory = script["Delta Shiny"].Accessories:FindFirstChild(v.Name)
			if Accessory then
				for i2,v2 in pairs(Accessory:GetChildren()) do
					if not v2:FindFirstChildWhichIsA("Motor6D") then warn("Missing", v2) continue end
					local Clone = v2:Clone()
					Clone.Parent = Model
					Clone:FindFirstChildWhichIsA("Motor6D").Part0 = v
				end
			end
			for i3,v3 in pairs(script["Delta Shiny"].Particles:GetChildren()) do
				local Clone = v3:Clone()
				Clone.Parent = v
				table.insert(CreatedModels[player.UserId], Clone)
			end
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 134452293324965
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
