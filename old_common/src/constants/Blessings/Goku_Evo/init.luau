local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local DefaultWalk = 18315401557
local DefaultRun = 18302093143

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
	
	local Numbus = script.Numbus:Clone()
	Numbus.Parent = Model
	Numbus.Weld.Part0 = player.Character.HumanoidRootPart
	
	local Wings = script.Wings:Clone()
	Wings.Parent = Model
	Wings.Weld.Part0 = player.Character.HumanoidRootPart
	
	AnimModule.PlayCustomAnim("105615859244402", Numbus.AnimationController, 1, "Numbus", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim("123639691852725", Wings.AnimationController, 1, "Wings", {Weight = 2, Fade = .15})
	
	--for i,v in pairs(character:GetChildren()) do
	--	if v:IsA("BasePart") then
	--		for i3,v3 in pairs(script.Particles:GetChildren()) do
	--			local Clone = v3:Clone()
	--			Clone.Parent = v
	--			table.insert(CreatedModels[player.UserId], Clone)
	--		end
	--	end
	--end
	character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 83669457080243
	player.WalkAnimationValue.Value = 83669457080243
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
	player.WalkAnimationValue.Value = 0
	character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end

return module
