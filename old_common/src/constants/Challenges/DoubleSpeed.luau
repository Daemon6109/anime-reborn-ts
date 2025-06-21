local Challenge = {
	DisplayName = "x2 Speed",
}

function Challenge:ApplyEffect(EnemyConfig)
	EnemyConfig.stats.Speed *= 2
	
	return EnemyConfig	
end

return Challenge
