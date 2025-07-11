local module = {}

local Maid = require(game.ReplicatedStorage.Maid).new()
local HTTP = game:GetService("HttpService")

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

function module:EquipTitle(Player, TitleName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	if not PlayerProfileClass then
		return
	end

	local PlayerInv = PlayerProfileClass:GetField("Inventory")
	local PlayerTitles = PlayerInv.Titles
	if not table.find(PlayerTitles, TitleName) then
		PlayerProfileClass:WriteField("CurrentTitle", "", true)
		return
	end

	--setting title
	PlayerProfileClass:WriteField("CurrentTitle", TitleName, true)
	--PlayerData.CurrentTitle.Value = TitleName
end

function module:GiveTitle(Player, TitleName)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
	if not PlayerProfileClass then
		return
	end

	--checking if player has the title
	local PlayerInv = PlayerProfileClass:GetField("Inventory")
	local PlayerTitles = PlayerInv.Titles
	if table.find(PlayerTitles, TitleName) then
		return
	end
	--giving title if player doesn't have it
	table.insert(PlayerTitles, TitleName)

	PlayerProfileClass:WriteDirectory("Inventory/Titles", PlayerTitles, true)
end

function module:start()
	--[[Maid:GiveTask("TitleRemote",TitleRemote.OnServerEvent,function(Player,TitleName)
		module:EquipTitle(Player,TitleName)
	end)]]
end

return module
