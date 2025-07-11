--------------------------------------------------------------------------------
-- skins_ui_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")
local SkinsRegistry = require("@registry/Skins")
local SkinsServer = require("@server/skins_service")
local UnitsRegistry = require("@registry/Units")

-- Network events
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2

--[=[
UI handler service for skin management functionality.

@class SkinsUIService
]=]
local SkinsUIService = {
	version = version,
}

--[=[
Deletes selected skins from player inventory.

@param player Player -- The player deleting skins
@param skinsToDelete table<string, boolean> -- Map of skin UUIDs to delete
]=]
function SkinsUIService.deleteSkins(player: Player, skinsToDelete: { [string]: boolean })
	local person = Person.new(player)
	local skins = person.dataCache().Inventory.Skins or {}

	for skinUUID, shouldDelete in skinsToDelete do
		if shouldDelete and skins[skinUUID] then
			skins[skinUUID] = nil
		end
	end
end

--[=[
Equips or unequips a skin on a unit.

@param player Player -- The player equipping the skin
@param data table -- Data containing SkinUUID and UnitUUID
]=]
function SkinsUIService.equipSkin(player: Player, data: { SkinUUID: string?, UnitUUID: string })
	if player:GetAttribute("EquippingSkin") then
		return
	end

	player:SetAttribute("EquippingSkin", true)

	local skinUUID = data.SkinUUID
	local unitUUID = data.UnitUUID

	local person = Person.new(player)
	local inventory = person.dataCache().Inventory
	local units = inventory.Units or {}
	local skins = inventory.Skins or {}

	-- Validate unit exists
	if not unitUUID or not units[unitUUID] then
		NotifyPlayer:FireClient(player, {
			text = "Unit does not exist in inventory!",
			color = "Red",
		})
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	local unitData = units[unitUUID]

	-- If unit already has a skin, unequip it
	if unitData.Skin and unitData.Skin ~= "" then
		SkinsServer:UnequipSkin(player, unitUUID)
		NotifyPlayer:FireClient(player, {
			text = "Successfully unequipped skin!",
			color = "Green",
		})
		task.wait(0.3)
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	-- Validate skin selection
	if not skinUUID then
		NotifyPlayer:FireClient(player, {
			text = "You have not selected a skin!",
			color = "Red",
		})
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	-- Validate skin exists in inventory
	local skinData = skins[skinUUID]
	if not skinData then
		NotifyPlayer:FireClient(player, {
			text = "Skin does not exist in inventory!",
			color = "Red",
		})
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	-- Validate skin configuration
	local skinInfo = SkinsRegistry[skinData.Name]
	if not skinInfo then
		NotifyPlayer:FireClient(player, {
			text = "Skin does not exist!",
			color = "Red",
		})
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	-- Check if unit can equip this skin
	local unitName = unitData.UnitName
	local unitInfo = UnitsRegistry[unitName]

	if not skinInfo.configuration.UnitNames or not skinInfo.configuration.UnitNames[unitName] then
		NotifyPlayer:FireClient(player, {
			text = "The selected unit cannot equip this skin!",
			color = "Red",
		})
		player:SetAttribute("EquippingSkin", nil)
		return
	end

	-- Equip the skin
	SkinsServer:EquipSkin(player, unitUUID, skinUUID)

	task.wait(0.3)
	player:SetAttribute("EquippingSkin", nil)

	NotifyPlayer:FireClient(player, {
		text = "Successfully equipped skin!",
		color = "Green",
	})
end

-- Register network handlers
Network.registerHandler("DeleteSkins", SkinsUIService.deleteSkins)
Network.registerHandler("EquipSkin", SkinsUIService.equipSkin)

return SkinsUIService
