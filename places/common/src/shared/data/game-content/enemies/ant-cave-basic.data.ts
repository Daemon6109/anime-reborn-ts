import { EnemyData } from './enemy-data.model';

export const antCaveBasic: EnemyData = {
  configuration: {
    RandomizeCustomization: false,
    MapAffinity: "Ant Cave",
  },
  reward: {
    money: 20,
  },
  stats: {
    Speed: 2.2,
    Damage: 10,
    HealthMultiplier: 1,
    // Health: 7000,
    NPC_Type: "Ground",
    Class: "Regular",
    Element: "Neutral",
  },
  misc: {
    Model: "old_common/src/constants/Enemies/Ant_Cave_Basic/Model", // Path to Model asset
    ShinyModel: "old_common/src/constants/Enemies/Ant_Cave_Basic/ShinyModel", // Path to ShinyModel asset
    ModelsPool: "ReplicatedStorage.EnemyModels.Ant_Cave.Basic", // Adjusted path
  },
};
