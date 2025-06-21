local module = {
	PlaceIdBlacklist = {17046374415, 132521906070053, 72761785039317}
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Collection = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local HTTP = game:GetService("HttpService")
local Events = ReplicatedStorage.Events
local IsServer = RunService:IsServer()
--_G.UnitSkillModulesCache = {}
local GameVariables = game:GetService("ReplicatedStorage"):WaitForChild("GameVariables")

local TempBuff
local BuffLib

--module.UnitAPI --= --(IsServer and not table.find(module.PlaceIdBlacklist, game.PlaceId)) and require(game:GetService("ServerScriptService"):WaitForChild("UnitAPI"))
--module.UnitHandler --= --(IsServer and not table.find(module.PlaceIdBlacklist, game.PlaceId)) and require(game.ServerScriptService.Services.UnitHandler)
--module.EnemyAPI --= --(IsServer and not table.find(module.PlaceIdBlacklist, game.PlaceId)) and require(game:GetService("ServerScriptService"):WaitForChild("EnemyAPI"))

module.TypeCallbacks = {
	
	["Stop"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup+self.configuration.Duration)
		
		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit)

			local Duration = self.configuration.Duration
			
			local Status = _G.Registry.registry.StatusEffects.Frozen
			
			if Status then
				Status:OnServer(Unit,self.configuration.IsGlobalAbility and AllNpcs or Npcs, Duration)
			end
		end)
	end,
	
	["WhisStop"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup+self.configuration.Duration)

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit)

			local Duration = self.configuration.Duration

			local Status = _G.Registry.registry.StatusEffects.Frozen

			if Status then
				Status:OnServer(Unit, AllNpcs, Duration)
			end
			
			Unit:SetAttribute("SpecialAbilityUsed", true)
			task.delay(5 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("SpecialAbilityUsed", false)
			end)
		end)
	end,
	
	["Slow"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup+self.configuration.Duration)

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit)

			local Duration = self.configuration.Duration
			local Status = _G.Registry.registry.StatusEffects.Slow

			if Status then
				Status:OnServer(Unit,self.configuration.IsGlobalAbility and AllNpcs or Npcs, Duration)
			end
		end)
	end,
	
	["Damage"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup+self.configuration.Duration)
		
		if not BuffLib then
			BuffLib = require(ReplicatedStorage.Libs.BuffLib)
		end
		
		local Damage = BuffLib:GetSplitDamage(Unit, self.HitConfig.HitCount)
		local TotalDamage = math.round((Damage*self.configuration.Multiplier)*100)/100

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			if self.configuration.CustomCallback then
				self.configuration.CustomCallback(Unit, Enemy)
			end
			
			for i = 1, self.HitConfig.HitCount do
				local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit, "First")
				--print("hey")

				local Constructs = {}

				for i, enemy in self.configuration.IsGlobalAbility and AllNpcs or Npcs do
					task.spawn(function()
						if self.configuration.Status and self.configuration.Status ~= "" then
							local _Duration =  self.configuration.StatusDuration
							local StatusEffect = _G.Registry.registry.StatusEffects[self.configuration.Status]

							if StatusEffect then
								StatusEffect:OnServer(Unit, {enemy.npc}, _Duration or 1)
							end
						end
					end)
					_G.EnemyAPI:DamageEnemy(enemy.npc.EnemyID, TotalDamage, HTTP:GenerateGUID(false), Unit)
					table.insert(Constructs,enemy.npc.EnemyID)
				end

				Events.VisualEffects:FireAllClients("DirectDamage",nil, nil, Unit, Constructs, TotalDamage)
				task.wait(self.HitConfig.MultihitDelay / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
			end
		end)
	end,
	
	["PercentDamage"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			for i = 1, self.HitConfig.HitCount do
				local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit, "First")

				for i, enemy in self.configuration.IsGlobalAbility and AllNpcs or Npcs do
					_G.EnemyAPI:DamageEnemy(enemy.npc.EnemyID, enemy.npc.MaxHealth * self.configuration.Percent, HTTP:GenerateGUID(false), Unit)
					Events.VisualEffects:FireAllClients("DirectDamage",nil, nil, Unit, {enemy.npc.EnemyID}, enemy.npc.MaxHealth * self.configuration.Percent)
				end
				task.wait(self.HitConfig.MultihitDelay / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
			end
		end)
	end,
	
	["CurrentPercentDamage"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local Npcs, AllNpcs = _G.UnitHandler:GetAvaliableSortedEnemies(Unit)
			--print("hey")

			for i, enemy in self.configuration.IsGlobalAbility and AllNpcs or Npcs do
				_G.EnemyAPI:DamageEnemy(enemy.npc.EnemyID, enemy.npc.Health * self.configuration.Percent, HTTP:GenerateGUID(false), Unit)
				Events.VisualEffects:FireAllClients("DirectDamage",nil, nil, Unit, {enemy.npc.EnemyID}, enemy.npc.Health * self.configuration.Percent)
			end
		end)
	end,
	
	["Buff"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)
		
		if not TempBuff then
			TempBuff = require(ReplicatedStorage.Libs.TemporaryBuffAPI)
		end

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()	
			local Allies = _G.UnitHandler:GetAllyUnitsInRange(Unit)
			local BuffData = self.configuration.BuffData
			local Duration = self.configuration.Duration
			
			TempBuff:BulkBuff(Allies, BuffData, Duration)
		end)
	end,
	
	["BuffByElement"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)

		if not TempBuff then
			TempBuff = require(ReplicatedStorage.Libs.TemporaryBuffAPI)
		end

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()	
			local Allies = _G.UnitHandler:GetAllyUnitsInRangeElement(Unit, Unit.configuration.Element.Value)
			local BuffData = self.configuration.BuffData
			local Duration = self.configuration.Duration
			
			table.insert(Allies, Unit)

			TempBuff:BulkBuff(Allies, BuffData, Duration)
		end)
	end,
	
	["SelfBuff"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)

		if not TempBuff then
			TempBuff = require(ReplicatedStorage.Libs.TemporaryBuffAPI)
		end

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local BuffData = self.configuration.BuffData
			local Duration = self.configuration.Duration

			TempBuff:BulkBuff({Unit}, BuffData, Duration)
		end)
	end,
	
	["Money"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)

		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local FarmOwner = Players:FindFirstChild(Unit.configuration.Owner.Value)
			if FarmOwner then
				local AbilityData = self.configuration.AbilityData
				local Reward = AbilityData.Money
				
				FarmOwner.notSavable.money.Value += Reward
				
				ReplicatedStorage.Events.VisualEffects:FireClient(FarmOwner, "DirectRun", ReplicatedStorage.Effects.MoneyEffect.Money, nil, nil, nil, {Unit, Reward, 1})
			end
		end)
	end,
	
	["Healing"] = function(self, Unit, Enemy)
		--_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		--_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		--_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup)
		
		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local AbilityData = self.configuration.AbilityData
			local HealType = AbilityData.Heal
			
			if type(HealType) == "string" then
				ReplicatedStorage.GameVariables.BaseHP.Value = math.min(ReplicatedStorage.GameVariables.BaseHP.Value+Unit.configuration[HealType].Value, ReplicatedStorage.GameVariables.BaseMaxHP.Value)
			elseif type(HealType) == "number" then
				ReplicatedStorage.GameVariables.BaseHP.Value = math.min(ReplicatedStorage.GameVariables.BaseHP.Value+HealType, ReplicatedStorage.GameVariables.BaseMaxHP.Value)
			end
		end)
	end,
	
	["OnTickCallback"] = function(self, Unit, Enemy)
		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local ID = _G.SpecialTick.add(nil, self.configuration.AbilityData.callback, Unit, self.configuration.AbilityData.onEndCallback)
			task.wait(self.configuration.Duration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
			_G.SpecialTick.remove(ID)
		end)
	end,
	
	["LoveTrain"] = function(self, Unit: Model, Enemy: {any})
		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local UUID = game.HttpService:GenerateGUID(false)
			_G.GlobalStopAtEnd = {Percent = self.configuration.Percent, EndAt = tick()+self.configuration.Duration, UUID = UUID}
			
			Unit:AddTag("InnateNoStun")
			Unit:AddTag("InnateNonTarget")

			local Timer = 0

			while Timer < self.configuration.Duration do
				if not Unit or not Unit.Parent then
					break
				end
				task.wait()
				Timer += 1/60
			end
			
			Unit:RemoveTag("InnateNoStun")
			Unit:RemoveTag("InnateNonTarget")

			if _G.GlobalStopAtEnd and _G.GlobalStopAtEnd.UUID == UUID then
				_G.GlobalStopAtEnd = nil
			end
		end)
	end,
	
	["StopNearBase"] = function(self, Unit: Model, Enemy: {any})
		task.delay(self.configuration.Windup / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			local UUID = game.HttpService:GenerateGUID(false)
			_G.GlobalStopAtEnd = {Percent = self.configuration.Percent, EndAt = tick()+self.configuration.Duration, UUID = UUID}
			
			local Timer = 0
			
			while Timer < self.configuration.Duration do
				if not Unit or not Unit.Parent then
					break
				end
				task.wait()
				Timer += 1/60
			end
			
			if _G.GlobalStopAtEnd and _G.GlobalStopAtEnd.UUID == UUID then
				_G.GlobalStopAtEnd = nil
			end
		end)
	end,
}

function module:onServer(Unit, Enemy)
	local FoundTypeCallback = self.TypeCallbacks[self.configuration.AbilityType]
	
	if FoundTypeCallback then
		_G.UnitAPI:SetTimedHyperArmorState(Unit, self.configuration.Windup+self.configuration.Duration)
		_G.UnitAPI:SetTimedBusyState(Unit, self.configuration.Windup)
		_G.UnitAPI:SetTimedUnsellableState(Unit, self.configuration.Windup+self.configuration.Duration)
		
		FoundTypeCallback(self, Unit, Enemy)
	end
end

function module:onClient(Unit, Enemy)
	local EnemyHRP = Enemy and Enemy:FindFirstChild("HumanoidRootPart")
	
	if not EnemyHRP then
		local FakeHRP = script.FakeHRP:Clone()
		FakeHRP.CFrame = Unit.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
		FakeHRP.Parent = workspace.Effects
		task.delay(5 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			FakeHRP:Destroy()
		end)
		require(self.configuration.Root.Visual):Effect({Unit, Unit.HumanoidRootPart, FakeHRP})
	else
		require(self.configuration.Root.Visual):Effect({Unit, Unit.HumanoidRootPart, EnemyHRP})
	end
end

return module
