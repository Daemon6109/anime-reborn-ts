-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- Data validation utilities for ensuring data integrity
local DEFAULT_DATA_TEMPLATE = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "types", "data-template").DEFAULT_DATA_TEMPLATE
local function validateDataSection(data, templateFactory)
	local _exitType, _returns = TS.try(function()
		local template = templateFactory()
		local _data = data
		if typeof(_data) ~= "table" then
			return TS.TRY_RETURN, { { false, "Data must be a table" } }
		end
		-- Basic validation - check if required fields exist
		local dataTable = data
		local templateTable = template
		for key, templateValue in pairs(templateTable) do
			local dataValue = dataTable[key]
			if dataValue == nil and templateValue ~= nil then
				return TS.TRY_RETURN, { { false, `Missing required field: {key}` } }
			end
			if dataValue ~= nil and typeof(dataValue) ~= typeof(templateValue) then
				return TS.TRY_RETURN, { { false, `Type mismatch for field {key}: expected {typeof(templateValue)}, got {typeof(dataValue)}` } }
			end
		end
		return TS.TRY_RETURN, { { true } }
	end, function(error)
		return TS.TRY_RETURN, { { false, `Validation error: {error}` } }
	end)
	if _exitType then
		return unpack(_returns)
	end
end
local function isValidDataTemplate(data)
	local _binding = validateDataSection(data, function()
		return DEFAULT_DATA_TEMPLATE
	end)
	local isValid = _binding[1]
	return isValid
end
return {
	validateDataSection = validateDataSection,
	isValidDataTemplate = isValidDataTemplate,
}
