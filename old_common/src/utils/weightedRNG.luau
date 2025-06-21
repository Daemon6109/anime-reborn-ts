--------------------------------------------------------------------------------
-- Weighted RNG Utility
-- Provides weighted random selection functionality
--------------------------------------------------------------------------------

--[=[
	Performs weighted random selection from a table of options.

	@param weightedTable { [any]: number } -- Table where keys are options and values are weights
	
	@return any -- The randomly selected key

	```lua
	local options = {
		CommonItem = 60,
		RareItem = 30, 
		EpicItem = 10,
	}
	local result = weightedRNG(options)
	```
]=]
local function weightedRNG(weightedTable: { [any]: number }): any
	local totalWeight = 0

	-- Calculate total weight
	for _, weight in pairs(weightedTable) do
		totalWeight += weight
	end

	if totalWeight <= 0 then
		error("Total weight must be greater than 0")
	end

	-- Generate random number between 0 and totalWeight
	local randomValue = math.random() * totalWeight
	local currentWeight = 0

	-- Find the selected item
	for item, weight in pairs(weightedTable) do
		currentWeight += weight
		if randomValue <= currentWeight then
			return item
		end
	end

	-- Fallback (should never reach here with valid input)
	local firstKey = next(weightedTable)
	return firstKey
end

return weightedRNG
