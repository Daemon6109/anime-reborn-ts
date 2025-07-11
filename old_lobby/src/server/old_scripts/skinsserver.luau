local Relics = {}
local DataAccess = require(game:GetService("ServerScriptService").ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local Players = game:GetService("Players")
local Registry = _G.Registry.registry
local SkinsRegistry = Registry.Skins

function Relics:GiveSkin(Player: Player, SkinName: string)
	assert(SkinsRegistry[SkinName], `[RELICS] Skin named {SkinName} doesn't exist`)

	local SkinData = SkinsRegistry[SkinName]

	local Profile = DataAPI:GetActivePlayerProfileClass(Player)
	local UUID = game.HttpService:GenerateGUID(false)
	Profile:WriteDirectory(`Inventory/Skins/{UUID}`, { Name = SkinName }, true)

	return UUID
end

function Relics:CheckIfCanEquip(Unit: { any }, SkinName: string)
	assert(SkinsRegistry[SkinName], `[RELICS] Skin named {SkinName} doesn't exist`)

	return SkinsRegistry[SkinName].configuration.UnitNames[Unit.UnitName]
end

function Relics:EquipSkin(Player: Player, UnitUUID: string, SkinUUID: string)
	local ProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local Inventory = ProfileClass:GetField("Inventory")
	local Units = Inventory.Units
	local Skins = Inventory.Skins
	local FoundUnit = Units[UnitUUID]
	local FoundSkin = Skins[SkinUUID]
	--warn(UnitUUID,FoundUnit)
	--warn(SkinUUID,FoundSkin,Skins)
	--warn('Found:',(FoundUnit and FoundSkin and true or false))
	if FoundUnit and FoundSkin then
		local Condition = Relics:CheckIfCanEquip(FoundUnit, FoundSkin.Name)
		--warn('Condition:',Condition)
		if Condition then
			ProfileClass:WriteDirectory(`Inventory/Skins/{SkinUUID}`, nil, true)
			ProfileClass:WriteDirectory(
				`Inventory/Units/{UnitUUID}/Skin`,
				{ UUID = SkinUUID, Name = FoundSkin.Name },
				true
			)

			_G.serverServices.UnitManager:UpdateSlotbar(Player)
		end
	end
end

function Relics:UnequipSkin(Player: Player, UnitUUID: string)
	local ProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	local Inventory = ProfileClass:GetField("Inventory")
	local Units = Inventory.Units
	local FoundUnit = Units[UnitUUID]

	if FoundUnit and FoundUnit.Skin ~= "" and FoundUnit.Skin.UUID then
		ProfileClass:WriteDirectory(
			`Inventory/Skins/{FoundUnit.Skin.UUID}`,
			{ UUID = FoundUnit.Skin.UUID, Name = FoundUnit.Skin.Name },
			true
		)
		ProfileClass:WriteDirectory(`Inventory/Units/{UnitUUID}/Skin`, "", true)
		_G.serverServices.UnitManager:UpdateSlotbar(Player)
	end
end

function Relics:start() end

return Relics
