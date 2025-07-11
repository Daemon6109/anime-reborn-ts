local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local module = {}
local summonEvent = ReplicatedStorage.Events.Summoning.SummonEvent
local summonFunction = ReplicatedStorage.Events.Summoning.SummonFunction
local uiCommunication = ReplicatedStorage.Events.UiCommunication
local summonFunctionCalls = {}

local unitRegistry = _G.Registry.registry.Units
local DataAccess = require(ServerScriptService.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local summonTime = ReplicatedStorage.GameVariables.SummonTime
local bannerPool = require(ReplicatedStorage.Registry.BannerPool)
local gameFunctions = require(ReplicatedStorage.Libs.GameFunctions)
local syncedTime = require(ReplicatedStorage.Libs.SyncedTime)

local DataStoreService = game:GetService("DataStoreService")
local ForcedBanners = DataStoreService:GetDataStore("ForcedBanners")
--// HARD CODED SUMMONING DATA
local BannerUpdateInSeconds = 3600
local BannerData = bannerPool:ReturnPool("Standard")
local BannerData_Mythical = bannerPool:ReturnPool("Mythical")

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local RarityPerBanner = {
	["Secret"] = 1,
	["Mythical"] = 1,
	["Legendary"] = 2,
	["Epic"] = 1,
	["Rare"] = 2,
}

local RarityPerBanner_Mythical = {
	["Secret"] = 1,
	["Mythical"] = 3,
	["Legendary"] = 2,
	["Epic"] = 1,
	["Rare"] = 2,
}

local SummonChances = gameFunctions.SummonChances

--// MUTABLES
local currentBanner = {
	["Secret"] = nil,
	["Mythical"] = nil,
	["Legendary"] = nil,
	["Epic"] = nil,
	["Rare"] = nil,
}

local mythical_Banner = {
	["Secret"] = nil,
	["Mythical"] = 3,
	["Epic"] = nil,
	["Rare"] = nil,
}

local ShinyChance = 1 --%

--// Help functions
function cloneTable(original)
	local copy = {}

	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = cloneTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

--=====================================================================================================
local function GetProductData(Player)
	local ProductData
	local PlrProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	ProductData = PlrProfileClass:GetField("ProductsBought")

	return ProductData
end

---// FUNCTION CALLS
--// When player requests the banner
function summonFunctionCalls:RequestCurrentBanner(player, Type)
	if Type == "get_Mythical" then
		-- Add another list to banner
		mythical_Banner["Mythical_2"] = {}
		for i, v in pairs(unitRegistry) do
			if
				v["configuration"].Rarity == "Mythical"
				and v["raw"]:FindFirstChild("Released")
				and v["raw"]:FindFirstChild("Summonable")
				and v["raw"].Summonable.Value == true
				and v["raw"].Released.Value == true
			then
				table.insert(mythical_Banner["Mythical_2"], i)
			end
		end

		local bnnr = table.clone(mythical_Banner)
		bnnr["Secret"] = nil
		return bnnr
	else
		local bnnr = table.clone(currentBanner)
		bnnr["Secret"] = nil
		return bnnr
	end
end

local sellableRarities = {
	"Epic",
	"Legendary",
	"Mythical",
	"Rare",
}

function summonFunctionCalls:ToggleAutoSell(player, rarity)
	if not table.find(sellableRarities, rarity) then
		return
	end

	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

	local Settings = PlayerProfileClass:GetField("Settings")

	local autoSell = Settings.AutoSell
	local _found = autoSell ~= nil and table.find(autoSell, rarity)
	if _found then
		table.remove(autoSell, _found)
		Settings.AutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)
		return false
	else
		table.insert(autoSell, rarity)
		Settings.AutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)

		return true
	end
end

function summonFunctionCalls:ToggleDragonCapsuleAutoSell(player, rarity)
	if not table.find(sellableRarities, rarity) then
		return
	end

	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

	local Settings = PlayerProfileClass:GetField("Settings")

	local autoSell = Settings.DragonCapsuleAutoSell
	local _found = autoSell ~= nil and table.find(autoSell, rarity)

	if _found then
		table.remove(autoSell, _found)
		Settings.DragonCapsuleAutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/DragonCapsuleAutoSell", autoSell, true)
		return false
	else
		table.insert(autoSell, rarity)
		Settings.DragonCapsuleAutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/DragonCapsuleAutoSell", autoSell, true)

		return true
	end
end

--// When player summons

--=====================================================================================================

function module:CalculateShinyChance(player, UseChance)
	local gamepasses = GetProductData(player)
	local shinyBoost = _G.serverServices.EffectService:CalculateMultiplier(player, "ShinyBoost")
	if gamepasses["1932432116"] then
		shinyBoost += 1
	end
	return (UseChance or ShinyChance) * shinyBoost
end

--// Initializing a global banner on the current server
function module:InitiailizeBanner()
	local seed = math.floor((syncedTime.time()) / BannerUpdateInSeconds)

	local function UpdateBanner(t)
		seed = math.floor((syncedTime.time()) / BannerUpdateInSeconds)

		BannerData = cloneTable(bannerPool:ReturnPool("Standard"))
		local BannerData = bannerPool:ReturnPool("Standard")

		BannerData_Mythical = cloneTable(bannerPool:ReturnPool("Mythical"))
		local BannerData_Mythical = bannerPool:ReturnPool("Mythical")

		local success, ForcedBanner = pcall(function()
			return ForcedBanners:GetAsync("BannerList")
		end)

		if not success then
			workspace:SetAttribute("BannerErrored", "Banner could not be loaded. Please wait.")
			for i = 1, 50 do
				success, ForcedBanner = pcall(function()
					return ForcedBanners:GetAsync("BannerList")
				end)

				if success then
					workspace:SetAttribute("BannerErrored", nil)
					break
				end
				warn(success)
				task.wait(2 * i)
			end
			if workspace:GetAttribute("BannerErrored") then
				for _, Player in Players:GetPlayers() do
					Player:Kick("Banner failed to load. Rejoin a new server.")
				end

				Players.PlayerAdded:Connect(function(player)
					player:Kick("Banner failed to load for this server. Rejoin a new server.")
				end)
			end
		end

		--print(ForcedBanner)

		if ForcedBanner and ForcedBanner[tostring(seed)] then
			ForcedBanner = ForcedBanner[tostring(seed)]
			if ForcedBanner["Mythical"] then
				BannerData["Mythical"] = ForcedBanner["Mythical"]
			end
			if ForcedBanner["Legendary"] then
				BannerData["Legendary"] = ForcedBanner["Legendary"]
			end
		end

		local RNG = Random.new(seed)
		local rarites = {
			[1] = "Secret",
			[2] = "Mythical",
			[3] = "Legendary",
		}
		for k = 1, #rarites do
			local i = rarites[k]
			local v = BannerData[i]
			if not v then
				continue
			end
			if RarityPerBanner[i] <= 1 then
				local unit = v[RNG:NextInteger(1, #v)]
				currentBanner[i] = unit
			else
				currentBanner[i] = {}
				local clonedData = cloneTable(BannerData)
				for n = 1, RarityPerBanner[i], 1 do
					local unitNo = RNG:NextInteger(1, #clonedData[i])
					table.insert(currentBanner[i], clonedData[i][unitNo])

					table.remove(clonedData[i], unitNo)
				end
			end
		end
		currentBanner["Rare"] = cloneTable(BannerData["Rare"])
		currentBanner["Epic"] = cloneTable(BannerData["Epic"])

		--

		local rarites_Mythical = {
			[1] = "Secret",
			[3] = "Legendary",
			[2] = "Mythical",
		}
		for k = 1, #rarites_Mythical do
			local i = rarites_Mythical[k]
			local v = BannerData_Mythical[i]
			if not v then
				continue
			end
			if RarityPerBanner_Mythical[i] <= 1 then
				local unit = v[RNG:NextInteger(1, #v)]
				mythical_Banner[i] = unit
			else
				mythical_Banner[i] = {}
				local clonedData = cloneTable(BannerData_Mythical)
				for n = 1, RarityPerBanner_Mythical[i], 1 do
					local unitNo = RNG:NextInteger(1, #clonedData[i])
					table.insert(mythical_Banner[i], clonedData[i][unitNo])

					table.remove(clonedData[i], unitNo)
				end
			end
		end
		mythical_Banner["Rare"] = cloneTable(BannerData_Mythical["Rare"])
		mythical_Banner["Epic"] = cloneTable(BannerData_Mythical["Epic"])
	end
	UpdateBanner()

	while task.wait(1) do
		--print(math.floor((syncedTime.time())/BannerUpdateInSeconds))
		if seed < math.floor((syncedTime.time()) / BannerUpdateInSeconds) then
			UpdateBanner(syncedTime.time())
			summonEvent:FireAllClients("BannerUpdated")
		end
		summonTime.Value = tostring(BannerUpdateInSeconds - (syncedTime.time() % BannerUpdateInSeconds))
	end
end

function module:Pity(
	plr: Player,
	pityType: "LegendaryPity" | "MythicalPity" | "SecretPity" | "FeaturedMythicalPity",
	addPity
)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

	local SummoningData = PlayerProfileClass:GetField("SummoningData")

	local totalPity = SummoningData[pityType] + addPity

	local maxPity
	if pityType == "LegendaryPity" then
		maxPity = 50
	elseif pityType == "MythicalPity" then
		maxPity = 400
	elseif pityType == "FeaturedMythicalPity" then
		maxPity = 400
	else
		maxPity = 15000
	end

	if
		SummoningData["LastBannerSeed"] ~= math.floor((syncedTime.time()) / BannerUpdateInSeconds)
		and pityType == "SecretPity"
	then
		totalPity = 0
		addPity = -SummoningData[pityType]
		SummoningData["LastBannerSeed"] = math.floor((syncedTime.time()) / BannerUpdateInSeconds)
	end
	if totalPity > maxPity then
		SummoningData[pityType] = math.abs((totalPity - maxPity) - 1)

		PlayerProfileClass:WriteField("SummoningData", SummoningData, false)

		return true
	else
		SummoningData[pityType] += addPity

		PlayerProfileClass:WriteField("SummoningData", SummoningData, false)

		return false
	end
end

function module:DragonCapsulePity(plr: Player, pityType: "LegendaryPity" | "MythicalPity", addPity)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

	local DragonCapsuleData = PlayerProfileClass:GetField("DragonCapsuleData")
	DragonCapsuleData[pityType] = DragonCapsuleData[pityType] or 0
	local totalPity = DragonCapsuleData[pityType] + addPity

	local maxPity
	if pityType == "LegendaryPity" then
		maxPity = 50
	elseif pityType == "MythicalPity" then
		maxPity = 500
	elseif pityType == "GohanEventPity" then
		maxPity = 3_000
	end

	if totalPity > maxPity then
		DragonCapsuleData[pityType] = math.abs((totalPity - maxPity) - 1)

		PlayerProfileClass:WriteField("DragonCapsuleData", DragonCapsuleData, false)

		return true
	else
		DragonCapsuleData[pityType] += addPity

		PlayerProfileClass:WriteField("DragonCapsuleData", DragonCapsuleData, false)

		return false
	end
end

function module:SetPity(
	plr: Player,
	pityType: "LegendaryPity" | "MythicalPity" | "SecretPity" | "FeaturedMythicalPity",
	pity
)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

	local SummoningData = PlayerProfileClass:GetField("SummoningData")

	SummoningData[pityType] = pity

	PlayerProfileClass:WriteField("SummoningData", SummoningData, false)
end

function module:SetDragonCapsulePity(plr: Player, pityType: "LegendaryPity" | "MythicalPity", pity)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

	local DragonCapsuleData = PlayerProfileClass:GetField("DragonCapsuleData")

	DragonCapsuleData[pityType] = pity

	PlayerProfileClass:WriteField("DragonCapsuleData", DragonCapsuleData, false)
end

function module:Chat(player, v, IsShiny)
	local Rarity = unitRegistry[v].configuration.Rarity
	local GohanLimitUpdater = _G.serverServices.GohanLimitUpdater

	local Concatenate

	if v == "Gohan" then
		Concatenate =
			`! {(GohanLimitUpdater:GetLimit() - GohanLimitUpdater:GetObtainedAmount()) - 1} remain to be obtained from the capsule!`
	end

	--

	if Rarity == "Secret" or (Rarity == "Mythical" and IsShiny) or Rarity == "Exclusive" then
		if v == "Gamma Brothers" and not IsShiny then
			return
		end
		local String = `{player.DisplayName} (@{player.Name}) has obtained a {IsShiny and "Shiny " or ""}{Rarity} {unitRegistry[v].configuration.DisplayName}`
			.. (Concatenate and Concatenate or "")

		local Success, EncodedString = pcall(function()
			return HttpService:JSONEncode(String)
		end)

		if
			Success
			and EncodedString
			and (Rarity == "Exclusive" or Rarity == "Secret" or (Rarity == "Mythical" and IsShiny))
		then
			local success, fail = pcall(function()
				return _G.serverServices.MessagingHandler:PublishAsync("Chat", EncodedString)
			end)
			if not success then
				print(fail)
			end
		end
		pcall(function()
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

			local Titles = PlayerProfileClass:GetField("Inventory")
			Titles = Titles and Titles.Titles
			if not Titles then
				return
			end
			if v == "Rimuru" and not table.find(Titles, "Rimuru") then
				_G.serverServices.TitleService:GiveTitle(player, "Rimuru")
			elseif v == "Gohan" and not table.find(Titles, "Beast Hunter") then
				_G.serverServices.TitleService:GiveTitle(player, "Beast Hunter")
			end
		end)
	end
end

function module:GetBannerPercentages(player, rarity)
	local luck = _G.serverServices.EffectService:CalculateMultiplier(player, "BannerLuck")
	if table.find({ "Mythical", "Legendary", "Secret" }, rarity) then
		return SummonChances[rarity] * luck
	end
	return SummonChances[rarity]
end

function module:Summon(player, summonType: "Summon1" | "Summon10" | "Summon1Mythical" | "Summon10Mythical")
	--if player:GetAttribute("Summoning") then return end
	--player:SetAttribute("Summoning", true)
	--task.delay(1, function()
	--	player:SetAttribute("Summoning", false)
	--end)
	if not _G.serverServices.UnitManager then
		return nil
	end
	local RNG = Random.new()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local plrLevel = PlayerProfileClass:GetField("Level")
	local products = GetProductData(player)
	local function GetRandomRarity(exclude)
		if not exclude then
			exclude = {}
		end
		if plrLevel < 15 then
			table.insert(exclude, "Secret")
		end
		local weight = 0
		for i, t in pairs(SummonChances) do
			if not table.find(exclude, i) then
				weight += module:GetBannerPercentages(player, i) * 100000
			end
		end

		local Chosen = RNG:NextNumber(1, weight)

		for i, t in pairs(SummonChances) do
			if not table.find(exclude, i) then
				weight -= module:GetBannerPercentages(player, i) * 100000
			end
			if Chosen > weight then
				return i
			end
		end
	end

	--local data__ = {}
	--for i=1, 50000 do
	--	local e = GetRandomRarity()
	--	data__[e] = data__[e] and data__[e] + 1 or 1
	--end

	--print(data__)

	local Currencies = PlayerProfileClass:GetField("Currencies")

	local gems = Currencies.Gems

	local unitManager = _G.serverServices.UnitManager
	local PlayerService = _G.serverServices.PlayerService
	local autoSell = PlayerProfileClass:GetField("Settings").AutoSell
	local inventory = PlayerProfileClass:GetField("Inventory")

	local set_Amount = if summonType == "Summon1" or summonType == "Summon1Mythical" then 1 else 10

	if #inventory.Units + set_Amount > inventory.MaxUnitStorage then
		return
	end

	local statistics = PlayerProfileClass:GetField("PlayerStatistics")

	local function statUpdate(unit)
		if unitRegistry[unit].configuration.Rarity == "Secret" then
			PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedSecrets", statistics.SummonedSecrets + 1, false)
		end
		if unitRegistry[unit].configuration.Rarity == "Mythical" then
			PlayerProfileClass:WriteDirectory(
				"PlayerStatistics/SummonedMythicals",
				statistics.SummonedMythicals + 1,
				false
			)
		end
	end

	if summonType == "Summon1" then
		if gems < 50 then
			return
		end
		local mythicPity = module:Pity(player, "MythicalPity", 1) and "Mythical" or nil
		local legendaryPity = module:Pity(player, "LegendaryPity", 1) and "Legendary" or nil
		local secretPity = module:Pity(player, "SecretPity", 1) and "Secret" or nil

		if mythicPity and secretPity then
			mythicPity = nil
			module:SetPity(player, "MythicalPity", 400)
		end

		if mythicPity and legendaryPity then
			legendaryPity = nil
			module:SetPity(player, "LegendaryPity", 50)
		end
		local unit
		if mythicPity then
			unit = typeof(currentBanner["Mythical"]) == "table"
					and currentBanner["Mythical"][math.random(1, #currentBanner["Mythical"])]
				or currentBanner["Mythical"]
		elseif legendaryPity then
			unit = typeof(currentBanner["Legendary"]) == "table"
					and currentBanner["Legendary"][math.random(1, #currentBanner["Legendary"])]
				or currentBanner["Legendary"]
		elseif secretPity then
			unit = typeof(currentBanner["Secret"]) == "table"
					and currentBanner["Secret"][math.random(1, #currentBanner["Secret"])]
				or currentBanner["Secret"]
		else
			local random = GetRandomRarity()
			unit = typeof(currentBanner[random]) == "table"
					and currentBanner[random][math.random(1, #currentBanner[random])]
				or currentBanner[random]
			local _reg = unitRegistry[unit]

			if _reg.configuration.Rarity == "Mythical" then
				module:SetPity(player, "MythicalPity", 0)
			end
			if _reg.configuration.Rarity == "Legendary" then
				module:SetPity(player, "LegendaryPity", 0)
			end
			if _reg.configuration.Rarity == "Secret" then
				module:SetPity(player, "SecretPity", 0)
			end
		end
		statUpdate(unit)

		local unitName = unit

		local IsShiny
		if plrLevel >= 10 or products["1932432116"] then
			--- Shiny roll placeholder
			local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
			local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player) * 10
			IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
			if IsShiny then
				PlayerProfileClass:WriteDirectory(
					"PlayerStatistics/SummonedShinies",
					statistics.SummonedShinies + 1,
					true
				)
			end
		end

		trackEngagement(player, "Summon1")

		if not IsShiny and table.find(autoSell, unitRegistry[unit].configuration.Rarity) then
			local EventSummonable = unitRegistry[unit].raw:FindFirstChild("EventSummonable")
			EventSummonable = EventSummonable and EventSummonable.Value

			local cost = gameFunctions:CalculateSellCost(unitRegistry[unit].configuration.Rarity, 1, EventSummonable)

			PlayerService:GiveCurrency(player, "Gold", cost, true)
		else
			local _UnitAdditionalData = IsShiny and { Shiny = true } or nil
			local v = unit
			unit = unitManager:giveUnit(player, unit, 1, _UnitAdditionalData, true)
			unit = unit[1]
			module:Chat(player, v, IsShiny)
		end

		PlayerProfileClass:ReplicateField("SummoningData")

		PlayerService:GiveCurrency(player, "Gems", -50)

		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 1, true)
		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 1)
		_G.serverServices.BingoService:AddProgress(player, "Summon", 1)

		local _reg = unitRegistry[unitName]
		if
			_reg.configuration.Rarity == "Secret"
			or _reg.configuration.Rarity == "Mythical"
			or _reg.configuration.Rarity == "Exclusive"
		then
			DataAPI:SaveProfile(player)
		end
		if _reg.configuration.Rarity == "Mythical" then
			_G.serverServices.BingoService:AddProgress(player, "MythicalSummons", 1)
		end

		uiCommunication:FireClient(player, "Summon/UnitSummoned", summonType, { unit })
		return unit
	elseif summonType == "Summon10" then
		local summonCost = gameFunctions:HasVIP(PlayerProfileClass) and 400 or 500
		if gems < summonCost then
			return
		end

		local mythicPity = module:Pity(player, "MythicalPity", 10) and "Mythical" or nil
		local secretPity = module:Pity(player, "SecretPity", 10) and "Secret" or nil

		trackEngagement(player, "Summon10")

		local legendaryPity = module:Pity(player, "LegendaryPity", 10) and "Legendary" or nil
		local units = {}
		local rollUnits = 10
		local _gold = 0
		if mythicPity then
			local unit = typeof(currentBanner["Mythical"]) == "table"
					and currentBanner["Mythical"][math.random(1, #currentBanner["Mythical"])]
				or currentBanner["Mythical"]

			table.insert(units, unit)
			rollUnits -= 1
		end

		if secretPity then
			local unit = typeof(currentBanner["Secret"]) == "table"
					and currentBanner["Secret"][math.random(1, #currentBanner["Secret"])]
				or currentBanner["Secret"]

			table.insert(units, unit)
			rollUnits -= 1
		end

		if legendaryPity then
			local unit = typeof(currentBanner["Legendary"]) == "table"
					and currentBanner["Legendary"][math.random(1, #currentBanner["Legendary"])]
				or currentBanner["Legendary"]

			table.insert(units, unit)
			rollUnits -= 1
		end

		for i = 1, rollUnits, 1 do
			local random = GetRandomRarity()

			local unit = typeof(currentBanner[random]) == "table"
					and currentBanner[random][math.random(1, #currentBanner[random])]
				or currentBanner[random]

			pcall(function()
				local _reg = unitRegistry[unit]

				if _reg.configuration.Rarity == "Mythical" then
					module:SetPity(player, "MythicalPity", 0)
				end

				if _reg.configuration.Rarity == "Legendary" then
					module:SetPity(player, "LegendaryPity", 0)
				end

				if _reg.configuration.Rarity == "Secret" then
					module:SetPity(player, "SecretPity", 0)
				end
			end)
			table.insert(units, unit)
		end

		local HasRareUnit = false

		local uuids = {}
		for i, v in units do
			local _reg = unitRegistry[v]
			if
				_reg.configuration.Rarity == "Secret"
				or _reg.configuration.Rarity == "Mythical"
				or _reg.configuration.Rarity == "Exclusive"
			then
				HasRareUnit = true
			end
			if _reg.configuration.Rarity == "Mythical" then
				_G.serverServices.BingoService:AddProgress(player, "MythicalSummons", 1)
			end
			local IsShiny
			if plrLevel >= 10 or products["1932432116"] then
				local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
				local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player) * 10
				IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
				if IsShiny then
					PlayerProfileClass:WriteDirectory(
						"PlayerStatistics/SummonedShinies",
						statistics.SummonedShinies + 1,
						true
					)
				end
			end

			if not IsShiny and table.find(autoSell, unitRegistry[v].configuration.Rarity) then
				local EventSummonable = unitRegistry[v].raw:FindFirstChild("EventSummonable")
				EventSummonable = EventSummonable and EventSummonable.Value

				local cost = gameFunctions:CalculateSellCost(unitRegistry[v].configuration.Rarity, 1, EventSummonable)
				_gold += cost
				table.insert(uuids, v)
				continue
			end

			local _UnitAdditionalData = IsShiny and { Shiny = true } or nil

			local uuid = unitManager:giveUnit(player, v, 1, _UnitAdditionalData, true)
			table.insert(uuids, uuid[1])

			module:Chat(player, v, IsShiny)

			statUpdate(v)
		end

		if _gold > 0 then
			PlayerService:GiveCurrency(player, "Gold", _gold, true)
		end
		PlayerProfileClass:ReplicateField("SummoningData")
		PlayerService:GiveCurrency(player, "Gems", -summonCost)

		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 10)
		_G.serverServices.BingoService:AddProgress(player, "Summon", 10)

		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 10, true)

		if HasRareUnit then
			DataAPI:SaveProfile(player)
		end

		uiCommunication:FireClient(player, "Summon/UnitSummoned", summonType, uuids)
	elseif summonType == "Summon1Mythical" then
		if gems < 50 then
			return
		end
		local featuredMythicPity = module:Pity(player, "FeaturedMythicalPity", 1) and "FeaturedMythical" or nil
		local secretPity = module:Pity(player, "SecretPity", 10) and "Secret" or nil

		if featuredMythicPity and secretPity then
			featuredMythicPity = nil
			module:SetPity(player, "FeaturedMythicalPity", 400)
		end

		trackEngagement(player, "Summon1Mythical")

		local unit
		if featuredMythicPity then
			unit = typeof(mythical_Banner["Mythical"]) == "table"
					and mythical_Banner["Mythical"][math.random(1, #mythical_Banner["Mythical"])]
				or mythical_Banner["Mythical"]
		elseif secretPity then
			unit = typeof(mythical_Banner["Secret"]) == "table"
					and mythical_Banner["Secret"][math.random(1, #mythical_Banner["Secret"])]
				or mythical_Banner["Secret"]
		else
			local random = GetRandomRarity()
			unit = typeof(mythical_Banner[random]) == "table"
					and mythical_Banner[random][math.random(1, #mythical_Banner[random])]
				or mythical_Banner[random]
			local _reg = unitRegistry[unit]

			if _reg.configuration.Rarity == "Mythical" then
				module:SetPity(player, "FeaturedMythicalPity", 0)
			end
			if _reg.configuration.Rarity == "Secret" then
				module:SetPity(player, "SecretPity", 0)
			end
		end
		statUpdate(unit)

		local unitName = unit

		local IsShiny
		if plrLevel >= 10 or products["1932432116"] then
			--- Shiny roll placeholder
			local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
			local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player) * 10
			IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
			if IsShiny then
				PlayerProfileClass:WriteDirectory(
					"PlayerStatistics/SummonedShinies",
					statistics.SummonedShinies + 1,
					true
				)
			end
		end

		if not IsShiny and table.find(autoSell, unitRegistry[unit].configuration.Rarity) then
			local EventSummonable = unitRegistry[unit].raw:FindFirstChild("EventSummonable")
			EventSummonable = EventSummonable and EventSummonable.Value

			local cost = gameFunctions:CalculateSellCost(unitRegistry[unit].configuration.Rarity, 1, EventSummonable)

			PlayerService:GiveCurrency(player, "Gold", cost, true)
		else
			local _UnitAdditionalData = IsShiny and { Shiny = true } or nil
			local v = unit
			unit = unitManager:giveUnit(player, unit, 1, _UnitAdditionalData, true)
			unit = unit[1]
			module:Chat(player, v, IsShiny)
		end

		PlayerProfileClass:ReplicateField("SummoningData")

		PlayerService:GiveCurrency(player, "Gems", -50)

		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 1, true)
		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 1)
		_G.serverServices.BingoService:AddProgress(player, "Summon", 1)

		local _reg = unitRegistry[unitName]
		if
			_reg.configuration.Rarity == "Secret"
			or _reg.configuration.Rarity == "Mythical"
			or _reg.configuration.Rarity == "Exclusive"
		then
			DataAPI:SaveProfile(player)
		end
		if _reg.configuration.Rarity == "Mythical" then
			_G.serverServices.BingoService:AddProgress(player, "MythicalSummons", 1)
		end

		uiCommunication:FireClient(player, "Summon/UnitSummoned", summonType, { unit })
		return unit
	elseif summonType == "Summon10Mythical" then
		local summonCost = gameFunctions:HasVIP(PlayerProfileClass) and 400 or 500
		if gems < summonCost then
			return
		end

		trackEngagement(player, "Summon10Mythical")

		local featuredMythicPity = module:Pity(player, "FeaturedMythicalPity", 10) and "FeaturedMythical" or nil
		local secretPity = module:Pity(player, "SecretPity", 10) and "Secret" or nil

		local units = {}
		local rollUnits = 10
		local _gold = 0

		if featuredMythicPity then
			local unit = typeof(mythical_Banner["Mythical"]) == "table"
					and mythical_Banner["Mythical"][math.random(1, #mythical_Banner["Mythical"])]
				or mythical_Banner["Mythical"]

			table.insert(units, unit)
			rollUnits -= 1
		end

		if secretPity then
			local unit = typeof(mythical_Banner["Secret"]) == "table"
					and mythical_Banner["Secret"][math.random(1, #mythical_Banner["Secret"])]
				or mythical_Banner["Secret"]

			table.insert(units, unit)
			rollUnits -= 1
		end
		for i = 1, rollUnits, 1 do
			local random = GetRandomRarity()

			local unit = typeof(mythical_Banner[random]) == "table"
					and mythical_Banner[random][math.random(1, #mythical_Banner[random])]
				or mythical_Banner[random]

			pcall(function()
				local _reg = unitRegistry[unit]

				if _reg.configuration.Rarity == "Mythical" then
					module:SetPity(player, "FeaturedMythicalPity", 0)
				end

				if _reg.configuration.Rarity == "Secret" then
					module:SetPity(player, "SecretPity", 0)
				end
			end)
			table.insert(units, unit)
		end

		local HasRareUnit = false

		local uuids = {}
		for i, v in units do
			local _reg = unitRegistry[v]
			if
				_reg.configuration.Rarity == "Secret"
				or _reg.configuration.Rarity == "Mythical"
				or _reg.configuration.Rarity == "Exclusive"
			then
				HasRareUnit = true
			end
			if _reg.configuration.Rarity == "Mythical" then
				_G.serverServices.BingoService:AddProgress(player, "MythicalSummons", 1)
			end
			local IsShiny
			if plrLevel >= 10 or products["1932432116"] then
				local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
				local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player) * 10
				IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
				if IsShiny then
					PlayerProfileClass:WriteDirectory(
						"PlayerStatistics/SummonedShinies",
						statistics.SummonedShinies + 1,
						true
					)
				end
			end

			if not IsShiny and table.find(autoSell, unitRegistry[v].configuration.Rarity) then
				local EventSummonable = unitRegistry[v].raw:FindFirstChild("EventSummonable")
				EventSummonable = EventSummonable and EventSummonable.Value

				local cost = gameFunctions:CalculateSellCost(unitRegistry[v].configuration.Rarity, 1, EventSummonable)
				_gold += cost
				table.insert(uuids, v)
				continue
			end

			local _UnitAdditionalData = IsShiny and { Shiny = true } or nil

			local uuid = unitManager:giveUnit(player, v, 1, _UnitAdditionalData, true)
			table.insert(uuids, uuid[1])

			module:Chat(player, v, IsShiny)

			statUpdate(v)
		end

		if _gold > 0 then
			PlayerService:GiveCurrency(player, "Gold", _gold, true)
		end
		PlayerProfileClass:ReplicateField("SummoningData")
		PlayerService:GiveCurrency(player, "Gems", -summonCost)

		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 10)
		_G.serverServices.BingoService:AddProgress(player, "Summon", 10)

		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 10, true)

		if HasRareUnit then
			DataAPI:SaveProfile(player)
		end

		uiCommunication:FireClient(player, "Summon/UnitSummoned", summonType, uuids)
	end
end
--// Initializing all the existing summoning functions upon request by client
function module:InitializeSummonCommunication()
	summonEvent.OnServerEvent:Connect(function(player, summonType)
		if workspace:GetAttribute("BannerErrored") then
			return
		end
		self:Summon(player, summonType)
	end)

	summonFunction.OnServerInvoke = function(player, identifier, ...)
		if workspace:GetAttribute("BannerErrored") then
			return
		end
		return summonFunctionCalls[identifier](summonFunctionCalls, player, ...)
	end
end

function module:start()
	self:InitializeSummonCommunication()
	self:InitiailizeBanner()

	return "Loaded"
end

return module
