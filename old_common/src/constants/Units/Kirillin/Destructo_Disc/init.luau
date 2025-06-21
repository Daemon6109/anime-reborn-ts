local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.6, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}
local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end
function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local newanim = AnimModule.PlayAnim(script.DiscAn, unit, .7, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Miain2"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.5)
	
	
	
	local humrp = rt
	
	local Enemy = pos
	humrp.CFrame = CFrame.lookAt(humrp.Position,Enemy.Position) 

	local o = humrp.CFrame

	local en = script.Disc:Clone()
	en.CFrame = humrp.CFrame * CFrame.new(0,3,0)
	en.Parent = workspace.Effects
	debris.AddItem(en,5)
	wait(.3)

	en.B.Shards2:Emit(8)
	en.B.Specs:Emit(8)

	for i,v in pairs(en:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v:Emit(1)
		elseif v:IsA('Attachment') then
			for i,v2 in pairs(v:GetChildren()) do
				v2:Emit(1)
			end

		end
	end

	task.spawn(function()
		emit.enablevfx(en,true)
		task.wait(.65)
		emit.enablevfx(en,false)
	end)
	
	tween_service:Create(en.PointLight,TweenInfo.new(.15),{Brightness = 3;Range = 8}):Play()
	delay(.65,function()
		tween_service:Create(en.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
	end)

	local cf_ = Enemy.CFrame * CFrame.new(math.random(-2.5,2.5),0,math.random(-2.5,2.5))
	local start = en.Position
	local finish = cf_.Position
	local middle = ((en.Position+finish)/2) + Vector3.new(math.random(6,16),math.random(-1.5,6),math.random(-5,15))

	local step = 35

	wait(.3)


	delay(.01,function()
		for i = 1,step do

			if i == step-3 then

				-- Burst

				local burst = script.Explosion:Clone()
				burst:SetPrimaryPartCFrame(cf_)
				burst.Parent = workspace.Effects
				debris.AddItem(burst,5)

				local dur_burst = .5

				SoundWrapper:PlaySound(script["Miain"], burst, Replicated.SoundGroups.UnitSFX)

				burst.Burst.B.Shards2:Emit(12)
				burst.Burst.B.Specs:Emit(12)
				burst.Burst.Fire:Emit(3)
				burst.Burst.Wind_Explo:Emit(3)
				burst.Origin.Floor.Realistic_Contrast:Emit(1)

				for i,v in pairs(burst.Burst:GetChildren()) do
					if v:IsA('ParticleEmitter') then
						v:Emit(1)
					elseif v:IsA('Attachment') then
						for i,v2 in pairs(v:GetChildren()) do
							v2:Emit(1)
						end

					end
				end
				tween_service:Create(burst.Burst.PointLight,TweenInfo.new(.15),{Brightness = 3;Range = 18}):Play()
				delay(.35,function()
					tween_service:Create(burst.Burst.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
				end)


				for i,v in pairs(burst:GetChildren()) do
					if v:IsA('MeshPart') then
						local siz = v.Size
						v.Size = Vector3.new(0,0,0)

						delay(.01,function()
							tween_service:Create(v,TweenInfo.new(.35,Enum.EasingStyle.Bounce),{Size = siz}):Play()
							tween_service:Create(v,TweenInfo.new(1),{CFrame = v.CFrame * CFrame.Angles(0,math.rad(150),0)}):Play()
							delay(.45,function()
								tween_service:Create(v,TweenInfo.new(.25),{Size = Vector3.new(0,0,0)}):Play()
								delay(.25,function()
									tween_service:Create(v,TweenInfo.new(.15),{Transparency = 1}):Play()
								end)
							end)
						end)
					end
				end

			end

			en.Position = quad(start,middle,finish,i/step)
			game:GetService('RunService').Heartbeat:Wait()
		end
	end)


	delay(.25,function()

		for i = 1,2 do

			local en = script.Disc:Clone()
			en.CFrame = humrp.CFrame * CFrame.new(0,3,0)
			en.Parent = workspace.Effects
			debris.AddItem(en,5)
			SoundWrapper:PlaySound(script["Miain"], en, Replicated.SoundGroups.UnitSFX)

			en.B.Shards2:Emit(4)
			en.B.Specs:Emit(4)

			for i,v in pairs(en:GetChildren()) do
				if v:IsA('ParticleEmitter') then
					v:Emit(1)
				elseif v:IsA('Attachment') then
					for i,v2 in pairs(v:GetChildren()) do
						v2:Emit(1)
					end

				end
			end

			task.spawn(function()
				emit.enablevfx(en,true)
				task.wait(.65)
				emit.enablevfx(en,false)
			end)
			
			tween_service:Create(en.PointLight,TweenInfo.new(.15),{Brightness = 3;Range = 8}):Play()
			delay(.65,function()
				tween_service:Create(en.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
			end)

			local cf_ = Enemy.CFrame * CFrame.new(math.random(-7.5,7.5),-1,math.random(-7.5,7.5))
			local start = en.Position
			local finish = cf_.Position
			local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-35,-15),math.random(-2.5,15),math.random(-35,35))

			if i == 2 then
				middle = ((en.Position+finish)/2) + Vector3.new(math.random(15,35),math.random(-2.5,15),math.random(-35,35))
			end

			local step = 35
			if i == 2 then
				step = 33
			end


			delay(.1,function()
				for i = 1,step do

					if i == step-3 then

						-- Burst

						local burst = script.Explosion:Clone()
						burst:SetPrimaryPartCFrame(cf_)
						burst.Parent = workspace.Effects
						debris.AddItem(burst,5)

						local dur_burst = .5


						burst.Burst.B.Shards2:Emit(7)
						burst.Burst.B.Specs:Emit(7)
						burst.Burst.Fire:Emit(3)
						burst.Burst.Wind_Explo:Emit(3)
						burst.Origin.Floor.Realistic_Contrast:Emit(1)

						for i,v in pairs(burst.Burst:GetChildren()) do
							if v:IsA('ParticleEmitter') then
								v:Emit(1)
							elseif v:IsA('Attachment') then
								for i,v2 in pairs(v:GetChildren()) do
									v2:Emit(1)
								end

							end
						end
						tween_service:Create(burst.Burst.PointLight,TweenInfo.new(.15),{Brightness = 3;Range = 18}):Play()
						delay(.35,function()
							tween_service:Create(burst.Burst.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
						end)


						for i,v in pairs(burst:GetChildren()) do
							if v:IsA('MeshPart') then
								local siz = v.Size
								v.Size = Vector3.new(0,0,0)

								delay(.01,function()
									tween_service:Create(v,TweenInfo.new(.35,Enum.EasingStyle.Bounce),{Size = siz}):Play()
									tween_service:Create(v,TweenInfo.new(1),{CFrame = v.CFrame * CFrame.Angles(0,math.rad(150),0)}):Play()
									delay(.45,function()
										tween_service:Create(v,TweenInfo.new(.25),{Size = Vector3.new(0,0,0)}):Play()
										delay(.25,function()
											tween_service:Create(v,TweenInfo.new(.15),{Transparency = 1}):Play()
										end)
									end)
								end)
							end
						end

					end

					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			AnimModule.ChangeAnimSpeed(newanim,.85)
			wait(.125)

		end

	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
