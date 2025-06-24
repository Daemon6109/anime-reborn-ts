import { EnemyData } from '../enemy-data.model';
import { aizonAttackConfig } from './attacks/aizon-attack.config';

export const aizon: EnemyData = {
  configuration: {
    DisplayName: "Aizon",
    MapAffinity: "West City",
    RessurectAnim: "old_common/src/constants/Enemies/Aizen/Ressurect", // Path to Animation asset
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
    // Health: 500000, // Original value: 50
    NPC_Type: "Ground",
    Class: "Boss",
    Element: "Neutral",
    RewardsOnDeath: {
      // Currencies: { Gems: 30, Gold: 80, "Candy Cane": 750 }, // Example from Luau, commented out
      Items: {
        Hogyoku: { Amount: {min: 1, max: 1}, Chance: 5, RNG: {min: 1, max: 100} },
      },
      Units: {},
    },
    IsBoss: true,
    IsAttackingType: true,
    AttackDelay: 25,
  },
  misc: {
    Model: "ReplicatedStorage.BossModels.Aizon.Model", // Adjusted path
    ShinyModel: "ReplicatedStorage.BossModels.Aizon.ShinyModel", // Adjusted path
  },
  Attack: {
    config: aizonAttackConfig,
    // Effect function logic is handled by game systems, see aizon-attack.config.ts for details
  },
  // onRessurect: (npc, anim) => { ... } // Logic for onRessurect would be part of a game system
  // The onRessurect Luau function plays an animation and enables particles.
  // This would be triggered by an event like EventBus.emit('EnemyRessurect', { enemyId: 'Aizon', npc, animationClip: aizon.configuration.RessurectAnim });
};
