local module = {}

local Replicated = game:GetService("ReplicatedStorage")
local Maid = require(Replicated.Maid).new()
local Events = Replicated.Events

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

function module:SanityCheck(OldValue, NewValue) -- for client settings??? Why?
	if type(NewValue) == "number" then
		if NewValue ~= NewValue then
			NewValue = 0
		end

		return math.clamp(NewValue, 0, 1)
	elseif type(NewValue) == "boolean" then
		return NewValue
	end

	return nil
end

function module:start()
	Maid:GiveTask(nil, Events.SettingsEvent.OnServerEvent, function(Player, SettingTable)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(Player)

		local Data = PlayerProfile:GetField("Settings")
		for i, v in SettingTable do
			if Data[i] ~= nil then
				local NewValue = self:SanityCheck(Data[i], v)
				if NewValue == nil then
					print("IT'S NIL")
					return
				end
				Data[i] = NewValue
			end
		end

		PlayerProfile:WriteField("Settings", Data, true)
	end)
end

return module
