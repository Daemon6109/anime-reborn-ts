--[[
	SummonService
	
	Handles unit summoning with banner management, pity systems, and shiny mechanics.
	
	@class SummonService
	@server
]]

local AnalyticsService = game:GetService("AnalyticsService")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Dependencies
local Network = require("@network/server")
local Person = require("@commonserver/person")
local Signal = require("@pkgs/shingo")

-- Types
export type SummonType = "Summon1" | "Summon10" | "Summon1Mythical" | "Summon10Mythical"
export type PityType = "LegendaryPity" | "MythicalPity" | "SecretPity" | "FeaturedMythicalPity"
export type BannerType = "Standard" | "Mythical"
export type Rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythical" | "Secret" | "Exclusive"

export type BannerData = {
	Secret: { string }?,
	Mythical: { string } | string?,
	Legendary: { string } | string?,
	Epic: { string },
	Rare: { string },
}

export type SummonResult = {
	unit: string,
	uuid: string?,
	isShiny: boolean,
	wasSold: boolean,
	goldEarned: number?,
}

export type SummonResponse = {
	success: boolean,
	results: { SummonResult }?,
	error: string?,
}

--- @class SummonService
local SummonService = {}
SummonService.__index = SummonService

-- Constants
local BANNER_UPDATE_SECONDS = 3600
local SHINY_BASE_CHANCE = 0.01
local SUMMON_COSTS = {
	single = 50,
	multi = 500,
	multiVIP = 400,
}

local PITY_LIMITS = {
	LegendaryPity = 50,
	MythicalPity = 400,
	SecretPity = 15000,
	FeaturedMythicalPity = 400,
}

local BANNER_RARITIES = {
	Standard = {
		Secret = 1,
		Mythical = 1,
		Legendary = 2,
		Epic = 1,
		Rare = 2,
	},
	Mythical = {
		Secret = 1,
		Mythical = 3,
		Legendary = 2,
		Epic = 1,
		Rare = 2,
	},
}

-- Registry references
local unitRegistry = _G.Registry.registry.Units
local DataAccess = require(ServerScriptService.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local bannerPool = require(ReplicatedStorage.Registry.BannerPool)
local gameFunctions = require(ReplicatedStorage.Libs.GameFunctions)
local syncedTime = require(ReplicatedStorage.Libs.SyncedTime)

-- Data stores
local ForcedBanners = DataStoreService:GetDataStore("ForcedBanners")

--- Creates a new SummonService instance
--- @return SummonService
function SummonService.new()
	local self = setmetatable({}, SummonService)

	-- Version tracking
	self.version = { major = 1, minor = 0, patch = 0 }

	-- Banner state
	self.currentBanner = {
		Secret = nil,
		Mythical = nil,
		Legendary = nil,
		Epic = nil,
		Rare = nil,
	}

	self.mythicalBanner = {
		Secret = nil,
		Mythical = 3,
		Epic = nil,
		Rare = nil,
	}

	self.currentSeed = 0
	self.bannerUpdateTime = 0

	-- Events
	self.unitSummoned = Signal.new()
	self.bannerUpdated = Signal.new()
	self.pityActivated = Signal.new()
	self.shinyObtained = Signal.new()

	-- Network setup
	self._network = Network.new("SummonService")
	self:_setupNetwork()

	-- Services
	self._unitManager = nil
	self._playerService = nil
	self._questService = nil
	self._bingoService = nil
	self._titleService = nil
	self._messagingHandler = nil
	self._effectService = nil

	return self
end

--- Initializes the service dependencies
--- @private
function SummonService:_initializeDependencies()
	-- Wait for services to be available
	repeat
		task.wait(0.1)
		self._unitManager = _G.serverServices.UnitManager
		self._playerService = _G.serverServices.PlayerService
		self._questService = _G.serverServices.QuestHandler
		self._bingoService = _G.serverServices.BingoService
		self._titleService = _G.serverServices.TitleService
		self._messagingHandler = _G.serverServices.MessagingHandler
		self._effectService = _G.serverServices.EffectService
	until self._unitManager
		and self._playerService
		and self._questService
		and self._bingoService
		and self._titleService
		and self._messagingHandler
		and self._effectService
end

--- Sets up network endpoints
--- @private
function SummonService:_setupNetwork()
	-- Summon endpoints
	self._network:event("summon", function(person: Person.Person, summonType: SummonType)
		if workspace:GetAttribute("BannerErrored") then
			return
		end
		return self:summon(person, summonType)
	end)

	-- Banner request endpoint
	self._network:func("getBanner", function(person: Person.Person, bannerType: string?)
		return self:getCurrentBanner(bannerType)
	end)

	-- Auto-sell toggle endpoints
	self._network:func("toggleAutoSell", function(person: Person.Person, rarity: Rarity)
		return self:toggleAutoSell(person, rarity)
	end)

	self._network:func("toggleDragonCapsuleAutoSell", function(person: Person.Person, rarity: Rarity)
		return self:toggleDragonCapsuleAutoSell(person, rarity)
	end)
end

--- Clones a table recursively
--- @param original table
--- @return table
function SummonService:_cloneTable(original: { [any]: any }): { [any]: any }
	local copy = {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = self:_cloneTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

--- Gets current banner data
--- @param bannerType string? -- "get_Mythical" for mythical banner, nil for standard
--- @return BannerData
function SummonService:getCurrentBanner(bannerType: string?): BannerData
	if bannerType == "get_Mythical" then
		-- Add all mythical units to banner
		local banner = self:_cloneTable(self.mythicalBanner)
		banner.Mythical_2 = {}

		for unitName, unitData in pairs(unitRegistry) do
			local config = unitData.configuration
			local raw = unitData.raw

			if
				config.Rarity == "Mythical"
				and raw:FindFirstChild("Released")
				and raw:FindFirstChild("Summonable")
				and raw.Summonable.Value == true
				and raw.Released.Value == true
			then
				table.insert(banner.Mythical_2, unitName)
			end
		end

		banner.Secret = nil
		return banner
	else
		local banner = self:_cloneTable(self.currentBanner)
		banner.Secret = nil
		return banner
	end
end

--- Toggles auto-sell for a rarity
--- @param person Person.Person
--- @param rarity Rarity
--- @return boolean? -- New state, nil if invalid rarity
--- @error "Invalid rarity for auto-sell"
function SummonService:toggleAutoSell(person: Person.Person, rarity: Rarity): boolean?
	local sellableRarities = { "Epic", "Legendary", "Mythical", "Rare" }
	if not table.find(sellableRarities, rarity) then
		return nil
	end

	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local settings = PlayerProfileClass:GetField("Settings")
	local autoSell = settings.AutoSell or {}

	local found = table.find(autoSell, rarity)
	if found then
		table.remove(autoSell, found)
		settings.AutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)
		return false
	else
		table.insert(autoSell, rarity)
		settings.AutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)
		return true
	end
end

--- Toggles dragon capsule auto-sell for a rarity
--- @param person Person.Person
--- @param rarity Rarity
--- @return boolean? -- New state, nil if invalid rarity
--- @error "Invalid rarity for dragon capsule auto-sell"
function SummonService:toggleDragonCapsuleAutoSell(person: Person.Person, rarity: Rarity): boolean?
	local sellableRarities = { "Epic", "Legendary", "Mythical", "Rare" }
	if not table.find(sellableRarities, rarity) then
		return nil
	end

	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local settings = PlayerProfileClass:GetField("Settings")
	local autoSell = settings.DragonCapsuleAutoSell or {}

	local found = table.find(autoSell, rarity)
	if found then
		table.remove(autoSell, found)
		settings.DragonCapsuleAutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/DragonCapsuleAutoSell", autoSell, true)
		return false
	else
		table.insert(autoSell, rarity)
		settings.DragonCapsuleAutoSell = autoSell
		PlayerProfileClass:WriteDirectory("Settings/DragonCapsuleAutoSell", autoSell, true)
		return true
	end
end

--- Calculates shiny chance for a player
--- @param person Person.Person
--- @param useChance number? -- Override base chance
--- @return number -- Shiny chance percentage
function SummonService:calculateShinyChance(person: Person.Person, useChance: number?): number
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local productData = PlayerProfileClass:GetField("ProductsBought")

	local shinyBoost = self._effectService:CalculateMultiplier(player, "ShinyBoost")

	-- VIP gamepass bonus
	if productData["1932432116"] then
		shinyBoost += 1
	end

	return (useChance or SHINY_BASE_CHANCE) * shinyBoost
end

--- Updates pity counter and checks if pity is activated
--- @param person Person.Person
--- @param pityType PityType
--- @param addPity number
--- @return boolean -- Whether pity was activated
function SummonService:updatePity(person: Person.Person, pityType: PityType, addPity: number): boolean
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local summoningData = PlayerProfileClass:GetField("SummoningData")

	local totalPity = summoningData[pityType] + addPity
	local maxPity = PITY_LIMITS[pityType]

	-- Reset secret pity on banner change
	if pityType == "SecretPity" then
		local currentSeed = math.floor(syncedTime.time() / BANNER_UPDATE_SECONDS)
		if summoningData.LastBannerSeed ~= currentSeed then
			totalPity = 0
			addPity = -summoningData[pityType]
			summoningData.LastBannerSeed = currentSeed
		end
	end

	if totalPity > maxPity then
		summoningData[pityType] = math.abs((totalPity - maxPity) - 1)
		PlayerProfileClass:WriteField("SummoningData", summoningData, false)

		self.pityActivated:fire(person, pityType, maxPity)
		return true
	else
		summoningData[pityType] += addPity
		PlayerProfileClass:WriteField("SummoningData", summoningData, false)
		return false
	end
end

--- Sets pity counter to a specific value
--- @param person Person.Person
--- @param pityType PityType
--- @param pity number
function SummonService:setPity(person: Person.Person, pityType: PityType, pity: number)
	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local summoningData = PlayerProfileClass:GetField("SummoningData")

	summoningData[pityType] = pity
	PlayerProfileClass:WriteField("SummoningData", summoningData, false)
end

--- Gets banner percentages for a rarity
--- @param person Person.Person
--- @param rarity Rarity
--- @return number -- Percentage chance
function SummonService:getBannerPercentages(person: Person.Person, rarity: Rarity): number
	local player = person:getPlayer()
	local luck = self._effectService:CalculateMultiplier(player, "BannerLuck")
	local summonChances = gameFunctions.SummonChances

	if table.find({ "Mythical", "Legendary", "Secret" }, rarity) then
		return summonChances[rarity] * luck
	end

	return summonChances[rarity]
end

--- Selects a random rarity based on weighted chances
--- @param person Person.Person
--- @param exclude {Rarity}? -- Rarities to exclude
--- @return Rarity
function SummonService:_getRandomRarity(person: Person.Person, exclude: { Rarity }?): Rarity
	if not exclude then
		exclude = {}
	end

	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local plrLevel = PlayerProfileClass:GetField("Level")

	-- Exclude Secret for low-level players
	if plrLevel < 15 then
		table.insert(exclude, "Secret")
	end

	local weight = 0
	local summonChances = gameFunctions.SummonChances

	for rarity, _ in pairs(summonChances) do
		if not table.find(exclude, rarity) then
			weight += self:getBannerPercentages(person, rarity) * 100000
		end
	end

	local chosen = Random.new():NextNumber(1, weight)

	for rarity, _ in pairs(summonChances) do
		if not table.find(exclude, rarity) then
			weight -= self:getBannerPercentages(person, rarity) * 100000
		end
		if chosen > weight then
			return rarity
		end
	end

	return "Rare" -- Fallback
end

--- Announces rare summons to global chat
--- @param person Person.Person
--- @param unitName string
--- @param isShiny boolean
function SummonService:_announceRareSummon(person: Person.Person, unitName: string, isShiny: boolean)
	local player = person:getPlayer()
	local unitData = unitRegistry[unitName]
	local rarity = unitData.configuration.Rarity
	local gohanLimitUpdater = _G.serverServices.GohanLimitUpdater

	local concatenate = ""
	if unitName == "Gohan" then
		local remaining = (gohanLimitUpdater:GetLimit() - gohanLimitUpdater:GetObtainedAmount()) - 1
		concatenate = `! {remaining} remain to be obtained from the capsule!`
	end

	-- Only announce for rare summons
	if rarity == "Secret" or (rarity == "Mythical" and isShiny) or rarity == "Exclusive" then
		if unitName == "Gamma Brothers" and not isShiny then
			return
		end

		local message = `{player.DisplayName} (@{player.Name}) has obtained a {isShiny and "Shiny " or ""}{rarity} {unitData.configuration.DisplayName}`
			.. concatenate

		local success, encodedString = pcall(function()
			return HttpService:JSONEncode(message)
		end)

		if success and encodedString then
			pcall(function()
				self._messagingHandler:PublishAsync("Chat", encodedString)
			end)
		end

		-- Award special titles
		pcall(function()
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
			local inventory = PlayerProfileClass:GetField("Inventory")
			local titles = inventory and inventory.Titles

			if not titles then
				return
			end

			if unitName == "Rimuru" and not table.find(titles, "Rimuru") then
				self._titleService:GiveTitle(player, "Rimuru")
			elseif unitName == "Gohan" and not table.find(titles, "Beast Hunter") then
				self._titleService:GiveTitle(player, "Beast Hunter")
			end
		end)
	end
end

--- Processes a single unit summon result
--- @param person Person.Person
--- @param unitName string
--- @param isShiny boolean
--- @param autoSell {string}
--- @return SummonResult
function SummonService:_processSummonResult(
	person: Person.Person,
	unitName: string,
	isShiny: boolean,
	autoSell: { string }
): SummonResult
	local player = person:getPlayer()
	local unitData = unitRegistry[unitName]
	local rarity = unitData.configuration.Rarity

	local result: SummonResult = {
		unit = unitName,
		uuid = nil,
		isShiny = isShiny,
		wasSold = false,
		goldEarned = 0,
	}

	-- Check for auto-sell
	if not isShiny and table.find(autoSell, rarity) then
		local eventSummonable = unitData.raw:FindFirstChild("EventSummonable")
		eventSummonable = eventSummonable and eventSummonable.Value

		local cost = gameFunctions:CalculateSellCost(rarity, 1, eventSummonable)
		result.wasSold = true
		result.goldEarned = cost
		result.unit = unitName
	else
		-- Give unit to player
		local unitAdditionalData = isShiny and { Shiny = true } or nil
		local uuid = self._unitManager:giveUnit(player, unitName, 1, unitAdditionalData, true)
		result.uuid = uuid[1]

		-- Announce rare summons
		self:_announceRareSummon(person, unitName, isShiny)
	end

	-- Update statistics
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local statistics = PlayerProfileClass:GetField("PlayerStatistics")

	if rarity == "Secret" then
		PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedSecrets", statistics.SummonedSecrets + 1, false)
	elseif rarity == "Mythical" then
		PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedMythicals", statistics.SummonedMythicals + 1, false)
	end

	if isShiny then
		PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedShinies", statistics.SummonedShinies + 1, true)
		self.shinyObtained:fire(person, unitName, rarity)
	end

	return result
end

--- Executes a summon operation
--- @param person Person.Person
--- @param summonType SummonType
--- @return SummonResponse
function SummonService:summon(person: Person.Person, summonType: SummonType): SummonResponse
	if not self._unitManager then
		return { success = false, error = "Service not initialized" }
	end

	local player = person:getPlayer()
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
	local plrLevel = PlayerProfileClass:GetField("Level")
	local currencies = PlayerProfileClass:GetField("Currencies")
	local inventory = PlayerProfileClass:GetField("Inventory")
	local autoSell = PlayerProfileClass:GetField("Settings").AutoSell or {}
	local statistics = PlayerProfileClass:GetField("PlayerStatistics")

	local isMulti = string.find(summonType, "10") ~= nil
	local isMythical = string.find(summonType, "Mythical") ~= nil
	local amount = isMulti and 10 or 1

	-- Check inventory space
	if #inventory.Units + amount > inventory.MaxUnitStorage then
		return { success = false, error = "Insufficient inventory space" }
	end

	-- Check costs
	local cost = SUMMON_COSTS.single
	if isMulti then
		local hasVIP = gameFunctions:HasVIP(PlayerProfileClass)
		cost = hasVIP and SUMMON_COSTS.multiVIP or SUMMON_COSTS.multi
	end

	if currencies.Gems < cost then
		return { success = false, error = "Insufficient gems" }
	end

	-- Track engagement
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. summonType)

	local results: { SummonResult } = {}
	local totalGoldEarned = 0
	local hasRareUnit = false

	-- Determine banner to use
	local banner = isMythical and self.mythicalBanner or self.currentBanner
	local pityType = isMythical and "FeaturedMythicalPity" or "MythicalPity"

	-- Check pity activations
	local pityActivations = {}

	if not isMythical then
		if self:updatePity(person, "MythicalPity", amount) then
			table.insert(pityActivations, "Mythical")
		end
		if self:updatePity(person, "LegendaryPity", amount) then
			table.insert(pityActivations, "Legendary")
		end
	else
		if self:updatePity(person, "FeaturedMythicalPity", amount) then
			table.insert(pityActivations, "FeaturedMythical")
		end
	end

	if self:updatePity(person, "SecretPity", amount) then
		table.insert(pityActivations, "Secret")
	end

	-- Handle pity conflicts (secret takes priority)
	if table.find(pityActivations, "Secret") and table.find(pityActivations, "Mythical") then
		table.remove(pityActivations, table.find(pityActivations, "Mythical"))
		self:setPity(person, "MythicalPity", PITY_LIMITS.MythicalPity)
	elseif table.find(pityActivations, "Secret") and table.find(pityActivations, "FeaturedMythical") then
		table.remove(pityActivations, table.find(pityActivations, "FeaturedMythical"))
		self:setPity(person, "FeaturedMythicalPity", PITY_LIMITS.FeaturedMythicalPity)
	end

	if table.find(pityActivations, "Mythical") and table.find(pityActivations, "Legendary") then
		table.remove(pityActivations, table.find(pityActivations, "Legendary"))
		self:setPity(person, "LegendaryPity", PITY_LIMITS.LegendaryPity)
	elseif table.find(pityActivations, "FeaturedMythical") and table.find(pityActivations, "Legendary") then
		table.remove(pityActivations, table.find(pityActivations, "Legendary"))
		self:setPity(person, "LegendaryPity", PITY_LIMITS.LegendaryPity)
	end

	local rollCount = amount

	-- Process pity units first
	for _, pityRarity in ipairs(pityActivations) do
		local rarity = string.gsub(pityRarity, "Featured", "")
		local unitPool = banner[rarity]

		if unitPool then
			local unitName = typeof(unitPool) == "table" and unitPool[math.random(1, #unitPool)] or unitPool

			-- Calculate shiny chance
			local isShiny = false
			if plrLevel >= 10 or PlayerProfileClass:GetField("ProductsBought")["1932432116"] then
				local shinyChance = self:calculateShinyChance(person) * 10
				isShiny = Random.new():NextInteger(1, 1000) <= shinyChance
			end

			local result = self:_processSummonResult(person, unitName, isShiny, autoSell)
			table.insert(results, result)

			if result.wasSold then
				totalGoldEarned += result.goldEarned or 0
			end

			local unitRarity = unitRegistry[unitName].configuration.Rarity
			if unitRarity == "Secret" or unitRarity == "Mythical" or unitRarity == "Exclusive" then
				hasRareUnit = true
			end

			rollCount -= 1
		end
	end

	-- Process remaining rolls
	for i = 1, rollCount do
		local rarity = self:_getRandomRarity(person)
		local unitPool = banner[rarity]

		if unitPool then
			local unitName = typeof(unitPool) == "table" and unitPool[math.random(1, #unitPool)] or unitPool

			-- Reset pity on natural rare summon
			local unitRarity = unitRegistry[unitName].configuration.Rarity
			if unitRarity == "Mythical" then
				if isMythical then
					self:setPity(person, "FeaturedMythicalPity", 0)
				else
					self:setPity(person, "MythicalPity", 0)
				end
			elseif unitRarity == "Legendary" then
				self:setPity(person, "LegendaryPity", 0)
			elseif unitRarity == "Secret" then
				self:setPity(person, "SecretPity", 0)
			end

			-- Calculate shiny chance
			local isShiny = false
			if plrLevel >= 10 or PlayerProfileClass:GetField("ProductsBought")["1932432116"] then
				local shinyChance = self:calculateShinyChance(person) * 10
				isShiny = Random.new():NextInteger(1, 1000) <= shinyChance
			end

			local result = self:_processSummonResult(person, unitName, isShiny, autoSell)
			table.insert(results, result)

			if result.wasSold then
				totalGoldEarned += result.goldEarned or 0
			end

			if unitRarity == "Secret" or unitRarity == "Mythical" or unitRarity == "Exclusive" then
				hasRareUnit = true
			end

			if unitRarity == "Mythical" then
				self._bingoService:AddProgress(player, "MythicalSummons", 1)
			end
		end
	end

	-- Give gold from auto-sold units
	if totalGoldEarned > 0 then
		self._playerService:GiveCurrency(player, "Gold", totalGoldEarned, true)
	end

	-- Deduct gems
	self._playerService:GiveCurrency(player, "Gems", -cost)

	-- Update statistics and quests
	PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + amount, true)
	self._questService:GivePointsByPointType(player, "Summons", amount)
	self._bingoService:AddProgress(player, "Summon", amount)

	-- Replicate summoning data
	PlayerProfileClass:ReplicateField("SummoningData")

	-- Save profile if rare unit obtained
	if hasRareUnit then
		DataAPI:SaveProfile(player)
	end

	-- Fire event
	self.unitSummoned:fire(person, summonType, results)

	return { success = true, results = results }
end

--- Updates banner data based on current time
--- @private
function SummonService:_updateBanner()
	local currentSeed = math.floor(syncedTime.time() / BANNER_UPDATE_SECONDS)

	if self.currentSeed == currentSeed then
		return -- No update needed
	end

	self.currentSeed = currentSeed

	-- Get banner data from pool
	local standardData = self:_cloneTable(bannerPool:ReturnPool("Standard"))
	local mythicalData = self:_cloneTable(bannerPool:ReturnPool("Mythical"))

	-- Check for forced banners
	local success, forcedBanner = pcall(function()
		return ForcedBanners:GetAsync("BannerList")
	end)

	if not success then
		workspace:SetAttribute("BannerErrored", "Banner could not be loaded. Please wait.")
		-- Handle banner loading failure...
		return
	end

	workspace:SetAttribute("BannerErrored", nil)

	-- Apply forced banner overrides
	if forcedBanner and forcedBanner[tostring(currentSeed)] then
		local forced = forcedBanner[tostring(currentSeed)]
		if forced.Mythical then
			standardData.Mythical = forced.Mythical
		end
		if forced.Legendary then
			standardData.Legendary = forced.Legendary
		end
	end

	-- Generate standard banner
	local rng = Random.new(currentSeed)
	local rarities = { "Secret", "Mythical", "Legendary" }

	for _, rarity in ipairs(rarities) do
		local pool = standardData[rarity]
		if not pool then
			continue
		end

		local count = BANNER_RARITIES.Standard[rarity]
		if count <= 1 then
			self.currentBanner[rarity] = pool[rng:NextInteger(1, #pool)]
		else
			self.currentBanner[rarity] = {}
			local clonedData = self:_cloneTable(standardData)
			for n = 1, count do
				local unitIndex = rng:NextInteger(1, #clonedData[rarity])
				table.insert(self.currentBanner[rarity], clonedData[rarity][unitIndex])
				table.remove(clonedData[rarity], unitIndex)
			end
		end
	end

	self.currentBanner.Rare = self:_cloneTable(standardData.Rare)
	self.currentBanner.Epic = self:_cloneTable(standardData.Epic)

	-- Generate mythical banner
	for _, rarity in ipairs(rarities) do
		local pool = mythicalData[rarity]
		if not pool then
			continue
		end

		local count = BANNER_RARITIES.Mythical[rarity]
		if count <= 1 then
			self.mythicalBanner[rarity] = pool[rng:NextInteger(1, #pool)]
		else
			self.mythicalBanner[rarity] = {}
			local clonedData = self:_cloneTable(mythicalData)
			for n = 1, count do
				local unitIndex = rng:NextInteger(1, #clonedData[rarity])
				table.insert(self.mythicalBanner[rarity], clonedData[rarity][unitIndex])
				table.remove(clonedData[rarity], unitIndex)
			end
		end
	end

	self.mythicalBanner.Rare = self:_cloneTable(mythicalData.Rare)
	self.mythicalBanner.Epic = self:_cloneTable(mythicalData.Epic)

	-- Notify clients of banner update
	self.bannerUpdated:fire(currentSeed)
end

--- Starts the banner update loop
--- @private
function SummonService:_startBannerLoop()
	task.spawn(function()
		while true do
			self:_updateBanner()

			-- Update banner time display
			local timeLeft = BANNER_UPDATE_SECONDS - (syncedTime.time() % BANNER_UPDATE_SECONDS)
			ReplicatedStorage.GameVariables.SummonTime.Value = tostring(math.floor(timeLeft))

			task.wait(1)
		end
	end)
end

--- Initializes the service
function SummonService:start()
	self:_initializeDependencies()
	self:_updateBanner() -- Initial banner setup
	self:_startBannerLoop()

	return "SummonService loaded"
end

return SummonService
