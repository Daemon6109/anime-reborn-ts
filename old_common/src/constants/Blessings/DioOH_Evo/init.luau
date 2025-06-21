local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local module = {}

local CreatedModels = {}
local AnimModule = require(game.ReplicatedStorage.AnimModule)
local localPlayer = game.Players.LocalPlayer
--prt1 constant
function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end
	
	local Stand = script.Effect.DIO["Dio stand"]:Clone()
	Stand.Parent = character

	Stand.RootPart.RootPart.Part0 = character.HumanoidRootPart

	AnimModule.PlayCustomAnim("139461745012713", Stand.AnimationController, .4, "Idle", {Weight = 2, Fade = .15})

	--im hard coding
	for _,obj in script.Effect.DIO:GetChildren() do
		if obj:GetAttribute("WeldOver") then
			obj = obj:Clone()
			obj:FindFirstChildOfClass("Motor6D").Part0 = character:FindFirstChild(obj:FindFirstChildOfClass("Motor6D").Name)			
			obj.Parent = character
			table.insert(CreatedModels[player.UserId], obj)

		end
	end
	
	
	
	table.insert(CreatedModels[player.UserId], Stand)
	

	

	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 84883427046172
end

function module:ShinyEquip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local Stand = script.Effect2["Dio stand"]:Clone()
	Stand.Parent = character

	Stand.RootPart.RootPart.Part0 = character.HumanoidRootPart

	AnimModule.PlayCustomAnim("139461745012713", Stand.AnimationController, .4, "Idle", {Weight = 2, Fade = .15})

	--im hard coding
	for _,obj in script.Effect2:GetChildren() do
		if obj:GetAttribute("WeldOver") then
			obj = obj:Clone()
			obj:FindFirstChildOfClass("Motor6D").Part0 = character:FindFirstChild(obj:FindFirstChildOfClass("Motor6D").Name)			
			obj.Parent = character
			table.insert(CreatedModels[player.UserId], obj)

		end
	end



	table.insert(CreatedModels[player.UserId], Stand)




	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 84883427046172
end


function module:Unequip(player : Player)
	if not CreatedModels[player.UserId] then return end

	for _, model in CreatedModels[player.UserId] do
		model:Destroy()
	end
	
	CreatedModels[player.UserId] = {}
	
	if player ~= localPlayer then return end

	player.IdleAnimationValue.Value = DefaultIdle
end

return module
