local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimModule = require(ReplicatedStorage.AnimModule)

local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer



function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script.Effects:GetChildren() do

		if v:GetAttribute("WeldOver") then
			local motor = v:FindFirstChildOfClass("Motor6D")
			if motor then
				local PartFound = character:FindFirstChild(motor:GetAttribute("Limb") or motor.Name)
				if PartFound then

					v = v:Clone()
					motor = v:FindFirstChildOfClass("Motor6D")

					motor.Part0 = PartFound
					v.Parent = character
					table.insert(CreatedModels[player.UserId], v)
					
					if v:GetAttribute("Snake") then
						local LoadAnim = v:FindFirstChild("AnimationController"):LoadAnimation(AnimModule.GetAnim(v:FindFirstChild("AnimationController"):FindFirstChild("Animation")))				
						LoadAnim:Play()
					end
					if v:GetAttribute("Skirt") then
						local LoadAnim = v:FindFirstChild("AnimationControllerSkirt"):LoadAnimation(AnimModule.GetAnim(v:FindFirstChild("AnimationControllerSkirt"):FindFirstChild("Animation")))				
						LoadAnim:Play()
					end
				
				end


			end
		else
			for _,ef in v:GetChildren() do
				if ef:IsA("ParticleEmitter") or (ef:IsA("Attachment") and ef:FindFirstChildOfClass("ParticleEmitter")) then
					local partFound = character:FindFirstChild(ef.Parent.Name)
					if partFound then
						ef = ef:Clone()
						ef.Parent = partFound
						table.insert(CreatedModels[player.UserId], ef)

					end
				end
			end
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 103892206281639
end

function module:ShinyEquip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script.EffectsShiny:GetChildren() do
		if v:GetAttribute("WeldOver") then
			local motor = v:FindFirstChildOfClass("Motor6D")

			if motor then
				local PartFound = character:FindFirstChild(motor:GetAttribute("Limb") or motor.Name)

				if PartFound then
					v = v:Clone()
					motor = v:FindFirstChildOfClass("Motor6D")

					motor.Part0 = PartFound
					v.Parent = character
					table.insert(CreatedModels[player.UserId], v)

				
				end


			end
		else
			for _,ef in v:GetChildren() do
				if ef:IsA("ParticleEmitter") or (ef:IsA("Attachment") and ef:FindFirstChildOfClass("ParticleEmitter")) then
					local partFound = character:FindFirstChild(ef.Parent.Name)
					if partFound then
						ef = ef:Clone()
						ef.Parent = partFound
						table.insert(CreatedModels[player.UserId], ef)

					end
				end
			end
		end
	end
	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 103892206281639
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
