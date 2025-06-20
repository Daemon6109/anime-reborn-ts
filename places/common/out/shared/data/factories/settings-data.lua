-- Compiled with roblox-ts v2.3.0
-- Settings data factory
local function createSettingsData()
	return {
		SoundMasterVolume = 1,
		UnitSFXVolume = 1,
		BGMVolume = 1,
		GeneralSFXVolume = 1,
		UnitVFX = true,
		StatusEffectVFX = true,
		AutoSkip = false,
		DamageIndicator = true,
		ShowMaxRangeOnPlace = true,
		AutoSell = {},
		DragonCapsuleAutoSell = {},
		SummonAnimation = true,
		TraitRerollCooldown = 0.5,
		LowGFX = false,
		ReducedColorIntensity = false,
		ReducedBloomntensity = false,
		PerformantWindows = false,
		AutoLockMythicals = true,
		AutoLockSecrets = true,
		InstantCrateOpen = false,
	}
end
return {
	createSettingsData = createSettingsData,
}
