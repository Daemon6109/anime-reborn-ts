-- Compiled with roblox-ts v2.3.0
-- Inventory data factory
local function createInventoryData()
	return {
		Units = {},
		Items = {},
		Titles = {},
		Mounts = {},
		Skins = {},
		MaxUnitStorage = 100,
	}
end
return {
	createInventoryData = createInventoryData,
}
