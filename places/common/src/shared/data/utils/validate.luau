--------------------------------------------------------------------------------
-- Data Validation Utility

-- This module provides functions to validate data against the strict type definitions
-- from our factory modules. It's especially useful for validating data that comes from
-- external sources like network or storage.
--------------------------------------------------------------------------------

local function validateType(value: any, expectedType: string): (boolean, string?)
	local valueType = typeof(value)

	if valueType ~= expectedType then
		return false, string.format("Expected type %s, got %s", expectedType, valueType)
	end

	return true
end

local function validateTable(value: any, template: { [string]: any }): (boolean, string?)
	if typeof(value) ~= "table" then
		return false, string.format("Expected table, got %s", typeof(value))
	end

	for key, expectedValue in pairs(template) do
		if value[key] == nil then
			return false, string.format("Missing required field '%s'", key)
		end

		local valueType = typeof(value[key])
		local expectedType = typeof(expectedValue)

		if valueType ~= expectedType then
			return false, string.format("Field '%s': expected type %s, got %s", key, expectedType, valueType)
		end

		if expectedType == "table" then
			local isValid, errorMessage = validateTable(value[key], expectedValue)
			if not isValid and errorMessage then
				return false, string.format("Field '%s': %s", key, errorMessage)
			end
		end
	end

	return true
end

local function validateDataSection<T>(data: any, createTemplate: () -> T): (boolean, string?)
	if typeof(data) ~= "table" then
		return false, string.format("Expected table, got %s", typeof(data))
	end

	local template = createTemplate()
	return validateTable(data, (template :: any) :: { [string]: any })
end

local function validatePlayerData(playerData: any, dataTemplate: any): (boolean, { [string]: string })
	local errors = {}

	for key, templateValue in pairs(dataTemplate) do
		local playerValue = playerData[key]

		if playerValue == nil then
			errors[key] = string.format("Missing required field '%s'", key)
		else
			local valueType = typeof(playerValue)
			local templateType = typeof(templateValue)

			if valueType ~= templateType then
				errors[key] = string.format("Expected type %s, got %s", templateType, valueType)
			elseif templateType == "table" then
				local isValid, errorMessage = validateTable(playerValue, templateValue)
				if not isValid and errorMessage then
					errors[key] = errorMessage
				end
			end
		end
	end

	return next(errors) == nil, errors
end

return {
	validateType = validateType,
	validateTable = validateTable,
	validateDataSection = validateDataSection,
	validatePlayerData = validatePlayerData,
}
