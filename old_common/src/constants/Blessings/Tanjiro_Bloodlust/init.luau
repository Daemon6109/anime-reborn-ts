local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer



function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script.Effect:GetChildren() do
		if v:GetAttribute("WeldOver") then
			local motor = v:FindFirstChildOfClass("Motor6D") or v:FindFirstChildWhichIsA("WeldConstraint")
			
			if motor then
				local PartFound = character:FindFirstChild(motor:GetAttribute("Limb") or motor.Name)
				
				if PartFound then
					v = v:Clone()
					motor = v:FindFirstChildOfClass("Motor6D") or v:FindFirstChildWhichIsA("WeldConstraint")
					
					if motor.Part0 then
						motor.Part1 = PartFound
					else
						motor.Part0 = PartFound
					end

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
	player.IdleAnimationValue.Value = 17881512810
end

function module:ShinyEquip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	for _, v in script.Effect2:GetChildren() do
		if v:GetAttribute("WeldOver") then
			local motor = v:FindFirstChildOfClass("Motor6D") or v:FindFirstChildWhichIsA("WeldConstraint")

			if motor then
				local PartFound = character:FindFirstChild(motor:GetAttribute("Limb") or motor.Name)

				if PartFound then
					v = v:Clone()
					motor = v:FindFirstChildOfClass("Motor6D") or v:FindFirstChildWhichIsA("WeldConstraint")

					if motor.Part0 then
						motor.Part1 = PartFound
					else
						motor.Part0 = PartFound
					end
					
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
	player.IdleAnimationValue.Value = 17881512810
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
