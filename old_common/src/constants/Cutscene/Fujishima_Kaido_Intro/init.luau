local module = {}

function module:Play()
	--plr Values
	local OriginalFOV = workspace.CurrentCamera.FieldOfView
	local ParamCache = {}
	local SoundGroups = game.ReplicatedStorage.SoundGroups
	local SoundWrapper = require(game.ReplicatedStorage.Libs.SoundWrapper)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local GameVariable = game:GetService("ReplicatedStorage"):WaitForChild("GameVariables")
	local Maid = require(game.ReplicatedStorage.Maid).new()
	local ThreadAccumulator = require(game.ReplicatedStorage.Libs.ThreadAccumulator).new()
	local UIMotion = require(game.ReplicatedStorage.Libs.UIMotion)
	local plr = game.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local CutsceneDummy = script.CutsceneDummy:Clone(); CutsceneDummy.Parent = workspace --game.Workspace.CutsceneDummy
	local Kaido = script.Kaido:Clone(); Kaido.Parent = workspace --workspace.Kaido
	local KaidoDragon = script.KaidoDragon:Clone(); KaidoDragon.Parent = workspace
	local Character = script.RigTemplate:Clone(); Character.Parent = workspace --game.ReplicatedStorage.Character1; Character.Parent = workspace
	local TweenMaid = require(game.ReplicatedStorage.Libs.TweenMaid).new()
	Character:WaitForChild("Humanoid"):ApplyDescription(game.Players:GetHumanoidDescriptionFromUserId(plr.UserId))
	plr:WaitForChild("PlayerGui", 10)
	
	local EffectsBack = {}
	
	for i,v in game:GetService("Lighting"):GetChildren() do
		if not v:IsA("Sky") then
			EffectsBack[v.Name] = v:Clone()
		end
	end
	
	local VersionGUI = plr.PlayerGui:WaitForChild("Version")
	
	VersionGUI.Enabled = false
	
	for i,v in Character:GetDescendants() do
		if v:IsA("LocalScript") or v:IsA("Script") or v:IsA("ModuleScript") then
			v:Destroy()
		end
	end
	
	local hrp = char:WaitForChild("HumanoidRootPart") 
	local cam = CutsceneDummy:WaitForChild("CameraPart")
	
	local PMToEnable = {}
	
	for _,effect in workspace.Map:GetDescendants() do
		if effect:IsA("ParticleEmitter") and effect.Parent.Name == "FireEyes1" then
			table.insert(PMToEnable, effect)
		elseif effect:IsA("ParticleEmitter") and effect.Parent.Name == "FireEyes2" then
			table.insert(PMToEnable, effect)
		elseif effect:IsA("ParticleEmitter") and effect.Parent.Name == "FireEyes3" then
			table.insert(PMToEnable, effect)
		end
	end
	
	for _, v in PMToEnable do
		v.Enabled = false
	end
	
	game.ContentProvider:PreloadAsync({CutsceneDummy, Kaido, KaidoDragon, Character})
	
	hum.AutoRotate = false
	
	hrp:PivotTo(CFrame.new(0,200,0))
	hrp.Anchored = true

	--Services
	local Players = game:GetService("Players")
	local RService = game:GetService("RunService")
	local camera = game.Workspace.CurrentCamera
	local ts = game:GetService("TweenService")

	--Effects
	local Lighting = game.Lighting
	local Blur = Lighting:FindFirstChild("Blur")
	Blur.Size = 2

	local hold = false

	local connection

	local cutscene = "Short"

	local AC1 = Character:WaitForChild("Humanoid"):WaitForChild("Animator")
	local AC2 = KaidoDragon:WaitForChild("AnimationController")
	local AC3 = Kaido:WaitForChild("Humanoid"):WaitForChild("Animator")
	local AC4 = CutsceneDummy:WaitForChild("AnimationController")

	local Charactertrack = AC1:LoadAnimation(AnimModule.GetAnim(script.Characteranim))
	local KaidoDragontrack = AC2:LoadAnimation(AnimModule.GetAnim(script.KaidoDragonanim))
	local Kaidotrack = AC3:LoadAnimation(AnimModule.GetAnim(script.Kaidoanim))
	local Effectstrack = AC4:LoadAnimation(AnimModule.GetAnim(script.Effectsanim))

	local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "CutsceneScreenGui"
	local FadeFrame = Instance.new("Frame")
	local SkipButton = script.SkipButton:Clone()
	
	Maid:GiveTask("CameraStep", game["Run Service"].RenderStepped, function()
		if camera.CameraType == Enum.CameraType.Scriptable then
			camera.CFrame = cam.CFrame	
		end
	end)
	
	ScreenGui.Enabled = true
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 100

	FadeFrame.BackgroundTransparency = 0
	FadeFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	FadeFrame.Size = UDim2.new(2,0,2,0)
	FadeFrame.AnchorPoint = Vector2.new(.5,.5)
	FadeFrame.Position = UDim2.fromScale(.5,.5)
	
	ScreenGui.Parent = plr.PlayerGui
	FadeFrame.Parent = ScreenGui
	SkipButton.Parent = ScreenGui

	Charactertrack.Looped = false
	KaidoDragontrack.Looped = false
	Kaidotrack.Looped = false
	Effectstrack.Looped = false

	Charactertrack:Play()
	KaidoDragontrack:Play()
	Kaidotrack:Play()
	Effectstrack:Play()
	Effectstrack:AdjustSpeed(0.995)

	Character:SetPrimaryPartCFrame(script.TeleportCharacter.CFrame)
	camera.CameraType = Enum.CameraType.Scriptable 
	
	local MusicSoundGroupVolume = SoundGroups.Music.Volume
	
	TweenMaid:GiveTask("MusicMute", ts:Create(SoundGroups.Music, TweenInfo.new(.5, Enum.EasingStyle.Sine), {Volume = 0}))
	
	local SFX = SoundWrapper:PlaySound(script.KaidoCutsceneSFX, plr.PlayerGui, SoundGroups.GeneralSFX, {}, false, true)
	
	local function HideObject(root)
		for _, Obj in root:GetDescendants() do
			if not ParamCache[Obj] then
				if Obj:IsA("BasePart") or Obj:IsA("Decal") or Obj:IsA("Texture") then
					ParamCache[Obj] = {Transparency = Obj.Transparency}
					Obj.Transparency = 1
				end
				
				if Obj:IsA("ParticleEmitter") or Obj:IsA("Beam") or Obj:IsA("BillboardGui") or Obj:IsA("SurfaceGui") then
					ParamCache[Obj] = {Enabled = Obj.Enabled}
					Obj.Enabled = false
				end
			end
		end
	end
	
	local function RestoreFromCache()
		for Obj, ParamTable in ParamCache do
			pcall(function()
				if Obj and Obj.Parent then
					for ParamName, ParamValue in ParamTable do
						Obj[ParamName] = ParamValue
					end
				end
			end)
		end
	end
	
	HideObject(workspace.Players)
	HideObject(workspace.UnitVisuals)
	HideObject(workspace.NPC_Client_Models)
	
	Maid:GiveTask("HidePlrs", workspace.Players.ChildAdded, HideObject)
	Maid:GiveTask("HideUnits", workspace.UnitsPlaced.ChildAdded, HideObject)
	Maid:GiveTask("HideEnemies", workspace.NPC_Client_Models.ChildAdded, HideObject)
	
	task.wait(.2)
	UIMotion:FullRegister(SkipButton, SkipButton.Size, {
		callBack = function()
			TweenMaid:GiveTask("FadeOutSound", ts:Create(SFX, TweenInfo.new(1, Enum.EasingStyle.Sine), {Volume = 0})):onTaskEnd(function()
				task.wait(.1)
				SFX:Destroy()
			end)
			local KaidoSavedCFR = CFrame.new(52.9713402, 4.46504879, 0.333678246, 1, 0, 0, 0, 1, 0, 0, 0, 1)
			ThreadAccumulator:Dispose()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 0.04}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 0.7}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = -0.1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(255,253,235)}):Play()
			for _, v in PMToEnable do
				v.Enabled = true
			end
			SkipButton:Destroy()
			TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(1.5,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {BackgroundTransparency = 0}))
			task.wait(1.5)
			
			do
				Kaidotrack:Stop()
				Kaidotrack = AC3:LoadAnimation(AnimModule.GetAnim(script.KaidoIdle))
				Kaidotrack:Play()
				Kaido.HumanoidRootPart.CFrame = KaidoSavedCFR
				local KaidoMaid = Maid.new()
				local CurrWave = GameVariable.CurrentWave
				local SpawnAnim = AC3:LoadAnimation(AnimModule.GetAnim(script.KaidoSpawn))
				KaidoMaid:GiveTask("EnterTrack", GameVariable.CurrentWave.Changed, function()
					if GameVariable.CurrentWave.Value == 15 then
						Kaidotrack:Stop(.1)
						SpawnAnim:Play(.1)
						SpawnAnim.Ended:Once(function()
							Kaido:Destroy()
						end)
						KaidoMaid:Dispose()
					end
				end)
			end
			
			_G.IntroCutscenePlayed = true
			CutsceneDummy:Destroy()
			KaidoDragon:Destroy()
			Character:Destroy()
			camera.CameraType = Enum.CameraType.Custom
			Maid:Dispose()
			hrp.Anchored = false
			hrp:PivotTo((workspace:FindFirstChild("Spawns") or workspace.Map.Spawns).SpawnLocation.CFrame*CFrame.new(math.random(-1.5,1.5),2,math.random(-.5,.5)))
			hum.AutoRotate = true
			VersionGUI.Enabled = true
			TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(2,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {BackgroundTransparency = 1}))
			TweenMaid:GiveTask("MusicUnmute", ts:Create(SoundGroups.Music, TweenInfo.new(2, Enum.EasingStyle.Sine), {Volume = MusicSoundGroupVolume}))
			RestoreFromCache()
			workspace.CurrentCamera.FieldOfView = OriginalFOV
			for i,v in game:GetService("Lighting"):GetChildren() do
				local _orig = EffectsBack[v.Name]
				if _orig then
					v:Destroy()
					_orig.Parent = game.Lighting
				end
			end
			task.wait(3)
			TweenMaid = nil
			ScreenGui:Destroy()
			ParamCache = nil
		end,	
	})
	ThreadAccumulator:AddThread(nil, task.spawn(function()
		ts:Create(FadeFrame, TweenInfo.new(1.5,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {BackgroundTransparency = 1}):Play()

		local function Haki()
			repeat wait()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Brightness = 1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Contrast = 1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Saturation = -1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TintColor = Color3.fromRGB(255,253,235)}):Play()
				wait(0.1)
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Brightness = 0.2}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Contrast = 1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Saturation = -0.9}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TintColor = Color3.fromRGB(125,128,255)}):Play()
				wait(0.1)
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Brightness = 1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Contrast = 0.6}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Saturation = 0.7}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TintColor = Color3.fromRGB(127,128,255)}):Play()
				wait(0.1)
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Brightness = 1}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Contrast = 0.6}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Saturation = 0.7}):Play()
				ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TintColor = Color3.fromRGB(127,128,255)}):Play()
			until hold == true
		end

		print("Setting Effects")	

		CutsceneDummy.EyeAnimated.EyeHighlight.Enabled = false

		ThreadAccumulator:AddThread(nil, task.delay(9.5,function() --Color Correction
			ThreadAccumulator:AddThread(nil,task.delay(0,function()
				Haki()
			end))
			wait(1.333)

			hold = true

			wait(0.1)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 0.04}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 0.7}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = -0.1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(255,253,235)}):Play()
			wait(7)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = -1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(255,253,235)}):Play()
			wait(0.1)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 0.2}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = -0.9}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(125,128,255)}):Play()
			wait(0.1)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 0.6}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = 0.7}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(127,128,255)}):Play()
			wait(0.1)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 0.6}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = 0.7}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(127,128,255)}):Play()
			wait(0.1)
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Brightness = 0.04}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Contrast = 0.7}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {Saturation = -0.1}):Play()
			ts:Create(Lighting.ColorCorrection, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {TintColor = Color3.fromRGB(255,253,235)}):Play()
			TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,1), {BackgroundTransparency = 0}))
			wait(2)
			TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(1,Enum.EasingStyle.Quad, Enum.EasingDirection.In,0,false,0), {BackgroundTransparency = 1}))
		end))

		ThreadAccumulator:AddThread(nil, task.delay(0,function() --Color Wall & Different ColorWall Effect
			CutsceneDummy.DifferentColorWall.Transparency = 1
			CutsceneDummy.Colorwall.Transparency = 0
			CutsceneDummy.Colorwall.Color = Color3.fromRGB(0, 0, 0)
			ts:Create(CutsceneDummy.Colorwall, TweenInfo.new(0.75,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0.75}):Play()
			wait(0.75)
			ts:Create(CutsceneDummy.Colorwall, TweenInfo.new(1.25,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()
			wait(17.417)
			CutsceneDummy.DifferentColorWall.Color = Color3.fromRGB(255,255,255)
			ts:Create(CutsceneDummy.DifferentColorWall, TweenInfo.new(0.5,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()
			wait(0.5)
			ts:Create(CutsceneDummy.DifferentColorWall, TweenInfo.new(0.5,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Color = Color3.new(0,0,0)}):Play()
			wait(0.5)
			ts:Create(CutsceneDummy.DifferentColorWall, TweenInfo.new(1,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()
			wait(4.583)
			TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(1.5,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {BackgroundTransparency = 0}))
			ts:Create(CutsceneDummy.DifferentColorWall, TweenInfo.new(2,Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()
		end))

		ThreadAccumulator:AddThread(nil, task.delay(0,function() --FOV Effect
			camera.FieldOfView = 70
			ts:Create(camera, TweenInfo.new(3,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 65}):Play()
			wait(9.5)
			ts:Create(camera, TweenInfo.new(0.03,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 120}):Play()
			wait(0.03)
			ts:Create(camera, TweenInfo.new(0.04,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 40}):Play()
			wait(0.04)
			ts:Create(camera, TweenInfo.new(0.217,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 120}):Play()
			wait(2.467)
			ts:Create(camera, TweenInfo.new(0.01,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 70}):Play()
		end))

		ThreadAccumulator:AddThread(nil, task.delay(7.3,function() --Eye Effect
			CutsceneDummy.EyeAnimated.EyeHighlight.Enabled = true
			wait(3.75)
			CutsceneDummy.EyeAnimated.EyeHighlight.Enabled = false
		end))

		ThreadAccumulator:AddThread(nil, task.delay(2.75,function() --Blur Effect
			ts:Create(Blur, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Size = 24}):Play()
			wait(0.25)
			ts:Create(Blur, TweenInfo.new(0.417,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Size = 2}):Play()
			wait(3.583)
			ts:Create(Blur, TweenInfo.new(0.1,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Size = 12}):Play()
			wait(0.1)
			ts:Create(Blur, TweenInfo.new(0.25,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Size = 4}):Play()
		end))

		ThreadAccumulator:AddThread(nil, task.delay(14.333,function() --Blur Effect
			local DragonHighlight = KaidoDragon.KaidoDragonHighlight
			DragonHighlight.Enabled = true
			DragonHighlight.FillColor = Color3.fromRGB(255,255,255)
			DragonHighlight.OutlineColor = Color3.fromRGB(255,255,255)

			ts:Create(DragonHighlight, TweenInfo.new(0.250,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FillTransparency = 0}):Play()
			wait(1.884)
			DragonHighlight.Enabled = false
		end))

		ThreadAccumulator:AddThread(nil, task.delay(16.167,function() --Blur Effect
			local Highlight = Kaido.KaidoHighlight
			Highlight.Enabled = true

			ts:Create(Highlight, TweenInfo.new(0.167,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FillColor = Color3.fromRGB(255,255,255),OutlineColor = Color3.fromRGB(255,255,255)}):Play()
			wait(1.416)
			Highlight.Enabled = false
		end))

		ThreadAccumulator:AddThread(nil, task.delay(20,function() --Skull Fire Effect
			for _, v in PMToEnable do
				v.Enabled = true
			end
			
			local KaidoSavedCFR = Kaido.HumanoidRootPart.CFrame
			
			ThreadAccumulator:AddThread(nil, task.delay(3, function()
				SkipButton:Destroy()
				task.wait(3)
				do
					Kaidotrack:Stop()
					Kaidotrack = AC3:LoadAnimation(AnimModule.GetAnim(script.KaidoIdle))
					Kaidotrack:Play()
					local KaidoMaid = Maid.new()
					local CurrWave = GameVariable.CurrentWave
					local SpawnAnim = AC3:LoadAnimation(AnimModule.GetAnim(script.KaidoSpawn))
					KaidoMaid:GiveTask("EnterTrack", GameVariable.CurrentWave.Changed, function()
						if GameVariable.CurrentWave.Value == 15 then
							Kaidotrack:Stop(.1)
							SpawnAnim:Play(.1)
							SpawnAnim.Ended:Once(function()
								Kaido:Destroy()
							end)
							KaidoMaid:Dispose()
						end
					end)
				end
				_G.IntroCutscenePlayed = true
				CutsceneDummy:Destroy()
				KaidoDragon:Destroy()
				Character:Destroy()
				camera.CameraType = Enum.CameraType.Custom
				Maid:Dispose()
				hrp.Anchored = false
				hrp:PivotTo((workspace:FindFirstChild("Spawns") or workspace.Map.Spawns).SpawnLocation.CFrame*CFrame.new(math.random(-1.5,1.5),2,math.random(-.5,.5)))
				hum.AutoRotate = true
				VersionGUI.Enabled = true
				TweenMaid:GiveTask("FadeFrame", ts:Create(FadeFrame, TweenInfo.new(2,Enum.EasingStyle.Sine), {BackgroundTransparency = 1}))
				Kaido.HumanoidRootPart.CFrame = KaidoSavedCFR
				TweenMaid:GiveTask("MusicUnmute", ts:Create(SoundGroups.Music, TweenInfo.new(2, Enum.EasingStyle.Sine), {Volume = MusicSoundGroupVolume}))
				RestoreFromCache()
				for i,v in game:GetService("Lighting"):GetChildren() do
					local _orig = EffectsBack[v.Name]
					if _orig then
						v:Destroy()
						_orig.Parent = game.Lighting
					end
				end
				workspace.CurrentCamera.FieldOfView = OriginalFOV
				task.wait(3)
				SFX:Destroy()
				ScreenGui:Destroy()
				TweenMaid = nil
				ParamCache = nil
			end))
		end))
	end))
end

return module
