local Trait = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Trait,{__index = require(replicated.Registry.TraitBaseMethods)})

Trait.configuration = {
	Name = "Slayer",
	Description = [[
	<font color="rgb(94,255,0)">(+25%)</font> Damage
	<font color="rgb(0,115,255)">(+Giant Slayer)</font>: Increases damage dealt to the enemy by 1% for every 2% of their missing HP.
	]],
	Icon = "rbxassetid://122894289710062",

	Percentage = 0.6,
	LayoutOrder = 15,
	--================= Visuals ======================--------
	Glare = nil,
	Gradient = script.UIGradient,
	Impact  = nil,
	PassiveType = "MissingHPDamageIncrease", --could be others -- what others? -tusim
	PassiveData = {
		DamageMultiplierPerMissingHP = 1,
		PerMissingHP = 0.02,
	},
	Buffs = {
		["Damage"] = 1.25, -- +5%
		["AttackSpeed"] = 1, -- -5%
		["Range"] = 1 -- +5%
	},
	Rarity = "Mythical"
}

function Trait:GetDamageIncrease(_Unit, _Enemy)
	local HP, MaxHP = _Enemy.Health, _Enemy.MaxHealth
	local DamageMultiplierPerMissingHP = Trait.configuration.PassiveData.DamageMultiplierPerMissingHP
	local PerMissingHP = Trait.configuration.PassiveData.PerMissingHP
	local Multiplier = MaxHP*PerMissingHP
	local MissingMulti = (1+((MaxHP-HP)/Multiplier)/100*DamageMultiplierPerMissingHP)
	--print(debug.traceback())
	return MissingMulti
end

local colors = {
	script.UIGradient.Color.Keypoints[1].Value,
	script.UIGradient.Color.Keypoints[2].Value
}
function Trait:AnimateGradient(gradient, dt)
	local num_colors = #colors
	local color_length = 1 / num_colors
	local period = 3 
	local progress = (tick() % period) / period 
	local newColors = {}
	local wrapColor = false

	for i = 1, num_colors + 1 do 
		local color = colors[i] or colors[i-num_colors]
		local position = progress + (i-1)/num_colors 

		if position > 1 then position = position - 1 end 
		if position == 0 or position == 1 then wrapColor = true end 

		table.insert(newColors, ColorSequenceKeypoint.new(position, color))
	end

	if not wrapColor then 
		local indexProgress = ((1 - progress) / color_length) + 1
		local col1 = colors[math.floor(indexProgress)]
		local col2 = colors[math.ceil(indexProgress)] or colors[1]
		local finalCol = col1:Lerp(col2, indexProgress % 1) 

		table.insert(newColors, ColorSequenceKeypoint.new(0, finalCol))
		table.insert(newColors, ColorSequenceKeypoint.new(1, finalCol))
	end

	table.sort(newColors, function(a, b)
		return a.Time < b.Time
	end)
	newColors[1]= ColorSequenceKeypoint.new(0, newColors[1].Value) 
	newColors[#newColors]= ColorSequenceKeypoint.new(1, newColors[#newColors].Value) 

	gradient.Color = ColorSequence.new(newColors)
end

return Trait
