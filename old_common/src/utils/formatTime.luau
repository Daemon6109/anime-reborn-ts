--[=[
	Takes a number of seconds and returns a string formatted as '0d 0h 0m 0s'
]=]

local MINUTE_SECONDS = 60
local HOUR_SECONDS = MINUTE_SECONDS * 60
local DAY_SECONDS = HOUR_SECONDS * 24

--[=[
	Formats the given time remaining in seconds into a human-readable string.

	@param timeRemaining number - The time remaining in seconds. Must be greater than or equal to 0 and less than infinity.

	@return string - A formatted string representing the time remaining in days, hours, minutes, and seconds.
	
	@error "timeRemaining must be greater than 0 and less than inf" - Will throw an error if timeRemaining is less than 0 or greater than infinity.

	```lua
	formatTimeRemaining(3661) -> "1h 1m 1s"
	formatTimeRemaining(86400) -> "1d 0h 0m 0s"
	formatTimeRemaining(0) -> "0s"
	```
]=]
local function formatTimeRemaining(timeRemaining: number)
	assert(timeRemaining >= 0 and timeRemaining ~= math.huge, "timeRemaining must be greater than 0 and less than inf")

	local days = math.floor(timeRemaining / DAY_SECONDS)
	timeRemaining -= days * DAY_SECONDS
	local hours = math.floor(timeRemaining / HOUR_SECONDS)
	timeRemaining -= hours * HOUR_SECONDS
	local minutes = math.floor(timeRemaining / MINUTE_SECONDS)
	timeRemaining -= minutes * MINUTE_SECONDS
	local seconds = timeRemaining

	local str = string.format("%ds", seconds)
	if minutes > 0 or hours > 0 or days > 0 then
		str = string.format("%dm %s", minutes, str)
	end
	if hours > 0 or days > 0 then
		str = string.format("%dh %s", hours, str)
	end
	if days > 0 then
		str = string.format("%dd %s", days, str)
	end

	return str
end

return formatTimeRemaining
