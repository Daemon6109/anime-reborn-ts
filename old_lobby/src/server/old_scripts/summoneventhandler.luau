local module = {}
--local summonEvent = game.ReplicatedStorage.Events.SummoningEvent.SummonEvent
--local summonFunction = game.ReplicatedStorage.Events.SummoningEvent.SummonFunction
--local uiCommunication = game.ReplicatedStorage.Events.UiCommunication
--local Chat_RE = game.ReplicatedStorage.Events.Chat
--local http = game:GetService("HttpService")
--local summonFunctionCalls = {}

--local unitRegistry = _G.Registry.registry.Units
--local runService = game:GetService("RunService")
--local MessagingService = game:GetService('MessagingService')
--local SSS = game:GetService("ServerScriptService")
--local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
--local DataAPI = DataAccess:GetAPI()

--local summonTime = game.ReplicatedStorage.GameVariables.SummonEventTime
--local gameFunctions = require(game.ReplicatedStorage.Libs.GameFunctions)
--local bannerPool = require(game.ReplicatedStorage.Registry.BannerPool)
--local effectsData = require(game.ReplicatedStorage.Registry.EffectsData)
--local syncedTime = require(game.ReplicatedStorage.Libs.SyncedTime)

--local DataStoreService = game:GetService("DataStoreService")

----// HARD CODED SUMMONING DATA
--local BannerUpdateInSeconds = 3600
--local BannerData = bannerPool:ReturnPool("Event")
--local RarityPerBanner = {
--	["Secret"] = 1,
--	["Mythical"] = 1,
--	["Legendary"] = 1,
--	["Epic"] = 1,
--	["Rare"] = 1
--}
--local SummonChances = gameFunctions.EventSummonChances

----// MUTABLES
--local currentBanner = {
--	["Secret"] = nil,
--	["Mythical"] = nil,
--	["Legendary"] = nil,
--	["Epic"] = nil,
--	["Rare"] = nil
--}

--local ShinyChance = 1 --%

----// Help functions
--function cloneTable(original)
--	local copy = {}

--	for key, value in pairs(original) do
--		if type(value) == "table" then
--			copy[key] = cloneTable(value)
--		else
--			copy[key] = value
--		end
--	end
--	return copy
--end

----=====================================================================================================
--local function GetProductData(Player)
--	local ProductData
--	local PlrProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
--	ProductData = PlrProfileClass:GetField("ProductsBought")

--	return ProductData
--end

--for _,v in game.ReplicatedStorage.Registry.Units:GetChildren() do
--	if v:IsA("ModuleScript") then
--		local unit = unitRegistry[v.Name]
--	end
--end

-----// FUNCTION CALLS
----// When player requests the banner
--function summonFunctionCalls:RequestCurrentBanner(player)
--	local bnnr = table.clone(currentBanner)
--	bnnr["Secret"] = nil
--	return bnnr
--end
--local sellableRarities = {
--	"Epic",
--	"Legendary",
--	"Mythical",
--	"Rare"
--}

--function summonFunctionCalls:ToggleAutoSell(player, rarity)
--	if not table.find(sellableRarities, rarity) then return end

--	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

--	local Settings = PlayerProfileClass:GetField("Settings")

--	local autoSell = Settings.AutoSell
--	local _found = autoSell ~= nil and table.find(autoSell, rarity)
--	if _found then
--		table.remove(autoSell, _found)
--		Settings.AutoSell = autoSell
--		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)
--		return false
--	else
--		table.insert(autoSell, rarity)
--		Settings.AutoSell = autoSell
--		PlayerProfileClass:WriteDirectory("Settings/AutoSell", autoSell, true)

--		return true
--	end
--end

--local function Length(dict : table)
--	local counter = 0
--	for _ in dict do
--		counter += 1
--	end
--	return counter
--end

----// When player summons

----=====================================================================================================

--function module:CalculateShinyChance(player, UseChance)
--	local gamepasses = GetProductData(player)
--	local shinyBoost = 1
--	if gamepasses["1932432116"] then
--		shinyBoost += 1
--	end
--	return (UseChance or  ShinyChance) * shinyBoost

--end

----// Initializing a global banner on the current server
--function module:InitiailizeBanner()
--	local s = syncedTime.time()

--	local seed = math.floor((syncedTime.time())/BannerUpdateInSeconds)

--	local function UpdateBanner(t)
--		t = t or syncedTime.time()
--		seed = math.floor(t/BannerUpdateInSeconds)
--		BannerData = cloneTable(bannerPool:ReturnPool("Event"))

--		local RNG = Random.new(seed)
--		local rarites = {
--			[1] = "Secret",
--			[2] = "Mythical",
--			[3] = "Legendary"
--		}
--		for k = 1, #rarites do
--			local i = rarites[k]
--			local v = BannerData[i]
--			if not v then continue end
--			if RarityPerBanner[i] <= 1 then
--				local unit = v[RNG:NextInteger(1,#v)]
--				currentBanner[i] = unit
--			else
--				currentBanner[i] = {}
--				local clonedData = cloneTable(BannerData)
--				for n = 1, RarityPerBanner[i], 1 do
--					local unitNo = RNG:NextInteger(1,#clonedData[i])
--					table.insert(currentBanner[i], clonedData[i][unitNo])

--					table.remove(clonedData[i], unitNo)

--				end
--			end

--		end
--		currentBanner["Rare"] = cloneTable(BannerData["Rare"])
--		currentBanner["Epic"] = cloneTable(BannerData["Epic"])

--	end
--	UpdateBanner()
--	local timeLeft = BannerUpdateInSeconds - (syncedTime.time() % BannerUpdateInSeconds)
--	summonTime.Value = tostring(timeLeft)
--	while task.wait(1) do

--		if seed < math.floor((syncedTime.time())/BannerUpdateInSeconds) then
--			UpdateBanner(syncedTime.time())
--			summonEvent:FireAllClients("BannerUpdated")
--		end
--		local timeLeft = BannerUpdateInSeconds - (syncedTime.time() % BannerUpdateInSeconds)
--		summonTime.Value = tostring(timeLeft)
--	end

--end

--function module:Pity(plr : Player, pityType : "LegendaryPity" | "MythicalPity" | "SecretPity", addPity)
--	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

--	local SummoningEventData =  PlayerProfileClass:GetField("SummoningEventData")

--	local totalPity = SummoningEventData[pityType] + addPity

--	local maxPity
--	if pityType == "LegendaryPity" then
--		maxPity = 50
--	elseif pityType == "MythicalPity" then
--		maxPity = 400
--	else
--		maxPity = 15000
--	end

--	if SummoningEventData["LastBannerSeed"] ~= math.floor((syncedTime.time())/BannerUpdateInSeconds) and pityType == "SecretPity" then
--		totalPity = 0
--		addPity = -SummoningEventData[pityType]
--		SummoningEventData["LastBannerSeed"] = math.floor((syncedTime.time())/BannerUpdateInSeconds)
--	end
--	if totalPity > maxPity then
--		SummoningEventData[pityType] = math.abs((totalPity - maxPity)-1)

--		PlayerProfileClass:WriteField("SummoningEventData", SummoningEventData, false)

--		return true
--	else
--		SummoningEventData[pityType] += addPity

--		PlayerProfileClass:WriteField("SummoningEventData", SummoningEventData, false)

--		return false
--	end
--end

--function module:SetPity(plr : Player, pityType : "LegendaryPity" | "MythicalPity" | "SecretPity", pity)
--	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)

--	local SummoningEventData =  PlayerProfileClass:GetField("SummoningEventData")

--	SummoningEventData[pityType] = pity

--	PlayerProfileClass:WriteField("SummoningEventData", SummoningEventData, false)
--end

--function module:Chat(player,v,IsShiny)
--	local Rarity = unitRegistry[v].configuration.Rarity
--	local GohanLimitUpdater = _G.serverServices.GohanLimitUpdater

--	local Concatenate;

--	if v == "Gohan" then
--		Concatenate = `! {((GohanLimitUpdater:GetLimit() - GohanLimitUpdater:GetObtainedAmount())) - 1} remain to be obtained from the capsule!`
--	end

--	--

--	if  Rarity == 'Secret' or (Rarity == 'Mythical' and IsShiny) or Rarity == 'Exclusive' then
--		if v == 'Gamma Brothers' and not IsShiny then
--			return
--		end
--		local String = `{player.DisplayName} (@{player.Name}) has obtained a {IsShiny and 'Shiny ' or ''}{Rarity} {unitRegistry[v].configuration.DisplayName}` .. (Concatenate and Concatenate or '')

--		local Success,EncodedString = pcall(function()
--			return http:JSONEncode(String)
--		end)

--		if Success and EncodedString and (Rarity == 'Exclusive' or Rarity == 'Secret' or (Rarity == 'Mythical' and IsShiny)) then
--			local Success, Error = pcall(function()

--				return _G.serverServices.MessagingHandler:PublishAsync('Chat',EncodedString)
--			end)
--		end
--		pcall(function()
--			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)

--			local Titles = PlayerProfileClass:GetField('Inventory')
--			Titles = Titles and Titles.Titles
--			if not Titles then return end
--			if v == 'Rimuru' and not table.find(Titles,'Rimuru') then
--				_G.serverServices.TitleService:GiveTitle(player,'Rimuru')
--			elseif v == 'Gohan' and not table.find(Titles,'Beast Hunter') then
--				_G.serverServices.TitleService:GiveTitle(player,'Beast Hunter')
--			end
--		end)
--	end

--end

--function module:GetBannerPercentages(player, rarity)

--	if table.find({"Mythical", "Legendary", "Secret"}, rarity) then
--		return SummonChances[rarity]
--	end
--	return SummonChances[rarity]

--end

--function module:Summon(player, summonType : "Summon1" | "Summon10" )
--	--if player:GetAttribute("Summoning") then return end
--	--player:SetAttribute("Summoning", true)
--	--task.delay(1, function()
--	--	player:SetAttribute("Summoning", false)
--	--end)
--	if not _G.serverServices.UnitManager then return nil end
--	local RNG = Random.new()
--	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
--	local plrLevel = PlayerProfileClass:GetField("Level")
--	local products = GetProductData(player)
--	local function GetRandomRarity(exclude)
--		if not exclude then exclude = {} end
--		if plrLevel < 15 then
--			table.insert(exclude, "Secret")
--		end
--		local weight = 0
--		for i, t in pairs(SummonChances) do

--			if not table.find(exclude, i) then
--				weight += module:GetBannerPercentages(player, i) * 100000
--			end
--		end

--		local Chosen = RNG:NextNumber(1, weight);

--		for i, t in pairs(SummonChances) do

--			if not table.find(exclude, i) then
--				weight -= module:GetBannerPercentages(player, i) * 100000
--			end
--			if Chosen > weight then
--				return i
--			end
--		end

--	end

--	--local data__ = {}
--	--for i=1, 50000 do
--	--	local e = GetRandomRarity()
--	--	data__[e] = data__[e] and data__[e] + 1 or 1
--	--end

--	--print(data__)

--	local Currencies = PlayerProfileClass:GetField("Currencies")

--	local gems = Currencies["Candy Cane"]

--	local unitManager = _G.serverServices.UnitManager
--	local PlayerService = _G.serverServices.PlayerService
--	local autoSell = PlayerProfileClass:GetField("Settings").AutoSell
--	local inventory = PlayerProfileClass:GetField("Inventory")
--	if summonType == "Summon1" then
--		if Length(inventory.Units) + 1 > inventory.MaxUnitStorage then return end
--	end
--	if summonType == "Summon10" then
--		if Length(inventory.Units) + 10 > inventory.MaxUnitStorage then return end
--	end

--	local statistics = PlayerProfileClass:GetField("PlayerStatistics")

--	local function statUpdate(unit)
--		if unitRegistry[unit].configuration.Rarity == "Secret" then
--			PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedSecrets", statistics.SummonedSecrets + 1, false)
--		end
--		if unitRegistry[unit].configuration.Rarity == "Mythical" then
--			PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedMythicals", statistics.SummonedMythicals + 1, false)
--		end
--	end

--	if summonType == "Summon1" then
--		if gems < 250 then return end
--		local mythicPity = module:Pity(player, "MythicalPity", 1) and "Mythical" or nil
--		local legendaryPity = module:Pity(player, "LegendaryPity", 1) and "Legendary" or nil
--		local secretPity = module:Pity(player, "SecretPity", 1) and "Secret" or nil

--		if mythicPity and secretPity then
--			mythicPity = nil
--			module:SetPity(player, "MythicalPity", 400)
--		end

--		if mythicPity and legendaryPity then
--			legendaryPity = nil
--			module:SetPity(player, "LegendaryPity", 50)
--		end
--		local unit
--		if mythicPity then
--			unit =  typeof(currentBanner["Mythical"]) == "table" and currentBanner["Mythical"][math.random(1, #currentBanner["Mythical"])] or currentBanner["Mythical"]
--		elseif legendaryPity then
--			unit = typeof(currentBanner["Legendary"]) == "table" and currentBanner["Legendary"][math.random(1, #currentBanner["Legendary"])] or currentBanner["Legendary"]
--		elseif secretPity then
--			unit = typeof(currentBanner["Secret"]) == "table" and currentBanner["Secret"][math.random(1, #currentBanner["Secret"])] or currentBanner["Secret"]

--		else
--			local random = GetRandomRarity()
--			unit = typeof(currentBanner[random]) == "table" and currentBanner[random][math.random(1, #currentBanner[random])] or currentBanner[random]
--			local _reg = unitRegistry[unit]

--			if _reg.configuration.Rarity == "Mythical" then
--				module:SetPity(player, "MythicalPity", 0)

--			end
--			if _reg.configuration.Rarity == "Legendary" then
--				module:SetPity(player, "LegendaryPity", 0)

--			end
--			if _reg.configuration.Rarity == "Secret" then
--				module:SetPity(player, "SecretPity", 0)
--			end

--		end
--		statUpdate(unit)

--		local unitName = unit

--		local IsShiny
--		if plrLevel >= 10 or products["1932432116"] then
--			--- Shiny roll placeholder
--			local ROLLED_SHINY_ODD = Random.new():NextInteger(1,100*10)
--			local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player)*10
--			IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD  --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
--			if IsShiny then
--				PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedShinies", statistics.SummonedShinies + 1, true)
--			end
--		end

--		if not IsShiny and table.find(autoSell, unitRegistry[unit].configuration.Rarity) then

--			local EventSummonable = unitRegistry[unit].raw:FindFirstChild('EventSummonable')
--			EventSummonable = EventSummonable and EventSummonable.Value

--			local cost = gameFunctions:CalculateSellCost(unitRegistry[unit].configuration.Rarity, 1,EventSummonable)

--			PlayerService:GiveCurrency(player, "Gold", cost, true)
--		else
--			local _UnitAdditionalData = IsShiny and {Shiny = true} or nil
--			local v = unit
--			unit = unitManager:giveUnit(player, unit, 1, _UnitAdditionalData, true)
--			unit = unit[1]
--			module:Chat(player,v,IsShiny)
--		end

--		PlayerProfileClass:ReplicateField("SummoningEventData")

--		PlayerService:GiveCurrency(player, "Candy Cane", -250)

--		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 1, true)
--		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 1)
--		_G.serverServices.QuestHandler:GivePointsByPointType(player, "WinterSummon", 1)

--		local _reg = unitRegistry[unitName]
--		if _reg.configuration.Rarity == "Secret" or _reg.configuration.Rarity == "Mythical" or _reg.configuration.Rarity == "Exclusive" then
--			DataAPI:SaveProfile(player)
--		end

--		uiCommunication:FireClient(player, "SummonEvent/UnitSummoned", summonType, {unit})
--		return unit
--	elseif summonType == "Summon10"  then
--		local summonCost = gameFunctions:HasVIP(PlayerProfileClass) and 2000 or 2500
--		if gems < summonCost then return end

--		local mythicPity = module:Pity(player, "MythicalPity", 10) and "Mythical" or nil
--		local secretPity = module:Pity(player, "SecretPity", 10) and "Secret" or nil

--		local legendaryPity = module:Pity(player, "LegendaryPity", 10) and "Legendary" or nil
--		local units = {}
--		local rollUnits = 10
--		local _gold = 0
--		local unit
--		if mythicPity then
--			local unit = typeof(currentBanner["Mythical"]) == "table" and currentBanner["Mythical"][math.random(1, #currentBanner["Mythical"])] or currentBanner["Mythical"]

--			table.insert(units, unit)
--			rollUnits -= 1
--		end

--		if secretPity then
--			local unit = typeof(currentBanner["Secret"]) == "table" and currentBanner["Secret"][math.random(1, #currentBanner["Secret"])] or currentBanner["Secret"]

--			table.insert(units, unit)
--			rollUnits -= 1
--		end

--		if legendaryPity then
--			local unit = typeof(currentBanner["Legendary"]) == "table" and currentBanner["Legendary"][math.random(1, #currentBanner["Legendary"])] or currentBanner["Legendary"]

--			table.insert(units, unit)
--			rollUnits -= 1
--		end

--		for i = 1, rollUnits, 1 do
--			local random = GetRandomRarity()

--			local unit = typeof(currentBanner[random]) == "table" and currentBanner[random][math.random(1, #currentBanner[random])] or currentBanner[random]

--			local _reg = unitRegistry[unit]

--			if _reg.configuration.Rarity == "Mythical" then
--				module:SetPity(player, "MythicalPity", 0)
--			end

--			if _reg.configuration.Rarity == "Legendary" then
--				module:SetPity(player, "LegendaryPity", 0)
--			end

--			if _reg.configuration.Rarity == "Secret" then
--				module:SetPity(player, "SecretPity", 0)
--			end
--			table.insert(units, unit)

--		end

--		local HasRareUnit = false

--		local uuids = {}
--		for i,v in units do
--			local _reg = unitRegistry[v]
--			if _reg.configuration.Rarity == "Secret" or _reg.configuration.Rarity == "Mythical" or _reg.configuration.Rarity == "Exclusive" then
--				HasRareUnit = true
--			end

--			local IsShiny
--			if plrLevel >= 10 or products["1932432116"] then
--				local ROLLED_SHINY_ODD = Random.new():NextInteger(1,100*10)
--				local CURRENT_LUCK_ODD_THRESHOLD = self:CalculateShinyChance(player)*10
--				IsShiny = ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD  --Random.new():NextInteger(1,100*10) <= self:CalculateShinyChance(player)*10
--				if IsShiny then
--					PlayerProfileClass:WriteDirectory("PlayerStatistics/SummonedShinies", statistics.SummonedShinies + 1, true)
--				end
--			end

--			if not IsShiny and table.find(autoSell, unitRegistry[v].configuration.Rarity) then
--				local EventSummonable = unitRegistry[v].raw:FindFirstChild('EventSummonable')
--				EventSummonable = EventSummonable and EventSummonable.Value

--				local cost = gameFunctions:CalculateSellCost(unitRegistry[v].configuration.Rarity, 1,EventSummonable)
--				_gold += cost
--				table.insert(uuids, v)
--				continue
--			end

--			local _UnitAdditionalData = IsShiny and {Shiny = true} or nil

--			local uuid = unitManager:giveUnit(player, v, 1, _UnitAdditionalData, true)
--			table.insert(uuids, uuid[1])

--			module:Chat(player,v,IsShiny)

--			statUpdate(v)
--		end

--		if _gold > 0 then
--			PlayerService:GiveCurrency(player, "Gold", _gold, true)
--		end
--		PlayerProfileClass:ReplicateField("SummoningEventData")
--		PlayerService:GiveCurrency(player, "Candy Cane", -summonCost)

--		_G.serverServices.QuestHandler:GivePointsByPointType(player, "Summons", 10)
--		_G.serverServices.QuestHandler:GivePointsByPointType(player, "WinterSummon", 10)

--		PlayerProfileClass:WriteDirectory("PlayerStatistics/TotalSummons", statistics.TotalSummons + 10, true)

--		if HasRareUnit then
--			DataAPI:SaveProfile(player)
--		end

--		uiCommunication:FireClient(player, "SummonEvent/UnitSummoned", summonType, uuids)
--	end

--end
----// Initializing all the existing summoning functions upon request by client
--function module:InitializeSummonCommunication()

--	summonEvent.OnServerEvent:Connect(function(player, summonType)

--		local uuid = self:Summon(player, summonType)
--	end)

--	summonFunction.OnServerInvoke = function(player, identifier, ...)
--		return summonFunctionCalls[identifier](summonFunctionCalls, player, ...)
--	end
--end

--function module:start()
--	self:InitializeSummonCommunication()
--	self:InitiailizeBanner()

--	return "Loaded"
--end

return module
