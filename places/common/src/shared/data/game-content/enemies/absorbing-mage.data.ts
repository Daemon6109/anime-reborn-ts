import { EnemyData } from './enemy-data.model';

export const absorbingMage: EnemyData = {
  configuration: {
    DisplayName: "Absorbing Mage",
    MapAffinity: "West City",
  },
  reward: {
    money: 20,
  },
  stats: {
    Speed: 1.4,
    Damage: 999999,
    HealthMultiplier: 1,
    // Health: 500000, // Original value: 50 - Luau comment indicates it was 500000 then 50
    NPC_Type: "Ground",
    Class: "Boss",
    Element: "Neutral",
    IsBoss: true,
  },
  misc: {
    // ScriptLink is not directly transferrable / useful in TS
    Model: "ReplicatedStorage.BossModels.Absorbing_Mage.Model", // Adjusted path
    ShinyModel: "ReplicatedStorage.BossModels.Absorbing_Mage.ShinyModel", // Adjusted path
  },
  // onSpawn, onClientDeath functions are not directly part of the data definition in TS.
  // This logic would typically be handled by game systems that consume this data.
};
