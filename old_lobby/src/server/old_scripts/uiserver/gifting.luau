--// Used for gifting ui, gift inbox is under Profile

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local MonetizationHandler = require(ServerScripts.Services.MonetizationHandler)

local UiCommunication = ReplicatedStorage.Events.UiCommunication
local COOLDOWN_DURATION = 3

local Gifting = {

	GiftPlayer = function(player: Player, GiftedPlayerId: number, ProductId: number | string)
		if player:GetAttribute("GiftCooldown") then
			return
		end -- Avoid too many MonetizationHandler:CanPlayerBeGifted requests
		if player.UserId == GiftedPlayerId or GiftedPlayerId <= 0 then
			return
		end

		player:SetAttribute("GiftCooldown", true)

		if MonetizationHandler:AttemptGiftPlayer(player, GiftedPlayerId, ProductId) then
			UiCommunication:FireClient(player, "Gifting/HideUI")
		else
			-- ReplicatedStorage.Events.NotifyPlayer_2:FireClient(player,'Error',"")
		end

		task.wait(COOLDOWN_DURATION)

		if player.Parent then
			player:SetAttribute("GiftCooldown", nil)
		end
	end,

	RemoveGiftData = function(player)
		MonetizationHandler.StoredGiftData[player] = nil
	end,
}

return Gifting
