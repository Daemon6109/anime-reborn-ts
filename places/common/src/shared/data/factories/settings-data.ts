// Settings data factory
export interface SettingsData {
	SoundMasterVolume: number;
	UnitSFXVolume: number;
	BGMVolume: number;
	GeneralSFXVolume: number;
	UnitVFX: boolean;
	StatusEffectVFX: boolean;
	AutoSkip: boolean;
	DamageIndicator: boolean;
	ShowMaxRangeOnPlace: boolean;
	AutoSell: Record<string, boolean>;
	DragonCapsuleAutoSell: Record<string, boolean>;
	SummonAnimation: boolean;
	TraitRerollCooldown: number;
	LowGFX: boolean;
	ReducedColorIntensity: boolean;
	ReducedBloomntensity: boolean;
	PerformantWindows: boolean;
	AutoLockMythicals: boolean;
	AutoLockSecrets: boolean;
	InstantCrateOpen: boolean;
}

export function createSettingsData(): SettingsData {
	return {
		SoundMasterVolume: 1,
		UnitSFXVolume: 1,
		BGMVolume: 1,
		GeneralSFXVolume: 1,
		UnitVFX: true,
		StatusEffectVFX: true,
		AutoSkip: false,
		DamageIndicator: true,
		ShowMaxRangeOnPlace: true,
		AutoSell: {},
		DragonCapsuleAutoSell: {},
		SummonAnimation: true,
		TraitRerollCooldown: 0.5,
		LowGFX: false,
		ReducedColorIntensity: false,
		ReducedBloomntensity: false,
		PerformantWindows: false,
		AutoLockMythicals: true,
		AutoLockSecrets: true,
		InstantCrateOpen: false,
	};
}
