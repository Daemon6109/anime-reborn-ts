local unit = game.Workspace:WaitForChild("Baruka")
local pos = game.Workspace:WaitForChild("BarukaPos")

local rt = unit:WaitForChild("HumanoidRootPart")
local humanoid = unit:WaitForChild("Humanoid")

wait()
local mesh = script:WaitForChild("Mesh")
local sounds = script:WaitForChild("Sounds")
local animations = script:WaitForChild("Animations")
local effectsfolder = game.Workspace.CurrentCamera

local tween_service = game:GetService("TweenService")
local run_service = game:GetService("RunService")
local debris_service = game:GetService("Debris")
local debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

local emit = require(script.Modules.emit)
local rocks = require(script.Modules.RocksModule)

local goalpos = pos.CFrame
local startpos = rt.CFrame
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 

end

warn("Loading Anims...")
wait(0.65)
warn("Anims Loaded!")

humanoid:LoadAnimation(animations.Idle):Play()

wait(3.5)


local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			task.spawn(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end        
				if v:GetAttribute("EmitDuration") then
					v.Enabled = true
					task.wait(v:GetAttribute("EmitDuration"))
					v.Enabled = false
				end


			end)

		end
	end
end


wait(1)

wait()
local chosen_skill = 3
wait()

wait(1)

while true do	
	if chosen_skill == 3 then
		chosen_skill = 1 
		rt.CFrame = CFrame.new(rt.Position, pos.Position)
		
		function movehere1()
			rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
			
			local oldcf = rt.CFrame
			
			local ElfKick = mesh.ElfKick:Clone()
			ElfKick.Parent = effectsfolder
			ElfKick.CFrame = pos.CFrame
			
			wait(0.865)

			unit.Torso.tp:Emit(25)
			wait(.12)
			rt.CFrame = CFrame.new(pos.Position.X,rt.Position.Y,pos.Position.Z)  *CFrame.new(-1,0,0) * CFrame.Angles(math.rad(rt.Orientation.X),math.rad(rt.Orientation.Y),math.rad(rt.Orientation.Z))
			wait(.03)
			unit.Torso.tp:Emit(25)	

			local anim = humanoid:LoadAnimation(animations.attk1)
			anim:Play()

			wait(0.5)

			emit.emitvfx(ElfKick)

			wait(1)

			unit.Torso.tp:Emit(25)
			wait(.12)
			rt.CFrame  = oldcf
			wait(.03)
			unit.Torso.tp:Emit(25)	

			debris_service:AddItem(ElfKick, 3)
		end
		movehere1()
		wait(2)
		
	elseif chosen_skill == 1 then
		chosen_skill = 2
		
		rt.CFrame = CFrame.new(rt.Position, pos.Position)

		function movehere2()
			rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
			
			local oldcf = rt.CFrame

			local anim = humanoid:LoadAnimation(animations.attk2)
			anim:Play()
			
			wait(0.5)
			unit.Torso.tp:Emit(45)
			wait(0.45)
			
			rt.CFrame = pos.CFrame + Vector3.new(0,10,0) + (rt.CFrame.LookVector * -4)
			
			wait(0.1)
			
			local info = TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
			local tween = tween_service:Create(rt,info,{CFrame = pos.CFrame + Vector3.new(0,-.2,0)})
			tween:Play()

			wait(0.2)

			local impact = mesh.Impact:Clone()
			impact.Parent = effectsfolder
			impact.CFrame = pos.CFrame * CFrame.new(0,-1.3,0)
			
			emit.emitvfx(impact)

			unit.Torso.tp:Emit(25)			

			wait(1)

			unit.Torso.tp:Emit(25)
			wait(.12)

			rt.CFrame = oldcf

			wait(.03)
			unit.Torso.tp:Emit(25)
			
			debris_service:AddItem(impact, 4)
		end
		movehere2()
		wait(2)
	elseif chosen_skill == 2 then
		chosen_skill = 3
		
		rt.CFrame = CFrame.new(rt.Position, pos.Position)

		function movehere3()
			rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
			
			local oldcf = rt.CFrame
			
			local slashes = mesh.Slashes:Clone()
			slashes.Parent = effectsfolder
			slashes.CFrame = pos.CFrame
			
			local anim = humanoid:LoadAnimation(animations.attk3)
			anim:Play()
			
			wait(1.1)
			
			unit.Torso.tp:Emit(25)

			rt.CFrame = pos.CFrame			
			
			emit.enablevfx(unit.Torso, true)
			emit.enablevfx(slashes, true)
			
			wait(anim.Length - 0.2)
			
			emit.enablevfx(unit.Torso, false)
			
			unit.Torso.tp:Emit(25)
			emit.enablevfx(slashes, false)
			emit.emitvfx(slashes.Impact)

			rt.CFrame = oldcf
			
		end
		movehere3()
		wait(2)
	end
end

wait(3)
