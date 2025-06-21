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

function module:Equip(player: Player)
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	local Model = script.Hair:Clone()
	
	ToggleHair(character)
	Model.RootPartMotor.Part0 = character.Head
	Model.Parent = character

	table.insert(CreatedModels[player.UserId], Model)
	
	for _, v in script.CloneParticles:GetChildren() do
		v = v:Clone()
		v.Parent = character:FindFirstChild(v.Name)
		table.insert(CreatedModels[player.UserId], v)
	end
	
	local Aura = script.MainBox:Clone()
	Aura.Motor.Part0 = character.HumanoidRootPart
	Aura.Parent = character

	table.insert(CreatedModels[player.UserId], Aura)
	if player ~= localPlayer then return end

	AnimModule.PlayCustomAnim("18172209224", Model.AnimationController, 1, "")
	player.IdleAnimationValue.Value = 18172212518
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
