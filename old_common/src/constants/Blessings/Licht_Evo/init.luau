local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DefaultIdle = ReplicatedStorage.Animations.Idle.Value
local module = {}

local CreatedModels = {}

local localPlayer = game.Players.LocalPlayer

function module:Equip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end
	
	local function iterate(obj, parent)
		for _, v in obj:GetChildren() do
			if v:GetAttribute("WeldOver") then
				local motor = v:FindFirstChildOfClass("Motor6D")
				if motor then
					local PartFound = character:FindFirstChild(motor.Name)
					if PartFound then
						v = v:Clone()
						motor = v:FindFirstChildOfClass("Motor6D")

						motor.Part0 = PartFound
						v.Parent = parent or character
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
	end
	
	iterate(script.Effect)
	local l = script.Effect["Licht Shiny Evo [ Anime Reborn ]"]:Clone()
	l.Parent = character
	for _,v in l:GetChildren() do
		if v:GetAttribute("WeldOver")then
			local motor = v:FindFirstChildOfClass("Motor6D")
			if motor then
				local PartFound = character:FindFirstChild(motor.Name)
				if PartFound then
					motor = v:FindFirstChildOfClass("Motor6D")

					motor.Part0 = PartFound
				end
			end
		end
	end	
	table.insert(CreatedModels[player.UserId], l)

	

	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 103922394288913
end


function module:ShinyEquip(player: Player)
	local character = player.Character or player.CharacterAppearanceLoaded:Wait()
	if not CreatedModels[player.UserId] then CreatedModels[player.UserId] = {} end

	local function iterate(obj, parent)
		for _, v in obj:GetChildren() do
			if v:GetAttribute("WeldOver") then
				local motor = v:FindFirstChildOfClass("Motor6D")
				if motor then
					local PartFound = character:FindFirstChild(motor.Name)
					if PartFound then
						v = v:Clone()
						motor = v:FindFirstChildOfClass("Motor6D")

						motor.Part0 = PartFound
						v.Parent = parent or character
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
	end

	iterate(script.Effect2)
	local l = script.Effect2["Licht Evo [ Anime Reborn ]"]:Clone()
	l.Parent = character
	for _,v in l:GetChildren() do
		if v:GetAttribute("WeldOver")then
			local motor = v:FindFirstChildOfClass("Motor6D")
			if motor then
				local PartFound = character:FindFirstChild(motor.Name)
				if PartFound then
					motor = v:FindFirstChildOfClass("Motor6D")

					motor.Part0 = PartFound
				end
			end
		end
	end	
	table.insert(CreatedModels[player.UserId], l)



	if player ~= localPlayer then return end
	player.IdleAnimationValue.Value = 103922394288913
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
