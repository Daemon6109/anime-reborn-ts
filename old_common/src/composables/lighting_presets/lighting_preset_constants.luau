local CONSTANTS = {
	-- When set to true, ClockTime will not be able to run backwards while tweening between presets
	ENFORCE_CLOCK_DIRECTION = true,
	DEFAULT_EASING_STYLE = Enum.EasingStyle.Linear,
	DEFAULT_EASING_DIRECTION = Enum.EasingDirection.Out,
}

table.freeze(CONSTANTS) -- Prevent accidental modification

return CONSTANTS
