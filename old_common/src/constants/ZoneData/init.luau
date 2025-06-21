local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UiCommunication = ReplicatedStorage.Events.UiCommunication

export type ZoneDataType = {
	
	OnEnter: (ZoneInstance) -> ()?; -- Fires once the player enters a zone
	OnExit: (ZoneInstance) -> ()?; -- Fires once the player leaves a zone
	
	HighlightData: {
		FillColor: Color3?;
		OutlineColor: Color3?;
		GoalFillTransparency: number?;
		GoalOutlineTransparency: number?;
	}?;
}


local function OpenDialogueWindow(dialogue)
	_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, dialogue)

end
local function CloseDialogueWindow()
	_G.WindowManager:CloseWindow("Dialogue")

end

local AdventureZoneLoaded = true
local MainZoneLoaded = true
local CachedAdventureZone = false
local CachedMainZone = false
local AdventureZoneDescendants
local MainZoneDescendants
local MainZoneVFXDescendants

--local function ToggleAdventureZoneVisual()
--	if not AdventureZoneDescendants then
--		if workspace:FindFirstChild("AdventureMap") then
--			AdventureZoneDescendants = workspace.AdventureMap:GetDescendants()
--		end
--	end
	
--	if AdventureZoneDescendants then
--		if not CachedAdventureZone then
--			for i,v in AdventureZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					if not v:GetAttribute("Transparency") then
--						v:SetAttribute("Transparency", v.Transparency)
--					end
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					if v:GetAttribute("Enabled") == nil then
--						v:SetAttribute("Enabled", v.Enabled)
--					end
--				end
--			end
--		end

--		if AdventureZoneLoaded then
--			for i,v in AdventureZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					v.Transparency = 1
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					v.Enabled = false
--				end
--			end
--		else
--			for i,v in AdventureZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					v.Transparency = v:GetAttribute("Transparency")
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					v.Enabled = v:GetAttribute("Enabled")
--				end
--			end
--		end

--		AdventureZoneLoaded = not AdventureZoneLoaded
--	end
--end

--local function ToggleMainZoneVisual()
--	if not MainZoneDescendants then
--		if workspace:FindFirstChild("Map") then
--			MainZoneDescendants = workspace.Map:GetDescendants()
--		end
--	end

--	if MainZoneDescendants then
--		if not CachedMainZone then
--			for i,v in MainZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					if not v:GetAttribute("Transparency") then
--						v:SetAttribute("Transparency", v.Transparency)
--					end
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					if v:GetAttribute("Enabled") == nil then
--						v:SetAttribute("Enabled", v.Enabled)
--					end
--				end
--			end
--		end

--		if MainZoneLoaded then
--			for i,v in MainZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					v.Transparency = 1
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					v.Enabled = false
--				end
--			end
--		else
--			for i,v in MainZoneDescendants do
--				if (v:IsA("BasePart") or v:IsA("Texture")) and not v:GetAttribute("Ignore") then
--					v.Transparency = v:GetAttribute("Transparency")
--				end 

--				if (v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight")) and not v:GetAttribute("Ignore") then
--					v.Enabled = v:GetAttribute("Enabled")
--				end
--			end
--		end

--		MainZoneLoaded = not MainZoneLoaded
--	end
--end

--ToggleAdventureZoneVisual()

local ZoneData: {[string]: ZoneDataType} = { --// Index is the zone name
	EvolveZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Evolve", HideSlotBar = true, BarsHidden = true})
		end,
		
		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Evolve" then return end
			_G.WindowManager:CloseWindow("Evolve")

		end,
	},
	
	LeaderboardZone = {
		OnEnter = function(Zone)
			_G.WindowManager:OpenWindow({WindowName = "LeaderboardInfo", HideSlotBar = true, BarsHidden = true}, Zone:GetAttribute("LeaderboardName"))
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "LeaderboardInfo" then return end
			_G.WindowManager:CloseWindow("LeaderboardInfo")

		end,
	},
	
	CollisionEvent = {

			OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Crates", BarsHidden = true, Darken = true, HideSlotBar = true})
			end,

			OnExit = function()
			if _G.WindowManager.openedWindow == "Crates" then
				_G.WindowManager:CloseWindow("Crates")
				end
			end,

			HighlightData = {
				FillColor = Color3.fromRGB(85, 0, 127);
				GoalFillTransparency = 0.7;
			};

	};
	
	MountsZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Mounts", HideSlotBar = true, BarsHidden = true})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Mounts" then return end
			_G.WindowManager:CloseWindow("Mounts")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(170, 0, 0);
		};
	},
	
	EnemyTypes = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "EnemyIndex", HideSlotBar = true, BarsHidden = true})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "EnemyIndex" then return end
			_G.WindowManager:CloseWindow("EnemyIndex")
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170, 0, 0);
		};
	},
	
	AdventureMapZone = {
		OnEnter = function()
			local LightingHandler = require(ReplicatedStorage.Libs.LightingMaster)
			
			LightingHandler:SetLighting(ReplicatedStorage.LightingDirectory.AdventureMap)
			--ToggleAdventureZoneVisual()
			--ToggleMainZoneVisual()
		end,

		OnExit = function()
			local LightingHandler = require(ReplicatedStorage.Libs.LightingMaster)
			
			LightingHandler:RestoreOriginalLighting()
			--ToggleAdventureZoneVisual()
			--ToggleMainZoneVisual()
		end,
	},
	
	
	TraitRerollZone = {
		
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "TraitReroll")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			elseif _G.WindowManager.openedWindow == "TraitReroll" then
				_G.WindowManager:CloseWindow("TraitReroll")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(170,0,127);
		};
	},
	StatPotReroll = {
		OnEnter = function()
			
			_G.WindowManager:OpenWindow({WindowName = "StatPotReroll"})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "StatPotReroll" then return end

			_G.WindowManager:CloseWindow("StatPotReroll")
		end,
	},
	SummonZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Summon", BarsHidden = true, HideSlotBar = false})

		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Summon" then return end

			_G.WindowManager:CloseWindow("Summon")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(170,0,127);
		};
	},
	
	SummonEventZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "SummonEvent", BarsHidden = true, HideSlotBar = false})

		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "SummonEvent" then return end

			_G.WindowManager:CloseWindow("SummonEvent")
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170,0,127);
		};
	},
	
	CraftingZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "Crafting")
		end,
		
		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			elseif _G.WindowManager.openedWindow == "Crafting" then
				_G.WindowManager:CloseWindow("Crafting")
			end
		end,
	},
	
	UnitIndexZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "UnitIndex")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				CloseDialogueWindow()
			elseif _G.WindowManager.openedWindow == "UnitIndex" then
				_G.WindowManager:CloseWindow("UnitIndex")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(158, 23, 255);
			GoalFillTransparency = 0.5;
		};
	},
	
	CodesZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Codes"})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Codes" then return end

			_G.WindowManager:CloseWindow("Codes")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(19,165,255);
			GoalFillTransparency = 0.7;
		};
	},
	
	LevelRewards = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "LevelRewards")
		end,
		
		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			elseif _G.WindowManager.openedWindow == "LevelRewards" then
				_G.WindowManager:CloseWindow("LevelRewards")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(0,255,0);
		};
	},
	
	AFKZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "AFK")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(255,85,0);
			GoalFillTransparency = 0.85;
		};
	},
	
	LeaderboardRewardsZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "LeaderboardRewards")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255, 170, 0);
			GoalFillTransparency = 0.78;
		};
	},
	
	MerchantZone = {
		OnEnter = function()
			OpenDialogueWindow("Merchant")
			--_G.WindowManager:OpenWindow({WindowName = "Merchant", BarsHidden = true})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				CloseDialogueWindow()
			elseif _G.WindowManager.openedWindow == "Merchant" then
				_G.WindowManager:CloseWindow("Merchant")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(255,100,0);
		};
	},
	
	HellTowerZone = {
		OnEnter = function()
			OpenDialogueWindow("HellTower")
			--_G.WindowManager:OpenWindow({WindowName = "Merchant", BarsHidden = true})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				CloseDialogueWindow()
			elseif _G.WindowManager.openedWindow == "Merchant" then
				_G.WindowManager:CloseWindow("HellTower")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255,100,0);
		};
	},
	
	AlchemyZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Alchemy", BarsHidden = true})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Alchemy" then return end
			_G.WindowManager:CloseWindow("Alchemy")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(255,100,0);
		};
	},
	
	BundlesZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Shop", HideSlotBar = true})
			_G.WindowManager:RunComponentMethod("Shop/GoToTab", "Bundles")
		end,
		
		OnExit = function()
			if _G.WindowManager.openedWindow ~= "Shop" then return end
			_G.WindowManager:CloseWindow("Shop")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(170,0,127);
		};
	},

	GoodBuilder = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "GoodBuilder")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255,85,0);
		};
	},	
	
	SoloWooZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "SoloWoo")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170, 0, 255);
		};
	},
	
	BadBuilder = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "BadBuilder")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(255,85,0);
		};
	},
	
	GroupZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "GroupPrize")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(255,85,0);
			GoalFillTransparency = 0.85;
		};
	},
	
	CurrencyExchanger = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "CurrencyExchanger")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(35, 0, 104);
			GoalFillTransparency = 0.85;
		};
	},
	
	UpdateLogsZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "UpdateLogs"})
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow ~= "UpdateLogs" then return end

			_G.WindowManager:CloseWindow("UpdateLogs")
		end,
		
		HighlightData = {
			FillColor = Color3.fromRGB(19,165,255);
			GoalFillTransparency = 0.7;
		};
	},
	
	EventInfoZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "EventDialogue")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255, 255, 255);
			GoalFillTransparency = 0.7;
		};
	},
	
	SoulsZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "SoulsDialogue")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255, 110, 144);
			GoalFillTransparency = 0.7;
		};
	},
	
	RaidInfoZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "Dialogue"}, "RaidDialogue")
		end,

		OnExit = function()
			if _G.WindowManager.openedWindow == "Dialogue" then
				_G.WindowManager:CloseWindow("Dialogue")
			end
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(255, 85, 0);
			GoalFillTransparency = 0.7;
		};
	},
	
	EventInfoNoDialogueZone = {
		OnEnter = function()
			_G.WindowManager:OpenWindow({WindowName = "EventInfo", BarsHidden = true, Darken = true, HideSlotBar = true})
		end,
	},
	
	PortalZone1 = {
		OnEnter = function()
			--local player = game:GetService("Players").LocalPlayer
			--local character = player.Character
			--local Goal = CFrame.new(683.34, 12.589, 406.049) * CFrame.Angles(0, math.rad(90) ,0)
			
			--if not character then return end
			
			--local UIMotion = require(ReplicatedStorage.Libs.UIMotion)
			
			--UIMotion:FadeInOut({
			--	FadeInCallback = function()
			--		if not player:GetAttribute("WindowsDisabled") then
			--			character:PivotTo(Goal)
			--		end
			--	end,
				
				
			--	WaitDuration = 0.2;
			--})
			
			--_G.WindowManager:OpenWindow({WindowName = "AdventureAreas", BarsHidden = true, Darken = true, HideSlotBar = true})
		end,
	},

	PortalZone2 = {
		OnEnter = function()
			local player = game:GetService("Players").LocalPlayer
			local character = player.Character
			local Goal = CFrame.new(1127.215, 8.753, -179.426) * CFrame.Angles(0,math.rad(95),0)

			if not character then return end

			local UIMotion = require(ReplicatedStorage.Libs.UIMotion)

			UIMotion:FadeInOut({
				FadeInCallback = function()
					if not player:GetAttribute("WindowsDisabled") then
						character:PivotTo(Goal)
					end
				end,

				WaitDuration = 0.2;
			})
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170, 85, 0);
			GoalFillTransparency = 0.7;
		};
	},

	PortalZone3 = {
		OnEnter = function()
			local player = game:GetService("Players").LocalPlayer
			local character = player.Character
			local Goal = CFrame.new(1127.215, 8.753, -179.426) * CFrame.Angles(0,math.rad(95),0)

			if not character then return end

			local UIMotion = require(ReplicatedStorage.Libs.UIMotion)

			UIMotion:FadeInOut({
				FadeInCallback = function()
					if not player:GetAttribute("WindowsDisabled") then
						character:PivotTo(Goal)
					end
				end,

				WaitDuration = 0.2;
			})
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170, 85, 0);
			GoalFillTransparency = 0.7;
		};
	},

	['Portal 1'] = {
		OnEnter = function()
			local player = game:GetService("Players").LocalPlayer
			local character = player.Character
			local Goal = CFrame.new(1127.215, 8.753, -179.426) * CFrame.Angles(0,math.rad(95),0)

			if not character then return end

			local UIMotion = require(ReplicatedStorage.Libs.UIMotion)

			UIMotion:FadeInOut({
				FadeInCallback = function()
					if not player:GetAttribute("WindowsDisabled") then
						character:PivotTo(Goal)
					end
				end,

				WaitDuration = 0.2;
			})
		end,

		HighlightData = {
			FillColor = Color3.fromRGB(170, 85, 0);
			GoalFillTransparency = 0.7;
		};
	},
}

return ZoneData
