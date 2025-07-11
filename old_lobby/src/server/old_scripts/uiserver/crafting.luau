local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CraftingLibrary = require(ReplicatedStorage.Libs.CraftingLibrary)

local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer

local Crafting = {
	CraftItem = function(player: Player, item: string)
		if not CraftingLibrary:CanCraftItem(player, item) then
			return
		end

		if CraftingLibrary:CraftItem(player, item) then
			NotifyPlayer:FireClient(player, {
				color = "Success",
				text = "Crafting successful!",
			})
			_G.serverServices.BingoService:AddProgress(player, "Craft", 1)
		end
	end,
}

return Crafting
