local Challenge = {
	DisplayName = "x2 HP",
}

function Challenge:ApplyEffect(EnemyConfig)
	EnemyConfig.stats.HealthMultiplier *= 2
	
	return EnemyConfig	
end

return Challenge
