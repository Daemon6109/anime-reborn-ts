local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CraftingLibrary = require(ReplicatedStorage.Libs.CraftingLibrary)

local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer
local DataStoreService = game:GetService("DataStoreService")
local ForcedBanners = DataStoreService:GetDataStore("ForcedBanners")
local UICommunication = game.ReplicatedStorage.Events.UiCommunication
local LockedWindows = require(game.ReplicatedStorage.Registry.LockedWindows)
local syncedTime = require(game.ReplicatedStorage.Libs.SyncedTime)

local ForceBanner = {
	LoadForcedBanners = function(player: Player)
		if not table.find(LockedWindows["ForceBanner"], player.UserId) then
			return
		end
		local success, data = pcall(function()
			return ForcedBanners:GetAsync("BannerList")
		end)

		if not success then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Forced banners failed to load",
			})
			warn(success)
			return
		end
		data = data or {}

		UICommunication:FireClient(player, "ForceBanner/_LoadForcedBanners", data, math.floor(syncedTime.time() / 3600))
	end,

	ConfirmBanner = function(player: Player, inHours: number, bannerData)
		if not table.find(LockedWindows["ForceBanner"], player.UserId) then
			return
		end
		if inHours <= 0 then
			return
		end

		if not bannerData["Mythical"] and bannerData["Legendary"] then
			return
		end

		local success, data = pcall(function()
			return ForcedBanners:GetAsync("BannerList")
		end)

		if not success then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Error occurred [CODE: 1]",
			})
			warn(success)

			return
		end
		data = data or {}
		bannerData["ForcedBy"] = player.UserId

		data[tostring(math.floor(syncedTime.time() / 3600) + inHours)] = bannerData

		local success, _ = pcall(function()
			return ForcedBanners:SetAsync("BannerList", data)
		end)

		if not success then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Error occurred [CODE: 2]",
			})
			warn(success)
			return
		end

		UICommunication:FireClient(player, "ForceBanner/_LoadForcedBanners", data, math.floor(syncedTime.time() / 3600))
	end,
	RemoveBanner = function(player: Player, hour: number)
		if not table.find(LockedWindows["ForceBanner"], player.UserId) then
			return
		end

		local success, data = pcall(function()
			return ForcedBanners:GetAsync("BannerList")
		end)

		if not success then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Error occurred [CODE: 1]",
			})
			warn(success)

			return
		end
		data = data or {}

		data[hour] = nil

		local success, _ = pcall(function()
			return ForcedBanners:SetAsync("BannerList", data)
		end)

		if not success then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Error occurred [CODE: 2]",
			})
			warn(success)
			return
		end

		UICommunication:FireClient(player, "ForceBanner/_LoadForcedBanners", data, math.floor(syncedTime.time() / 3600))
	end,
}

return ForceBanner
