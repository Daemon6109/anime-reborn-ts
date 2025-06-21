local Challenge = {
	DisplayName = "All Shields",
}

function Challenge:ApplyEffect(EnemyConfig)
	EnemyConfig.stats.Class = "Shield"
	if not EnemyConfig.stats["ShieldCharges"] then
		EnemyConfig.stats["ShieldCharges"] = 1
	else
		EnemyConfig.stats["ShieldCharges"] += 1
	end
	
	return EnemyConfig	
end

return Challenge
