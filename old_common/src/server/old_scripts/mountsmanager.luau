--// By @ThatOneTusk

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local MountsRegistry = _G.Registry.registry.Mounts

local ToggleMountRemote = ReplicatedStorage.Events.ToggleMount
local DataAPI = DataAccess:GetAPI()

local MountsManager = {}
local EquippedMountData: { [Player]: { Model: Model? }? } = {}

--// Gives the player a mount
-- TODO: Removing mounts?
function MountsManager:GiveMount(player: Player, Mount: string, amount: number?)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local MountsInventory = PlayerProfile:GetField("Inventory").Mounts

	amount = amount or 1

	if not MountsRegistry[Mount] then
		warn(`Invalid Mount {Mount}`)
		return
	end

	PlayerProfile:WriteDirectory(`Inventory/Mounts/{Mount}`, {
		Count = MountsInventory[Mount] and MountsInventory[Mount].Count + amount or amount,
	}, true)
end

--// Equips a mount
function MountsManager:EquipMount(player: Player, Mount: string)
	local character = player.Character or player.CharacterAdded:Wait()
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local MountsInventory = PlayerProfile:GetField("Inventory").Mounts
	local FoundMount = MountsRegistry[Mount]

	if not MountsInventory[Mount] or not FoundMount then
		return
	end

	MountsManager:UnequipMount(player)

	local MountModel = FoundMount:GetModel()

	player:SetAttribute("MountToggled", true)
	EquippedMountData[player] = {}

	if MountModel then
		local NewModel = MountModel:Clone()

		EquippedMountData[player].Model = NewModel

		for _, motor: Motor6D in NewModel:GetDescendants() do
			if not motor:IsA("Motor6D") or not character:FindFirstChild(motor.Name) then
				continue
			end

			local Limb = character:FindFirstChild(motor.Name)

			if not motor.Part0 then
				motor.Part0 = Limb
			elseif not motor.Part1 then
				motor.Part1 = Limb
			end
		end

		NewModel.Parent = character

		local MountObject = character:FindFirstChild("MountObject")
		if not MountObject then
			MountObject = Instance.new("ObjectValue")
			MountObject.Name = "MountObject"
			MountObject.Parent = character
		end
		MountObject.Value = NewModel
	end
end

--// Unequips their equipped mount
function MountsManager:UnequipMount(player: Player)
	local character = player.Character or player.CharacterAdded:Wait()

	player:SetAttribute("MountToggled", nil)

	if EquippedMountData[player] then
		if EquippedMountData[player].Model then
			EquippedMountData[player].Model:Destroy()
		end

		EquippedMountData[player] = nil
	end
end

--// Equip the player's equipped mounts
function MountsManager:characterAdded(player: Player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local EquippedMount = PlayerProfile:GetField("EquippedMount")

	if EquippedMount ~= "" then
		MountsManager:EquipMount(player, EquippedMount)
	end
end

--// Remove the player's equipped mount data
function MountsManager:playerRemoved(player: Player)
	if EquippedMountData[player] then
		EquippedMountData[player] = nil
	end
end

--//
function MountsManager:start()
	ToggleMountRemote.OnServerEvent:Connect(function(player)
		if player:GetAttribute("ToggleMountCooldown") then
			return
		end --// Avoid bad use

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local EquippedMount = PlayerProfile:GetField("EquippedMount")

		if EquippedMount ~= "" then
			player:SetAttribute("ToggleMountCooldown", true)

			task.delay(1, function()
				player:SetAttribute("ToggleMountCooldown", nil)
			end)

			if EquippedMountData[player] then
				MountsManager:UnequipMount(player)
			else
				MountsManager:EquipMount(player, EquippedMount)
			end
		end
	end)
end

return MountsManager
