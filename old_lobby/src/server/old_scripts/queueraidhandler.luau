--// By @ThatOneTusk
-- Choosing map data is handled in UiServer > MapSelection
local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local QueueZones = workspace.Map.QueueRaidZones
local CustomData = require(script.CustomData)
local QueueLibrary = require(ReplicatedStorage.Libs.QueueLibrary)

export type ZoneDataType = CustomData.ZoneDataType
export type ChosenDataType = CustomData.ChosenDataType

local QueueHandler = {
	CreatedZones = {} :: { [Instance]: ZoneDataType },
}

local EnterCooldowns = {}
local CreatedZones = QueueHandler.CreatedZones

local MAP_SELECTOR_TIMEOUT = 30
local DEFAULT_WAIT_TIME = 30
local DEFAULT_MINIMUM_PLAYERS = 1
local DEFAULT_MAXIMUM_PLAYERS = 4
local MODE = "Raid"

local DifficultyIcons = {
	Easy = "rbxassetid://18621359625",
	Normal = "rbxassetid://18621367494",
	Hard = "rbxassetid://18621367494",
}

local UiCommunication = ReplicatedStorage.Events.UiCommunication
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2
local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local GradientRegistry = _G.Registry.registry.GradientAnimations

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

--// Set up all the queue zones and start-up RunService
function QueueHandler:start()
	for _, Zone: Instance in QueueZones:GetChildren() do
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

		local ZoneData: ZoneDataType = QueueHandler:_CreateZone(Zone)

		--// Entering
		Hitbox.Touched:Connect(function(hit)
			local player = PlayerService:GetPlayerFromCharacter(hit.Parent)

			if not player or EnterCooldowns[player] or player:GetAttribute("Teleporting") then
				return
			end

			EnterCooldowns[player] = true

			task.delay(1, function()
				EnterCooldowns[player] = nil
			end)
			if ZoneData.ChosenData and not ZoneData.MapSelector then
				NotifyPlayer:FireClient(player, "Error", `Failed to join queue!`)
				return
			end

			if not ZoneData.CanPlayersEnter or ZoneData.IsTeleporting then
				if not ZoneData.IsTeleporting then
					if ZoneData.MapSelector == player then
						return
					end
					NotifyPlayer:FireClient(player, "Error", `{ZoneData.MapSelector} is selecting a map!`)
				end
				return
			end
			if #ZoneData.Players >= ZoneData.MaximumPlayers or QueueHandler:GetPlayerZone(player) then
				if #ZoneData.Players >= ZoneData.MaximumPlayers then
					NotifyPlayer:FireClient(player, "Error", `Failed to join, queue is full!`)
				end
				return
			end

			local PlayerData = DataAPI:GetActivePlayerProfileClass(player)

			warn()

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

			local LastOwned = player:GetAttribute("OwnerCooldown") or 0
			if LastOwned >= os.clock() and not ZoneData.MapSelector then
				NotifyPlayer:FireClient(
					player,
					"Error",
					`You are entering queues too early! ({math.floor((LastOwned - os.clock()) * 100) / 100}s)`
				)
				return
			end

			if player:GetAttribute("Portal") then
				NotifyPlayer:FireClient(player, "Error", `You are already queueing for a portal!`)
				return
			end

			if ZoneData.ChosenData then
				warn("Friends only", ZoneData.ChosenData.FriendsOnly)
				if ZoneData.ChosenData.FriendsOnly then
					local Success, IsFriends = pcall(function()
						return player:IsFriendsWith(ZoneData.MapSelector.UserId)
					end)
					warn(IsFriends)
					if not IsFriends then
						NotifyPlayer:FireClient(player, "Error", `You must be friends with {ZoneData.MapSelector}!`)
						return
					end
				end

				if QueueLibrary:CheckRequirements(player, ZoneData.ChosenData) ~= true then
					NotifyPlayer:FireClient(player, "Error", `You do not meet the requirements to enter this queue!`)
					return
				end

				if not ZoneData.MapSelector or not ZoneData.MapSelector.Parent then
					NotifyPlayer:FireClient(player, "Error", `Something went wrong, try again later!`)
					return
				end
			end

			QueueHandler:_OnEnter(ZoneData, player)
		end)
	end

	RunService.PostSimulation:Connect(function(delta)
		for ZoneInstance, ZoneData in CreatedZones do
			local Count = #ZoneData.Players
			local SurfaceGui = ZoneInstance:FindFirstChild("GuiContainer")
				and ZoneInstance.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")

			if SurfaceGui then
				SurfaceGui.Enabled = Count ~= 0 and (ZoneData.ChosenData or ZoneData.MapSelector)
				if SurfaceGui.Enabled then
					local Container = SurfaceGui.Container
					local Selecting = SurfaceGui.Selecting

					Container.Visible = ZoneData.ChosenData
					Selecting.Visible = not Container.Visible

					if Selecting.Visible then
						Selecting.Bar.Size = UDim2.new(ZoneData.PassedSelectorTime / MAP_SELECTOR_TIMEOUT, 0, 1, 0)
					end

					--Container.MapData.LoadingBar.Status.Text = Count >= ZoneData.MinimumPlayers and math.ceil(ZoneData.PassedTime) or "Waiting For Players..."
				end
			end

			if not ZoneData.ChosenData and ZoneData.MapSelector then
				if ZoneData.PassedSelectorTime <= 0 then
					NotifyPlayer:FireClient(ZoneData.MapSelector, "Error", `You took too long to select a map!`)

					QueueHandler:KickPlayer(ZoneData.MapSelector)
					ZoneData.PassedSelectorTime = MAP_SELECTOR_TIMEOUT
				else
					ZoneData.PassedSelectorTime -= delta
				end
			end

			if Count >= ZoneData.MinimumPlayers and Count <= ZoneData.MaximumPlayers then
				if ZoneData.Active then
					if ZoneData.PassedTime > 0 then
						ZoneData.PassedTime -= delta

						if ZoneData.MapSelector then
							local alpha = ZoneData.PassedTime / DEFAULT_WAIT_TIME
							local color = Color3.fromRGB(255, 0, 0)
								:Lerp(Color3.fromRGB(0, 255, 0), math.clamp(math.max(0, alpha), 0, 1))
							local hue, saturation = color:ToHSV()

							ZoneInstance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.Size =
								UDim2.fromScale(math.max(0, alpha), 1)
							ZoneInstance.GuiContainer.SurfaceGui.Container.TimeoutBar.GreenBar.UIGradient.Color =
								ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, saturation, 0.55)),
									ColorSequenceKeypoint.new(1, color),
								})
						end
					elseif not ZoneData.IsTeleporting then
						QueueHandler:StartGame(ZoneData)
					end
				end
			else
				ZoneData.Active = false
				ZoneData.PassedTime = ZoneData.WaitTime

				if Count == 0 then
					ZoneData.ChosenData = nil
				end
			end
		end
	end)
end

--// Returns a new queue zone
function QueueHandler:_CreateZone(Instance: Instance): ZoneDataType
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
function QueueHandler:_OnEnter(Zone: ZoneDataType, player: Player)
	local character = player.Character
	--warn(Zone)
	local ZoneInstance = Zone.Instance
	local EnterPosition: BasePart = ZoneInstance.EnterPosition

	table.insert(Zone.Players, player)

	Zone.PlayerConnections[player] = character.AncestryChanged:Connect(function()
		if not character.Parent then
			QueueHandler:KickPlayer(player)
		end
	end)

	player:SetAttribute("WindowsDisabled", true)

	local PlayersHolder = Zone.Instance.GuiContainer.SurfaceGui.Container.Frame
	local RewardsHolder = Zone.Instance.GuiContainer.SurfaceGui.Container.Rewards
	local MapData = Zone.Instance.GuiContainer.SurfaceGui.Container.MapData
	local PlayerFrame = PlayersHolder.Example:Clone()
	PlayerFrame.ImageLabel.Image = `rbxthumb://type=AvatarHeadShot&id={player and player.UserId or ""}&w=60&h=60`
	PlayerFrame:SetAttribute("Name", player.DisplayName)
	PlayerFrame.Visible = true
	PlayerFrame.Name = player.UserId
	PlayerFrame.Parent = PlayersHolder

	local Success, Error = pcall(function()
		QueueLibrary:ReconcileData(player)
	end)
	if not Success then
		warn(Error)
	end

	--if Zone.MapSelector and not Zone.MapSelector.Parent then Zone.MapSelector = nil Zone.ChosenData = nil end
	--print(Zone.ChosenData and not Zone.MapSelector)
	if not Zone.ChosenData and not Zone.MapSelector then
		Zone.PassedSelectorTime = MAP_SELECTOR_TIMEOUT
		Zone.MapSelector = player
		Zone.CanPlayersEnter = false
		self:QueueGuiEnabled(Zone, true)
		task.wait(0.125)

		UiCommunication:FireClient(player, "WindowManager/OpenWindow", {
			WindowName = "MapSelection",
			CloseCurrentWindow = true,
			HideSlotBar = true,
			Blur = false,
			BarsHidden = true,
			Darken = false,
		}, MAP_SELECTOR_TIMEOUT, MODE, EnterPosition.CFrame)
	else
		task.wait(0.125)
		if not Zone.ChosenData then
			local Suc, Err = pcall(function()
				QueueHandler:KickPlayer(player)
			end)
			if not Suc then
				warn(Err)
			end
			return
		end

		local Suc, Err = pcall(function()
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
				Zone.PassedTime,
				Zone.DisplayName,
				Zone.Icon,
				Zone.ChallengeDisplayName,
				Zone.TimerDisplay,
				Zone.TimerBar,
				PlayersHolder,
				RewardsHolder,
				MapData,
				Zone.ChosenData and Zone.ChosenData.Difficulty,
				{
					["GameType"] = Zone.ChosenData.GameType,
					["GameScenarioID"] = Zone.ChosenData.GameScenarioID,
					["MapName"] = Zone.ChosenData.MapName,
					["BossName"] = Zone.Boss,
				},
				EnterPosition.CFrame
			)
			UiCommunication:FireClient(player, "MapSelection/OpenQueueExitButton", player == Zone.MapSelector, Zone)
		end)
		if not Suc then
			warn(Err)
		end
	end
	--character.HumanoidRootPart.Anchored = true
	--character.HumanoidRootPart.CFrame = EnterPosition.CFrame
	--character.HumanoidRootPart.Anchored = false
	--warn('PreMap Selector:',player == Zone.MapSelector)
	QueueHandler:UpdateZoneGui(Zone, player == Zone.MapSelector)
end

--// Exits the player from their zone (in any scenario, like leaving the game)
function QueueHandler:KickPlayer(player: Player)
	local Zone: ZoneDataType = QueueHandler:GetPlayerZone(player)
	--print('kicking',player)
	if not Zone then
		return
	end

	local character = player.Character

	local ZoneInstance = Zone.Instance
	local ExitPosition: BasePart = ZoneInstance.ExitPosition

	if character then
		character:PivotTo(ExitPosition.CFrame)
	end

	table.remove(Zone.Players, table.find(Zone.Players, player))

	UiCommunication:FireClient(player, "MapSelection/CloseQueueExitButton")

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
		Zone.Active = false
		Zone.CanPlayersEnter = false
		Zone.MapSelector = nil
		Zone.PassedSelectorTime = nil
		UiCommunication:FireClient(player, "WindowManager/CloseWindow", "MapSelection")

		local Adder = player:GetAttribute("OwnerCount") or 0
		Adder += 1
		player:SetAttribute("OwnerCount", Adder)
		player:SetAttribute("OwnerCooldown", os.clock() + 2 + Adder)

		for _, player in Zone.Players do
			NotifyPlayer:FireClient(player, "Error", `The owner of this queue has left!`)

			QueueHandler:KickPlayer(player)
		end

		Zone.CanPlayersEnter = true
		self:QueueGuiEnabled(Zone, true)
	end
	player:SetAttribute("WindowsDisabled", false)
	--warn('PreMap Selector:',player == Zone.MapSelector)
	QueueHandler:UpdateZoneGui(Zone, player == Zone.MapSelector)
end

function QueueHandler:_FormatNumber(number: number | string): string
	if number < 1000 then
		return number
	end
	local abbreviations = { "x", "K", "M", "B", "T" }

	number = tostring(math.floor(number))
	return string.sub(number, 1, ((#number + 2) % 3) + 1) .. abbreviations[math.floor((#number - 1) / 3) + 1]
end

function QueueHandler:_SetUnitViewport(itemData, viewport: ViewportFrame, data: RegisterItemFrameData) end

function QueueHandler:_SetItemViewport(itemData, viewport: ViewportFrame, data: RegisterItemFrameData)
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
					--	print('Animating')
				else
					--print('GradientPattern',GradientRegistry)
				end
			end
		end
	end
end

local SetZoneGuiRewards_RE = ReplicatedStorage.Events.SetZoneGuiRewards
local SetZoneGuiBosses_RE = ReplicatedStorage.Events.SetZoneGuiBosses
local ViewportPlayerAddedConnectionBoss
local ViewportPlayerAddedConnectionItems

--// Updates the gui for the zone
function QueueHandler:UpdateZoneGui(Zone: ZoneDataType, MapSelector)
	--warn('MapSelector',MapSelector)
	--Zone.ChosenData.GameType = "Raid"
	--Zone.ChosenData.Difficulty = "Raid"

	local ChosenData = Zone.ChosenData

	local SurfaceGui = Zone.Instance:WaitForChild("GuiContainer")

	if not SurfaceGui then
		return
	end

	SurfaceGui = SurfaceGui:FindFirstChildWhichIsA("SurfaceGui"):WaitForChild("Container")

	local MapData = SurfaceGui.MapData
	--local LoadingBar = MapData.LoadingBar
	local PlayerAmount = #Zone.Players

	if ChosenData then
		local FoundMap = _G.Registry.registry.Maps[ChosenData.MapName]
		local FoundAct = require(
			_G.Registry.registry.Maps[ChosenData.MapName].raw[ChosenData.GameType]:FindFirstChild(
				ChosenData.GameScenarioID
			)
		)

		local Difficulty = ChosenData.GameType == "Story" and ChosenData.Difficulty
			or ChosenData.GameType == "Infinite" and "Nightmare"
			or ChosenData.GameType == "Raid" and "Raid"
			or ChosenData.GameType
		MapData.MapName.Text = ChosenData.MapName
		MapData.ActName.Text =
			`Act {ChosenData.GameScenarioID} - {ChosenData.GameType ~= "Infinite" and Difficulty or "Infinite"} Mode`
		--print(ChosenData)
		MapData.Image = FoundMap.Icon
		--MapData.DifficultyIcon.Image = DifficultyIcons[ChosenData.GameType == 'Story' and ChosenData.Difficulty or 'Nightmare'] or ""

		for _, UIGradient in MapData.DifficultyIcon:GetChildren() do
			if not UIGradient:IsA("UIGradient") then
				continue
			end
			UIGradient.Enabled = false
		end
		if MapData.DifficultyIcon:FindFirstChild(Difficulty) then
			MapData.DifficultyIcon:FindFirstChild(Difficulty).Enabled = true
		end

		local BossFolder = SurfaceGui.MapData.BossIcon.ViewportFrame.WorldModel:FindFirstChild("BossFolder")
			or Instance.new("Folder", SurfaceGui.MapData.BossIcon.ViewportFrame.WorldModel)

		local ActBoss = FoundAct.Boss
		Zone.BossName = ActBoss
		if ActBoss then
			if _G.Registry.registry.Enemies[ActBoss] then
				--local BossModel = _G.Registry.registry.Enemies[ActBoss].raw:FindFirstChildOfClass('Model')
				--if BossModel then
				--	BossFolder.Name = 'BossFolder'
				--	BossFolder:ClearAllChildren()
				--	BossModel = BossModel:Clone()
				--	BossModel.HumanoidRootPart.CFrame = SurfaceGui.MapData.BossIcon.ViewportFrame.WorldModel.Model.HumanoidRootPart.CFrame
				--	BossModel.Name = ActBoss
				--	BossModel.Parent = BossFolder
				--end

				for i, v in game.Players:GetPlayers() do
					task.spawn(function()
						if
							v:WaitForChild("notSavable"):WaitForChild("loaded").Value
							or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
						then
							SetZoneGuiBosses_RE:FireClient(v, SurfaceGui.MapData.BossIcon, ActBoss)
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
						SetZoneGuiBosses_RE:FireClient(v, SurfaceGui.MapData.BossIcon, ActBoss)
					end
				end)
			end
		end

		if MapSelector then
			for _, Slot in SurfaceGui.Rewards:GetChildren() do
				if not Slot:IsA("Frame") then
					continue
				end
				if Slot.Name == "Example" then
					continue
				end
				Slot:Destroy()
			end
		end
		--print(FoundMap)
		local ActRewards = FoundAct.Rewards

		if ActRewards and MapSelector then
			for i, v in game.Players:GetPlayers() do
				task.spawn(function()
					if
						v:WaitForChild("notSavable"):WaitForChild("loaded").Value
						or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
					then
						SetZoneGuiRewards_RE:FireClient(v, SurfaceGui.Rewards, ChosenData)
					end
				end)
			end

			if ViewportPlayerAddedConnectionItems then
				ViewportPlayerAddedConnectionItems:Disconnect()
			end

			ViewportPlayerAddedConnectionItems = game.Players.PlayerAdded:Connect(function(v)
				if
					v:WaitForChild("notSavable"):WaitForChild("loaded").Value
					or v:WaitForChild("notSavable"):WaitForChild("loaded").Changed:Wait()
				then
					SetZoneGuiRewards_RE:FireClient(v, SurfaceGui.Rewards, ChosenData)
				end
			end)
		end

		self:QueueGuiEnabled(Zone, false)
	end

	--if Zone.MapSelector then
	--	MapData.OwnerDisplay.Text = Zone.MapSelector.Name
	--end

	--LoadingBar.Bar.Size = UDim2.new(PlayerAmount / Zone.MaximumPlayers, 0, 0, 16)
	--LoadingBar.PlayerAmount.Text = `{PlayerAmount}/{Zone.MaximumPlayers}`

	if PlayerAmount <= 0 then
		self:QueueGuiEnabled(Zone, true)
	end
end

local TeleportingToggle_RE = ReplicatedStorage.Events.TeleportingToggle
--// Attempts to teleport all the players in the zone, returning whether it passed or not
function QueueHandler:_TeleportPlayers(ZoneData: ZoneDataType): boolean?
	--ZoneData.ChosenData.GameType = "Raid"
	--ZoneData.ChosenData.Difficulty = "Raid"

	local ChosenData = ZoneData.ChosenData
	warn(ZoneData)
	warn(ChosenData.Owner)
	warn(ChosenData.Owner.Parent)
	warn(ChosenData.Owner.Name)

	if not ChosenData then
		return
	end

	local GameType, MapName, GameScenarioID, Difficulty = "Raid", ChosenData.MapName, ChosenData.GameScenarioID, "Raid"

	local PlaceId = (game.GameId == 6717025335 and 127759625243990) or (game.GameId == 5844593548 and 87213590469285) --  _G.Registry.registry.Maps[MapName].PlaceId
	local PlayerListIds = {}

	local TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions.ShouldReserveServer = true
	TeleportOptions:SetTeleportData({
		["MapName"] = MapName,
		["Difficulty"] = Difficulty,
		["GameType"] = GameType,
		["GameScenarioId"] = GameScenarioID,
		["Host"] = ChosenData.Owner and ChosenData.Owner.UserId,
	})

	local Success, TeleportResult = pcall(function()
		return TeleportService:TeleportAsync(PlaceId, ZoneData.Players, TeleportOptions)
	end)
	if not Success then
		warn(TeleportResult)

		for _, player in ZoneData.Players do
			TeleportingToggle_RE:FireClient(player, false, ZoneData.ChosenData)
			QueueHandler:KickPlayer(player)
		end

		return
	end

	local Engagement = `{GameType}:{MapName}:{Difficulty}`

	for _, player in ZoneData.Players do
		trackEngagement(player, Engagement)
	end

	local Server, ServerId = TeleportResult.ReservedServerAccessCode, TeleportResult.PrivateServerId

	for _, player in ZoneData.Players do
		table.insert(PlayerListIds, player.UserId)
	end

	for _, player in ZoneData.Players do
		player:SetAttribute("Teleporting", true)
	end

	--TeleportService:TeleportPartyAsync(PlaceId, ZoneData.Players, )

	--TeleportService:TeleportToPrivateServer(PlaceId, Server, ZoneData.Players)
	return true
end

function QueueHandler:QueueGuiEnabled(Zone, Bool)
	--warn('QueueGuiEnabled')
	local QueueGui = Zone.Instance:FindFirstChild("QueueDisplay")

	if QueueGui then
		QueueGui = QueueGui:FindFirstChildWhichIsA("SurfaceGui")
		QueueGui.Enabled = Bool
	else
		warn("does not exist !2!")
	end
end

function QueueHandler:_RemovePlayerFrames(ZoneData)
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
end

--//
function QueueHandler:StartGame(ZoneData: ZoneDataType)
	if ZoneData.IsTeleporting then
		return
	end

	ZoneData.PassedTime = 0
	ZoneData.CanPlayersEnter = false
	ZoneData.IsTeleporting = true

	for _, player in ZoneData.Players do
		UiCommunication:FireClient(player, "MapSelection/CloseQueueExitButton")
		TeleportingToggle_RE:FireClient(player, true, ZoneData.ChosenData)
	end

	if QueueHandler:_TeleportPlayers(ZoneData) then
		coroutine.wrap(function()
			task.wait(8)
			ZoneData.IsTeleporting = false
			ZoneData.CanPlayersEnter = true

			self:_RemovePlayerFrames(ZoneData)
		end)()
		ZoneData.PassedTime = 8 -- A time window to not allow spam

		for _, player in ZoneData.Players do
			UiCommunication:FireClient(player, "MapSelection/OpenQueueExitButton", player == ZoneData.MapSelector)
		end

		return
	end

	for index, connection in ZoneData.PlayerConnections do
		connection:Disconnect()
		ZoneData[index] = nil
	end

	ZoneData.Active = false
	ZoneData.Players = {}

	self:_RemovePlayerFrames(ZoneData)

	self:QueueGuiEnabled(ZoneData, true)
	task.wait(8)
	ZoneData.CanPlayersEnter = true
	ZoneData.IsTeleporting = false
end

--// Gets the zone a player is in
function QueueHandler:GetPlayerZone(player: Player): ZoneDataType
	for _, ZoneData in CreatedZones do
		if table.find(ZoneData.Players, player) then
			return ZoneData
		end
	end
end

--// Validates the data sent from the client
function QueueHandler:ValidateData(Zone: ZoneDataType, Data: ChosenDataType): boolean?
	if not Data then
		return
	end

	local GameType, MapName, GameScenarioID, Difficulty = "Raid", Data.MapName, Data.GameScenarioID, "Raid"

	if not (GameType and MapName and GameScenarioID and Difficulty) then
		return
	end

	local Response = QueueLibrary:CheckRequirements(Zone.MapSelector, Data)

	if Response ~= true then
		NotifyPlayer:FireClient(
			Zone.MapSelector,
			"Error",
			typeof(Response) == "string" and Response or `You do not meet the requirements to queue for this!`
		)

		return
	end

	local FoundMap = _G.Registry.registry.Maps[MapName]

	if not FoundMap or not FoundMap.raw.Raid:FindFirstChild(GameScenarioID) or not FoundMap.raw.Released.Value then
		return
	end

	return true
end

function QueueHandler:ReconcileData(Player)
	QueueLibrary:ReconcileData(Player)
end

SetZoneGuiRewards_RE.OnServerEvent:Connect(function(Player)
	--warn('Setting Zone')
	for Index, ZoneData in CreatedZones do
		if ZoneData.Type ~= "Raid" then
			continue
		end
		if not ZoneData.ChosenData then
			--warn('Queue continuing')
			continue
		end
		--warn(ZoneData.ChosenData)
		local ZoneInstance = Index
		local SurfaceGui = ZoneInstance:FindFirstChild("GuiContainer")
			and ZoneInstance.GuiContainer:FindFirstChildWhichIsA("SurfaceGui")
		--SurfaceGui = SurfaceGui:FindFirstChildWhichIsA("SurfaceGui")
		--warn(SurfaceGui)
		SurfaceGui = SurfaceGui:WaitForChild("Container")
		--warn(SurfaceGui.Rewards)
		SetZoneGuiRewards_RE:FireClient(Player, SurfaceGui.Rewards, ZoneData.ChosenData)
	end
end)

return QueueHandler
