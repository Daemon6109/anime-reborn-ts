import { EnemyData } from '../enemy-data.model';
import { beerusAttackConfig } from './attacks/beerus-attack.config';

export const beerus: EnemyData = {
  configuration: {
    DisplayName: "Beruus", // Note: Name in Luau is "Beruus", file is "Beerus"
    MapAffinity: "West City",
    RessurectAnim: "old_common/src/constants/Enemies/Beerus/Ressurect", // Path to Animation asset
  },
  reward: {
    money: 20,
  },
  stats: {
    // Ressurect: true, // Original Luau file has this commented out
    // RessurectDuration: 2, // Original Luau file has this commented out
    Speed: 1.1,
    Damage: 999999,
    HealthMultiplier: 1,
    // Health: 500000,
    NPC_Type: "Ground",
    Class: "Boss",
    Element: "Neutral",
    RewardsOnDeath: {
      // Currencies: { Gems: 30, Gold: 80, "Candy Cane": 750 }, // Example from Luau, commented out
      Items: {
        Pudding: { Amount: {min: 1, max: 1}, Chance: 5, RNG: {min: 1, max: 100} },
      },
      Units: {},
    },
    IsBoss: true,
    IsAttackingType: true,
    AttackDelay: 25,
  },
  misc: {
    Model: "ReplicatedStorage.BossModels.Beerus.Model", // Adjusted path
    ShinyModel: "ReplicatedStorage.BossModels.Beerus.ShinyModel", // Adjusted path
  },
  Attack: {
    config: beerusAttackConfig,
    // Effect function logic is handled by game systems, see beerus-attack.config.ts for details
  },
  // onRessurect: (npc, anim) => { ... }
  // Summary of onRessurect: Plays animation, enables particles marked with "Marked" attribute after 1s, stops animation after 2s.
};
