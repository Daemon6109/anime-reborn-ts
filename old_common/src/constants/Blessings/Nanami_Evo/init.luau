local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer

function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end
	
	for _, v in script:GetChildren() do
		local motor = v:FindFirstChildOfClass("Motor6D")
		if motor then
			local PartFound = character:FindFirstChild(motor.Name)
			if PartFound then
				v = v:Clone()
				motor = v:FindFirstChildOfClass("Motor6D")

				motor.Part0 = PartFound
				v.Parent = character
				table.insert(CreatedModels[player.UserId], v)
			end

			
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 112626968929674
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
