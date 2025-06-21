local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)


local IsMultipath = workspace:FindFirstChild("MultiPath")
local PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
local MultipathPaths = IsMultipath and IsMultipath:GetChildren()
local NormalPath = not MultipathPaths and PathRoot:GetChildren()

local function CountMultiPathPaths()
	local x = 0

	if not MultipathPaths then return end

	for i,v in MultipathPaths do
		if string.find(v.Name, "Ally") then
			continue
		end

		x += 1
	end

	return x
end

local MultiPath_PathCount = CountMultiPathPaths()

module.config = {
	HitDelay = 1.7, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local newanim = AnimModule.PlayAnim(script.Animation3, unit, 1, "anima", {Weight = 2, Fade = .15})
	
	local Stand = script.stand:Clone()
	Stand.Parent =effectsfolder
	Stand.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(0,0,-1.5)
	local rtf = Stand:WaitForChild("HumanoidRootPart")
	local hrpcff = rtf.CFrame
	game.Debris:AddItem(Stand,5)

	AnimModule.PlayAnim(script.Animation3D4c, Stand, 1, "", {Weight = 2, Fade = .15})

		
	task.wait(.3)
	
	local dust = script:FindFirstChild("GroundStep"):Clone()
	dust.Parent = effectsfolder
	dust.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + Vector3.new(0,-1,0)
	emit.emitvfx(dust)
	
	debris.AddItem(dust,2)
	
	task.wait(.6)

	local dust = script:FindFirstChild("GroundStep"):Clone()
	dust.Parent = effectsfolder
	dust.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2.5) + Vector3.new(0,-1,0)
	emit.emitvfx(dust)
	debris.AddItem(dust,2)

		
	task.wait(1)	

	local eyeflash = script:FindFirstChild("Eyes"):Clone()
	eyeflash.Parent = effectsfolder
	eyeflash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2.5) + Vector3.new(0,.5,0)
	emit.emitvfx(eyeflash)
	debris.AddItem(eyeflash,2)
	
	local tet = script:FindFirstChild("EmitText"):Clone()
	tet.Parent = effectsfolder
	tet.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + Vector3.new(0,.5,0) + (rt.CFrame.RightVector * .5)
	emit.emitvfx(tet)
	debris.AddItem(tet,2)
	

	task.wait(1.4)
	
	local standappear = script:FindFirstChild("Appear"):Clone()
	standappear.Parent = effectsfolder
	standappear.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + Vector3.new(0,.5,0) + (rt.CFrame.RightVector * .5)
	emit.emitvfx(standappear)
	debris.AddItem(standappear,2)
		
	task.wait(.9)


	local start = script:FindFirstChild("start"):Clone()
	start.Parent = effectsfolder
	start.CFrame = rt.CFrame + (rt.CFrame.LookVector * 5) + Vector3.new(0,.5,0) 
	emit.emitvfx(start)
	debris.AddItem(start,2)
	
	local em = script:FindFirstChild("Emit1"):Clone()
	em.Parent = effectsfolder
	em.CFrame = rt.CFrame + (rt.CFrame.LookVector * 5) + Vector3.new(0,.5,0) 
	emit.emitvfx(em)
	debris.AddItem(em,2)
		
	task.spawn(function()
		task.wait(.4)
		
		local tp = script:FindFirstChild("Appear"):Clone()
		tp.Parent = effectsfolder
		tp.CFrame = rt.CFrame
		emit.emitvfx(tp)
		debris.AddItem(tp,2)
		rt.CFrame = startpos
		AnimModule.StopAnim(unit,"anima")
		AnimModule.ChangeAnimSpeed(newanim,11)

	end)	
		
	task.wait(.75)
	
	local main = script:FindFirstChild("Loveuhtrain"):Clone() -- THE ACTGUAL LOVE TRIAN VFX
	
	table.insert(_G.SharedTrash, main)
	
	main.Parent = effectsfolder
	main.Position = rt.Position + Vector3.new(0,-.5,0)
	emit.emitvfx(main)
	debris.AddItem(main,30)
	
	emit.enablevfx(main,true)

	for i, v in pairs(main:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
				
				task.wait(15) -- put this to however long the ability lasts
				

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
				
				task.wait(.3)
				emit.enablevfx(main,false)

				
			end
		end)
	end	
	
	--- base one
	
	do		
		local function spawnLoveTrainOnBase(part)
			local main = script:FindFirstChild("Loveuhtrain"):Clone() -- THE ACTGUAL LOVE TRIAN VFX
			
			table.insert(_G.SharedTrash, main)
			
			main.Parent = effectsfolder
			main.Position = part.Position + Vector3.new(0,-.5,0)
			emit.emitvfx(main)
			debris.AddItem(main,30)

			emit.enablevfx(main,true)

			for i, v in pairs(main:GetDescendants()) do -- tween for making the beams appear smooth
				task.spawn(function()
					if v:IsA("Beam") then
						local oldbeamsize = v.Width0
						local oldbeamsize2 = v.Width1
						v.Width0 = 0
						v.Width1 = 0
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
						TweenComplete:Play()
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
						TweenComplete:Play()

						task.wait(15) -- put this to however long the ability lasts


						local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
						TweenComplete:Play()
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})
						TweenComplete:Play()

						task.wait(.3)
						emit.enablevfx(main,false)


					end
				end)
			end	
		end
		
		if IsMultipath then
			for _,pathRoot in MultipathPaths do
				
				if string.find(pathRoot.Name, "Ally") then
					continue
				end
				
				local PathNodes = pathRoot:GetChildren()
				local LastNode = #PathNodes
				local FoundNode = pathRoot:FindFirstChild(tostring(LastNode))
				
				if FoundNode then
					spawnLoveTrainOnBase(FoundNode.End)
				end
			end
		else
			local LastNode = #NormalPath
			local FoundNode = workspace.Path:FindFirstChild(tostring(LastNode))

			if FoundNode then
				spawnLoveTrainOnBase(FoundNode.End)
			end
		end
	end
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
