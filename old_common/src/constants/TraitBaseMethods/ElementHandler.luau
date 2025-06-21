local ElementalSystem = {}
local Enabled = game.ReplicatedStorage.Registry.ElementalModifiers.ElementalSystemEnabled.Value
local Enums = require(game.ReplicatedStorage.Libs.Enums)
local elements = {
	["Netural"] = {
		["StrongAgainst"] = {},
		["WeakAgainst"] = {}
	},
	["Water"] = {
		["StrongAgainst"] = {"Fire"},
		["WeakAgainst"] = {"Wind", "Angelic"}
	},
	["Fire"] = {
		["StrongAgainst"] = {"Earth"},
		["WeakAgainst"] = {"Water", "Angelic"}
	},
	["Earth"] = {
		["StrongAgainst"] = {"Wind"},
		["WeakAgainst"] = {"Fire", "Angelic"}
	},
	["Wind"] = {
		["StrongAgainst"] = {"Water"},
		["WeakAgainst"] = {"Earth", "Angelic"}
	},
	["Dark"] = {
		["StrongAgainst"] = {"Light"},
		["WeakAgainst"] = {"Angelic"}
	},
	["Light"] = {
		["StrongAgainst"] = {"Dark"},
		["WeakAgainst"] = {"Angelic"}
	},
	["Angelic"] = {
		["StrongAgainst"] = {"Everything"},
		["WeakAgainst"] = {"Demonic"}
	},
	["Demonic"] = {
		["StrongAgainst"] = {"Everything"},
		["WeakAgainst"] = {"Angelic"}
	}
}


















































local function isStrongAgainst(attackerElement: Enums.Elements, targetElement: Enums.Elements)
	if attackerElement == "Angelic" or targetElement == "Demonic" then return true end
	if not elements[attackerElement] or not elements[targetElement] then return false end
	
	local strongAgainst = elements[attackerElement]["StrongAgainst"]
	for _, element in ipairs(strongAgainst) do
		if element == targetElement then
			return true
		end
	end
	return false
end

local function isWeakAgainst(attackerElement: Enums.Elements, targetElement: Enums.Elements)
	if targetElement == "Angelic" or targetElement == "Demonic" then return true end
	if not elements[attackerElement] or not elements[targetElement] then return false end
	
	local weakAgainst = elements[attackerElement]["WeakAgainst"]
	for _, element in ipairs(weakAgainst) do
		if element == targetElement then
			return true
		end
	end
	return false
end

function ElementalSystem.calculateDamage(attackerElement: Enums.Elements, targetElement: Enums.Elements, damage: number)
	local path = game.ReplicatedStorage.Registry.ElementalModifiers[attackerElement]
	local modifiedDamage = damage
	
	local buffModifier = path.DamageBuff.Value 
	local debuffModifier = path.DamageDebuff.Value 
	
	if isStrongAgainst(attackerElement, targetElement) and Enabled then
		
		if buffModifier > 0 then
			modifiedDamage += modifiedDamage * buffModifier / 100 -- damage buff
		elseif buffModifier < 0 then
			modifiedDamage -= modifiedDamage * math.abs(buffModifier) / 100 -- damage reduction
		end
		
	elseif isWeakAgainst(attackerElement, targetElement) and Enabled then
		
		if debuffModifier > 0 then
			modifiedDamage -= modifiedDamage * debuffModifier / 100 -- damage reduction
		elseif debuffModifier < 0 then
			modifiedDamage += modifiedDamage * math.abs(debuffModifier) / 100 -- damage buff
		end
		
	end

	return modifiedDamage
end

return ElementalSystem
