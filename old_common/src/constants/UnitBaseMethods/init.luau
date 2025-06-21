local module = {
	PlaceIdBlacklist = {17046374415, 132521906070053, 72761785039317}
}

local Units = script.Parent.Units
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EnemyAPI = (RunService:IsServer() and not table.find(module.PlaceIdBlacklist, game.PlaceId)) and require(game:GetService("ServerScriptService"):WaitForChild("EnemyAPI", 10))
local ElementalSystem = require(ReplicatedStorage.Libs:WaitForChild("ElementHandler"))
local Tween = game:GetService("TweenService")
local VFXEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("VisualEffects")
local UnitAbilityRegistry
local BuffLib

local CachedStatusEffects = false

local TweenMaid = require(game.ReplicatedStorage.Libs.TweenMaid).new()

_G.UnitSkillModulesCache = {}

module.animations = {
	idle = "17893593497"
}
module.CachedStatusEffectNames = {}

function module:CacheAbilities()
	if not self.Abilities then
		self.Abilities = {}
	end
	
	if not table.find(module.PlaceIdBlacklist, game.PlaceId) then
		for _, AbilityModule in pairs(self.misc.ScriptLink:GetChildren()) do
			if AbilityModule:IsA("ModuleScript") then
				--print("cached ability", AbilityModule.Name)
				self.Abilities[AbilityModule.Name] = require(AbilityModule)
			end
		end
	end
end

local function GetCached(UnitName, SkillName)
	if (UnitName and UnitName ~= "") and (SkillName and SkillName ~= "") then
		if not _G.UnitSkillModulesCache[UnitName] then
			_G.UnitSkillModulesCache[UnitName] = {}
		end

		if not _G.UnitSkillModulesCache[UnitName][SkillName] then
			local FoundUnit = Units:FindFirstChild(UnitName)

			if FoundUnit then
				local FoundSkillModule = FoundUnit:FindFirstChild(SkillName)

				if FoundSkillModule then
					print("Cached and used")
					_G.UnitSkillModulesCache[UnitName][SkillName] = require(FoundSkillModule)
					return _G.UnitSkillModulesCache[UnitName][SkillName]
				end

				return warn("No module")
			end

			return warn("No unit")
		end

		print("Used cached")

		return _G.UnitSkillModulesCache[UnitName][SkillName]
	end
end

function module:GetModel(plr, UnitData)
	if UnitData and UnitData.Skin and UnitData.Skin ~= "" then
		local SkinName = UnitData.Skin.Name
		local SkinRegistry = _G.Registry.registry.Skins[SkinName]
		
		if SkinRegistry then
			if UnitData.Shiny and SkinRegistry.misc.ShinyModel ~= nil then
				return SkinRegistry.misc.ShinyModel
			end

			if SkinRegistry.misc.Model then
				return SkinRegistry.misc.Model
			end
		end	
	end
	
	if UnitData and UnitData.Shiny then
		return self.misc.ShinyModel or self.misc.Model
	end
	
	return self.misc.Model
end

function module:requireVFX(plr, unit, target)
	target = target.EnemyID

	VFXEvent:FireAllClients("RunVFX", script, plr, unit, target)
end

function module:requireFarmVFX(plr, unit)
	VFXEvent:FireAllClients("RunFarmVFX", script, plr, unit)
end

function module:syncedDamageRequest(plr, unit, targetList, additional)
	VFXEvent:FireAllClients("SyncedDmg", script, plr, unit, targetList, additional)
end

function module:checkForStatusFromPassives(unit: Model)
	for _, StatusName in module.CachedStatusEffectNames do
		local Status = unit:GetAttribute(`Passive{StatusName}`)
		if Status then
			return StatusName, Status
		end
	end
end

function module:onAttack(plr, unit, target, attackUID, IsCrit, CustomMulti, CritDamageBoost, CustomDamage)
	if not CachedStatusEffects then
		CachedStatusEffects = true
		for _, Status in game.ReplicatedStorage.Registry.StatusEffects:GetChildren() do
			if Status:IsA("ModuleScript") then
				table.insert(module.CachedStatusEffectNames, Status.Name)
			end
		end
	end
	
	if not BuffLib then
		BuffLib = require(ReplicatedStorage.Libs.BuffLib)
	end
	if not IsCrit then IsCrit = false end
	
	local function triggerStatusEffect()
		local StatusEff, _Duration = module:checkForStatusFromPassives(unit.modelLink)
		--print(StatusEff, _Duration)
		if type(_Duration) == "boolean" then
			_Duration = math.random(3,5)
		end
		--local _Duration =  StatusEff ~= nil and unit.configuration.AttackEffectDurationFromPassive or unit.configuration.AttackEffectDuration

		--if unit.configuration.AttackEffect ~= "" and _G.Registry.registry.StatusEffects[unit.configuration.AttackEffect] then
		--	_G.Registry.registry.StatusEffects[unit.configuration.AttackEffect]:OnServer(unit.modelLink, {target}, unit.configuration.AttackEffectDuration)
		--end

		--if not StatusEff then
		--	StatusEff = unit.configuration.AttackEffect
		--	_Duration = unit.configuration.AttackEffectDurationFromPassive or unit.configuration.AttackEffectDuration
		--end

		if unit.configuration.AttackEffect ~= "" and _G.Registry.registry.StatusEffects[unit.configuration.AttackEffect] then
			StatusEff = unit.configuration.AttackEffect
			_Duration = unit.configuration.AttackEffectDuration
		end

		local StatusEffect = StatusEff ~= "" and _G.Registry.registry.StatusEffects[StatusEff] 
		
		--print(StatusEffect)

		if StatusEffect then
			StatusEffect:OnServer(unit.modelLink, {target}, _Duration)
		end
	end
	
	task.defer(function()
		triggerStatusEffect()
		
		local UnitModelRef = unit.modelLink
		local _Damage = BuffLib:GetDamage(unit.modelLink) --unit.modelLink:GetAttribute(`BuffedDamage`)*unit.configuration.Damage
		
		
		if unit.HitCount then
			_Damage = BuffLib:GetSplitDamage(UnitModelRef, unit.HitCount) --tonumber(string.format("%.2f", _Damage/unit.HitCount))
		end
		
		local Damage = _Damage
		
		if unit.modelLink:HasTag("IgnoreElementsDebuff") and target.Elements[unit.modelLink.configuration.Element.Value] and target.Elements[unit.modelLink.configuration.Element.Value] < 0 then
			Damage = _Damage
		elseif not unit.modelLink:HasTag("IgnoreElements") then
			Damage = ElementalSystem:CheckElements(unit.modelLink, target.Elements, UnitModelRef.configuration.Element.Value, _Damage)
		end
		
		if IsCrit then
			Damage *= (1+BuffLib:GetCritDamage(unit.modelLink)) + (CritDamageBoost or 0)
		end
		
		if target.IsBoss then
			Damage *= BuffLib:GetDamageToBossMulti(unit.modelLink)
		end
		
		if CustomMulti then
			Damage *= CustomMulti
		end

		if CustomDamage then
			Damage = CustomDamage
		end
		
		Damage = math.round(Damage*100)/100
		
		EnemyAPI:DamageEnemy(target.EnemyID, Damage, attackUID, unit.modelLink)
		
		if UnitModelRef and UnitModelRef.Parent then
			UnitModelRef.configuration.TotalDamage.Value += Damage
		end
		
		if plr then
			plr.notSavable.damage.Value += Damage
		end
	end)
end

function module:specialAbility()
	
end

function module:runFarmVFX(plr, unit)
	if unit  then
		local UnitConfig = unit.configuration
		local Name = unit.Name
		unit = unit:WaitForChild("VisualModelLink").Value
		
		local RootUnit = unit:WaitForChild("RootModelLink").Value

		repeat task.wait() until unit:HasTag("Loaded")
		
		local Skin
		local SkinRegistry

		if RootUnit:HasTag("SkinVFX") then
			Skin = RootUnit:GetAttribute("SkinName")
			SkinRegistry = _G.Registry.registry.Skins[Skin]
		end

		local CachedSkillModule

		if Skin and SkinRegistry then
			local HasChangedVFX = SkinRegistry.configuration.SkinVFX[UnitConfig.Ability.Value]

			CachedSkillModule = _G.Registry.registry.Units[Name]["Abilities"][HasChangedVFX or UnitConfig.Ability.Value] 
		else
			CachedSkillModule =_G.Registry.registry.Units[Name]["Abilities"][UnitConfig.Ability.Value] 
		end

		--local CachedSkillModule = _G.Registry.registry.Units[Name]["Abilities"][UnitConfig.Ability.Value]  --GetCached(Name, UnitConfig.Ability.Value)
		
		if CachedSkillModule then
			CachedSkillModule:Effect({unit,unit.HumanoidRootPart,nil})
		end
	end
end

function module:onClientAttack(plr, unitRoot, target, additional)
	if unitRoot and target then
		local UnitConfig = unitRoot.configuration
		local Name = unitRoot.Name
		local unit = unitRoot:WaitForChild("VisualModelLink").Value
		
		--print("onClient1")
		
		repeat task.wait() until unit:HasTag("Loaded")
		
		local Origin = unit:GetPivot()
		
		local AOE = unit:FindFirstChild("AOE")
		if AOE then
			AOE.Event:Fire("EnemyChange", target)
		end
		
		local UnitPos, TargetPos = Origin, target.HumanoidRootPart.Position
		local NewCFrame = CFrame.lookAt(UnitPos.Position, Vector3.new(TargetPos.X, UnitPos.Y, TargetPos.Z))
		local Skin
		local SkinRegistry
		
		if unitRoot:HasTag("SkinVFX") then
			Skin = unitRoot:GetAttribute("SkinName")
			SkinRegistry = _G.Registry.registry.Skins[Skin]
		end
		
		local CachedSkillModule
			
		if Skin and SkinRegistry then
			local HasChangedVFX = SkinRegistry.configuration.SkinVFX[UnitConfig.Ability.Value]

			CachedSkillModule = _G.Registry.registry.Units[Name]["Abilities"][HasChangedVFX or UnitConfig.Ability.Value] 
		else
			CachedSkillModule =_G.Registry.registry.Units[Name]["Abilities"][UnitConfig.Ability.Value] 
		end
		
		--GetCached(Name, UnitConfig.Ability.Value)
		
		
		--print("onClient3")
		
		if CachedSkillModule then
			--print("onClient4")
			TweenMaid:GiveTask(unit.Name, Tween:Create(unit.HumanoidRootPart, TweenInfo.new(.3, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {["CFrame"] = NewCFrame})):onTaskEnd(function()
				if not _G.ClientSettings["UnitVFX"] then return end
				
				--if CachedSkillModule.config.HitDelay then
				--	task.delay(CachedSkillModule.config.HitDelay-., function()
				--		UnitPos, TargetPos = Origin, target.HumanoidRootPart.Position
				--		NewCFrame = CFrame.lookAt(UnitPos.Position, Vector3.new(TargetPos.X, UnitPos.Y, TargetPos.Z))
				--		--TweenMaid:GiveTask(unit.Name, Tween:Create(unit.HumanoidRootPart, TweenInfo.new(.15, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {["CFrame"] = NewCFrame}))
				--	end)
				--end
				
				CachedSkillModule:Effect({unit,unit.HumanoidRootPart,target.HumanoidRootPart})
				
				if unit and unit:FindFirstChild("HumanoidRootPart") then
					unit.HumanoidRootPart.CFrame = CFrame.new(unitRoot.HumanoidRootPart.Position) * NewCFrame.Rotation
				end
				--task.delay(1, function()
				--	unit.HumanoidRootPart.CFrame = CFrame.new(unitRoot.HumanoidRootPart.Position) * unit.HumanoidRootPart.CFrame.Rotation
				--end)
			end)
		end
	end
end

function module:onWave(plr, unit)
	warn("Wave", plr, unit)
end

function module:customizeVisuals(plr, unit)
end

function module:onPlace(plr, unit)
end

function module:onDelete(plr, unit)

end

return module
