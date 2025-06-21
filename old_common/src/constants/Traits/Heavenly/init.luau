local Trait = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Trait,{__index = require(replicated.Registry.TraitBaseMethods)})

Trait.configuration = {
	Name = "Heavenly",
	Description = [[<font color="rgb(94,255,0)">(+20%)</font> Damage Buff
<font color="rgb(0,115,255)">(+Ascension)</font>: Gains 5% range for every allied unit in range. Caps at 30%.]],
	Icon = "rbxassetid://96756049750964",

	Percentage = 0.5,
	LayoutOrder = 16,
	--================= Visuals ======================--------
	Glare = nil,
	Gradient = script.UIGradient,
	Impact  = nil,
	PassiveType = "AlliesInRange", --could be others -- what others? -tusim
	MaxStacks = 6,
	PercentPerStack = 0.05,
	Buffs = {
		["Damage"] = 1.2, -- +5%
		["AttackSpeed"] = 1 , -- -5%
		["Range"] = 1 -- +5%
	},
	Rarity = "Mythical"
}
local colors = {
	script.UIGradient.Color.Keypoints[1].Value,
	script.UIGradient.Color.Keypoints[2].Value
}

function Trait:CalculateUnitsInRange(Unit)
	local BuffLib = require(replicated.Libs.BuffLib)
	local FastVector = require(replicated.Libs.FastVector).new()
	
	if not Unit:GetAttribute("HeavenlyStacks") then
		Unit:SetAttribute("HeavenlyStacks", 0)
	end
	
	local InRangeCount = 0
	
	for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
		if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
			continue
		end
		
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local CurrentHeavenlyStacks = Unit:GetAttribute("HeavenlyStacks")
		
		if FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange and InRangeCount < Trait.configuration.MaxStacks then
			InRangeCount += 1
		end
	end
	
	local CurrentHeavenlyStacks = Unit:GetAttribute("HeavenlyStacks")
	Unit:SetAttribute("HeavenlyStacks", CurrentHeavenlyStacks+(InRangeCount-CurrentHeavenlyStacks))

	local CurrentMulti = Unit:GetAttribute("PermanentRangeMulti")

	Unit:SetAttribute("PermanentRangeMulti", CurrentMulti+(Trait.configuration.PercentPerStack*(InRangeCount-CurrentHeavenlyStacks)))
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
