--// @bravobravo909
local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local EffectsData = require(ReplicatedStorage.Registry.EffectsData)

function module:playerJoined(player: Player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local effects = PlayerProfile:GetField("Effects")

	for effect, data in effects do
		data.StartTime = DateTime.now().UnixTimestamp
	end
	PlayerProfile:WriteField("Effects", effects, true)
end

function module:playerRemoved(player: Player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local effects = PlayerProfile:GetField("Effects")
	local currentTime = DateTime.now().UnixTimestamp

	for effect, data in effects do
		if module:IsEffectActive(player, effect) then
			print("Play Time " .. currentTime - data.StartTime)
			data.Duration = (data.StartTime + data.Duration) - currentTime
			--print(data.Duration)
		else
			effects[effect] = nil
		end
	end
	PlayerProfile:WriteField("Effects", effects, true)
end

--// Apply Effects
--// @bravobravo909
function module:ApplyEffect(player: Player, effect: string, span: number)
	--print("ello")
	if EffectsData[effect] then
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local effects = PlayerProfile:GetField("Effects")
		local newTable

		local _foundEffect = effects[effect]

		if self:IsEffectActive(player, effect) then
			newTable = table.clone(effects[effect])
			newTable = {
				Duration = effects[effect].Duration + span,
				StartTime = effects[effect].StartTime,
			}
		else
			newTable = {
				Duration = span,
				StartTime = DateTime.now().UnixTimestamp,
			}
		end
		PlayerProfile:WriteDirectory(`Effects/{effect}`, newTable, true)
	end
end

function module:RevokeEffect(player: Player, effect: string)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local effects = PlayerProfile:GetField("Effects")
	if effects[effect] then
		PlayerProfile:WriteDirectory(`Effects/{effect}`, nil, true)
	end
end

function module:IsEffectActive(player: Player, effect: string)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local effects = PlayerProfile:GetField("Effects")

	if effects[effect] then
		return (effects[effect].StartTime + effects[effect].Duration) > DateTime.now().UnixTimestamp
	else
		return false
	end
end

function module:GetAllActiveEffects(player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

	local allEffects = PlayerProfile:GetField("Effects")
	local toReturn = {}
	for effect, _data in allEffects do
		if module:IsEffectActive(player, effect) then
			toReturn[effect] = _data
		end
	end
	return toReturn
end

function module:CalculateMultiplier(player: Player, Type: "BannerLuck" | "ExpBoost" | "ShinyBoost" | "DropChanceBoost")
	local activeEffects = self:GetAllActiveEffects(player)
	local multiplier = 1
	for effect, data in activeEffects do
		if EffectsData[effect] then
			for mltName, mlt in EffectsData[effect].Multiplier do
				if mltName == Type then
					multiplier += (mlt - 1)
				end
			end
		end
	end

	return multiplier
end

function module:start()
	for _, v in game.Players:GetChildren() do
		module:playerJoined(v)
	end
	game.Players.PlayerAdded:Connect(function(player: Player)
		module:playerJoined(player)
	end)
end

return module
