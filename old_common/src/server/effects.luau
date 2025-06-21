--------------------------------------------------------------------------------
-- effects
--------------------------------------------------------------------------------

local EffectsData = require("@registry/EffectsData")
local Person = require("@commonserver/person")

local version = { major = 1, minor = 0, patch = 0 }

--[=[
	Effects module for managing player effects in the game.
	
	@class Effects
]=]
local Effects = {}

type Person = Person.Person

--[=[
	Applies an effect to a player.

	@within Effects
	
	@param person Person -- The person to apply the effect to
	@param effect Multiplier -- The effect name
	@param span number -- Duration in seconds
	
	```lua
	Effects:ApplyEffect(person, "ExpBoost", 3600)
	```
]=]
function Effects:ApplyEffect(person: Person, effect: Multiplier, span: number): ()
	if not EffectsData[effect] then
		warn(`Invalid effect: {effect}`)
		return
	end
	person.dataCache(function(dataCache)
		local effects = dataCache.Effects
		local newTable
		if Effects:IsEffectActive(person, effect) then
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
		dataCache.Effects[effect] = newTable
		return dataCache
	end)
end

--[=[
	Revokes an effect from a player.

	@within Effects
	
	@param person Person -- The person to revoke the effect from
	@param effect Multiplier -- The effect name
	
	```lua
	Effects:RevokeEffect(person, "ExpBoost")
	```
]=]
function Effects:RevokeEffect(person: Person, effect: Multiplier): ()
	person.dataCache(function(dataCache)
		local effects = dataCache.Effects
		if effects[effect] then
			effects[effect] = nil
		end
		return dataCache
	end)
end

--[=[
	Checks if an effect is currently active for a player.

	@within Effects
	
	@param person Person -- The person to check
	@param effect Multiplier -- The effect name

	@return boolean -- Whether the effect is active
	
	```lua
	local isActive = Effects:IsEffectActive(person, "ExpBoost")
	```
]=]
function Effects:IsEffectActive(person: Person, effect: Multiplier): boolean
	local dataCache = person.dataCache()
	local effects = dataCache.Effects
	if effects[effect] then
		return (effects[effect].StartTime + effects[effect].Duration) > DateTime.now().UnixTimestamp
	else
		return false
	end
end

--[=[
	Gets all active effects for a player.

	@within Effects
	
	@param person Person -- The person to get effects for
	@return { [Multiplier]: EffectData } -- Dictionary of active effects
	
	```lua
	local activeEffects = Effects:GetAllActiveEffects(person)
	```
]=]
function Effects:GetAllActiveEffects(person: Person): { [Multiplier]: EffectData }
	local dataCache = person.dataCache()
	local allEffects = dataCache.Effects
	local toReturn = {} :: { [Multiplier]: EffectData }

	for effect, data in pairs(allEffects) do
		if Effects:IsEffectActive(person, effect :: any) then
			toReturn[effect :: any] = data
		end
	end

	return toReturn
end

--[=[
	Calculates the total multiplier for a specific type from all active effects.

	@within Effects
	
	@param person Person -- The person to calculate for
	@param multiplierType Multiplier -- The type of multiplier to calculate

	@return number -- The total multiplier value
	
	```lua
	local multiplier = Effects:CalculateMultiplier(person, "ExpBoost")
	```
]=]
function Effects:CalculateMultiplier(person: Person, multiplierType: Multiplier): number
	local activeEffects = self:GetAllActiveEffects(person)
	local multiplier = 1

	for effect, data in pairs(activeEffects) do
		if EffectsData[effect] and EffectsData[effect].Multiplier then
			for mltName: Multiplier, mlt: number in pairs(EffectsData[effect].Multiplier) do
				if mltName == multiplierType then
					multiplier += (mlt - 1)
				end
			end
		end
	end

	return multiplier
end

--[=[
	Initializes the effects system.
	
	```lua
	Effects.init()
	```
]=]
local function init(): ()
	-- Connect to person events using Shingo signals
	Person.personAdded:connect(function(person: Person.Person)
		person.dataCache(function(dataCache)
			for effect, data in pairs(dataCache.Effects) do
				data.StartTime = DateTime.now().UnixTimestamp
			end
			return dataCache
		end)
	end)
	Person.personRemoved:connect(function(person: Person.Person)
		person.dataCache(function(dataCache)
			local currentTime = DateTime.now().UnixTimestamp
			for effect, data in pairs(dataCache.Effects) do
				if Effects:IsEffectActive(person, effect :: any) then
					data.Duration = (data.StartTime + data.Duration) - currentTime
				else
					dataCache.Effects[effect :: any] = nil
				end
			end
			return dataCache
		end)
	end)
end

return {
	version = version,

	-- Functions
	init = init,
	ApplyEffect = Effects.ApplyEffect,
	RevokeEffect = Effects.RevokeEffect,
	IsEffectActive = Effects.IsEffectActive,
	GetAllActiveEffects = Effects.GetAllActiveEffects,
	CalculateMultiplier = Effects.CalculateMultiplier,
}
