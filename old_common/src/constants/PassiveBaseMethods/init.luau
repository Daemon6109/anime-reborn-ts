local module = {}

function module:OnServerTick(...): (any?)
	return self.callbacks:onServerTick(...)
end

function module:OnWave(...): (any?)
	return self.callbacks:onWave(...)
end

function module:OnPlace(...): (any?)
	return self.callbacks:onPlace(...)
end

function module:OnKill(...): (any?)
	return self.callbacks:onKill(...)
end

function module:OnUnitsInRange(...): (any?)
	return self.callbacks:onUnitsInRange(...)
end

function module:OnRemove(...): (any?)
	return self.callbacks:onRemove(...)
end

function module:OnAttack(...): (any?)
	return self.callbacks:onAttack(...)
end

function module:OnAttackEnded(...): (any?)
	return self.callbacks:onAttackEnded(...)
end

function module:OnSpecialAbility(...): (any?)
	return self.callbacks:onSpecialAbility(...)
end

function module:OnConditionalDamage(...): (any?)
	return self.callbacks:onConditionalDamage(...)
end

function module:OnCriticalHit(...): (any?)
	return self.callbacks:onCriticalHit(...)
end

function module:OnBeforeStun(...): (any?)
	return self.callbacks:onBeforeStun(...)
end

function module:OnStunned(...): (any?)
	return self.callbacks:onStunned(...)
end

function module:OnStunEnded(...): (any?)
	return self.callbacks:onStunEnded(...)
end

function module:OnAllyStunned(...): (any?)
	return self.callbacks:onAllyStunned(...)
end

function module:OnAllyStunEnded(...): (any?)
	return self.callbacks:onAllyStunEnded(...)
end

function module:OnAllyAttack(...): (any?)
	return self.callbacks:onAllyAttack(...)
end

function module:OnAllyKill(...): (any?)
	return self.callbacks:onAllyKill(...)
end

function module:OnAnyKill(...): (any?)
	return self.callbacks:onAnyKill(...)
end

return module
