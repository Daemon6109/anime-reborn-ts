local Challenge = {
	DisplayName = "All Regenerate",
}

function Challenge:ApplyEffect(EnemyConfig)
	--EnemyConfig.stats.Class = "Regenerate"
	if not EnemyConfig.stats["Regen"] then
		EnemyConfig.stats["Regen"] = 5/100
		EnemyConfig.stats["RegenDelay"] = 10
	else
		EnemyConfig.stats["Regen"] += 3/100
	end
	
	return EnemyConfig	
end

return Challenge
