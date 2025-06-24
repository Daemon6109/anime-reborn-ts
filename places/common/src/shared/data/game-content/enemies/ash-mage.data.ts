import { EnemyData } from './enemy-data.model';

export const ashMage: EnemyData = {
  configuration: {
    DisplayName: "Ash Mage",
    MapAffinity: "West City",
  },
  reward: {
    money: 20,
  },
  stats: {
    Speed: 1.4,
    Damage: 999999,
    HealthMultiplier: 1,
    // Health: 500000,
    NPC_Type: "Ground",
    Class: "Boss",
    Element: "Neutral",
    IsBoss: true,
  },
  misc: {
    Model: "ReplicatedStorage.BossModels.Ash_Mage.Model", // Adjusted path
    ShinyModel: "old_common/src/constants/Enemies/Ash_Mage/ShinyModel", // Path to ShinyModel asset
  },
};
