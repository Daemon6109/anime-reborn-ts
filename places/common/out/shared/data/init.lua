-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local exports = {}
-- Main data exports for easy importing
-- Export the main data template and types
exports.DATA_TEMPLATE = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "data-template").DATA_TEMPLATE
-- Export all factory types
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "player-basic-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "player-statistics-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "player", "slotbar-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "economy", "currencies") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "economy", "currency-exchanger-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "inventory", "inventory-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "inventory", "summoning-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "events", "battlepass-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "events", "advent-calendar-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "daily-rewards-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "settings-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "receipt-history-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "missions", "mission-completion-data") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "factories", "misc-factories") or {} do
	exports[_k] = _v
end
-- Export utilities
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "utils", "testing") or {} do
	exports[_k] = _v
end
for _k, _v in TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "field-privacy-manifest") or {} do
	exports[_k] = _v
end
return exports
