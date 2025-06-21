local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .65, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}




local function tp(humrp,cf)

	local x = {humrp,cf}

	for i = 1,2 do
		local model = script.Blink:Clone()
		model.CFrame = x[i]
		model.Parent = workspace.Effects
		debris.AddItem(model,5)

		task.spawn(function()
			emit.enablevfx(model,true)
			task.wait(.25)
			emit.enablevfx(model,false)
		end)
	end

end




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

	local newanim = AnimModule.PlayAnim(script.Tornadoan, unit, 1, "", {Weight = 2, Fade = .15})

	local humrp = rt
	local Enemy = pos
	humrp.CFrame = CFrame.lookAt(humrp.Position,Enemy.Position) 

	local o = humrp.CFrame




	tp(humrp.CFrame,Enemy.CFrame)
	delay(.15,function()
		humrp.CFrame = Enemy.CFrame
	end)

	delay(1,function()
		tp(humrp.CFrame * CFrame.new(0,4.8,0),o)
		delay(.15,function()
			humrp.CFrame = o
		end)
	end)

	wait(.65)

	SoundWrapper:PlaySound(script["Tornado"], rt, Replicated.SoundGroups.UnitSFX)
	
	local model = script.Whirlwind:Clone()
	model:SetPrimaryPartCFrame(Enemy.CFrame * CFrame.new(0,3,0))
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	local dur = .4

	task.spawn(function()
		emit.enablevfx(model.Burst,true)
		task.wait(dur+.35)
		emit.enablevfx(model.Burst,false)
	end)

	delay(.01,function()
		for i = 1,50 do
			model:SetPrimaryPartCFrame(model:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(3.5),0))
			game:GetService('RunService').Heartbeat:Wait()
		end
	end)

	for i,v in pairs(model:GetChildren()) do
		if v.Name == 'Part' then

			delay(.1,function()
				for i = 1,3 do
					tween_service:Create(v,TweenInfo.new(.15),{
						CFrame = v.CFrame * CFrame.Angles(math.rad(math.random(-5,5)),math.rad(90),math.rad(math.random(-5,5)))
					}):Play()
				end	
			end)

			for i,v2 in pairs(v:GetChildren()) do
				if v2:IsA('Beam') then
					local w0 = v2.Width0
					local w1 = v2.Width1

					v2.Width0 = 0
					v2.Width1 = 0

					delay(.15,function()
						tween_service:Create(v2,TweenInfo.new(.25),{Width0 = w0*math.random(1.5,2.5);Width1 = w1*math.random(1.5,2.5)}):Play()
						delay(.15,function()
							tween_service:Create(v2,TweenInfo.new(.15),{Width0 = w0;Width1 = w1}):Play()
							delay(dur,function()
								tween_service:Create(v2,TweenInfo.new(.25),{Width0 = 0;Width1 = 0}):Play()
							end)

						end)
					end)

				end
			end

		end
	end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
