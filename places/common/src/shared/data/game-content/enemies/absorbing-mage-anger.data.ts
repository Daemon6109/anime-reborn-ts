import { EnemyData } from './enemy-data.model';

export const absorbingMageAnger: EnemyData = {
  configuration: {
    DisplayName: "Absorbing Mage [Anger]",
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
    Model: "ReplicatedStorage.BossModels.Absorbing_Mage_Anger.Model", // Adjusted path
    ShinyModel: "ReplicatedStorage.BossModels.Absorbing_Mage_Anger.ShinyModel", // Adjusted path
  },
};
