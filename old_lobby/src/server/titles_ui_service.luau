--------------------------------------------------------------------------------
-- titles_ui_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local TitleService = require("@server/title_service")

--[=[
UI handler service for title management functionality.

@class TitlesUIService
]=]
local TitlesUIService = {
	version = version,
}

-- Constants
local COOLDOWN = 2

--[=[
Toggles the equipped state of a title.

@param player Player -- The player toggling the title
@param titleName string -- The title to toggle
]=]
function TitlesUIService.toggleEquip(player: Player, titleName: string)
	if player:GetAttribute("ChangeTitleCooldown") then
		return
	end

	player:SetAttribute("ChangeTitleCooldown", true)

	task.delay(COOLDOWN, function()
		if player.Parent then
			player:SetAttribute("ChangeTitleCooldown", nil)
		end
	end)

	local person = Person.new(player)
	local currentTitle = person.dataCache().CurrentTitle

	if currentTitle == titleName then
		-- Unequip the title
		TitleService.equipTitle(person, "")
	else
		-- Equip the title
		TitleService.equipTitle(person, titleName)
	end
end

-- Register network handlers
Network.registerHandler("ToggleEquipTitle", TitlesUIService.toggleEquip)

return TitlesUIService
