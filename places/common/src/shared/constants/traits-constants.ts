// This file will store the rewritten trait definitions.

export interface TraitBuffs {
	Damage?: number;
	AttackSpeed?: number;
	Range?: number;
	[key: string]: number | undefined; // For any other dynamic buffs
}

export interface TraitConfiguration {
	Name: string;
	Description: string;
	Icon: string;
	Percentage: number;
	LayoutOrder: number;
	Glare?: unknown | undefined; // Roblox specific type, define if needed
	Gradient?: unknown | undefined; // Roblox specific type UIGradient, define if needed
	Impact?: unknown | undefined; // Roblox specific type, define if needed
	PassiveType: "StatBuff" | string; // Add other passive types if they exist
	Buffs: TraitBuffs;
	Rarity: "Rare" | "Legendary" | "Common" | "Uncommon" | "Mythic" | "Secret" | string; // Add other rarities
}

// todo: rewrite traits from old_common/src/constants/Traits/

export const Traits: { [key: string]: TraitConfiguration } = {
	Agile1: {
		Name: "Agile I",
		Description: `<font color="rgb(94,255,0)">(-5%)</font> SPA`,
		Icon: "rbxassetid://130372046731400",
		Percentage: 13.1,
		LayoutOrder: 4,
		// Glare: nil, // Represent nil as undefined or skip the field
		// Gradient: script.UIGradient, // This needs to be handled, placeholder for now
		// Impact: nil, // Represent nil as undefined or skip the field
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 0.95,
			Range: 1,
		},
		Rarity: "Rare",
	},
	Anubis: {
		Name: "Anubis",
		Description: `<font color="rgb(94,255,0)">(-17.5%)</font> SPA`,
		Icon: "rbxassetid://128928038628240",
		Percentage: 4.5,
		LayoutOrder: 11,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 0.825,
			Range: 1,
		},
		Rarity: "Legendary",
	},
	Agile2: {
		Name: "Agile II",
		Description: `<font color="rgb(94,255,0)">(-8%)</font> SPA`,
		Icon: "rbxassetid://130372046731400",
		Percentage: 8.1,
		LayoutOrder: 5,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 0.92,
			Range: 1,
		},
		Rarity: "Rare",
	},
	Agile3: {
		Name: "Agile III",
		Description: `<font color="rgb(94,255,0)">(-12%)</font> SPA`,
		Icon: "rbxassetid://130372046731400",
		Percentage: 5.8,
		LayoutOrder: 6,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 0.88,
			Range: 1,
		},
		Rarity: "Epic",
	},
	Archer: {
		Name: "Archer",
		Description: `<font color="rgb(94,255,0)">(+25%)</font> Range`,
		Icon: "http://www.roblox.com/asset/?id=106069457933669",
		Percentage: 4,
		LayoutOrder: 12,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1.25,
		},
		Rarity: "Legendary",
	},
	Demon: {
		Name: "Demon",
		Description: `
	<font color="rgb(94,255,0)">(+75%)</font> Damage Buff
	<font color="rgb(0,115,255)">(+Speed Demon)</font>: For every 20 elimination stacks on this unit decrease SPA by 50% for 15 seconds. Reduces placelimit to 2.
`,
		Icon: "rbxassetid://123408658714528",
		Percentage: 0.3,
		LayoutOrder: 17,
		PassiveType: "StatBuff", // Note: Original has OnKill logic, representing as StatBuff for now. Further implementation needed for dynamic parts.
		Buffs: {
			Damage: 1.75,
			AttackSpeed: 1,
			Range: 1,
		},
		// BuffsData, BuffDuration, StacksNeeded, MaxPlacementAmount would require extending the interface or special handling.
		Rarity: "Mythical",
	},
	Ethereal: {
		Name: "Ethereal",
		Description: `
<font color="rgb(94,255,0)">(+200%)</font> DoT Damage
<font color="rgb(94,255,0)">(+10%)</font> Range
	`,
		Icon: "rbxassetid://87423157838957",
		Percentage: 0.4,
		LayoutOrder: 18,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1.1,
			AttackEffectDamageMultiplier: 3,
		},
		Rarity: "Mythical",
	},
	Exploder: {
		Name: "Exploder",
		Description: `<font color="rgb(94,255,0)">(+25%)</font> Damage`,
		Icon: "http://www.roblox.com/asset/?id=81813617006335",
		Percentage: 2,
		LayoutOrder: 10,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1.25,
			AttackSpeed: 1,
			Range: 1,
		},
		Rarity: "Legendary",
	},
	Heavenly: {
		Name: "Heavenly",
		Description: `<font color="rgb(94,255,0)">(+20%)</font> Damage Buff
<font color="rgb(0,115,255)">(+Ascension)</font>: Gains 5% range for every allied unit in range. Caps at 30%.`,
		Icon: "rbxassetid://96756049750964",
		Percentage: 0.5,
		LayoutOrder: 16,
		PassiveType: "AlliesInRange", // Note: Original has CalculateUnitsInRange logic.
		Buffs: {
			Damage: 1.2,
			AttackSpeed: 1,
			Range: 1,
		},
		// MaxStacks, PercentPerStack require interface extension or special handling.
		Rarity: "Mythical",
	},
	Miracle: {
		Name: "Miracle",
		Description: `<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-10%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1.
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
`,
		Icon: "rbxassetid://97553106305715",
		Percentage: 0.1,
		LayoutOrder: 20,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 3,
			AttackSpeed: 0.85,
			Range: 1.2,
		},
		// MaxPlacementAmount requires interface extension or special handling.
		Rarity: "Secret",
	},
	Miracle_A: {
		Name: "Miracle I",
		Description: `<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-10%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1.
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
`,
		Icon: "rbxassetid://97553106305715",
		Percentage: 0.025,
		LayoutOrder: 20,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 4,
			AttackSpeed: 0.9,
			Range: 1.2,
			AttackEffectDamageMultiplier: 1.2,
		},
		Rarity: "Secret",
	},
	Miracle_B: {
		Name: "Miracle II",
		Description: `<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-10%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1.
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
`,
		Icon: "rbxassetid://97553106305715",
		Percentage: 0.025,
		LayoutOrder: 20,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 4.2,
			AttackSpeed: 0.9,
			Range: 1.2,
		},
		Rarity: "Secret",
	},
	Miracle_C: {
		Name: "Miracle III",
		Description: `<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-20%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1.
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
`,
		Icon: "rbxassetid://97553106305715",
		Percentage: 0.025,
		LayoutOrder: 20,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 4,
			AttackSpeed: 0.8,
			Range: 1.2,
		},
		Rarity: "Secret",
	},
	Miracle_D: {
		Name: "Miracle IV",
		Description: `<font color="rgb(94,255,0)">(+300%)</font> Damage
<font color="rgb(94,255,0)">(-10%)</font> SPA
<font color="rgb(94,255,0)">(+20%)</font> Range
<font color="rgb(0,115,255)">(+Miracle)</font>: When this trait is rolled, gain 1 buff from the random buff pool. Reduces place limit to 1.
<font color="rgb(255, 238, 0)"><i><b>CLICK</b> to view pool.</i></font>
`,
		Icon: "rbxassetid://97553106305715",
		Percentage: 0.025,
		LayoutOrder: 20,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 4,
			AttackSpeed: 0.9,
			Range: 1.4,
		},
		Rarity: "Secret",
	},
	Paladin: {
		Name: "Paladin",
		Description: `<font color="#5eff00">(+125%)</font> Damage Buff
<font color="#5eff00">(+10%)</font> Range Buff
<font color="#0073ff">(+God's Chosen)</font>: Every attack has a 15% chance to trigger a random buff on the unit for 10s. Reduces placelimit to 2.
`,
		Icon: "rbxassetid://124398438551313",
		Percentage: 0.2,
		LayoutOrder: 19,
		PassiveType: "BuffOnAttack", // Note: Original has OnAttack logic.
		Buffs: {
			Damage: 2.25,
			AttackSpeed: 1,
			Range: 1.1,
		},
		// BuffsData, ActiveBuffDuration, MaxPlacementAmount require interface extension or special handling.
		Rarity: "Secret",
	},
	Potential: {
		Name: "Potential",
		Description: `<font color="rgb(94,255,0)">(+40%)</font> More Exp`,
		Icon: "rbxassetid://110481061283480",
		Percentage: 4.5,
		LayoutOrder: 13,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1,
		},
		// XPMulti requires interface extension or special handling.
		Rarity: "Legendary",
	},
	Slayer: {
		Name: "Slayer",
		Description: `
	<font color="rgb(94,255,0)">(+25%)</font> Damage
	<font color="rgb(0,115,255)">(+Giant Slayer)</font>: Increases damage dealt to the enemy by 1% for every 2% of their missing HP.
	`,
		Icon: "rbxassetid://122894289710062",
		Percentage: 0.6,
		LayoutOrder: 15,
		PassiveType: "MissingHPDamageIncrease", // Note: Original has GetDamageIncrease logic.
		Buffs: {
			Damage: 1.25,
			AttackSpeed: 1,
			Range: 1,
		},
		// PassiveData requires interface extension or special handling.
		Rarity: "Mythical",
	},
	Sniper1: {
		Name: "Sniper I",
		Description: `<font color="rgb(94,255,0)">(+5%)</font> Range`,
		Icon: "rbxassetid://102781030420800",
		Percentage: 13.1,
		LayoutOrder: 7,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1.05,
		},
		Rarity: "Rare",
	},
	Sniper2: {
		Name: "Sniper II",
		Description: `<font color="rgb(94,255,0)">(+10%)</font> Range`,
		Icon: "rbxassetid://102781030420800",
		Percentage: 8.1,
		LayoutOrder: 8,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1.1,
		},
		Rarity: "Rare",
	},
	Sniper3: {
		Name: "Sniper III",
		Description: `<font color="rgb(94,255,0)">(+15%)</font> Range`,
		Icon: "rbxassetid://102781030420800",
		Percentage: 5.8,
		LayoutOrder: 9,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1.15,
		},
		Rarity: "Epic",
	},
	Warrior1: {
		Name: "Warrior I",
		Description: `<font color="rgb(94,255,0)">(+5%)</font> Damage`,
		Icon: "rbxassetid://111850984554962",
		Percentage: 13.1,
		LayoutOrder: 1,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1.05,
			AttackSpeed: 1,
			Range: 1,
		},
		Rarity: "Rare",
	},
	Warrior2: {
		Name: "Warrior II",
		Description: `<font color="rgb(94,255,0)">(+10%)</font> Damage`,
		Icon: "rbxassetid://111850984554962",
		Percentage: 8.1,
		LayoutOrder: 2,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1.1,
			AttackSpeed: 1,
			Range: 1,
		},
		Rarity: "Rare",
	},
	Warrior3: {
		Name: "Warrior III",
		Description: `<font color="rgb(94,255,0)">(+15%)</font> Damage`,
		Icon: "rbxassetid://111850984554962",
		Percentage: 5.8,
		LayoutOrder: 3,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1.15,
			AttackSpeed: 1,
			Range: 1,
		},
		Rarity: "Epic",
	},
	Wealth: {
		Name: "Wealth",
		Description: `
<font color="rgb(94,255,0)">(+25%)</font> Yen for farm units
OR
<font color="rgb(94,255,0)">(+25%)</font> Yen per kill for normal units
	`,
		Icon: "rbxassetid://77324522487813",
		Percentage: 1.9,
		LayoutOrder: 14,
		PassiveType: "StatBuff",
		Buffs: {
			Damage: 1,
			AttackSpeed: 1,
			Range: 1,
		},
		// MoneyMult requires interface extension or special handling.
		Rarity: "Legendary",
	},
};

// todo: export all traits (this is implicitly done by exporting Traits object)
