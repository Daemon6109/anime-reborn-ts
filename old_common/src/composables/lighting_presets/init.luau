--------------------------------------------------------------------------------
-- lighting_presets
-- Provides functions to manage and apply lighting presets in Roblox.
-- It includes functions to set lighting settings, tween lighting settings, create presets, and create presets from current settings.
--------------------------------------------------------------------------------

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local lighting_preset_constants = require("@self/lighting_preset_constants")
local lighting_preset_properties = require("@self/lighting_preset_properties")

--[=[
	Provides functions to manage and apply lighting presets in Roblox.

	@class LightingPresets
]=]
local LightingPresets = {}

--[=[
	Sets the lighting settings to the specified preset.

	@within LightingPresets
	@method setLighting
	@param preset Configuration -- The lighting preset to apply.

	```lua
	LightingPresets:setLighting(preset)
	```
]=]
function LightingPresets:setLighting(preset: Configuration)
	-- Remove any post effects not included in the preset
	for _, postEffect in Lighting:GetChildren() do
		if not preset:FindFirstChild(postEffect.Name) then
			postEffect:Destroy()
		end
	end

	-- Set lighting properties
	for _, property in lighting_preset_properties.Lighting do
		local value = preset:GetAttribute(property)
		if value == nil then
			continue
			-- Setting properties dynamically like this is unsafe and usually not recommended, as it can lead to runtime errors
			-- Since the list of properties we are accessing has been pre-set, this is not an issue here
			-- By casting Lighting to any, we avoid the warning about dynamic property access
		end
		(Lighting :: any)[property] = value
	end

	-- Set properties for any PostEffects, Ambience, Sky
	for _, postEffect in preset:GetChildren() do
		if lighting_preset_properties[postEffect.ClassName] then
			local lightingInstance = Lighting:FindFirstChild(postEffect.Name)
			if not lightingInstance then
				local clone = postEffect:Clone()
				clone.Parent = Lighting
				lightingInstance = clone
			end

			-- Set the instance properties
			for _, property in lighting_preset_properties[postEffect.ClassName] do
				-- Cast to any to avoid warnings about dynamic property access
				(lightingInstance :: any)[property] = (postEffect :: any)[property]
			end
		end
	end
end

--[=[
	Tweens the lighting settings to the specified preset.

	@within LightingPresets
	@method tweenLightingAsync
	@param preset Configuration -- The lighting preset to tween to.
	@param tweenTime number -- The duration of the tween.
	@param easingStyle Enum.EasingStyle? -- The easing style of the tween.
	@param easingDirection Enum.EasingDirection? -- The easing direction of the tween.

	```lua
	LightingPresets:tweenLightingAsync(preset, tweenTime, easingStyle, easingDirection)
	```
]=]
function LightingPresets:tweenLightingAsync(
	preset: Configuration,
	tweenTime: number,
	easingStyle: Enum.EasingStyle?,
	easingDirection: Enum.EasingDirection?
)
	-- Remove any post effects not included in the preset
	for _, postEffect in Lighting:GetChildren() do
		if not preset:FindFirstChild(postEffect.Name) then
			postEffect:Destroy()
		end
	end

	local tweenInfo = TweenInfo.new(
		tweenTime,
		easingStyle or lighting_preset_constants.DEFAULT_EASING_STYLE,
		easingDirection or lighting_preset_constants.DEFAULT_EASING_DIRECTION
	)

	-- Create a table of properties to tween
	local lightingProperties = {}
	for _, property in lighting_preset_properties.Lighting do
		local value = preset:GetAttribute(property)
		if value == nil then
			continue
		end
		if typeof(value) == "string" then
			-- Property is not tweenable, set it directly
			-- Cast to any to avoid warnings about dynamic property access
			(Lighting :: any)[property] = value
		else
			lightingProperties[property] = value
		end
	end

	-- Keep the sun from moving backwards through the sky
	if lighting_preset_constants.ENFORCE_CLOCK_DIRECTION then
		if lightingProperties.ClockTime and lightingProperties.ClockTime < Lighting.ClockTime then
			-- Since Lighting.ClockTime is clamped 0-24, we create a proxy NumberValue to tween.
			-- The value from this proxy is modulo'd and applied back to Lighting.ClockTime.
			local clockTime = lightingProperties.ClockTime
			lightingProperties.ClockTime = nil

			local clockTimeProxy = Instance.new("NumberValue")
			clockTimeProxy.Value = Lighting.ClockTime

			local connection = clockTimeProxy:GetPropertyChangedSignal("Value"):Connect(function()
				Lighting.ClockTime = clockTimeProxy.Value % 24
			end)

			local clockTimeTween = TweenService:Create(clockTimeProxy, tweenInfo, { Value = clockTime + 24 })
			clockTimeTween.Completed:Once(function()
				connection:Disconnect()
				clockTimeProxy:Destroy()
			end)
			clockTimeTween:Play()
		end
	end

	local lightingTween = TweenService:Create(Lighting, tweenInfo, lightingProperties)
	lightingTween:Play()

	-- Create and play tweens for any PostEffects, Ambience, Sky
	for _, postEffect in preset:GetChildren() do
		if lighting_preset_properties[postEffect.ClassName] then
			local lightingInstance = Lighting:FindFirstChild(postEffect.Name)
			-- If the instance doesn't exist already, clone it from the parent
			if not lightingInstance then
				local clone = postEffect:Clone()
				clone.Parent = Lighting
				lightingInstance = clone
			end

			local properties = {}
			for _, property in lighting_preset_properties[postEffect.ClassName] do
				-- Cast to any to avoid warnings about dynamic property access
				local value = (postEffect :: any)[property]
				if value == nil then
					continue
				end
				if typeof(value) == "string" then
					-- Property is not tweenable, set it directly
					-- Cast to any to avoid warnings about dynamic property access
					(lightingInstance :: any)[property] = value
				else
					properties[property] = value
				end
			end
			assert(lightingInstance, "Lighting instance not found for " .. postEffect.Name, 2)
			-- Create and play tween
			local tween = TweenService:Create(lightingInstance, tweenInfo, properties)
			tween:Play()
		end
	end

	task.wait(tweenTime)
end

--[=[
	Creates a lighting preset from a dictionary of properties and an array of instances.

	@within LightingPresets
	@method createPreset
	@param lightingProperties { [string]: any } -- A dictionary of lighting properties.
	@param lightingInstances { any }? -- An array of instances to include in the preset.
	@return Configuration -- The created lighting preset.

	```lua
	LightingPresets:createPreset(lightingProperties, lightingInstances)
	```
]=]
function LightingPresets:createPreset(lightingProperties: { [string]: any }, lightingInstances: { any }?): Configuration
	local preset = Instance.new("Configuration")

	for property, value in lightingProperties do
		if table.find(lighting_preset_properties.Lighting, property) then
			preset:SetAttribute(property, value)
		end
	end

	if lightingInstances then
		for _, postEffect in lightingInstances do
			postEffect.Parent = preset
		end
	end

	return preset
end

--[=[
	Creates a lighting preset from the current lighting properties.

	@within LightingPresets
	@method createPresetFromCurrentSettings
	@return Configuration -- The created lighting preset.

	```lua
	LightingPresets:createPresetFromCurrentSettings()
	```
]=]
function LightingPresets:createPresetFromCurrentSettings(): Configuration
	local lightingProperties: { [string]: any } = {}
	local lightingInstances: { Instance } = {}

	for _, property in lighting_preset_properties.Lighting do
		-- Cast to any to avoid warnings about dynamic property access
		lightingProperties[property] = (Lighting :: any)[property]
	end

	for _, child in Lighting:GetChildren() do
		if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Sky") then
			local clone = child:Clone()
			table.insert(lightingInstances, clone)
		end
	end

	return self:createPreset(lightingProperties, lightingInstances)
end

return LightingPresets
