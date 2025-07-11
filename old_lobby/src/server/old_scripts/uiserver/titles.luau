local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local COOLDOWN = 2

local Titles = {
	ToggleEquip = function(player: Player, title: string)
		if player:GetAttribute("ChangeTitleCooldown") then
			return
		end

		player:SetAttribute("ChangeTitleCooldown", true)

		task.delay(COOLDOWN, function()
			if player.Parent then
				player:SetAttribute("ChangeTitleCooldown", nil)
			end
		end)

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if PlayerProfile:GetField("CurrentTitle") == title then
			_G.serverServices.TitleService:EquipTitle(player, "")
		else
			_G.serverServices.TitleService:EquipTitle(player, title)
		end
	end,
}

return Titles
