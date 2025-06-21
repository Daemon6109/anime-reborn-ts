local Trait = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local TempBuff

setmetatable(Trait,{__index = require(replicated.Registry.TraitBaseMethods)})

Trait.configuration = {
	Name = "Paladin",
	Description = [[<font color="#5eff00">(+125%)</font> Damage Buff
<font color="#5eff00">(+10%)</font> Range Buff
<font color="#0073ff">(+God's Chosen)</font>: Every attack has a 15% chance to trigger a random buff on the unit for 10s. Reduces placelimit to 2.
]],
	Icon = "rbxassetid://124398438551313",

	Percentage = 0.2,
	LayoutOrder = 19,
	--================= Visuals ======================--------
	Glare = nil,
	Gradient = script.UIGradient,
	Impact  = nil,
	PassiveType = "BuffOnAttack", --could be others -- what others? -tusim
	Buffs = {
		["Damage"] = 2.25, -- +5%
		["AttackSpeed"] = 1  , -- -5%
		["Range"] = 1.10 -- +5%
	},
	BuffsData = {
		{
			Damage = 75/100,
		},
		{
			Range = 35/100,	
		},
		{
			AttackSpeed = 20/100,	
		},
	}, -- array of random buffs
	ActiveBuffDuration = 10, -- seconds
	MaxPlacementAmount = 2,
	Rarity = "Secret"
}
local colors = {
	script.UIGradient.Color.Keypoints[1].Value,
	script.UIGradient.Color.Keypoints[2].Value,
	script.UIGradient.Color.Keypoints[3].Value
}

function Trait:OnAttack(Unit)
	if not TempBuff then
		TempBuff = require(replicated.Libs.TemporaryBuffAPI)
	end
	
	if math.random(1, 100) <= 15 and not Unit:GetAttribute("PaladinBuffActive") then
		Unit:SetAttribute("PaladinBuffActive", true)
		TempBuff:ApplyBuff(Unit, Trait.configuration.BuffsData[math.random(1,#Trait.configuration.BuffsData)], Trait.configuration.ActiveBuffDuration)
		
		task.delay(Trait.configuration.ActiveBuffDuration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			Unit:SetAttribute("PaladinBuffActive", false)
		end)
	end
end

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
