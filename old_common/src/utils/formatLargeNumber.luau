type LargeNumberFormat = { denom: number, letter: string }

local FORMATS: { LargeNumberFormat } = {
	{
		denom = 1_000_000_000_000,
		letter = "T",
	},
	{
		denom = 1_000_000_000,
		letter = "B",
	},
	{
		denom = 1_000_000,
		letter = "M",
	},
	{
		denom = 1_000,
		letter = "K",
	},
}

--[=[
    Formats a large number into a more readable string with appropriate suffix.
    
    @param num number - The number to format.
    @return string - The formatted number as a string.
]=]
local function formatLargeNumber(num: number): string
	for _, format in FORMATS do
		if num >= format.denom then
			return string.format("%.2f%s", num / format.denom, format.letter)
		end
	end

	return tostring(num)
end

return formatLargeNumber
