--------------------------------------------------------------------------------
-- codes_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")
local RewardLibrary = require("@commonutils/RewardLibrary")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

-- Constants
local REDEEM_ATTEMPT_COOLDOWN = 6
local GROUP_ID = 33820338

export type CodeRewards = {
	Currencies: { [string]: number }?,
	Items: { [string]: number }?,
	Units: { [string]: number }?,
	ShinyUnits: { [string]: number }?,
}

export type CodeData = {
	Code: string,
	ExpireDate: number?,
	Rewards: CodeRewards,
	UseLimit: number?,
	AmountUsed: number?,
	RoleExclusive: { string }?,
	LevelRequirement: number?,
	BoughtProductId: (number | { number })?,
}

--[=[
	Service for handling code redemption system.

	@class CodesService
]=]
local CodesService = {
	version = version,
}

-- Track players on cooldown to prevent spam
local playerCooldowns: { [Player]: boolean } = {}

--[=[
	Creates a code configuration

	@private

	@within CodesService

	@param props CodeData -- The code properties

	@return CodeData -- The code configuration

	```lua
	CodesService.createCode({
		Code = "examplecode",
		ExpireDate = DateTime.fromUniversalTime(2025, 1, 1).UnixTimestamp,
		Rewards = {
			Currencies = { Gems = 1000 },
			Items = { TraitCrystal = 5 },
		},
	})
	```
]=]
local function createCode(props: CodeData): CodeData
	return props
end

-- Active codes configuration
local codes: { CodeData } = {
	createCode({
		Code = "bannercostfixed",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
			},
		},
	}),
	createCode({
		Code = "patch",
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 100,
				FrostKey = 30,
				PotentialKey = 30,
				RainbowStar = 3,
			},
			Currencies = {
				Gems = 5000,
			},
		},
	}),
	createCode({
		Code = "domainexpansion!",
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 20,
				["Vyasche Item"] = 1,
				["Dragon Ball (7)"] = 1,
			},
		},
	}),
	createCode({
		Code = "crystals",
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				["Fierce Crystal"] = 10,
				["Fire Crystal"] = 10,
				["Dark Crystal"] = 10,
				["Light Crystal"] = 10,
				["Wind Crystal"] = 10,
				["Water Crystal"] = 10,
			},
		},
	}),
	createCode({
		Code = "sorryfordelay",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			},
			Currencies = {
				Gems = 10000,
			},
		},
	}),
	createCode({
		Code = "newbanner",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
			},
			Currencies = {
				Gems = 3000,
			},
		},
	}),
	createCode({
		Code = "reborn",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
				BasicLuckPotion = 1,
			},
		},
	}),
	createCode({
		Code = "tournamentofpower",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 20,
			},
			Currencies = {
				Gems = 5000,
			},
		},
	}),
	createCode({
		Code = "goodnighttestersigozzz",
		ExpireDate = DateTime.fromUniversalTime(2026, 4, 7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 150,
				PotentialKey = 100,
				FrostKey = 50,
				RainbowStar = 30,
				GreenStar = 30,
				PurpleStar = 30,
				RedStar = 30,
				BlueStar = 30,
				OrangeStar = 30,
			},
			Currencies = {
				Gems = 12000,
			},
		},
		RoleExclusive = { "Tester", "[CLOSED] Tester", "Moderator", "Admin" },
	}),
	createCode({
		Code = "arftw",
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 14).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
			},
			Currencies = {
				Gems = 500,
			},
		},
	}),
}

--[=[
	Finds a code by its string value

	@private

	@within CodesService

	@param codeString string -- The code string to search for

	@return CodeData? -- The found code or nil

	```lua
	local codeData = CodesService.findCode("FREEGEMS")
	if codeData then
		print("Code found:", codeData.Code)
	else
		print("Code not found")
	end
	```
]=]
local function findCode(codeString: string): CodeData?
	for _, code in ipairs(codes) do
		if code.Code == codeString then
			return code
		end
	end
	return nil
end

--[=[
	Checks if a player meets the requirements to redeem a code

	@private

	@within CodesService

	@param person Person -- The person trying to redeem
	@param code CodeData -- The code being redeemed

	@return boolean -- Whether the player can redeem the code
	@return string? -- Error message if redemption is not allowed

	```lua
	local canRedeem, errorMessage = CodesService.canRedeemCode(person, codeData)
	if canRedeem then
		print("Player can redeem the code!")
	else
		print("Cannot redeem code:", errorMessage)
	end
	```
]=]
local function canRedeemCode(person: Person.Person, code: CodeData): (boolean, string?)
	local dataCache = person.dataCache()
	local player = person.player
	-- Check if already redeemed
	if table.find(dataCache.RedeemedCodes, code.Code) then
		return false, "You have already redeemed this code!"
	end
	-- Check role exclusivity
	if code.RoleExclusive then
		local playerRole = player:GetRoleInGroup(GROUP_ID)
		if not table.find(code.RoleExclusive, playerRole) then
			return false, "Invalid Code! You cant redeem this"
		end
	end
	-- Check level requirement
	if code.LevelRequirement and dataCache.Level < code.LevelRequirement then
		return false, `You must be level {code.LevelRequirement} to redeem this code!`
	end
	-- Check product requirement
	if code.BoughtProductId then
		local productsBought = dataCache.ProductsBought or {}
		local boughtProduct = false
		local productIds = typeof(code.BoughtProductId) == "number" and { code.BoughtProductId } or code.BoughtProductId
		for _, productId in ipairs(productIds) do
			if productsBought[tostring(productId)] then
				boughtProduct = true
				break
			end
		end
		if not boughtProduct then
			return false, "You must own the product to redeem this code!"
		end
	end
	-- Check expiration
	if code.ExpireDate and code.ExpireDate < DateTime.now().UnixTimestamp then
		return false, "This code has expired!"
	end
	-- Check use limit (global)
	if code.UseLimit and code.AmountUsed and code.AmountUsed >= code.UseLimit then
		return false, "This code has reached its usage limit!"
	end
	return true, nil
end

--[=[
	Redeems a code for a player

	@within CodesService

	@param person Person -- The person redeeming the code
	@param codeString string -- The code string to redeem

	```lua
	CodesService.redeemCode(person, "FREEGEMS")
	```
]=]
function CodesService.redeemCode(person: Person.Person, codeString: string): ()
	local player = person.player
	-- Check cooldown
	if playerCooldowns[player] then
		return
	end
	-- Set cooldown
	playerCooldowns[player] = true
	local canResetCooldown = true
	task.delay(REDEEM_ATTEMPT_COOLDOWN, function()
		if canResetCooldown then
			playerCooldowns[player] = nil
		end
	end)
	-- Normalize code string
	local normalizedCode = string.lower(tostring(codeString))
	-- Find the code
	local code = findCode(normalizedCode)
	if not code then
		if NotifyPlayer then
			NotifyPlayer:FireClient(player, "Error", "Invalid Code!")
		end
		return
	end
	-- Check if player can redeem
	local canRedeem, errorMessage = canRedeemCode(person, code)
	if not canRedeem then
		if NotifyPlayer and errorMessage then
			NotifyPlayer:FireClient(player, "Error", errorMessage)
		end
		return
	end
	-- Add code to redeemed list
	local dataCache = person.dataCache()
	local newCache = table.clone(dataCache)
	local redeemedCodes = table.clone(dataCache.RedeemedCodes)
	table.insert(redeemedCodes, code.Code)
	newCache.RedeemedCodes = redeemedCodes
	-- Update data cache
	person.dataCache(newCache)
	-- Give rewards
	local success = pcall(function()
		RewardLibrary:RewardPlayer(player, code.Rewards)
	end)
	if success then
		-- Update global usage count if applicable
		if code.UseLimit then
			code.AmountUsed = (code.AmountUsed or 0) + 1
		end
		-- Notify success
		if NotifyPlayer then
			NotifyPlayer:FireClient(player, "Success", "Code Redeemed!")
		end
	else
		warn(`Failed to give rewards for code {code.Code} to player {player.Name}`)
		-- Could rollback the redeemed codes here if needed
	end
	-- Reset cooldown immediately on success/failure
	canResetCooldown = false
	playerCooldowns[player] = nil
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   CodesService.start()
   ```
]=]
function CodesService.start()
	-- Set up network handlers
	Network.registerHandler("Codes/Redeem", function(player: Player, code: string)
		local person = Person.getForPlayer(player)
		if person then
			CodesService.redeemCode(person, code)
		end
	end)
	-- Clean up cooldowns when players leave
	Players.PlayerRemoving:Connect(function(player)
		playerCooldowns[player] = nil
	end)
end

return CodesService
