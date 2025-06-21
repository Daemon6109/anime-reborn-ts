local Trait = {}
local replicated = game:GetService("ReplicatedStorage")
local GameVariables = replicated:WaitForChild("GameVariables")
local Enums = require(replicated.Libs.Enums)
local TempBuff
local UnitAPI
local BuffLib

setmetatable(Trait,{__index = require(replicated.Registry.TraitBaseMethods)})

Trait.configuration = {
	Name = "Demon",
	Description = [[
	<font color="rgb(94,255,0)">(+75%)</font> Damage Buff 
	<font color="rgb(0,115,255)">(+Speed Demon)</font>: For every 20 elimination stacks on this unit decrease SPA by 50% for 15 seconds. Reduces placelimit to 2.
]],
	Icon = "rbxassetid://123408658714528",

	Percentage = 0.3,
	LayoutOrder = 17,
	--================= Visuals ======================--------
	Glare = nil,
	Gradient = script.UIGradient,
	Impact  = nil,
	PassiveType = "StatBuff", --could be others -- what others? -tusim
	Buffs = {
		["Damage"] = 1.75, -- +5%
		["AttackSpeed"] = 1, -- -5%
		["Range"] = 1 -- +5%
	},
	BuffsData = {
		{
			AttackSpeed = 50/100,	
		},
	}, -- array of random buffs
	BuffDuration = 15,
	StacksNeeded = 20,
	MaxPlacementAmount = 2,
	Rarity = "Mythical"
}
local colors = {
	script.UIGradient.Color.Keypoints[1].Value,
	script.UIGradient.Color.Keypoints[2].Value

}


function Trait:OnKill(Unit)
	if not TempBuff then
		TempBuff = require(replicated.Libs.TemporaryBuffAPI)
		UnitAPI = require(game.ServerScriptService.UnitAPI)
		BuffLib = require(game.ReplicatedStorage.Libs.BuffLib)
	end
	
	if not Unit:GetAttribute("SpeedDemonBuffActive") then
		local CurrentStacks = Unit:GetAttribute("SpeedDemonStacks") or 0
		if CurrentStacks < Trait.configuration.StacksNeeded then
			Unit:SetAttribute("SpeedDemonStacks", CurrentStacks+1)
			
			if Unit:GetAttribute("SpeedDemonStacks") == Trait.configuration.StacksNeeded then
				Unit:SetAttribute("SpeedDemonBuffActive", true)
				TempBuff:ApplyBuff(Unit, Trait.configuration.BuffsData[1], Trait.configuration.BuffDuration)
				
				local BuffedStats = BuffLib:GetAllBuffedStats(Unit)
				UnitAPI:UpdateAttackCD(Unit, tick()+(BuffedStats.AttackSpeed ))

				task.delay(Trait.configuration.BuffDuration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
					Unit:SetAttribute("SpeedDemonStacks", 0)
					Unit:SetAttribute("SpeedDemonBuffActive", false)
				end)
			end
		end
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
