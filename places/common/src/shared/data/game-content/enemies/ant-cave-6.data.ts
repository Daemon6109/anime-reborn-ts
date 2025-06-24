import { EnemyData } from './enemy-data.model';

export const antCave6: EnemyData = {
  configuration: {
    DisplayName: "Ant King",
    MapAffinity: "Ant Cave",
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
    Model: "ReplicatedStorage.BossModels.Ant_Cave.Stage_6.Model", // Adjusted path
    ShinyModel: "old_common/src/constants/Enemies/Ant_Cave_6/ShinyModel", // Path to ShinyModel asset
  },
};
