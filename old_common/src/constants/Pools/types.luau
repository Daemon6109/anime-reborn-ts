--------------------------------------------------------------------------------
-- Pool Types
-- Type definitions for pool structures
--------------------------------------------------------------------------------

--[=[
	@interface PoolReward
	@within PoolTypes
	.Quantity number -- The quantity of the reward
	.Chance number -- The percentage chance of receiving this reward
	.Rewards { [string]: PoolReward }? -- Sub-rewards for nested pools
]=]
export type PoolReward = {
	Quantity: number,
	Chance: number,
	Rewards: { [string]: PoolReward }?,
}

--[=[
	@interface PoolData
	@within PoolTypes
	.Units { [string]: PoolReward }? -- Unit rewards
	.Items { [string]: PoolReward }? -- Item rewards  
	.Currencies { [string]: PoolReward }? -- Currency rewards
	.Skins { [string]: PoolReward }? -- Skin rewards
	.Guaranteed { [string]: { [string]: number } }? -- Guaranteed rewards
]=]
export type PoolData = {
	Units: { [string]: PoolReward }?,
	Items: { [string]: PoolReward }?,
	Currencies: { [string]: PoolReward }?,
	Skins: { [string]: PoolReward }?,
	Guaranteed: { [string]: { [string]: number } }?,
}

--[=[
	@interface PoolModule
	@within PoolTypes
	.Get () -> PoolData -- Function that returns pool data
]=]
export type PoolModule = {
	Get: () -> PoolData,
}

return {}
