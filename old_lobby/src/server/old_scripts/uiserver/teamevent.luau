local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScripts = game:GetService("ServerScriptService")
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local IndexRegistry = require(ReplicatedStorage.Registry.IndexData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local GlobalbpData = require(game.ReplicatedStorage.Registry.GlobalTeamEventData)
local bpData = require(game.ReplicatedStorage.Registry.TeamEventData)
local TeamEventShopItems = _G.Registry.registry.TeamEventShopItems

local function Length(dict: table)
	local counter = 0
	for _ in dict do
		counter += 1
	end
	return counter
end
local function counter(root)
	local count = 0

	for i, v in root do
		count += v
	end

	return count
end

local DataAPI = DataAccess:GetAPI()
local unreleased = true
local UnitIndex = {
	ClaimGlobalRewards = function(player: Player)
		warn("Claiming Global")
		--// Player Cooldown
		if player:GetAttribute("ClaimingBattlepass") then
			return
		end
		player:SetAttribute("ClaimingBattlepass", true)

		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local playerBpData = PlayerProfileClass:GetField("TeamEventData").GlobalBattlepass
		local _ContributedSouls = PlayerProfileClass:GetField("TeamEventData").ContributedSouls

		local GlobalContributedSouls =
			ReplicatedStorage.TeamEventCount:GetAttribute(PlayerProfileClass:GetField("TeamEventData").Team)

		--// Cycle through rewards to check if anything is claimable
		local CanClaim = {
			["Regular"] = {},
			["Premium"] = {},
		}
		local Claimed = playerBpData.Claimed
		warn("Claimed", Claimed)

		local UnitCount = 0
		--// Check if rewards has units
		for Number, LevelInfo in GlobalbpData.LevelData do
			if LevelInfo.Exp > _ContributedSouls then
				continue
			end
			if LevelInfo.Global > GlobalContributedSouls then
				continue
			end

			if not table.find(Claimed["Regular"], Number) then
				if GlobalbpData.LevelData[Number].Regular.Units then
					UnitCount += counter(GlobalbpData.LevelData[Number].Regular.Units)
				end
				if GlobalbpData.LevelData[Number].Regular.ShinyUnits then
					UnitCount += counter(GlobalbpData.LevelData[Number].Regular.ShinyUnits)
				end
			end

			if not playerBpData.HasPremium then
				continue
			end

			if not table.find(Claimed["Premium"], Number) then
				if GlobalbpData.LevelData[Number].Premium.Units then
					UnitCount += counter(GlobalbpData.LevelData[Number].Premium.Units)
				end
				if GlobalbpData.LevelData[Number].Premium.ShinyUnits then
					UnitCount += counter(GlobalbpData.LevelData[Number].Premium.ShinyUnits)
				end
			end
		end

		--// Return if unit count is full
		local PlayerUnitCount = Length(PlayerProfileClass:GetField("Inventory").Units)
		if UnitCount > PlayerProfileClass:GetField("Inventory").MaxUnitStorage - PlayerUnitCount then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Error", "Your unit storage is full!")
			task.wait(1)
			player:SetAttribute("ClaimingBattlepass", false)
			return
		end

		--// Cycle now
		for Number, LevelInfo in GlobalbpData.LevelData do
			if LevelInfo.Exp > _ContributedSouls then
				continue
			end
			if LevelInfo.Global > GlobalContributedSouls then
				continue
			end

			if not table.find(Claimed["Regular"], Number) then
				table.insert(Claimed["Regular"], Number)
				table.insert(CanClaim["Regular"], Number)
			end

			if not playerBpData.HasPremium then
				continue
			end

			if not table.find(Claimed["Premium"], Number) then
				table.insert(Claimed["Premium"], Number)
				table.insert(CanClaim["Premium"], Number)
			end
		end

		warn("CanClaim", CanClaim)

		--// Checks to see if there is nothing to claim
		if #CanClaim["Regular"] == 0 and #CanClaim["Premium"] == 0 then
			task.wait(1)
			player:SetAttribute("ClaimingBattlepass", false)
			return
		end

		--// Award rewards here

		for Type, ClaimIndexTable in CanClaim do
			warn("Claiming Type:", Type)
			for _, i in ClaimIndexTable do
				RewardLibrary:RewardPlayer(player, GlobalbpData.LevelData[i][Type])
			end
		end

		PlayerProfileClass:WriteDirectory("TeamEventData/GlobalBattlepass/Claimed", Claimed, true)
		game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Success", "Successfully claimed rewards!")

		task.wait(1)
		player:SetAttribute("ClaimingBattlepass", false)
		return
	end,

	ClaimRewards = function(player: Player)
		warn("Claiming Indiv")
		--// Player Cooldown
		if player:GetAttribute("ClaimingBattlepass") then
			return
		end
		player:SetAttribute("ClaimingBattlepass", true)

		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local playerBpData = PlayerProfileClass:GetField("TeamEventData").Battlepass
		local _ContributedSouls = PlayerProfileClass:GetField("TeamEventData").ContributedSouls

		--// Cycle through rewards to check if anything is claimable
		local CanClaim = {
			["Regular"] = {},
			["Premium"] = {},
		}
		local Claimed = playerBpData.Claimed
		warn("Claimed", Claimed)

		local UnitCount = 0
		--// Check if rewards has units
		for Number, LevelInfo in bpData.LevelData do
			if LevelInfo.Exp > _ContributedSouls then
				continue
			end

			if not table.find(Claimed["Regular"], Number) then
				if bpData.LevelData[Number].Regular.Units then
					UnitCount += counter(bpData.LevelData[Number].Regular.Units)
				end
				if bpData.LevelData[Number].Regular.ShinyUnits then
					UnitCount += counter(bpData.LevelData[Number].Regular.ShinyUnits)
				end
			end

			if not playerBpData.HasPremium then
				continue
			end

			if not table.find(Claimed["Premium"], Number) then
				if bpData.LevelData[Number].Premium.Units then
					UnitCount += counter(bpData.LevelData[Number].Premium.Units)
				end
				if bpData.LevelData[Number].Premium.ShinyUnits then
					UnitCount += counter(bpData.LevelData[Number].Premium.ShinyUnits)
				end
			end
		end

		--// Return if unit count is full
		local PlayerUnitCount = Length(PlayerProfileClass:GetField("Inventory").Units)
		if UnitCount > PlayerProfileClass:GetField("Inventory").MaxUnitStorage - PlayerUnitCount then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Error", "Your unit storage is full!")
			task.wait(1)
			player:SetAttribute("ClaimingBattlepass", false)
			return
		end

		--// Cycle now
		for Number, LevelInfo in bpData.LevelData do
			if LevelInfo.Exp > _ContributedSouls then
				continue
			end

			if not table.find(Claimed["Regular"], Number) then
				table.insert(Claimed["Regular"], Number)
				table.insert(CanClaim["Regular"], Number)
			end

			if not playerBpData.HasPremium then
				continue
			end

			if not table.find(Claimed["Premium"], Number) then
				table.insert(Claimed["Premium"], Number)
				table.insert(CanClaim["Premium"], Number)
			end
		end

		warn("CanClaim", CanClaim)

		--// Checks to see if there is nothing to claim
		if #CanClaim["Regular"] == 0 and #CanClaim["Premium"] == 0 then
			task.wait(1)
			player:SetAttribute("ClaimingBattlepass", false)
			return
		end

		--// Award rewards here

		for Type, ClaimIndexTable in CanClaim do
			warn("Claiming Type:", Type)
			for _, i in ClaimIndexTable do
				RewardLibrary:RewardPlayer(player, bpData.LevelData[i][Type])
			end
		end

		PlayerProfileClass:WriteDirectory("TeamEventData/Battlepass/Claimed", Claimed, true)
		game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Success", "Successfully claimed rewards!")

		task.wait(1)
		player:SetAttribute("ClaimingBattlepass", false)
		return
	end,
	BuyItem = function(player, data)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local Item = data.Item
		local Amount = data.Amount

		if not TeamEventShopItems[Item] then
			return
		end
		if Amount ~= Amount or not tonumber(Amount) then
			return
		end

		local ItemData = TeamEventShopItems[Item]

		Amount = math.floor(math.abs(Amount))
		Amount = math.clamp(Amount, 1, math.huge)

		local Price = Amount * ItemData.Price
		local Quantity = ItemData.Quantity

		local EventShopData = PlayerProfile:GetField("TeamEventData").Shop

		if Quantity and EventShopData then
			local BoughtQuantity = EventShopData.Bought[Item] or 0

			if BoughtQuantity + Amount > Quantity then
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Error",
					`This item has {Quantity - BoughtQuantity} stock left!`
				)
				return
			else
				PlayerProfile:WriteDirectory(`TeamEventData/Shop/Bought/{Item}`, BoughtQuantity + Amount, true)
			end
		end

		local itemService = _G.serverServices.ItemManager
		if not itemService:HasItem(player, "Soul", Price) then
			return
		end

		itemService:GiveItems(player, { ["Soul"] = -Price }, nil, true)

		_G.serverServices.ItemManager:GiveItems(player, { [Item] = Amount })
		game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
			player,
			"Success",
			`You bought x{tonumber(Amount)} {Item}!`
		)
	end,

	ClaimEvilEye = function(player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if PlayerProfile:GetField("TeamEventData").Team == "Spirits" then
		else
			local InTop50 = false

			local ContributedSouls = PlayerProfile:GetField("TeamEventData").ContributedSouls

			if ContributedSouls < 2000 and player.Name ~= "DrDarkMatter" then
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Error",
					"You have not contributed enough souls!"
				)
				return
			end

			local HasClaimed = PlayerProfile:GetField("TeamEventData").HasClaimed --
			if HasClaimed then
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Error",
					"You have already claimed this reward!"
				)
				return
			end

			for _, ValueObject in pairs(ReplicatedStorage.UILeaderboards.AliensContributedSouls:GetChildren()) do
				if tostring(ValueObject:GetAttribute("UserId")) == tostring(player.UserId) then
					if tonumber(ValueObject.Name) <= 50 then
						InTop50 = true
					end
				end
			end

			if InTop50 then
				RewardLibrary:RewardPlayer(player, {
					ShinyUnits = {
						["Evil Eye"] = 1,
					},
				})

				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Success",
					"Successfully claimed reward!"
				)

				PlayerProfile:WriteDirectory("TeamEventData/HasClaimed", true, true)
			else
				game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
					player,
					"Error",
					"Your team has lost the team event!"
				)
			end
			return
		end
		local ContributedSouls = PlayerProfile:GetField("TeamEventData").ContributedSouls

		if ContributedSouls < 2000 and player.Name ~= "DrDarkMatter" then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				player,
				"Error",
				"You have not contributed enough souls!"
			)
			return
		end

		local HasClaimed = PlayerProfile:GetField("TeamEventData").HasClaimed --
		if HasClaimed then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				player,
				"Error",
				"You have already claimed this reward!"
			)
			return
		end

		game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player, "Success", "Successfully claimed reward!")

		RewardLibrary:RewardPlayer(player, {
			Units = {
				["Evil Eye"] = 1,
			},
		})

		local Top50

		for _, ValueObject in ReplicatedStorage.UILeaderboards.SpiritsContributedSouls:GetChildren() do
			if tostring(ValueObject:GetAttribute("UserId")) == tostring(player.UserId) then
				if tonumber(ValueObject.Name) <= 50 then
					Top50 = true
				end
			end
		end

		if Top50 then
			RewardLibrary:RewardPlayer(player, {
				ShinyUnits = {
					["Evil Eye"] = 1,
				},
			})
		end

		PlayerProfile:WriteDirectory("TeamEventData/HasClaimed", true, true)
	end,
}

return UnitIndex
