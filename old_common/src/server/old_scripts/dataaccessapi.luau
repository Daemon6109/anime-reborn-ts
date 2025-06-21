--!native
local API = {}

export type Profile = {
	Data: { any },
	MetaData: any,
	MetaTagsUpdated: any,

	RobloxMetaData: any,
	UserIds: { any },
	GlobalUpdates: any,
}

export type ProfileClass = {
	Data: { any },
	GetDataChangedSignal: (stat: string) -> any,
	Dispose: () -> (),
}

local ProfileClass = require(script.ProfileClassServer)
local TournamentDataModule = require(game.ReplicatedStorage.Registry.TournamentData)

local Dev_Core_Allow_List =
	{ "Lead-Developer", "Developer+", "developerX", "Veteran", "Project Leader", "Co-Owner", "Owner" }
local Dev_Core_Allow_List_TESTPLACE = {
	"Lead-Developer",
	"Developer+",
	"developerX",
	"Veteran",
	"Project Leader",
	"Co-Owner",
	"Owner",
	"Tester",
	"[CLOSED] Tester",
	"Admin",
	"Moderator",
}

local UniversesWhitelist = {
	["5844593548"] = "Production",
	["6717025335"] = "Tester",
	["87542414930759"] = "Tester",
}

local function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function RunServiceMethod(method: string, ...: any?)
	local args = { ... }

	task.spawn(function()
		if not game.ReplicatedStorage.ServerLoaded.Value then
			game.ReplicatedStorage.ServerLoaded.Changed:Wait()
		end

		for _, module in _G.serverServices do
			if type(module[method]) == "function" then
				task.spawn(function()
					module[method](module, table.unpack(args)) -- Pass the module first to assign self
				end)
			end
		end
	end)
end

function API.init()
	if not _G.DataAPI and not _G.LoadingDataAPI then
		_G.LoadingDataAPI = true
		--- Declarations
		local Players = game:GetService("Players")
		local HTTP = game:GetService("HttpService")
		local ServerStorage = game:GetService("ServerStorage")
		local SSS = script.Parent.Parent
		local DataStoreService = game:GetService("DataStoreService")
		local GiftInboxDataStore =
			DataStoreService:GetDataStore(game:GetService("ServerScriptService").GiftInboxDatastoreName.Value)

		local services = _G.serverServices
		--- Imports
		local PlaceDatastoreWhitelist = {
			["5844593548"] = SSS.DatastoreName,
			["6717025335"] = SSS.TestPlaceDatastoreName,
		}

		local dataStoreName = PlaceDatastoreWhitelist[tostring(game.GameId)]
		local ProfileTemplate = require(SSS.ServerLibs.ProfileTemplate)
		local whitelists = require(SSS.ServerLibs.PlaceWhitelist)
		local ProfileService = require(SSS.ServerLibs.ProfileStore)
		--local ProfileStore = ProfileService.GetProfileStore(
		--	dataStoreName.Value,
		--	ProfileTemplate
		--)

		local ProfileStore = ProfileService.New(dataStoreName.Value, ProfileTemplate)

		--- Private
		local _Profiles = {}
		local _ProfileClasses = {}
		local _LoadingProfile = {}

		local SoftRelease = false

		--- Public
		local Public = {}
		Public.Methods = {}

		local function LoadPlayerProfileOnJoin(player: Player)
			if _LoadingProfile[player] ~= true then
				_LoadingProfile[player] = true

				local profile = ProfileStore:StartSessionAsync("Player_" .. player.UserId, {
					Cancel = function()
						return player.Parent ~= Players
					end,
				}) --ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
				if profile ~= nil then
					profile:AddUserId(player.UserId) -- GDPR compliance
					profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
					profile.OnSessionEnd:Connect(function()
						_Profiles[player] = nil
						_LoadingProfile[player] = nil
						_ProfileClasses[player]:Dispose()
						_ProfileClasses[player] = nil

						-- The profile could've been loaded on another Roblox server:
						print("released plr", player)
						if not SoftRelease then
							player:Kick()
						end
					end)
					if player.Parent == Players then
						_Profiles[player] = profile
						_ProfileClasses[player] = ProfileClass.new(_Profiles[player], player)
						_LoadingProfile[player] = nil

						--_Profiles[player]:MessageHandler(function(message, processed)
						--	local InternalCallbacks = {
						--		Gift = function()

						--		end,
						--	}
						--end)

						xpcall(function()
							local resetApplied = false

							--if table.find(Dev_Core_Allow_List, player:GetRoleInGroup(33820338)) then
							--	--return
							--end

							if not _Profiles[player].Data.ResetByTypeOnce then
								_Profiles[player].Data.ResetByTypeOnce = {}
							end

							if _Profiles[player].Data.Inventory.Items["TraitCrystal"] then
								--warn(_Profiles[player].Data.Inventory.Items["TraitCrystal"].Count >= 10_000 and _Profiles[player].Data.Currencies.Gems >= 1_500_000 and _Profiles[player].Data.Currencies["New Year Coin"] >= 1_500_000)
								--warn(_Profiles[player].Data.Inventory.Items["TraitCrystal"].Count)
								--warn(_Profiles[player].Data.Currencies.Gems)
								--warn(_Profiles[player].Data.Currencies["New Year Coin"])

								if
									_Profiles[player].Data.Inventory.Items["TraitCrystal"].Count >= 8_000
									and _Profiles[player].Data.Currencies.Gems >= 1_500_000
									and _Profiles[player].Data.Currencies["New Year Coin"] >= 1_500_000
								then
									if not _Profiles[player].Data.ResetsApplied then
										_Profiles[player].Data.ResetsApplied = {}
									end

									table.insert(_Profiles[player].Data.ResetsApplied, {
										Date = `{os.date("!*t").year}-{os.date("!*t").month}-{os.date("!*t").day}`,
										ResetType = "Bingo",
										Amounts = {
											["Gems"] = _Profiles[player].Data.Currencies.Gems,
											["New Year Coin"] = _Profiles[player].Data.Currencies["New Year Coin"],
											["TraitCrystal"] = _Profiles[player].Data.Inventory.Items["TraitCrystal"].Count,
										},
									})

									_Profiles[player].Data.Currencies.Gems = 100_000
									_Profiles[player].Data.Currencies["New Year Coin"] = 500_000
									_Profiles[player].Data.Inventory.Items["TraitCrystal"].Count = 500

									resetApplied = true
								end
							end

							if _Profiles[player].Data.Currencies.Gems >= 10_000_000 then
								if not _Profiles[player].Data.ResetsApplied then
									_Profiles[player].Data.ResetsApplied = {}
								end

								table.insert(_Profiles[player].Data.ResetsApplied, {
									Date = `{os.date("!*t").year}-{os.date("!*t").month}-{os.date("!*t").day}`,
									ResetType = "Gems",
									PreviousAmount = _Profiles[player].Data.Currencies.Gems,
								})

								_Profiles[player].Data.Currencies.Gems = 100_000

								--_Profiles[player].Data.ResetByTypeOnce["Gems"] = true

								resetApplied = true
							end

							if _Profiles[player].Data.Currencies["New Year Coin"] then
								if _Profiles[player].Data.Currencies["New Year Coin"] >= 10_000_000 then
									if not _Profiles[player].Data.ResetsApplied then
										_Profiles[player].Data.ResetsApplied = {}
									end

									table.insert(_Profiles[player].Data.ResetsApplied, {
										Date = `{os.date("!*t").year}-{os.date("!*t").month}-{os.date("!*t").day}`,
										ResetType = "New Year Coin",
										PreviousAmount = _Profiles[player].Data.Currencies["New Year Coin"],
									})

									_Profiles[player].Data.Currencies["New Year Coin"] = 500_000

									--_Profiles[player].Data.ResetByTypeOnce["New Year Coin"] = true

									resetApplied = true
								end
							end

							if _Profiles[player].Data.Inventory.Items["TraitCrystal"] then
								if _Profiles[player].Data.Inventory.Items["TraitCrystal"].Count >= 20_000 then
									if not _Profiles[player].Data.ResetsApplied then
										_Profiles[player].Data.ResetsApplied = {}
									end

									table.insert(_Profiles[player].Data.ResetsApplied, {
										Date = `{os.date("!*t").year}-{os.date("!*t").month}-{os.date("!*t").day}`,
										ResetType = "TraitCrystal",
										PreviousAmount = _Profiles[player].Data.Inventory.Items["TraitCrystal"].Count,
									})

									_Profiles[player].Data.Inventory.Items["TraitCrystal"].Count = 500

									--_Profiles[player].Data.ResetByTypeOnce["TraitCrystal"] = true

									resetApplied = true
								end
							end

							if resetApplied then
								Public.Methods:SaveProfile(player)
								_ProfileClasses[player]:ReplicateWholeProfile()
							end
						end, function(a0)
							warn(a0)
						end)

						--warn(_ProfileClasses[player]:GetField("MissionCompletionData").Raid)

						player:SetAttribute("LastPlayTimeRefresh", os.time())

						pcall(function()
							--if player:GetRankInGroup(33820338) >= 40 then
							--	task.spawn(function()
							--		local NewDevUIClone = script.DevUI:Clone()
							--		NewDevUIClone.Parent = player:WaitForChild("PlayerGui", 10)
							--		NewDevUIClone.DevServer.Enabled = true
							--	end)
							--end
							if UniversesWhitelist[tostring(game.GameId)] == "Production" then
								--print("product")
								if table.find(Dev_Core_Allow_List, player:GetRoleInGroup(33820338)) then
									task.spawn(function()
										local NewDevUIClone = script.DevUI:Clone()
										NewDevUIClone.Parent = player:WaitForChild("PlayerGui", 10)
										NewDevUIClone.DevServer.Enabled = true
									end)
								end
							elseif UniversesWhitelist[tostring(game.GameId)] == "Tester" then
								--print("test")
								if table.find(Dev_Core_Allow_List_TESTPLACE, player:GetRoleInGroup(33820338)) then
									task.spawn(function()
										local NewDevUIClone = script.DevUI:Clone()
										NewDevUIClone.Parent = player:WaitForChild("PlayerGui", 10)
										NewDevUIClone.DevServer.Enabled = true
									end)
								end
							end
						end)

						ServerStorage.notSavable:Clone().Parent = player
					else
						-- Player left before the profile loaded:
						profile:EndSession()
					end

					--local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
					--if profile ~= nil then
					--	profile:AddUserId(player.UserId) -- GDPR compliance
					--	profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
					--	profile:ListenToRelease(function()
					--		_Profiles[player] = nil
					--		_LoadingProfile[player] = nil
					--		_ProfileClasses[player] = nil

					--		-- The profile could've been loaded on another Roblox server:
					--		print("released plr", player)
					--		player:Kick()
					--	end)
					--	if player:IsDescendantOf(Players) == true then
					--		_Profiles[player] = profile
					--		_ProfileClasses[player] = ProfileClass.new(_Profiles[player], player)
					--		_LoadingProfile[player] = nil

					--		player:SetAttribute("LastPlayTimeRefresh", os.time())

					--		pcall(function()
					--			if player:GetRankInGroup(33820338) >= 40 then
					--				task.spawn(function()
					--					local NewDevUIClone = script.DevUI:Clone()
					--					NewDevUIClone.Parent = player:WaitForChild("PlayerGui", 10)
					--					NewDevUIClone.DevServer.Enabled = true
					--				end)
					--			end
					--		end)

					--		ServerStorage.notSavable:Clone().Parent = player
					--	else
					--		-- Player left before the profile loaded:
					--		profile:Release()
					--	end
				else
					_LoadingProfile[player] = nil
					_Profiles[player] = nil
					_ProfileClasses[player] = nil
					--if _ProfileClasses[player] then
					--	--_ProfileClasses[player]:Dispose()
					--	_ProfileClasses[player] = nil
					--end
					-- The profile couldn't be loaded possibly due to other
					--   Roblox servers trying to load this profile at the same time:
					player:Kick()
				end
			end
		end

		function Public.Methods:IsProfileActive(player: Player)
			if _Profiles[player] then
				return _Profiles[player]:IsActive()
			end

			return false
		end

		function Public.Methods:SaveProfile(player: Player)
			if Public.Methods:IsProfileActive(player) then
				_Profiles[player]:Save()
				return true
			end

			return false
		end

		function Public.Methods:SaveLeaderboardData(player: Player)
			local success, _err = pcall(function()
				local PlayerProfile = _Profiles[player]

				if PlayerProfile and player.UserId > 0 and PlayerProfile:IsActive() then
					task.spawn(function()
						local PlayerData = PlayerProfile.Data
						local RobuxSpent = PlayerData.RobuxSpent
						local Gems = PlayerData.Currencies.Gems
						local PlayTime = PlayerData.PlayerStatistics.PlayTime
						local ContributedSouls = PlayerData.TeamEventData.ContributedSouls
						local PlayerTeam = PlayerData.TeamEventData.Team
						local InfiniteData = PlayerData.MissionCompletionData.Infinite

						local LeaderboardData = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData)
						local IsSeasonActive = LeaderboardData:IsSeasonActive()

						local OrderedDataStores = {
							RobuxSpent = LeaderboardData:GetDatastoreForLeaderboard("RobuxSpent"),
							Gems = LeaderboardData:GetDatastoreForLeaderboard("Gems"),
							PlayTime = LeaderboardData:GetDatastoreForLeaderboard("PlayTime"),
							SoulDesertWaves = LeaderboardData:GetDatastoreForLeaderboard("SoulDesertWaves"),
							DorasozaWaves = LeaderboardData:GetDatastoreForLeaderboard("DorasozaWaves"),
							BurnedYorkWaves = LeaderboardData:GetDatastoreForLeaderboard("BurnedYorkWaves"),
							--  HellTowerWaves = LeaderboardData:GetDatastoreForLeaderboard("HellTowerWaves");
							--	LeafVillageWaves = LeaderboardData:GetDatastoreForLeaderboard("LeafVillageWaves");
							--	LandOfTheSkyWaves = LeaderboardData:GetDatastoreForLeaderboard("LandOfTheSkyWaves");
							--	FujishimaIslandWaves = LeaderboardData:GetDatastoreForLeaderboard("FujishimaIslandWaves");
							--  ContributedSouls = PlayerTeam == "Aliens" and LeaderboardData:GetDatastoreForLeaderboard("AliensContributedSouls") or PlayerTeam == "Spirits" and LeaderboardData:GetDatastoreForLeaderboard("SpiritsContributedSouls");
						}

						OrderedDataStores.RobuxSpent:SetAsync(player.UserId, RobuxSpent)
						OrderedDataStores.Gems:SetAsync(player.UserId, Gems)
						OrderedDataStores.PlayTime:SetAsync(player.UserId, PlayTime)

						if OrderedDataStores.ContributedSouls then
							OrderedDataStores.ContributedSouls:SetAsync(player.UserId, ContributedSouls)
						end

						--// Only updates these when the  is active

						if game.ServerScriptService.Services:FindFirstChild("TournamentHandler") then
							task.spawn(function()
								pcall(function()
									local TournamentHandler =
										require(game.ServerScriptService.Services.TournamentHandler)
									TournamentHandler:UpdatePlayerLeaderboard(player, PlayerData.TournamentsData)
								end)
							end)
						end

						if IsSeasonActive then
							--[[	if InfiniteData["Leaf Village"] then
								OrderedDataStores.LeafVillageWaves:SetAsync(player.UserId, InfiniteData["Leaf Village"].HighestWave)							
							end

							if InfiniteData["Land of the Sky"] then
								OrderedDataStores.LandOfTheSkyWaves:SetAsync(player.UserId, InfiniteData["Land of the Sky"].HighestWave)							
							end

							if InfiniteData["Fujishima Island"] then
								OrderedDataStores.FujishimaIslandWaves:SetAsync(player.UserId, InfiniteData["Fujishima Island"].HighestWave)
							end]]

							if InfiniteData["Soul Desert"] then
								OrderedDataStores.SoulDesertWaves:SetAsync(
									player.UserId,
									InfiniteData["Soul Desert"].HighestWave
								)
							end

							if InfiniteData["Dorasoza"] then
								OrderedDataStores.DorasozaWaves:SetAsync(
									player.UserId,
									InfiniteData["Dorasoza"].HighestWave
								)
							end

							if InfiniteData["Burned York"] then
								OrderedDataStores.BurnedYorkWaves:SetAsync(
									player.UserId,
									InfiniteData["Burned York"].HighestWave
								)
							end
						end
					end)
				end
			end)

			if not success then
				warn(`Error occured while saving leaderboard data for {player}. Error: {_err}`)
			end
		end

		function Public.Methods:ReleaseProfile(player: Player)
			if _Profiles[player] ~= nil then
				pcall(function()
					Public.Methods:SaveLeaderboardData(player)
					RunServiceMethod("playerRemoved", player)
					--local success, _err = pcall(function()
					--	local LastPlayTimeRefresh = player:GetAttribute("LastPlayTimeRefresh")

					--	if LastPlayTimeRefresh then
					--		_Profiles[player].Data.PlayerStatistics.PlayTime += os.time() - LastPlayTimeRefresh
					--	end
					--end)

					--if not success then
					--	warn(`Error occured while saving play time for {player}. Error: {_err}`)
					--end

					local LastPlayTimeRefresh = player:GetAttribute("LastPlayTimeRefresh")

					if LastPlayTimeRefresh then
						_Profiles[player].Data.PlayerStatistics.PlayTime += os.time() - LastPlayTimeRefresh
					end

					local leaderstats = player:FindFirstChild("leaderstats")
					if _ProfileClasses[player] and leaderstats then
						local _Stats = _ProfileClasses[player]:GetField("PlayerStatistics")
						--print(_Stats)
						_Stats.Kills += leaderstats.Eliminations.Value
						_Stats.TotalDamage += leaderstats.Damage.Value
						_ProfileClasses[player]:WriteField("PlayerStatistics", _Stats)
					end

					--pcall(function()
					--	local leaderstats = player:FindFirstChild("leaderstats")
					--	if _ProfileClasses[player] and leaderstats then
					--		local _Stats = _ProfileClasses[player]:GetField("PlayerStatistics")
					--		--print(_Stats)
					--		_Stats.Kills += leaderstats.Eliminations.Value
					--		_Stats.TotalDamage += leaderstats.Damage.Value
					--		_ProfileClasses[player]:WriteField("PlayerStatistics", _Stats)
					--	end
					--end)
				end)

				_Profiles[player]:EndSession()

				--_Profiles[player] = nil
				--_LoadingProfile[player] = nil
				--_ProfileClasses[player] = nil

				print("released plr profile", player)

				--if _Profiles[player] then

				--	_Profiles[player] = nil
				--	_LoadingProfile[player] = nil
				--end

				--if _ProfileClasses[player] then
				--	_ProfileClasses[player]:Dispose()
				--	_ProfileClasses[player] = nil
				--end

				----player:Kick()
			end
		end

		function Public.Methods:GetActivePlayerProfileRaw(player: Player): Profile?
			if _Profiles[player] == nil and _LoadingProfile[player] ~= true then
				LoadPlayerProfileOnJoin(player)
			end

			if not _ProfileClasses[player] then
				local Timeout = os.clock()
				repeat
					task.wait()
				until (_LoadingProfile[player] ~= true and _ProfileClasses[player] ~= nil) or os.clock() - Timeout >= 60

				if not _ProfileClasses[player] then
					return player:Kick()
				end
			end

			return _Profiles[player]
		end

		function Public.Methods:GetActivePlayerProfileClass(player: Player): ProfileClass?
			if _Profiles[player] == nil and _LoadingProfile[player] ~= true then
				LoadPlayerProfileOnJoin(player)
			end

			if not _ProfileClasses[player] then
				local Timeout = os.clock()
				repeat
					task.wait()
				until (_LoadingProfile[player] ~= true and _ProfileClasses[player] ~= nil) or os.clock() - Timeout >= 60

				if not _ProfileClasses[player] then
					return player:Kick()
				end
			end

			return _ProfileClasses[player]
		end

		for _, Plr in game.Players:GetPlayers() do
			task.spawn(LoadPlayerProfileOnJoin, Plr)
		end

		Players.PlayerAdded:Connect(function(Player)
			LoadPlayerProfileOnJoin(Player)
		end)

		Players.PlayerRemoving:Connect(function(Player)
			Public.Methods:ReleaseProfile(Player)
		end)

		game:BindToClose(function()
			SoftRelease = true

			for _, Player in Players:GetPlayers() do
				Public.Methods:ReleaseProfile(Player)
			end
		end)

		_G.DataAPI = Public
	end
end

function API:GetAPI()
	if not _G.DataAPI and not _G.LoadingDataAPI then
		self.init()
	end

	local GetAPIMethods = {}

	function GetAPIMethods:ReleaseProfile(player: Player): nil
		return _G.DataAPI.Methods:ReleaseProfile(player)
	end

	function GetAPIMethods:GetActivePlayerProfileRaw(player: Player): Profile?
		return _G.DataAPI.Methods:GetActivePlayerProfileRaw(player)
	end

	function GetAPIMethods:IsProfileActive(player: Player): boolean?
		return _G.DataAPI.Methods:IsProfileActive(player)
	end

	function GetAPIMethods:SaveProfile(player: Player): boolean?
		return _G.DataAPI.Methods:IsProfileActive(player)
	end

	function GetAPIMethods:GetActivePlayerProfileClass(player: Player): ProfileClass.ProfileClass
		return _G.DataAPI.Methods:GetActivePlayerProfileClass(player)
	end

	function GetAPIMethods:SaveLeaderboardData(player: Player)
		return _G.DataAPI.Methods:SaveLeaderboardData(player)
	end

	return GetAPIMethods
end

return API
