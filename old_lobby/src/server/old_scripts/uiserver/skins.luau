local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)

local DataAPI = DataAccess:GetAPI()

local registry = _G.Registry.registry

local uiCommunication = game.ReplicatedStorage.Events.UiCommunication

local SkinsServer = require(game.ServerScriptService.Services.SkinsServer)

local Skins = {
	Delete = function(Player: Player, Data: { [string]: boolean })
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

		local Skins = PlayerProfileClass:GetField("Inventory").Skins

		for UUID in Data do
			if Data[UUID] then
				Skins[UUID] = nil
			end
		end

		PlayerProfileClass:WriteDirectory(`Inventory/Skins`, Skins, true)
	end,
	Equip = function(Player: Player, Data)
		if Player:GetAttribute("EquippingSkin") then
			return
		else
			Player:SetAttribute("EquippingSkin", true)
		end
		--warn('Equip',Player,Data)
		local SkinUUID = Data.SkinUUID
		local UnitUUID = Data.UnitUUID

		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

		local Inventory = PlayerProfileClass:GetField("Inventory")
		local Units = Inventory.Units
		local Skins = Inventory.Skins
		--warn('Skins',Skins)

		local UnitData = Units[UnitUUID]

		if not UnitUUID then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				Player,
				"Error",
				"Unit does not exist in inventory!"
			)
			Player:SetAttribute("EquippingSkin", true)
			return
		end

		if UnitData and UnitData.Skin ~= "" then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(Player, "Error", `Successfully unequipped skin!`)
			--warn(`Unequipping`)
			SkinsServer:UnequipSkin(Player, UnitUUID)
			--warn(UnitData.Skin)
			--PlayerProfileClass:WriteDirectory(`Inventory/Skins/{SkinUUID}`,{Name = UnitData.UnitName},true)
			task.wait(0.3)
			Player:SetAttribute("EquippingSkin", nil)
			return
		end

		local SkinData = Skins[SkinUUID]

		if not SkinUUID then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(Player, "Error", `You have not selected a skin!`)
			Player:SetAttribute("EquippingSkin", nil)
			return
		end

		if not SkinData then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				Player,
				"Error",
				"Skin does not exist in inventory!"
			)
			Player:SetAttribute("EquippingSkin", nil)
			return
		end

		local SkinName = SkinData.Name
		local SkinInfo = registry.Skins[SkinName]
		if not SkinInfo then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(Player, "Error", "Skin does not exist!")
			Player:SetAttribute("EquippingSkin", nil)
			return
		end

		local UnitName = UnitData.UnitName
		local UnitInfo = registry.Units[UnitName]

		if not SkinInfo.configuration.UnitNames[UnitName] then
			game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(
				Player,
				"Error",
				"The selected unit cannot equip this skin!"
			)
		end

		SkinsServer:EquipSkin(Player, UnitUUID, SkinUUID)
		--warn(SkinData)
		--PlayerProfileClass:WriteDirectory(`Inventory/Skins/{SkinUUID}`,nil,true)
		task.wait(0.3)
		Player:SetAttribute("EquippingSkin", nil)
		game.ReplicatedStorage.Events.NotifyPlayer_2:FireClient(Player, "Success", `Successfully equipped skin!`)
	end,
}

return Skins
