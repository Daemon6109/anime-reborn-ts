--------------------------------------------------------------------------------
-- Pool Factory
-- Factory function for creating type-safe pool modules
--------------------------------------------------------------------------------

local PoolTypes = require("./types")

type PoolData = PoolTypes.PoolData
type PoolModule = PoolTypes.PoolModule

--[=[
	Creates a type-safe pool module with the provided data.

	@param poolData PoolData -- The pool data structure
	@return PoolModule -- A pool module with Get function

	```lua
	local myPool = createPool({
		Units = {
			TestUnit = { Quantity = 1, Chance = 50 },
		},
		Items = {
			TestItem = { Quantity = 2, Chance = 25 },
		},
		Guaranteed = {
			Currency = { Gold = 100 },
		},
	})
	```
]=]
local function createPool(poolData: PoolData): PoolModule
	return {
		Get = function(): PoolData
			return poolData
		end,
	}
end

return createPool
