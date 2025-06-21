local Trait = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Trait,{__index = require(replicated.Registry.TraitBaseMethods)})
Trait.configuration = {
	Name = "Miracle III",
	Description = [[<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-20%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1. 
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
]],
	Icon = "rbxassetid://97553106305715",

	Percentage = 0.025,
	LayoutOrder = 20,
	--================= Visuals ======================--------
	Glare = nil,
	Gradient = script.UIGradient,
	Impact  = nil,
	PassiveType = "StatBuff", --could be others -- what others? -tusim
	Buffs = {
		["Damage"] = 4, -- +5%
		["AttackSpeed"] = .8 ,
		["Range"] = 1.2 -- +5%
	},
	MaxPlacementAmount = 1,
	Rarity = "Secret"
}
local colors = {
	script.UIGradient.Color.Keypoints[1].Value,
	script.UIGradient.Color.Keypoints[2].Value,
	script.UIGradient.Color.Keypoints[3].Value

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
