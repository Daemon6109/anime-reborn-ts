local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .8, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.thirdattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["3"], rt, Replicated.SoundGroups.UnitSFX)

	local a = rt.CFrame
	emit.trailonoff(unit.Folder,true)

	local enable = script.atk3enable:Clone() -- vfx
	enable.Parent = workspace.Effects
	enable.Position = rt.Position + Vector3.new(0,-1.25,0)
	emit.enablevfx(enable,true)
	debris.AddItem(enable,2.5)

	task.spawn(function()
		for i=0,5,1 do
			wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(26, 255, 45)),0.0005,.7,"Long",false,0,0,4)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.0005,.7,"Long",false,0,0,4)
		end
	end)

	wait(.55)

	local Slash1StartCFrame = a
	local Slash2StartCFrame = a * CFrame.Angles(0, math.rad(-15), 0)
	local Slash3StartCFrame = a * CFrame.Angles(0, math.rad(15),0)

	local function slash3(start)
		task.spawn(function()
			local endposss = start.Position + (start.LookVector * 20)  -- THIS MOVE IS SUPPOSED TO BE LINE/CONE AOE SO THE END POSITION ISN'T THE ENEMY POS

			emit.emitvfx(enable.emitbig)
			emit.enablevfx(enable,false)



			local slash = script.atk3slash:Clone() -- vfx
			slash.Parent = workspace.Effects
			slash.Position =  start.Position + (start.LookVector * 2) 
			slash.aa.Position =  start.Position + (start.LookVector * 1) 
			emit.enablevfx(slash,true)
			debris.AddItem(slash,2.5)

			slash.CFrame = CFrame.lookAt(slash.Position, endposss)

			for i, v in pairs(slash:GetDescendants()) do -- tween for making the beams appear smooth
				task.spawn(function()
					if v:IsA("Beam") then
						local oldbeamsize = v.Width0
						local oldbeamsize2 = v.Width1


						task.wait(.25)

						local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
						TweenComplete:Play()
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})  -- tween for the beams to dissapear
						TweenComplete:Play()
					end
				end)
			end	
			local trailpartup = script.Gotrail:Clone()
			trailpartup.Parent = workspace.Effects
			trailpartup.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
			task.spawn(function()
				emit.Trailgoup(trailpartup,.3,endposss,.6,1)
			end)
			debris.AddItem(trailpartup,2.5)

			local info = TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
			local tween = tween_service:Create(slash,info,{Position = endposss}) -- tween for the slash
			tween:Play()
			local info = TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
			local tween = tween_service:Create(slash.aa,info,{Position = endposss}) -- tween for the slash
			tween:Play()


			task.wait(.1)

			slash.g.LinesParticle2.Enabled = false
			slash.g.LinesParticle3.Enabled = false

			task.wait(.35)
			local aaaa = script.Abc:Clone() -- vfx
			aaaa.Parent = workspace.Effects
			aaaa.Position =  slash.Position 
			debris.AddItem(aaaa,2.5)

			emit.emitvfx(aaaa)
			emit.enablevfx(slash,true)
			emit.emitvfx(slash.endem)
			emit.enablevfx(slash.sidesmokee,false)
			emit.enablevfx(slash.sidesmokee2,false)

			emit.enablevfx(slash.Attachment2,false)
			emit.enablevfx(slash.trail1,false)
			emit.enablevfx(slash.aa,false)
			emit.enablevfx(slash.g,false)


		end)


	end

	emit.trailonoff(unit.Folder,false)


	slash3(Slash1StartCFrame)
	slash3(Slash2StartCFrame)
	slash3(Slash3StartCFrame)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
