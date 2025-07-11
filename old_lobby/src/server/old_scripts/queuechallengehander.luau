--// By @ThatOneTusk & Nahid

local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
--local MemoryService = game:GetService("MemoryStoreService")

local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

--local JoinData = MemoryService:GetHashMap("JoinData")

local QueueChallengeZones = workspace.Map.QueueChallengeZones
local CustomData = require(script.CustomData)
local QueueLibrary = require(ReplicatedStorage.Libs.QueueLibrary)

export type ZoneDataType = CustomData.ZoneDataType
export type ChosenDataType = CustomData.ChosenDataType

local QueueChallenge = {
	CreatedZones = {} :: { [Instance]: ZoneDataType },
}

local EnterCooldowns = {}
local CreatedZones = QueueChallenge.CreatedZones

local MAP_SELECTOR_TIMEOUT = 30
local DEFAULT_WAIT_TIME = 10
local DEFAULT_MINIMUM_PLAYERS = 1
local DEFAULT_MAXIMUM_PLAYERS = 4

local GradientRegistry = _G.Registry.registry.GradientAnimations

local DifficultyIcons = {
	Easy = "rbxassetid://18621359625",
	Normal = "rbxassetid://18621367494",
	Hard = "rbxassetid://18621367494",
}

local PossibleMaps = {}

local MinuteModifier = 0

local UiCommunication = ReplicatedStorage.Events.UiCommunication
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

local SecondsToTime = require(ReplicatedStorage:WaitForChild("SecondsToTime"))
--local UIMotion = require(game.ReplicatedStorage.Libs.UIMotion)
local SetZoneGuiRewards_RE = ReplicatedStorage.Events.SetZoneGuiRewards
local SetZoneGuiBosses_RE = ReplicatedStorage.Events.SetZoneGuiBosses

local CurrentPoolNumbers = {}

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

function QueueChallenge:_SetItemViewport(itemData, viewport: ViewportFrame, data: RegisterItemFrameData)
	local identifier = itemData.Name
	local _FoundInRegistry = _G.Registry.registry.Items[identifier]

	if _FoundInRegistry then
		--print('Found in reg')
		if viewport then
			--print('Has viewport')
			local camera = viewport:FindFirstChild("Camera") or Instance.new("Camera")
			local WorldModel = viewport:FindFirstChild("WorldModel") or Instance.new("WorldModel"):Clone()
			WorldModel.WorldPivot = CFrame.new()
			WorldModel.Parent = viewport

			local ModelOrRoot = _FoundInRegistry.misc.Model:Clone()
			ModelOrRoot.Parent = WorldModel

			--print(ModelOrRoot)

			camera.CFrame = CFrame.new()
			if viewport and camera and ModelOrRoot then
				--print('setting pivot')
				ModelOrRoot:PivotTo(_FoundInRegistry.configuration.ViewportCFrame)
				viewport.CurrentCamera = camera
			end
			--warn(data)
			if data.Rarity then
				if GradientRegistry[data.Rarity] then
					GradientRegistry[data.Rarity]:Animate(viewport.Parent.Icon:WaitForChild("UIGradient"), 1)
					GradientRegistry[data.Rarity]:Animate(
						viewport.Parent.Icon.Halftone.ImageLabel:WaitForChild("UIGradient"),
						1
					)
					print("Animating")
				else
					print("GradientPattern", GradientRegistry)
				end
			end
		end
	end
end

local animModule = require(game.ReplicatedStorage.AnimModule)

function QueueChallenge:_SetUnitViewport(unitData, viewport: ViewportFrame, data: RegisterItemFrameData)
	local identifier = unitData["UnitName"]
	local _FoundInRegistry = _G.Registry.registry.Units[identifier]

	if _FoundInRegistry then
		if viewport then
			if viewport:FindFirstChildWhichIsA("WorldModel") then
				viewport:FindFirstChildWhichIsA("WorldModel"):Destroy()
			end

			local WorldModel = game.ReplicatedStorage.Other.WorldModel:Clone()
			WorldModel.Parent = viewport

			local ModelOrRoot = _FoundInRegistry:GetModel(unitData):Clone() --.misc.Model:Clone()
			ModelOrRoot.Parent = WorldModel

			local Camera = viewport:FindFirstChild("Camera") or Instance.new("Camera")

			if viewport and Camera and ModelOrRoot then
				Camera.CFrame = ModelOrRoot.HumanoidRootPart.CFrame * _FoundInRegistry.configuration.Viewport
				viewport.CurrentCamera = Camera
			end

			if unitData.Shiny == true then
				ModelOrRoot:AddTag("ShinyModel")
			end

			if _FoundInRegistry["customizeVisuals"] then
				_FoundInRegistry:customizeVisuals(game.Players.LocalPlayer, ModelOrRoot)
			end

			GradientRegistry[unitData.Rarity]:Animate(viewport.Parent.Icon:WaitForChild("UIGradient"), 1)
			GradientRegistry[unitData.Rarity]:Animate(
				viewport.Parent.Icon.Halftone.ImageLabel:WaitForChild("UIGradient"),
				1
			)

			animModule.PlayAnim(_FoundInRegistry.animations.idle, ModelOrRoot, 1, "Idle")
		end
	end
end

function QueueChallenge:_FormatNumber(number: number | string): string
	if number < 1000 then
		return number
	end
	local abbreviations = { "K", "M", "B", "T" }

	number = tostring(math.floor(number))
	return string.sub(number, 1, ((#number + 2) % 3) + 1) .. abbreviations[math.floor((#number - 1) / 3) + 1]
end

function QueueChallenge:GetLayoutOrders(FoodByMaps, PoolTypes, TypArray)
	if self.LayoutOrders then
		return self.LayoutOrders
	end
	local LayoutOrders = {}

	for Type, Tables in PoolTypes do
		for Order, Table in Tables do
			for Name, ItemTable in Table do
				LayoutOrders[Name] = Order * 10 + (table.find(TypArray, Type) or 0) * 100
			end
		end
	end

	for _, Food in FoodByMaps do
		LayoutOrders[Food] = (#TypArray + 1) * 100
	end
	self.LayoutOrders = LayoutOrders
	--warn('LayoutOrders',LayoutOrders)
	return self.LayoutOrders
end

local ViewportPlayerAddedConnectionBoss
local ViewportPlayerAddedConnectionItems

function Format(Int)
	return string.format("%02i", Int)
end

function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds % 60) / 60
	Seconds = Seconds - Minutes * 60
	local Hours = (Minutes - Minutes % 60) / 60
	Minutes = Minutes - Hours * 60
	return Format(Hours) .. ":" .. Format(Minutes) .. ":" .. Format(Seconds)
end

function getNextResetTime(timestamp)
	local utcDate = os.date("!*t", timestamp)
	return os.time({
		year = utcDate.year,
		month = utcDate.month,
		day = utcDate.day + 1,
		hour = 0,
		min = 0,
		sec = 0,
	})
end

--// Set up all the queue zones and start-up RunService
function QueueChallenge:start()
	for _, Zone: Instance in QueueChallengeZones:GetChildren() do
		local Hitbox: BasePart = Zone:FindFirstChild("Hitbox")
		local ExitPosition: BasePart = Zone:FindFirstChild("ExitPosition")
		local EnterPosition: BasePart = Zone:FindFirstChild("EnterPosition")

		if not Hitbox then
			--warn(`No Hitbox for zone {Zone}`)
			continue
		end

		if not ExitPosition then
			--warn(`No ExitPosition for zone {Zone}`)
			continue
		end

		if not EnterPosition then
			--warn(`No EnterPosition for zone {Zone}`)
			continue
		end

		local ZoneData: ZoneDataType = QueueChallenge:_CreateZone(Zone)
		ZoneData.Type = "Challenge"
		--// Entering
		Hitbox.Touched:Connect(function(hit)
			--warn("HIT REGISTERED")
			local player = PlayerService:GetPlayerFromCharacter(hit.Parent)
			local ChosenData = ZoneData.ChosenData
				or {
					GameType = "Challenge",
					MapName = ZoneData.Map,
					GameScenarioID = 1,
					Difficulty = "Nightmare",
					Challenges = ZoneData.Challenges,
					RewardPoolSeed = ZoneData.RewardPoolSeed,
					RandomSeed = ZoneData.RandomSeed,
					PoolType = ZoneData.PoolType,
				}

			if not player or EnterCooldowns[player] or player:GetAttribute("Teleporting") then
				warn("debug")
				return
			end

			EnterCooldowns[player] = true

			task.delay(1, function()
				EnterCooldowns[player] = nil
			end)

			if not ZoneData.CanPlayersEnter or ZoneData.IsTeleporting then
				warn("returning", not ZoneData.CanPlayersEnter, ZoneData.IsTeleporting)
				return
			end
			if #ZoneData.Players >= ZoneData.MaximumPlayers or QueueChallenge:GetPlayerZone(player) then
				warn("debug2")
				return
			end

			local PlayerData = DataAPI:GetActivePlayerProfileClass(player)

			local NoUnits = true

			for _, slot in PlayerData:GetField("Slotbar") do
				if slot and slot.UnitName and slot.UnitName ~= "" then
					NoUnits = false
				end
			end

			if NoUnits then
				NotifyPlayer:FireClient(player, "Error", `You have no units equipped!`)
				return
			end

			if player:GetAttribute("Portal") then
				NotifyPlayer:FireClient(player, "Error", `You are already queueing for a portal!`)
				return
			end
			if ChosenData then
				if ChosenData.FriendsOnly then
					local IsFriends = pcall(function()
						player:IsFriendsWith(ZoneData.MapSelector)
					end)

					if not IsFriends then
						NotifyPlayer:FireClient(player, "Error", `You must be friends with {ZoneData.MapSelector}!`)
						return
					end
				end

				if QueueLibrary:CheckRequirements(player, ChosenData) ~= true then
					NotifyPlayer:FireClient(player, "Error", `You do not meet the requirements to enter this queue!`)
					return
				end

				if ZoneData.Instance and ZoneData.Instance:GetAttribute("24h") then
					local lastPlayed = PlayerData:GetField("DailyChallenge")

					if lastPlayed then
						local now = os.time()
						local nextReset = getNextResetTime(lastPlayed)

						if now < nextReset then
							local timeLeft = nextReset - now
							local hours = math.floor(timeLeft / 3600)
							local minutes = math.floor((timeLeft % 3600) / 60)

							print(string.format("time left until next daily: %02d:%02d", hours, minutes))
							NotifyPlayer:FireClient(player, "Error", `You can only do this challenge once a day!`)
							return
						end
					end
				end
			end

			QueueChallenge:_OnEnter(ZoneData, player)
		end)
	end
	self.Tick = os.time()
	self.QueueCount = 0
	RunService.PostSimulation:Connect(function(delta)
		for ZoneInstance, ZoneData in CreatedZones do
			local Count = #ZoneData.Players
			local SurfaceGui = ZoneInstance:FindFirstChild("GuiContainer")
				and ZoneInstance.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")
			local QueueDisplay = ZoneInstance:FindFirstChild("QueueDisplay") and ZoneInstance.QueueDisplay.SurfaceGui

			if SurfaceGui then
				SurfaceGui.Enabled = true

				if QueueDisplay then
					QueueDisplay.Enabled = not SurfaceGui.Enabled
				end

				if SurfaceGui.Enabled then
					local Container = SurfaceGui.Container
				end
			end

			if not ZoneData.ChosenData and ZoneData.MapSelector then
				if ZoneData.PassedSelectorTime <= 0 then
					if not ZoneData.IsTeleporting then
						QueueChallenge:StartGame(ZoneData)
					end
					--ZoneData.PassedSelectorTime = MAP_SELECTOR_TIMEOUT
					if not ZoneData.Instance then
						continue
					end

					local alpha = 1
					local color = Color3.fromRGB(255, 0, 0)
						:Lerp(Color3.fromRGB(0, 255, 0), math.clamp(math.max(0, alpha), 0, 1))
					local hue, saturation = color:ToHSV()

					ZoneData.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.Size =
						UDim2.fromScale(math.max(0, alpha), 1)
					ZoneData.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.UIGradient.Color =
						ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, saturation, 0.55)),
							ColorSequenceKeypoint.new(1, color),
						})
				else
					ZoneData.PassedSelectorTime -= delta
					if not ZoneData.Instance then
						continue
					end

					local alpha = ZoneData.PassedSelectorTime / MAP_SELECTOR_TIMEOUT
					local color = Color3.fromRGB(255, 0, 0)
						:Lerp(Color3.fromRGB(0, 255, 0), math.clamp(math.max(0, alpha), 0, 1))
					local hue, saturation = color:ToHSV()

					ZoneData.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.Size =
						UDim2.fromScale(math.max(0, alpha), 1)
					ZoneData.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.UIGradient.Color =
						ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, saturation, 0.55)),
							ColorSequenceKeypoint.new(1, color),
						})
				end
			end

			if Count >= ZoneData.MinimumPlayers and Count <= ZoneData.MaximumPlayers then
				if ZoneData.Active then
					if ZoneData.PassedTime > 0 then
						ZoneData.PassedTime -= delta
					elseif not ZoneData.IsTeleporting then
						QueueChallenge:StartGame(ZoneData)
					end
				end
			else
				ZoneData.Active = false
				ZoneData.PassedTime = ZoneData.WaitTime

				if Count == 0 then
					--ZoneData.ChosenData = nil
				end
			end
		end

		if os.time() - self.Tick >= 1 then
			self.Tick = os.time()

			for Index, QueueData in CreatedZones do
				pcall(function()
					local SurfaceGui = Index:FindFirstChild("GuiContainer")
						and Index.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")

					if QueueData.ResetTime then
						local String = `Time Remaining: {SecondsToTime((CreatedZones[Index].ResetTime - os.time()))}`
						local TimerDisplay =
							SurfaceGui:WaitForChild("Container"):WaitForChild("MapData"):FindFirstChild("TimerDisplay")
						if TimerDisplay then
							TimerDisplay.Text = String
							CreatedZones[Index].TimerDisplay = TimerDisplay
							local TimerFrame = SurfaceGui:WaitForChild("Container")
								:WaitForChild("MapData")
								:FindFirstChild("TimeoutBar")
							local TimerBar = TimerFrame:WaitForChild("GreenBar")
							local timeRemaining = (CreatedZones[Index].ResetTime - os.time())
							TimerBar.Size = UDim2.fromScale(
								math.min(1, math.max(0, timeRemaining / (Index:GetAttribute("24h") and 86400 or 3600))),
								1
							)
							CreatedZones[Index].TimerBar = TimerBar
						end
					end

					if not QueueData.ResetTime or os.time() >= QueueData.ResetTime then
						local resetTime

						if Index:GetAttribute("24h") then
							local utcNow = os.time()
							CreatedZones[Index].ResetTime = getNextResetTime(utcNow)
						else
							local Date = os.date("!*t")
							CreatedZones[Index].ResetTime = os.time({
								year = Date.year,
								month = Date.month,
								day = Date.day,
								hour = Date.hour + 1,
								min = 0,
								sec = 0,
							})
						end

						if CurrentPoolNumbers[tostring(QueueData.ResetTime)] then
							CurrentPoolNumbers[tostring(QueueData.ResetTime)] = nil
						end

						if not CurrentPoolNumbers[tostring(QueueData.ResetTime)] then
							CurrentPoolNumbers[tostring(QueueData.ResetTime)] = {}
						end

						--print(os.time()/10000,NextHourStartTime/10000,os.time()-NextHourStartTime)
						task.wait(1)

						if not CreatedZones[Index].Number then
							self.QueueCount += 1
							CreatedZones[Index].Number = self.QueueCount
						end
						local Date = os.date("!*t")
						local RandomSeed = Index:GetAttribute("24h")
								and tonumber(Date.yday) * CreatedZones[Index].Number
							or tonumber(Date.yday .. Date.hour) * CreatedZones[Index].Number
						CreatedZones[Index].RewardPoolSeed = RandomSeed
						local RND = Random.new(RandomSeed)
						--	RND = Random.new()
						local Maps = _G.Registry.registry.Maps

						if #PossibleMaps <= 0 then
							PossibleMaps = {}
							for MapName, MapData in Maps do
								if MapData.raw.Released.Value and MapData.raw:FindFirstChild("Challenge") then
									table.insert(PossibleMaps, MapName)
									--table.insert(PossibleMaps,MapName)
								end
							end
						end
						local ChosenMap = PossibleMaps[RND:NextInteger(1, #PossibleMaps)]
						table.remove(PossibleMaps, table.find(PossibleMaps, ChosenMap))
						CreatedZones[Index].Map = ChosenMap
						--					print('PossibleMaps',PossibleMaps)
						local MapData = Maps[CreatedZones[Index].Map]

						local Challenges = _G.Registry.registry.Challenges

						local PossibleChallenges = {}

						for ChallengeName, ChallengeData in Challenges do
							if ChallengeName ~= "Traits Disabled" then
								table.insert(PossibleChallenges, ChallengeName)
							end
						end

						--print(Date,RND)
						CreatedZones[Index].Challenge = PossibleChallenges[RND:NextInteger(1, #PossibleChallenges)]
						CreatedZones[Index].Challenges = {
							[CreatedZones[Index].Challenge] = true,
						}
						CreatedZones[Index].ChallengeDisplayName = Challenges[CreatedZones[Index].Challenge].DisplayName
						CreatedZones[Index].DisplayName = MapData.DisplayName
						CreatedZones[Index].Icon = MapData.Icon

						SurfaceGui.Container.MapData.Image = CreatedZones[Index].Icon
						SurfaceGui.Container.MapData.MapName.Text = CreatedZones[Index].DisplayName
						SurfaceGui.Container.MapData.ActName.Text = "Challenge Mode"
						SurfaceGui.Container.MapData.Challenge.TextLabel.Text = CreatedZones[Index].ChallengeDisplayName

						--print('MapData',MapData,_G.Registry.registry)

						local FoundAct = require(MapData.raw.Challenge:FindFirstChild("1"))
						local ActRewards = {
							Set = {
								Currencies = {},

								Items = {},

								Units = {},
							},

							FirstClear = {
								Currencies = {},

								Items = {},

								Units = {},
							},
							["Random"] = {
								Currencies = {
									Gold = not CreatedZones[Index].Instance:GetAttribute("24h") and {
										Amount = NumberRange.new(40, 60),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									} or nil,
									Gems = not CreatedZones[Index].Instance:GetAttribute("24h") and {
										Amount = NumberRange.new(40, 60),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									} or nil,
								},

								Items = {},

								Units = {},
							},
						} --FoundAct.Rewards

						--print('=============')
						--print('===REWARDS===')
						--print('=============')
						--print(_G.Registry.registry)

						for _, Slot in SurfaceGui.Container.Rewards:GetChildren() do
							if not Slot:IsA("Frame") then
								continue
							end
							if Slot.Name == "Example" then
								continue
							end
							Slot:Destroy()
						end

						local ActBoss = FoundAct.Boss
						if ActBoss then
							CreatedZones[Index].BossName = ActBoss
							if _G.Registry.registry.Enemies[ActBoss] then
								local FoundBoss = _G.Registry.registry.Enemies[ActBoss]

								local BossModel = FoundBoss.misc.Model
								local ViewportFrame = SurfaceGui.Container.MapData.BossIcon.ViewportFrame
								--local WorldModel = ViewportFrame:FindFirstChild('WorldModel') or Instance.new('WorldModel',ViewportFrame)
								--local BossFolder = WorldModel:FindFirstChild('BossFolder') or Instance.new('Folder',WorldModel)

								--warn(FoundBoss)
								--warn(BossModel)

								if BossModel then
									for i, v in game.Players:GetPlayers() do
										task.spawn(function()
											if
												v:WaitForChild("notSavable"):WaitForChild("loaded").Value
												or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
											then
												SetZoneGuiBosses_RE:FireClient(v, ViewportFrame.Parent, ActBoss)
											end
										end)
									end

									if ViewportPlayerAddedConnectionBoss then
										ViewportPlayerAddedConnectionBoss:Disconnect()
									end
									ViewportPlayerAddedConnectionBoss = game.Players.PlayerAdded:Connect(function(v)
										if
											v:WaitForChild("notSavable"):WaitForChild("loaded").Value
											or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
										then
											SetZoneGuiBosses_RE:FireClient(v, ViewportFrame.Parent, ActBoss)
										end
									end)

									--BossFolder.Name = 'BossFolder'
									--BossFolder:ClearAllChildren()
									--BossModel = BossModel:Clone()
									--BossModel.HumanoidRootPart.Anchored = true
									--BossModel.HumanoidRootPart.CFrame = WorldModel.Model.HumanoidRootPart.CFrame * (FoundBoss.configuration.ViewportOffset or CFrame.new(0,0,0))
									--BossModel.Name = ActBoss
									--BossModel.Parent = BossFolder
								end
							end
						end

						local FoodByMaps = {
							["West City"] = "SmallCapsule",
							["Leaf Village"] = "Naruto",
							["Land of the Sky"] = "SkyShell",
							["Fujishima Island"] = "Meat",
							["Red Army HQ"] = "SenzuBean",
							["Clover Kingdom"] = "MageStone",
							["Ghost Tunnel"] = "PurpleStar",
							["Burned York"] = "PurpleStar",
						}

						local PoolTypes = {
							["Stars"] = {
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Green"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Purple"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Red"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 10,
										RNG = NumberRange.new(1, 100),
									},
								},
								{ ["Food"] = { Amount = NumberRange.new(2, 2), Chance = 1, RNG = NumberRange.new(1, 1) } },

								{
									[`TraitCrystal`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
							},
							["Stones"] = {
								{
									[`{"Water"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Gale"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Fire"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Light"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Dark"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Fierce"}Stone`] = {
										Amount = NumberRange.new(2, 5),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`TraitCrystal`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								--{[`{"Blue"}Star`] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)}},
								--{[`{"Green"}Star`] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)}},
								--{[`{"Red"}Star`] = {Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)}},
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 10,
										RNG = NumberRange.new(1, 100),
									},
								},

								{ ["Food"] = { Amount = NumberRange.new(2, 2), Chance = 1, RNG = NumberRange.new(1, 1) } },
							},
							["Misc"] = {
								{
									[`PotentialKey`] = {
										Amount = NumberRange.new(1, 1),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`FrostKey`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`Redstone`] = {
										Amount = NumberRange.new(1, 1),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`TraitCrystal`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Green"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Purple"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Red"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 10,
										RNG = NumberRange.new(1, 100),
									},
								},

								{ ["Food"] = { Amount = NumberRange.new(2, 2), Chance = 1, RNG = NumberRange.new(1, 1) } },
							},
							["Additional"] = {
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Green"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Purple"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Red"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`TraitCrystal`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{ ["Food"] = { Amount = NumberRange.new(2, 2), Chance = 1, RNG = NumberRange.new(1, 1) } },
							},
							["Souls"] = {
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Green"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Purple"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Red"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{
									[`TraitCrystal`] = {
										Amount = NumberRange.new(1, 2),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},

								{ ["Food"] = { Amount = NumberRange.new(2, 2), Chance = 1, RNG = NumberRange.new(1, 1) } },
							},
						}

						local dchallengePool = {
							["Stones"] = {
								{
									[`{"Water"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Gale"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Fire"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Light"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Dark"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Fierce"}Stone`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
							},
							["Stars"] = {
								{
									[`{"Orange"}Star`] = {
										Amount = NumberRange.new(5, 10),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Blue"}Star`] = {
										Amount = NumberRange.new(4, 8),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Green"}Star`] = {
										Amount = NumberRange.new(4, 8),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Purple"}Star`] = {
										Amount = NumberRange.new(4, 8),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Red"}Star`] = {
										Amount = NumberRange.new(4, 8),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
								{
									[`{"Rainbow"}Star`] = {
										Amount = NumberRange.new(2, 4),
										Chance = 1,
										RNG = NumberRange.new(1, 1),
									},
								},
							},
						}

						local TypArray =
							{ "Stars", "Stars", "Stars", "Stones", "Stones", "Stones", "Misc", "Additional" }

						self.LayoutOrders = self.LayoutOrders
							or self:GetLayoutOrders(FoodByMaps, PoolTypes, TypArray, FoodByMaps)

						local CurrentChallengeType = TypArray[RND:NextInteger(1, #TypArray)]

						if not CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] then
							CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] = 0
						end

						local CustomLimit = {
							["Stars"] = 3,
							["Misc"] = 1,
							["Additional"] = 1,
							["Souls"] = 1,
						}

						local RoomLimit = CustomLimit[CurrentChallengeType] or 2

						if CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] >= RoomLimit then
							repeat
								CurrentChallengeType = TypArray[RND:NextInteger(1, #TypArray)]
								if not CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] then
									CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] = 0
								end
							until CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] < RoomLimit
						end

						CurrentPoolNumbers[tostring(QueueData.ResetTime)][CurrentChallengeType] += 1

						--	print(CurrentPoolNumbers[tostring(QueueData.ResetTime)])

						--print("challenge", Index, CurrentChallengeType)

						CreatedZones[Index].PoolType = CurrentChallengeType

						--warn(PoolTypes,CurrentChallengeType,PoolTypes[CurrentChallengeType])
						if not CreatedZones[Index].Instance:GetAttribute("24h") then
							if PoolTypes[CurrentChallengeType] then
								for _, _RewardTab in PoolTypes[CurrentChallengeType] do
									for RewardName, _Value in _RewardTab do
										if RewardName == "Food" then
											local FoundFoodName = FoodByMaps[MapData.raw.Name]
											if FoundFoodName then
												ActRewards.Random.Items[FoundFoodName] = _Value
											end
											continue
										end
										ActRewards.Random.Items[RewardName] = _Value
									end
								end
							end
						else
							ActRewards.Random.Currencies["Gold"] =
								{ Amount = NumberRange.new(1000, 1000), Chance = 1, RNG = NumberRange.new(1, 1) }
							ActRewards.Random.Currencies["Gems"] =
								{ Amount = NumberRange.new(1000, 1000), Chance = 1, RNG = NumberRange.new(1, 1) }

							ActRewards.Set.Items["TraitCrystal"] = 20
							ActRewards.Set.Items["PotentialKey"] = 10

							ActRewards.Set.Items["FrostKey"] = 10

							ActRewards.Set.Items["bloodexpvile"] = 1

							for _, _Category in pairs(dchallengePool) do
								for _, _RewardTab in ipairs(_Category) do
									for RewardName, _Value in pairs(_RewardTab) do
										ActRewards.Random.Items[RewardName] = _Value
									end
								end
							end
						end

						if ActRewards then
							CreatedZones[Index].ActRewards = ActRewards

							task.spawn(function()
								if ViewportPlayerAddedConnectionItems then
									ViewportPlayerAddedConnectionItems:Disconnect()
								end

								ViewportPlayerAddedConnectionItems = PlayerService.PlayerAdded:Connect(function(v)
									if v:WaitForChild("notSavable") then
										SetZoneGuiRewards_RE:FireClient(
											v,
											SurfaceGui.Container.Rewards,
											{ ["ActRewards"] = ActRewards },
											self.LayoutOrders
										)
									end
								end)

								for i, v in PlayerService:GetPlayers() do
									task.spawn(function()
										if v:WaitForChild("notSavable") then
											SetZoneGuiRewards_RE:FireClient(
												v,
												SurfaceGui.Container.Rewards,
												{ ["ActRewards"] = ActRewards },
												self.LayoutOrders
											)
										end
									end)
								end
							end)
						end
					end
				end)
			end
		end
	end)
end

--// Returns a new queue zone
function QueueChallenge:_CreateZone(Instance: Instance): ZoneDataType
	if CreatedZones[Instance] then
		return CreatedZones[Instance]
	end

	local ZoneType = Instance:GetAttribute("ZoneType")

	local SetData: ZoneDataType = {
		Instance = Instance,

		WaitTime = DEFAULT_WAIT_TIME,
		MinimumPlayers = DEFAULT_MINIMUM_PLAYERS,
		MaximumPlayers = DEFAULT_MAXIMUM_PLAYERS,
		Players = {},
		PlayerConnections = {},

		CanPlayersEnter = true,
		Active = false,
	}

	if ZoneType and CustomData[ZoneType] then
		for index, value in CustomData[ZoneType] do
			SetData[index] = value
		end
	end

	SetData.PassedTime = SetData.WaitTime

	CreatedZones[Instance] = SetData
	return SetData
end

--// Fires when a player enters a zone
function QueueChallenge:_OnEnter(Zone: ZoneDataType, player: Player)
	--warn(string.upper(script.Name),Zone)

	--for i,v in pairs(Zone) do
	--	warn(i,v)
	--end

	local character = player.Character

	local ZoneInstance = Zone.Instance
	local EnterPosition: BasePart = ZoneInstance.EnterPosition

	character.HumanoidRootPart.Anchored = true
	character:PivotTo(EnterPosition.CFrame)
	character.HumanoidRootPart.Anchored = false

	table.insert(Zone.Players, player)

	Zone.PlayerConnections[player] = character.AncestryChanged:Connect(function()
		if not character.Parent then
			print("Player has left!")
			QueueChallenge:KickPlayer(player)
		end
	end)

	player:SetAttribute("WindowsDisabled", true)
	if not Zone.MapSelector then
		Zone.PassedSelectorTime = MAP_SELECTOR_TIMEOUT
		Zone.MapSelector = player
		Zone.CanPlayersEnter = true
		--warn('apointing new map selector')
	end

	local PlayersHolder = Zone.Instance.GuiContainer.SurfaceGui.Container.Frame
	local RewardsHolder = Zone.Instance.GuiContainer.SurfaceGui.Container.Rewards
	local MapData = Zone.Instance.GuiContainer.SurfaceGui.Container.MapData
	local PlayerFrame = PlayersHolder.Example:Clone()
	PlayerFrame.ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={player and player.UserId or ""}&w=60&h=60`
	PlayerFrame:SetAttribute("Name", player.DisplayName)
	PlayerFrame.Visible = true
	PlayerFrame.Name = player.UserId
	PlayerFrame.Parent = PlayersHolder
	--warn('seconds left till closure',Zone.PassedSelectorTime)
	UiCommunication:FireClient(
		player,
		"WindowManager/OpenWindow",
		{
			WindowName = "MatchStats",
			CloseCurrentWindow = true,
			HideSlotBar = true,
			Blur = false,
			BarsHidden = true,
			Darken = false,
		},
		Zone.PassedSelectorTime,
		Zone.DisplayName,
		Zone.Icon,
		Zone.ChallengeDisplayName,
		Zone.TimerDisplay,
		Zone.TimerBar,
		PlayersHolder,
		RewardsHolder,
		MapData,
		"Nightmare",
		{ ["ActRewards"] = Zone.ActRewards, ["BossName"] = Zone.BossName }
	)

	UiCommunication:FireClient(player, "MatchStats/OpenQueueExitButton", true, "Challenge")

	QueueChallenge:UpdateZoneGui(Zone)
end

--// Exits the player from their zone (in any scenario, like leaving the game)
function QueueChallenge:KickPlayer(player: Player)
	--warn('kicking',player)
	local Zone: ZoneDataType = QueueChallenge:GetPlayerZone(player)
	--warn(string.upper(script.Name),Zone)

	if not Zone then
		--warn('no zone',Zone)
		return
	end
	--warn('kicking2',player)
	local character = player.Character

	local ZoneInstance = Zone.Instance
	local ExitPosition: BasePart = ZoneInstance.ExitPosition

	if character then
		character:PivotTo(ExitPosition.CFrame)
	end

	table.remove(Zone.Players, table.find(Zone.Players, player))
	UiCommunication:FireClient(player, "MatchStats/CloseQueueExitButton")

	local PlayersHolder = Zone.Instance.GuiContainer.SurfaceGui.Container.Frame
	if PlayersHolder:FindFirstChild(player.UserId) then
		PlayersHolder:FindFirstChild(player.UserId):Destroy()
	end

	if Zone.PlayerConnections[player] then
		Zone.PlayerConnections[player]:Disconnect()
		Zone.PlayerConnections[player] = nil
	end
	UiCommunication:FireClient(player, "WindowManager/CloseWindow", "MatchStats")

	if Zone.MapSelector == player then
		--warn('is map selector',player)
		--Zone.Active = false
		--Zone.CanPlayersEnter = false
		--Zone.MapSelector = nil

		--warn(Zone.Players)
		for _, otherplayer in Zone.Players do
			if player == otherplayer then
				continue
			end
			Zone.MapSelector = otherplayer
			break
		end
		if Zone.MapSelector == player then
			Zone.MapSelector = nil
			Zone.Active = false
		end
		--warn(Zone.MapSelector)
		Zone.CanPlayersEnter = true
	end
	player:SetAttribute("WindowsDisabled", false)
	QueueChallenge:UpdateZoneGui(Zone)
end

--// Updates the gui for the zone
function QueueChallenge:UpdateZoneGui(Zone: ZoneDataType)
	local ChosenData = Zone.ChosenData
	local SurfaceGui = Zone.Instance:WaitForChild("GuiContainer")

	if not SurfaceGui then
		return
	end

	SurfaceGui = SurfaceGui:FindFirstChildWhichIsA("SurfaceGui"):WaitForChild("Container")

	local MapData = SurfaceGui.MapData
	local PlayerAmount = #Zone.Players
	--warn('number of players',PlayerAmount)
	if ChosenData then
		local FoundMap = _G.Registry.registry.Maps[ChosenData.MapName]

		MapData.MapName.Text = ChosenData.MapName
		MapData.ActName.Text = "Challenge Mode"
		MapData.MapDescription.Text = FoundMap.Description or "No Description Found."
		MapData.DifficultyIcon.Image = DifficultyIcons[ChosenData.Difficulty] or ""
	end

	if PlayerAmount <= 0 then
		local alpha = 1
		local color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), math.clamp(math.max(0, alpha), 0, 1))
		local hue, saturation = color:ToHSV()

		Zone.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.Size =
			UDim2.fromScale(math.max(0, alpha), 1)
		Zone.Instance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, saturation, 0.55)),
			ColorSequenceKeypoint.new(1, color),
		})
	end
end

local TeleportingToggle_RE = ReplicatedStorage.Events.TeleportingToggle
--// Attempts to teleport all the players in the zone, returning whether it passed or not
function QueueChallenge:_TeleportPlayers(ZoneData: ZoneDataType): boolean?
	local ChosenData = {
		GameType = "Challenge",
		MapName = ZoneData.Map,
		GameScenarioID = "1",
		Difficulty = "Nightmare",
		Challenges = ZoneData.Challenges,
		RewardPoolSeed = ZoneData.RewardPoolSeed,
		RandomSeed = ZoneData.RandomSeed,
		--RandomSeed = ZoneData.RandomSeed,
		PoolType = ZoneData.PoolType,
		is24H = ZoneData.Instance:GetAttribute("24h"),
	}

	print("ZoneData", ZoneData, "ChosenData", ChosenData)
	if not ChosenData then
		return
	end

	local GameType, MapName, GameScenarioID, Difficulty =
		ChosenData.GameType, ChosenData.MapName, ChosenData.GameScenarioID, ChosenData.Difficulty
	local PlaceId = (game.GameId == 6717025335 and 127759625243990) or (game.GameId == 5844593548 and 87213590469285) -- _G.Registry.registry.Maps[MapName].PlaceId
	local Success, Server, ServerId = pcall(function()
		return TeleportService:ReserveServer(PlaceId)
	end)
	local PlayerListIds = {}
	if RunService:IsStudio() then
		for _, player in ZoneData.Players do
			player:Kick()
		end
	end

	--for _, player in ZoneData.Players do
	--local passed, _error = pcall(function()
	--	JoinData:SetAsync("Player_"..player.UserId, {
	--		AccessCode = Server,
	--		PlaceId = PlaceId
	--	}, 240)
	--end)

	--if not passed then
	--	--warn(`Failed to store JoinData for {player}. Error: {_error}`)
	--	return
	--end

	--	table.insert(PlayerListIds, player.UserId)
	--end

	local TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions.ShouldReserveServer = true
	TeleportOptions:SetTeleportData({
		MapName = MapName,
		Difficulty = Difficulty,
		GameType = GameType, -- "Story", "Infinity", "Challenge"
		GameScenarioId = GameScenarioID, -- story chapter if story, some challenge name if challenge when we add it later
		PlaceId = PlaceId, -- for checks if we got the right place
		PrivateServerId = ServerId,
		PlayerList = PlayerListIds,
		Challenges = ZoneData.Challenges,
		RewardPoolSeed = ZoneData.RewardPoolSeed,
		RandomSeed = ZoneData.RandomSeed,
		PoolType = ZoneData.PoolType,
		Host = ZoneData.MapSelector and ZoneData.MapSelector.UserId,
		BossName = ZoneData.BossName,
		is24H = ZoneData.Instance:GetAttribute("24h"),
	})

	local EngagementType = (ZoneData.Instance:GetAttribute("24h") and ZoneData.Instance:GetAttribute("24h") == true)
			and "DailyChallenge"
		or GameType
	local Engagement = `${EngagementType}`

	for _, player in ZoneData.Players do
		trackEngagement(player, Engagement)
	end

	local Success, TeleportResult = pcall(function()
		return TeleportService:TeleportAsync(PlaceId, ZoneData.Players, TeleportOptions)
	end)
	if not Success then
		warn(TeleportResult)

		for _, player in ZoneData.Players do
			TeleportingToggle_RE:FireClient(player, false, ZoneData.ChosenData)
			QueueChallenge:KickPlayer(player)
		end

		return
	end

	--local passed, _error = pcall(function()
	--	JoinData:SetAsync("GameStart_"..ServerId, {
	--		MapName = MapName,
	--		Difficulty = Difficulty,
	--		GameType = GameType, -- "Story", "Infinity", "Challenge"
	--		GameScenarioId = GameScenarioID, -- story chapter if story, some challenge name if challenge when we add it later
	--		PlaceId = PlaceId, -- for checks if we got the right place
	--		PrivateServerId = ServerId,
	--		PlayerList = PlayerListIds,
	--		Challenges = ZoneData.Challenges,
	--		RewardPoolSeed = ZoneData.RewardPoolSeed,
	--		RandomSeed = ZoneData.RandomSeed,
	--		PoolType = ZoneData.PoolType,
	--		Host = ZoneData.MapSelector and ZoneData.MapSelector.Name,
	--		BossName = ZoneData.BossName
	--	}, 240)
	--end)

	--if not passed then
	--	--warn(`Failed to save JoinData for GameStart. Error: {_error}`)
	--	return
	--end

	for _, player in ZoneData.Players do
		player:SetAttribute("Teleporting", true)
	end

	--TeleportService:TeleportToPrivateServer(PlaceId, Server, ZoneData.Players)
	return true
end

--//
function QueueChallenge:StartGame(ZoneData: ZoneDataType)
	if ZoneData.IsTeleporting then
		--warn(string.upper(script.Name),'NOT TELEPORTING')
		return
	end
	--warn(string.upper(script.Name),'TELEPORTING')
	ZoneData.PassedTime = 0
	ZoneData.CanPlayersEnter = false
	ZoneData.IsTeleporting = true

	for _, player in ZoneData.Players do
		UiCommunication:FireClient(player, "MatchStats/CloseQueueExitButton")
		TeleportingToggle_RE:FireClient(player, true, {
			GameType = "Challenge",
			MapName = ZoneData.Map,
			GameScenarioID = 1,
			Difficulty = "Nightmare",
			Challenges = ZoneData.Challenges,
			RewardPoolSeed = ZoneData.RewardPoolSeed,
			RandomSeed = ZoneData.RandomSeed,
			PoolType = ZoneData.PoolType,
		})
	end

	if not QueueChallenge:_TeleportPlayers(ZoneData) then
		print("Not Teleporting")
		ZoneData.IsTeleporting = false
		ZoneData.CanPlayersEnter = true
		ZoneData.PassedTime = 5 -- A time window to not allow spam

		for _, player in ZoneData.Players do
			UiCommunication:FireClient(player, "MatchStats/OpenQueueExitButton", true)
		end

		return
	else
		print("Teleporting")
	end

	for index, connection in ZoneData.PlayerConnections do
		connection:Disconnect()
		ZoneData[index] = nil
	end

	ZoneData.Active = false
	ZoneData.Players = {}
	ZoneData.MapSelector = nil
	ZoneData.ChosenData = nil
	ZoneData.PassedSelectorTime = nil
	local PlayersHolder = ZoneData.Instance.GuiContainer.SurfaceGui.Container.Frame

	for _, PlayerFrame in PlayersHolder:GetChildren() do
		if not PlayerFrame:IsA("Frame") then
			continue
		end
		if PlayerFrame.Name == "Example" then
			continue
		end
		PlayerFrame:Destroy()
	end

	task.wait(5)
	ZoneData.CanPlayersEnter = true
	ZoneData.IsTeleporting = false
	--warn('Closing off')
	--warn(table.unpack(ZoneData))
end

--// Gets the zone a player is in
function QueueChallenge:GetPlayerZone(player: Player): ZoneDataType
	for _, ZoneData in CreatedZones do
		if table.find(ZoneData.Players, player) then
			return ZoneData
		end
	end
end

--// Validates the data sent from the client
function QueueChallenge:ValidateData(Zone: ZoneDataType, Data: ChosenDataType): boolean?
	if not Data then
		return
	end

	local GameType, MapName, GameScenarioID, Difficulty =
		Data.GameType, Data.MapName, Data.GameScenarioID, Data.Difficulty

	if not (GameType and MapName and GameScenarioID and Difficulty) then
		return
	end

	if QueueLibrary:CheckRequirements(Zone.MapSelector, Data) ~= true then
		NotifyPlayer:FireClient(Zone.MapSelector, "Error", `You do not meet the requirements to queue for this!`)

		return
	end

	local FoundMap = _G.Registry.registry.Maps[MapName]

	if not FoundMap or not FoundMap.raw.Story:FindFirstChild(GameScenarioID) or not FoundMap.raw.Released.Value then
		return
	end

	return true
end

SetZoneGuiRewards_RE.OnServerEvent:Connect(function(Player)
	--warn('Setting REWARDS REWARDS')
	for Index, ZoneData in CreatedZones do
		if ZoneData.Type ~= "Challenge" then
			continue
		end
		local ZoneInstance = Index
		local SurfaceGui = ZoneInstance:FindFirstChild("GuiContainer")
			and ZoneInstance.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")
		if CreatedZones[Index].ActRewards then
			SetZoneGuiRewards_RE:FireClient(
				Player,
				SurfaceGui.Container.Rewards,
				{ ["ActRewards"] = CreatedZones[Index].ActRewards }
			)
		end
	end
end)

SetZoneGuiBosses_RE.OnServerEvent:Connect(function(Player)
	--warn('Setting BOSSES BOSSES')

	for Index, ZoneData in CreatedZones do
		if ZoneData.Type ~= "Challenge" then
			continue
		end
		local ZoneInstance = Index
		local SurfaceGui = ZoneInstance:FindFirstChild("GuiContainer")
			and ZoneInstance.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")
		if CreatedZones[Index].BossName then
			--SetZoneGuiRewards_RE:FireClient(Player,SurfaceGui.Container.Rewards,{['ActRewards'] = CreatedZones[Index].ActRewards})
			for i, v in game.Players:GetPlayers() do
				task.spawn(function()
					if
						v:WaitForChild("notSavable"):WaitForChild("loaded").Value
						or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
					then
						SetZoneGuiBosses_RE:FireClient(
							v,
							SurfaceGui.Container.MapData.BossIcon,
							CreatedZones[Index].BossName
						)
					end
				end)
			end
			--warn('FOUND BOSS',CreatedZones[Index].BossName)
		else
			--warn('NO BOSS!')
		end
	end
end)

return QueueChallenge
